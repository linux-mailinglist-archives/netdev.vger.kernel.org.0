Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE21A108D54
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 12:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfKYL4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 06:56:18 -0500
Received: from a27-56.smtp-out.us-west-2.amazonses.com ([54.240.27.56]:58124
        "EHLO a27-56.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725828AbfKYL4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 06:56:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574682977;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=cTtwrlGNTkiAUYkuNC9OPAuoAAZBBpmDBW6s3hPB4Xw=;
        b=TQgEbxnxfaaVpJyfKq/1UJLhvAiHYuIVctLugJHTOIsQMS0e7tIULhu1EGH3D6n8
        OKQ2I0jQ8yAeK7cEgBojIaB51ipGu5eqH2srgQBXYqkkJp1JktzJ4nKtfvqez16oMnq
        ma6wPbEKGqUpwyIJyg/5LS07sBg1nNeBjKVBrmg0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574682977;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=cTtwrlGNTkiAUYkuNC9OPAuoAAZBBpmDBW6s3hPB4Xw=;
        b=RDpZ1odtrzeBcvyiVgRueZAKUg8Ohpxppv4HOs4Me3dBv/hNzWmJIVZLtGCVSaAO
        AQmr6yfNOvjSuknunWRk5u7NJpJ3BHtiuRYAKP8SGSp2McXHF9eqzAZtOlbf9bLWhg9
        QZGQ+T1otQRCUtBJopRGW+H+o/ZZR124sjYeHaJM=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 958EEC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Handle when FW doesn't support
 QMI_WLFW_HOST_CAP_REQ_V01
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191106233130.2169-1-jeffrey.l.hugo@gmail.com>
References: <20191106233130.2169-1-jeffrey.l.hugo@gmail.com>
To:     Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Cc:     davem@davemloft.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-ID: <0101016ea26b635d-ed1f7406-4ae3-411f-8b1d-47a1a5cc2dd5-000000@us-west-2.amazonses.com>
Date:   Mon, 25 Nov 2019 11:56:17 +0000
X-SES-Outgoing: 2019.11.25-54.240.27.56
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jeffrey Hugo <jeffrey.l.hugo@gmail.com> wrote:

> Firmware with the build id QC_IMAGE_VERSION_STRING=WLAN.HL.1.0.2-XXXX does
> not support the QMI_WLFW_HOST_CAP_REQ_V01 message and will return the
> QMI not supported error to the ath10k driver.  Since not supporting this
> message is not fatal to the firmware nor the ath10k driver, lets catch
> this particular scenario and ignore it so that we can still bring up
> wifi services successfully.
> 
> Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

501d4152b018 ath10k: Handle when FW doesn't support QMI_WLFW_HOST_CAP_REQ_V01

-- 
https://patchwork.kernel.org/patch/11231343/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

