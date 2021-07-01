Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B233B95A1
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 19:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbhGARpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 13:45:23 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:31497 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbhGARpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 13:45:23 -0400
Received: from [192.168.1.18] ([86.243.172.93])
        by mwinf5d12 with ME
        id Ptip2500321Fzsu03tip3W; Thu, 01 Jul 2021 19:42:51 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 01 Jul 2021 19:42:51 +0200
X-ME-IP: 86.243.172.93
Subject: Re: [PATCH 0/3] gve: Fixes and clean-up
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     csully@google.com, sagis@google.com, jonolson@google.com,
        davem@davemloft.net, kuba@kernel.org, awogbemila@google.com,
        willemb@google.com, yangchun@google.com, bcf@google.com,
        kuozhao@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <cover.1625118581.git.christophe.jaillet@wanadoo.fr>
 <CAErkTsQLP9_y-Am3MN-O4vZXe3cTKHfYMwkFk-9YWWPLAQM1cw@mail.gmail.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <29632746-3234-1991-040d-3c0dfb3b3acb@wanadoo.fr>
Date:   Thu, 1 Jul 2021 19:42:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAErkTsQLP9_y-Am3MN-O4vZXe3cTKHfYMwkFk-9YWWPLAQM1cw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 01/07/2021 à 18:20, Jeroen de Borst a écrit :
> On Wed, Jun 30, 2021 at 10:58 PM Christophe JAILLET
> <christophe.jaillet@wanadoo.fr> wrote:
>>
>> This serie is part of the effort to axe the wrappers in
>> include/linux/pci-dma-compat.h
>>
>> While looking at it, I spotted:
>>    - a resource leak in an error handling path (patch 1)
>>    - an error code that could be propagated. (patch 2)
>>      This patch could be ignored. It's only goal is to be more consistent
>>      with other drivers.
>>
>> These 2 paches are not related to the 'pci-dma-compat.h' stuff, which can
>> be found in patch 3.
>>
>> Christophe JAILLET (3):
>>    gve: Fix an error handling path in 'gve_probe()'
>>    gve: Propagate error codes to caller
>>    gve: Simplify code and axe the use of a deprecated API
>>
>>
> 
> Thanks for these patches.
> 
> Can split this into 2 patch series;

Sure.

> one for net (with the first 2
> patches) and one for net-next (with the cleanup one)?

I've never worked with net and net-next directly.
If just adding net and net-next after [PATCH] in the subject of the 
mail, yes, I can do it if it helps.


BTW, I gave a look at https://patchwork.kernel.org/project/netdevbpf/list/
The patch 1/3 is marked as failed because "1 blamed authors not CCed: 
lrizzo@google.com; 1 maintainers not CCed: lrizzo@google.com"

This author/blame was not spotted by get_maintainer.pl. Is it something 
I should worry about?


> Also the label in the first patch should probably read
> 'abort_with_gve_init' instead of 'abort_with_vge_init'.

Good catch. Sorry about that.

> 
> Jeroen
> 

CJ

