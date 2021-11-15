Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C003452417
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 02:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353989AbhKPBfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 20:35:50 -0500
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:56942 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242576AbhKOSis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 13:38:48 -0500
Received: from [192.168.1.18] ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id mgpYmlwNfHQrlmgpYml2nB; Mon, 15 Nov 2021 19:35:50 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Mon, 15 Nov 2021 19:35:50 +0100
X-ME-IP: 86.243.171.122
Subject: Re: [PATCH] net: bridge: Slightly optimize 'find_portno()'
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <00c39d09c8df7ad0673bf2043f6566d6ef08b789.1636916479.git.christophe.jaillet@wanadoo.fr>
 <20211115123534.GD26989@kadam>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <b3c93506-7dc8-a5fe-6cfc-938fc88b9f07@wanadoo.fr>
Date:   Mon, 15 Nov 2021 19:35:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211115123534.GD26989@kadam>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 15/11/2021 à 13:35, Dan Carpenter a écrit :
> On Sun, Nov 14, 2021 at 08:02:35PM +0100, Christophe JAILLET wrote:
>> The 'inuse' bitmap is local to this function. So we can use the
>> non-atomic '__set_bit()' to save a few cycles.
>>
>> While at it, also remove some useless {}.
> 
> I like the {} and tend to add it in new code.  There isn't a rule about
> this one way or the other.
> 
> regards,
> dan carpenter
> 
> 
> 

Hi Dan,

- checkpatch prefers the style without {}
- Usually, greg k-h and Joe Perches give feed-back that extra {} should 
be removed.
- in https://www.kernel.org/doc/html/v5.13/process/coding-style.html, 
after "Rationale: K&R":
    "Do not unnecessarily use braces where a single statement will do."


My own preference is to have {}. It is the standard used on another 
project I work on (i.e. httpd) and it helps when you add some code (it 
avoids unexpected behavior if you forget to add some missing {})

My understanding is that on the HUGE code base of Linux, emphasis is put 
on saving some lines of code, reducing the length of lines and avoiding 
the need to read some extra char.
I'm also fine with it.

CJ
