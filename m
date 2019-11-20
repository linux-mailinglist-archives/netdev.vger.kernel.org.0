Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D94C1034E3
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 08:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbfKTHOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 02:14:40 -0500
Received: from a27-21.smtp-out.us-west-2.amazonses.com ([54.240.27.21]:39784
        "EHLO a27-21.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727175AbfKTHOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 02:14:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574234079;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=jTDnJbAD+OmeeNay72pKKr25SQyviuZ8HJ985/FTvTo=;
        b=CYgYg1d23p+M6KZP6LANHhnIAqafL9L7FQeUKAwPsYoFOA52/qChkuajKc8tARbE
        qBSaDT0g7Bc6p2UYwuBStTDd2xLLeWTad/AxEa/pXRJnntxs+iaQTEjB3D7FKO0lqcp
        jNAY57EiYFEGUrLxc/XuuYtEPDSZkdZ4faxrGD9Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574234079;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=jTDnJbAD+OmeeNay72pKKr25SQyviuZ8HJ985/FTvTo=;
        b=HitXlYIBzzUD+dI2jBlo9bjPl7kGbnb2C2bnqIjivKL3sbFJ3ddJx2xNEfZAI9vf
        dldpcK3WZbwnvWocKY9hieg2fggfwCd9IODFcnJ7si5mxH7Pio2mfckP5pTdOWp60VR
        5L4b3d/ng6pMeoC9ZqsQyAP2sJLAeWL85qFVOh/M=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3834FC433A2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH -next] brcmfmac: remove set but not used variable 'mpnum','nsp','nmp'
References: <1573888967-104078-1-git-send-email-zhengbin13@huawei.com>
Date:   Wed, 20 Nov 2019 07:14:39 +0000
In-Reply-To: <1573888967-104078-1-git-send-email-zhengbin13@huawei.com>
        (zhengbin's message of "Sat, 16 Nov 2019 15:22:47 +0800")
Message-ID: <0101016e87a9bfdf-2f0de3c7-8cd5-473e-b06b-3f6dab955c23-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2019.11.20-54.240.27.21
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhengbin <zhengbin13@huawei.com> writes:

> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c: In function brcmf_chip_dmp_get_regaddr:
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c:790:5: warning: variable mpnum set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c: In function brcmf_chip_dmp_erom_scan:
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c:866:10: warning: variable nsp set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c: In function brcmf_chip_dmp_erom_scan:
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c:866:5: warning: variable nmp set but not used [-Wunused-but-set-variable]
>
> They are introduced by commit 05491d2ccf20 ("brcm80211:
> move under broadcom vendor directory"), but never used,
> so remove them.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>

Applied, thanks.

7af496b9eb04 brcmfmac: remove set but not used variable 'mpnum','nsp','nmp'

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
