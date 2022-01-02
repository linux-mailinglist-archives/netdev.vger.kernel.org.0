Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063EB482B8D
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 15:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbiABOWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 09:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiABOWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 09:22:43 -0500
Received: from mirix.in-vpn.de (mirix.in-vpn.de [IPv6:2001:67c:1407:a0::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366FFC061761;
        Sun,  2 Jan 2022 06:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mirix.org;
        s=43974b1a7d21b2cf; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=68Az2Vg/exR/Hz65nfa3EliZftOSB7gUaulGvWG0sAg=; b=bwaTuGKGIAklarOvcobErvsrb8
        836toYtA8KJQ+t/vNXCR4U7J4c8BzpLonY4fJz6nUc6M71j0YvZFh3sfjupv1zEdWYQeHi+DV0vAQ
        lPnU7kI0UYCEgB+sBCqDAsOD8o7dHblSkIRpFpkGPYdYpEF79I7qhEZcZAWVAEV7DH5AIn0MpPudZ
        AYnbuzUv0jlwCpT5PdQ/ks6ob8XVyBsK0fLROzA6XI41OJlObXm2m0CbluVykO6ZY6NCpJv6GfdB5
        B5f0xs/AmHVvTRLjFAhB0GaB6N8aYyxX3QQPbrhui5DztzoXTdxMm2esFQKt35+y5oWEp1MLEoaVm
        qusVbb7w==;
Received: from [::1] (helo=localhost.localdomain)
        by mirix.in-vpn.de with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
        (Exim)
        id 1n41ku-0001wg-LT; Sun, 02 Jan 2022 14:22:40 +0000
Subject: Re: [PATCH] net: usb: pegasus: Do not drop long Ethernet frames
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Petko Manolov <petkan@nucleusys.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
References: <20211226132930.7220-1-ott@mirix.org>
 <36ee5c5c-a03c-c9f5-dd5c-9e3a04b0374a@gmail.com>
From:   Matthias-Christian Ott <ott@mirix.org>
Message-ID: <459e7018-5b96-ca05-c741-778172048a91@mirix.org>
Date:   Sun, 2 Jan 2022 15:22:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <36ee5c5c-a03c-c9f5-dd5c-9e3a04b0374a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/12/2021 10:56, Sergei Shtylyov wrote:
>> Actually, the hardware is even able to receive Ethernet frames with 2048
>> octets which exceeds the claimed limit frame size limit of the driver of
>                                    ^^^^^            ^^^^^
>    Too many limits. :-)

Thank you for pointing this out. Indeed, this sentence does make sense.
:) Unfortunately, the patch was already merged and it seems that I can't
change its commit message anymore. Nonetheless, thank you for reviewing it.

Kind regards,
Matthias-Christian Ott
