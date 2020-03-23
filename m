Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADBC618F9B0
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 17:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgCWQaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 12:30:30 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:27737 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727234AbgCWQaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 12:30:30 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1584981029; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=c4JttsfXGBMaNrukutMhRZE1w7upJvToGQQ3kuVR83A=; b=ByvgJPYBvD5PwjULxxm6A/QrwgQ8IkVwqW1GQVs9cwSvUSHn7C2eTomGniRDS0y0RD9Q0Z1D
 5aYrBzwC0R5o4f6iGwMPcPLhrBLiUuS9yPNDs/LW9tnlKYsJniAkX/Blz9YJd00Eqs8aI/79
 SD0rclvS3AI3e/zFCgCfgi0Y4io=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e78e415.7f65746ef848-smtp-out-n02;
 Mon, 23 Mar 2020 16:30:13 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 94026C433CB; Mon, 23 Mar 2020 16:30:13 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8E405C433D2;
        Mon, 23 Mar 2020 16:30:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8E405C433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     gregkh@linuxfoundation.org, davem@davemloft.net,
        smohanad@codeaurora.org, jhugo@codeaurora.org,
        bjorn.andersson@linaro.org, hemantk@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 7/7] net: qrtr: Do not depend on ARCH_QCOM
References: <20200323123102.13992-1-manivannan.sadhasivam@linaro.org>
        <20200323123102.13992-8-manivannan.sadhasivam@linaro.org>
Date:   Mon, 23 Mar 2020 18:30:07 +0200
In-Reply-To: <20200323123102.13992-8-manivannan.sadhasivam@linaro.org>
        (Manivannan Sadhasivam's message of "Mon, 23 Mar 2020 18:01:02 +0530")
Message-ID: <87lfnravao.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org> writes:

> IPC Router protocol is also used by external modems for exchanging the QMI
> messages. Hence, it doesn't always depend on Qualcomm platforms. One such
> instance is the QCA6390 modem connected to x86 machine.

QCA6390 is not a modem, it's a Wi-Fi 6 (802.11ax) device :)

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
