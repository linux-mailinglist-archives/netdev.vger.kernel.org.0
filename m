Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15EEA3665E7
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 09:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236422AbhDUHBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 03:01:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:48482 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234025AbhDUHB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 03:01:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618988453; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zuMPGCEoFTBrQjlLesKTqICmVZBdzid0Et5b/N6s22c=;
        b=E6ft7IUyhTxpxdBZH5f2BrBH6YUmpujpSA14FpGqI76XXwBse38NPU7V9frIpjmQXPFMCP
        gFBCDWT2/wbJHlcHqeiKMCyPAGbYM0pqrKg11phxLg/FR7oo8nJBj7rTM9C2sxD1uszXqh
        gYOiJyBdDR8lAqozU2mpjI144QjeVWw=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6EECAAD80;
        Wed, 21 Apr 2021 07:00:53 +0000 (UTC)
Date:   Wed, 21 Apr 2021 09:00:52 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Mike Rapoport <rppt@linux.ibm.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3] docs: proc.rst: meminfo: briefly describe gaps in
 memory accounting
Message-ID: <YH/NpH8dm/exPidf@dhcp22.suse.cz>
References: <20210421061127.1182723-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421061127.1182723-1-rppt@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 21-04-21 09:11:27, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> Add a paragraph that explains that it may happen that the counters in
> /proc/meminfo do not add up to the overall memory usage.
> 
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>

Acked-by: Michal Hocko <mhocko@suse.com>

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
> -- 
> 2.29.2
> 

-- 
Michal Hocko
SUSE Labs
