Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51468482B89
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 15:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbiABOTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 09:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiABOTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 09:19:31 -0500
Received: from mirix.in-vpn.de (mirix.in-vpn.de [IPv6:2001:67c:1407:a0::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A24C061761;
        Sun,  2 Jan 2022 06:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mirix.org;
        s=43974b1a7d21b2cf; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:References:Cc:To:From:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HaASqwvZlgb9yEGVRHt7KKIBTkQ0iQVrx0fVNrI8nww=; b=BztsaGtaqrVc3NwtgNybWddVKC
        H2Amw2bALlILAX5AR6ze6W53DISpywOAKLyHZ9ld+tISVb+5WLpcPFaysXZxVNVMwc3AJVbt1/qgj
        ztyzFiTswiR2QYDVy+siQE+9UIBlEKB++oscmSUYyvxJk3/WBL38lQsrB6/X59Wcy0jRLpi/RMwxp
        PSXlVomV2AlNBEbzrJb6e9cHTHUe6RGH4mVAWJ+aDVPO9Ge6+1nJ4ltqtsEclkv6uCWp89ZrpJrQ8
        XCac33/s1fO2kEuiceijIfh8Nh4Ol89epNMHZXZ2ksfO3/hxods5lpDA4oxFgRRhwqlwAbbBGp8Og
        dTyxs4Yg==;
Received: from [::1] (helo=localhost.localdomain)
        by mirix.in-vpn.de with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
        (Exim)
        id 1n41ho-0001wO-Hw; Sun, 02 Jan 2022 14:19:28 +0000
Subject: Re: [PATCH net v2] net: usb: pegasus: Do not drop long Ethernet
 frames
From:   Matthias-Christian Ott <ott@mirix.org>
To:     Petko Manolov <petkan@nucleusys.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
References: <20211226221208.2583-1-ott@mirix.org>
 <YcmfbX5o0XHn1Uhx@karbon.k.g>
 <87aa9378-ac72-7221-6bf1-ee4d6ed2009d@mirix.org>
Message-ID: <82950271-66ba-cbc5-5c84-ab6db1cea170@mirix.org>
Date:   Sun, 2 Jan 2022 15:19:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <87aa9378-ac72-7221-6bf1-ee4d6ed2009d@mirix.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/01/2022 15:16, Matthias-Christian Ott wrote:
> Yes, this also not the subject or intent of the commit. I will remove
> the sentence from the paragraph in a subsequent version of the patch.

It seems that the patch was already merged. So I was too late to change
it. I suppose we now have to live the commit message. I apologize.
Perhaps the archived discussion about it can somewhat correct it.

Kind regards,
Matthias-Christian Ott
