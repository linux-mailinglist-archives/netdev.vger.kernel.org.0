Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67DA91A3B16
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 22:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgDIUGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 16:06:54 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52910 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbgDIUGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 16:06:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=TXLVBqfZ+07haYUvl/Id3UZMJwYXkWX7YmD/hAgXmZ8=; b=V4HU/iK+P+ZtD2g8imvWa52e4L
        SeLkZrm/0qM+ajujIvf+JAnq/p2edTD6Xn7qwLM9Tb60gpxKaNuCQZcITJGhIbsPOqnVUIrd5pRC+
        TJ3qXPCroTaTAKGmwqwL5khSMUbXTFQ1u2UH4P5azWvVpORHUDyGEfYHJCd9IX4RQcTp1wStcgpCV
        C6yyvJq/G5P/RH+l28ZxeLZBM9KGmmyHOxdn/rkLfVRr0iIspnYRxyOpkqEaLsviaPtf/v1WSjae5
        YuoRqSJucL2TY+RPN57wsgSZejqtVHgHcLBYoj9HJ5VBr8GuEPzAF2FawgtDqFxJiuQR8xP4WrPpM
        zgXhOwww==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMdRs-0005N3-8Q; Thu, 09 Apr 2020 20:06:52 +0000
Subject: Re: [PATCH net] docs: networking: add full DIM API
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        talgi@mellanox.com, leon@kernel.org, jacob.e.keller@intel.com
References: <20200409175704.305241-1-kuba@kernel.org>
 <fcda6033-a719-adfb-c25d-d562072b5e82@infradead.org>
 <e27192c8-a251-4d72-1102-85d250d50f49@infradead.org>
 <20200409124221.128d6327@kicinski-fedora-PC1C0HJN>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <0a2f9a52-6abb-b9ca-45c1-cc74f6d276d7@infradead.org>
Date:   Thu, 9 Apr 2020 13:06:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200409124221.128d6327@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/9/20 12:42 PM, Jakub Kicinski wrote:
> On Thu, 9 Apr 2020 12:27:17 -0700 Randy Dunlap wrote:
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> Add the full net DIM API to the net_dim.rst file.
>>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: davem@davemloft.net
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: netdev@vger.kernel.org, talgi@mellanox.com, leon@kernel.org, jacob.e.keller@intel.com
> 
> Ah, very nice, I didn't know how to do that!
> 
> Do you reckon we should drop the .. c:function and .. c:type marking I
> added? So that the mentions of net_dim and the structures point to the
> kdoc?

My understanding is that if functions have an ending (), then the c:function
is not needed/wanted.  I don't know about the c:type uses.

But there is some duplication that might be cleaned up some.

> Do you want to take best parts of both your and my versions and repost?

Not really. The part that was slowing me down is using git (for the
removed file), and you have that part done. :)

thanks.
-- 
~Randy

