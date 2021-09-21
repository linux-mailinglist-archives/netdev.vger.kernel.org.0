Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5700C413944
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 19:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhIURzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 13:55:38 -0400
Received: from gateway32.websitewelcome.com ([192.185.145.108]:20265 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231153AbhIURze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 13:55:34 -0400
X-Greylist: delayed 1243 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Sep 2021 13:55:34 EDT
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 2B692164081
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 12:33:18 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Sjdtm490YrJtZSjdummcxv; Tue, 21 Sep 2021 12:33:18 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=V2ipY4XW+WZzd2kUAeQUYTq4ml6dgf93+kXUdm7z19M=; b=uCdk5SkXATJvZwBhALindVcIZ+
        G9SvSKo4+wJcEcKSkAEo088pgDm703ewCmXelXXjYmsHtKM8OKBfMOs1084XJK6WbFPPYAYk3DcOf
        2+GmBsEC5yoIkCRONsbY/2VRljJAyILeyR6zUOgkLvw+NJgH1FgL26MscJVzW6XVYRnAVJa4aAH/i
        bSe0BUYk+KG/yZ3F+Toq0CyLeDMGfpLk9imeD3jOavWoPeFjdMRYKPdOKAkyyKjg9l7z85LBjNnVT
        ELwvmFTj1HW184N0fpNuuNrBqcKMTFXDfvMWGjBMzbgh/CfW5LD9+sdPk1psogh1CHHEv5dNESTKk
        +w+h2/rg==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:36190 helo=[192.168.15.9])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1mSjds-003xVQ-T2; Tue, 21 Sep 2021 12:33:16 -0500
Subject: Re: [PATCH] brcmfmac: Replace zero-length array with flexible array
 member
To:     Kalle Valo <kvalo@codeaurora.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Len Baker <len.baker@gmx.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210904092217.2848-1-len.baker@gmx.com>
 <20210912191536.GB146608@embeddedor> <87o88sy2gk.fsf@codeaurora.org>
 <871r5iwjyo.fsf@codeaurora.org>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <b8f06e6d-02e9-a82d-a9ae-448372e0f9cf@embeddedor.com>
Date:   Tue, 21 Sep 2021 12:37:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <871r5iwjyo.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1mSjds-003xVQ-T2
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.9]) [187.162.31.110]:36190
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 17
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/21/21 00:55, Kalle Valo wrote:

> Gustavo, so have you dropped this from your tree now? I do not want to
> get any conflicts because of this.

It's not on my tree.

> 
> I'll reiterate again: do not take any patches touching
> drivers/net/wireless unless I have acked them.

Got it.

--
Gustavo
