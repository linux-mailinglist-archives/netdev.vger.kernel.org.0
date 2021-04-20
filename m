Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91CA3658D3
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 14:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhDTMVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 08:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231313AbhDTMVt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 08:21:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBD86613BC;
        Tue, 20 Apr 2021 12:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618921277;
        bh=uP+pgn/p+9cOp/ggTRqj+9Q5FU/IEPnyZLH5hUzKUEc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p3ksMvQ+1TkJXRLDE0enljtghMjSN6i2qAalOGLBZ8UMZ6hpC15NuiIXmPcLJ7G4F
         oZQ8iYxBlzHcmpKexLlAb/mrKPt/NEZOeCgTxuB8nZ6fEnYbmqeycgD8CQ0CWQTlNQ
         08aAPvNt7Bya/w9Q6xGymYz06/UMozXTAetCy9VC1YiBB+FjIygIVdXXgVVbaE10uB
         7TZ5HKhvKKOLfwVapO4kY/xEaf14nxB++sh8mpNZZdGZn6OlCplE1ChEK3OpRTQK8y
         EGP5gQN1GBCpXFGeTGcNI6FWDXg6f11j3VZi8FBqScbDC6kttS6ty/UJ5fmjqP+2zE
         gwOZe5N4nLn7g==
Date:   Tue, 20 Apr 2021 15:21:08 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@linux.ibm.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] docs: proc.rst: meminfo: briefly describe gaps in
 memory accounting
Message-ID: <YH7HNHJLZyQKqmir@kernel.org>
References: <20210420121354.1160437-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420121354.1160437-1-rppt@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 03:13:54PM +0300, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> Add a paragraph that explains that it may happen that the counters in
> /proc/meminfo do not add up to the overall memory usage.
> 
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>

Ooops, forgot to add Michal's Ack, sorry.

> ---
> v2:
> * Add brief changelog
> * Fix typo
> * Update example about network memory usage according to Eric's comment at
> 
> https://lore.kernel.org/lkml/CANn89iKprp7WYeZy4RRO5jHykprnSCcVBc7Tk14Ui_MA9OK7Fg@mail.gmail.com
> 
> v1: Link: https://lore.kernel.org/lkml/20210420085105.1156640-1-rppt@kernel.org
> 
>  Documentation/filesystems/proc.rst | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index 48fbfc336ebf..8c77a491c436 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -929,8 +929,14 @@ meminfo
>  ~~~~~~~
>  
>  Provides information about distribution and utilization of memory.  This
> -varies by architecture and compile options.  The following is from a
> -16GB PIII, which has highmem enabled.  You may not have all of these fields.
> +varies by architecture and compile options. Please note that it may happen
> +that the memory accounted here does not add up to the overall memory usage
> +and the difference for some workloads can be substantial. In many cases there
> +are other means to find out additional memory using subsystem specific
> +interfaces, for instance /proc/net/sockstat for TCP memory allocations.
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
Sincerely yours,
Mike.
