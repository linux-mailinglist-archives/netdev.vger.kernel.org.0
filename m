Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870673119EF
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhBFDYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbhBFDRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 22:17:32 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A881FC0613D6;
        Fri,  5 Feb 2021 19:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=qlPEp38Wvmdv0QR7RAJOZZgFMN7oJgR3A9jELvjc99k=; b=Zk7iVOE7CvKBkOSeLHwFwmbfeY
        lQrOCnGD180SHGk6bBrYt34P2qorny38GK7j2gvIUdfPPY4p3jmVkFA5swKpMf6voK81DOzjwM04X
        cQ349ycr16/6Q3mOXnkqMpyDge3BhOFRdZiepMs25aDQ1sOohft6geAWW825UgW+zGF8EIj6Egvc/
        RIU8i6SZfct8IS3jTg1S82imKCaULgqGMQVF07wc4CJdaraY98KEkSUM81CRc4zgATyeNzY5meQ8x
        eKWrYHagwQScNGsaKhWV8eLSlQWsR35Z/HpqjkQiDIgjuyo1nI7YZWLjwkcxUx+RE/f8D6U5mFtvw
        uDWX+/eA==;
Received: from [2601:1c0:6280:3f0::aec2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l8E5Y-0000lw-B2; Sat, 06 Feb 2021 03:16:48 +0000
Subject: Re: [PATCH 0/3] drivers/net/ethernet/amd: Follow style guide
To:     Amy Parker <enbyamy@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, akpm@linux-foundation.org, rppt@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210206000146.616465-1-enbyamy@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <c1eae547-aa14-8307-cb81-b585a13bbd3d@infradead.org>
Date:   Fri, 5 Feb 2021 19:16:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210206000146.616465-1-enbyamy@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/5/21 4:01 PM, Amy Parker wrote:
> This patchset updates atarilance.c and sun3lance.c to follow the kernel
> style guide. Each patch tackles a different issue in the style guide.
> 
>    -Amy IP
> 
> Amy Parker (3):
>   drivers/net/ethernet/amd: Correct spacing around C keywords
>   drivers/net/ethernet/amd: Fix bracket matching and line levels
>   drivers/net/ethernet/amd: Break apart one-lined expressions
> 
>  drivers/net/ethernet/amd/atarilance.c | 64 ++++++++++++++-------------
>  drivers/net/ethernet/amd/sun3lance.c  | 64 +++++++++++++++------------
>  2 files changed, 69 insertions(+), 59 deletions(-)
> 

Hi Amy,

For each patch, can you confirm that the before & after binary files
are the same?  or if they are not the same, explain why not?

Just something that I have done in the past...

thanks.
-- 
~Randy

