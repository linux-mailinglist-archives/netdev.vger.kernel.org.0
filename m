Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09403E1CC8
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 21:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237084AbhHETej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 15:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhHETej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 15:34:39 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE14AC061798;
        Thu,  5 Aug 2021 12:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=g/u/JfxOfcGYNBwCoVS+XZvseyWFfZAjPvhv0usF60I=; b=YzhYBzY1obA6+pIEB9HcP7LxEm
        iAzbtd4L2gTIgS3Fq1c1cMqb9lQHUjgfCeGGrPfL6cScOef5/SODJVXxcTQCqGjyl0BWzWHZl+ZdZ
        T1FsCLz7Lok1it879ZD6TKHb1UkHpG82RryZRsFcMrDXD+JkuiPJ6j90K93z1w/5GQlwO1G+PJK/F
        rFqWfvgYxGoTvxaiKCgYMcWpBn3m8ZJ6uzYH9wDMSpPG94rjQtQ4b1sHbY71YR743eFHWrEHG5oYb
        l/m8TNGyvhiJ0RAJGoGjS08HfJ9DFLk8yb3afGqSQ2WhV1twAdCqjI9UPjJSCXAoWy+8yuErOyxrC
        7KYWTpRQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mBj8H-0069jd-1t; Thu, 05 Aug 2021 19:34:21 +0000
Subject: Re: [GIT PULL] Networking for 5.14-rc5
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20210805154335.1070064-1-kuba@kernel.org>
 <CAHk-=wi8ufjAUS=+gPxpDPx_tupvfPppLX03RxjWeJ1JtuDZYg@mail.gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <afa0b41f-bcb9-455e-4ea8-476ed880fbd2@infradead.org>
Date:   Thu, 5 Aug 2021 12:34:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wi8ufjAUS=+gPxpDPx_tupvfPppLX03RxjWeJ1JtuDZYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/5/21 12:30 PM, Linus Torvalds wrote:
> On Thu, Aug 5, 2021 at 8:43 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> Small PR this week, maybe it's cucumber time, maybe just bad
>> timing vs subtree PRs, maybe both.
> 
> "Cucumber time"?
> 
> Google informs me about this concept, but I'd never heard that term before.

wow, nor had I.
Thanks for the info. :)

-- 
~Randy

