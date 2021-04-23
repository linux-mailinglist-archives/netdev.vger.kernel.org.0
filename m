Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3893694A9
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 16:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242576AbhDWO2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 10:28:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:42362 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240603AbhDWO2Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 10:28:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2EFA1AF17;
        Fri, 23 Apr 2021 14:27:46 +0000 (UTC)
Subject: Re: [PATCH v3] docs: proc.rst: meminfo: briefly describe gaps in
 memory accounting
To:     Mike Rapoport <rppt@kernel.org>, Jonathan Corbet <corbet@lwn.net>
Cc:     Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@linux.ibm.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org
References: <20210421061127.1182723-1-rppt@kernel.org>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <d047c2fb-d15a-d094-3256-ea6eeff2d7c7@suse.cz>
Date:   Fri, 23 Apr 2021 16:27:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210421061127.1182723-1-rppt@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/21 8:11 AM, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> Add a paragraph that explains that it may happen that the counters in
> /proc/meminfo do not add up to the overall memory usage.
> 
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

Thanks.

> ---
> v3:
> * Add sentense about counters overlap
> * Use wording suggested by Matthew
> 
> v2: Link: https://lore.kernel.org/lkml/20210420121354.1160437-1-rppt@kernel.org
> * Add brief changelog
> * Fix typo
> * Update example about network memory usage according to Eric's comment at
> 
> https://lore.kernel.org/lkml/CANn89iKprp7WYeZy4RRO5jHykprnSCcVBc7Tk14Ui_MA9OK7Fg@mail.gmail.com
> 
> v1: Link: https://lore.kernel.org/lkml/20210420085105.1156640-1-rppt@kernel.org
>  Documentation/filesystems/proc.rst | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index 48fbfc336ebf..0a07a5025571 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -929,8 +929,15 @@ meminfo
>  ~~~~~~~
>  
>  Provides information about distribution and utilization of memory.  This
> -varies by architecture and compile options.  The following is from a
> -16GB PIII, which has highmem enabled.  You may not have all of these fields.
> +varies by architecture and compile options.  Some of the counters reported
> +here overlap.  The memory reported by the non overlapping counters may not
> +add up to the overall memory usage and the difference for some workloads
> +can be substantial.  In many cases there are other means to find out
> +additional memory using subsystem specific interfaces, for instance
> +/proc/net/sockstat for TCP memory allocations.
> +
> +The following is from a 16GB PIII, which has highmem enabled.
> +You may not have all of these fields.
>  
>  ::
>  
> 

