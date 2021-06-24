Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1533B273C
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 08:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhFXGQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 02:16:00 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:43463 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231189AbhFXGP5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 02:15:57 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624515219; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=mgjoAktbr4Uw+4QleB7HqWrhEn+xU2tzcnaEMEP1Z3M=;
 b=BWtfUI7PCzLM0SxydLREB4s7uLA+6pljd39NtMP0v9aYn6RunZORgSqTKPR75ixmGcFQeilv
 d/2l0wLUJf6ptduQAkxDrwh2ose/83AAryCTxKESLt/mZxIrIbCLNqGmXR3SUiDPbXWJdklz
 /k26dXTCx8FyosMByPi67iqyUUI=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 60d422912a2a9a97617aadc3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 24 Jun 2021 06:13:37
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id ED4BDC4338A; Thu, 24 Jun 2021 06:13:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A494CC433F1;
        Thu, 24 Jun 2021 06:13:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A494CC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: remove unused variable in
 ath10k_htt_rx_h_frag_pn_check
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210514220644.1.Iad576de95836b74aba80a5fc28d7131940eca190@changeid>
References: <20210514220644.1.Iad576de95836b74aba80a5fc28d7131940eca190@changeid>
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     Johannes Berg <johannes.berg@intel.com>, briannorris@chromium.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Jouni Malinen <jouni@codeaurora.org>,
        Wen Gong <wgong@codeaurora.org>, kuabhs@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210624061336.ED4BDC4338A@smtp.codeaurora.org>
Date:   Thu, 24 Jun 2021 06:13:36 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Abhishek Kumar <kuabhs@chromium.org> wrote:

> The local variable more_frags in ath10k_htt_rx_h_frag_pn_check is not
> used. This patch is to remove that.
> 
> Fixes: a1166b2653db ("ath10k: add CCMP PN replay protection for fragmented
> frames for PCIe")
> Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>

Fixed already by another identical commit:

https://git.kernel.org/linus/e0a6120f6816

Patch set to Superseded.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210514220644.1.Iad576de95836b74aba80a5fc28d7131940eca190@changeid/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

