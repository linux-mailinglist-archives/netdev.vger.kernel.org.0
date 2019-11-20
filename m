Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF51103453
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 07:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfKTGec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 01:34:32 -0500
Received: from a27-188.smtp-out.us-west-2.amazonses.com ([54.240.27.188]:37664
        "EHLO a27-188.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725832AbfKTGec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 01:34:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574231671;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=p3O4v1U+XwO0r7HlswHbozlwB2rYAmXkQgj4NLIm5PM=;
        b=Du4p9WLb4Z8vEP7RNcEeVVpObApzUUK+9R37MHB2ya2c8sPSUxc6CN+4jqg+8D0S
        7dWdBq/Rl5S5nGYOzKdvzCSU9IrcOuAr3zAQYhu2iXqa5q/3EO1CJzDdGvns4vOw6vL
        qqngKn1ASK7l3bqBk1zjbrOee3TpnNOYZBS5cA2o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574231671;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=p3O4v1U+XwO0r7HlswHbozlwB2rYAmXkQgj4NLIm5PM=;
        b=Rcs/Xm032md8dHAbnnVR0FBAfeOoW95+5s1/RzVu0WmkAQR1Z/bMLKiNlsiyiSVH
        RT01p9YkHw/ur07L7XXM2UkClwnPAP21FiZSEcU/C3X+9F2qrZmsdU4SVkXQMheyujB
        SVY5+LwSd7UE6YdEMZ+s8PaLJRNhNNCHI6PEHGK8=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org ADDACC43383
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
Date:   Wed, 20 Nov 2019 06:34:31 +0000
In-Reply-To: <1573888967-104078-1-git-send-email-zhengbin13@huawei.com>
        (zhengbin's message of "Sat, 16 Nov 2019 15:22:47 +0800")
Message-ID: <0101016e87850355-969ffdac-7a02-4d1e-af93-99e9c27109d6-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2019.11.20-54.240.27.188
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

No they are not, that commit only moved the driver into a different
directory. I'll remove that sentence when I commit this.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
