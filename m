Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAD72C0C4
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 10:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfE1ICA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 04:02:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46892 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfE1ICA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 04:02:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5Anq1qwGKoGsIX6kb9ZWLK4o9JgSaVCCm8wVkC+oVCE=; b=AUfFmnK9XzeNtgYFLAw32vYpg
        uHV8PlXfVQ8TVUhu+7QmSiTGyVi9+JtQqh6ES2ANR77xHCPHIea/pNle1cd/kpxZs7jF/S0QPtYlh
        4H+WGxCtJ588MjkDyGPi25GnNQuQ6g0qkn/2A4IAemeQAWpii2+4Vq1yDIzJBNuVQ17tCMsnWghwR
        HgA0EieTjD/ELwj3HL9UR3qjzAUkM6i47p4SCrEPQGdRwT0hS8OUEDiwEWiZQwRde+rmtEoPmOP46
        GWKL83J16ZVG0bJYENsh+lIg5TwAG7fYcaMCjxdAUejy5dczD2i1PVruv7VulObHGR+3Rk7oDE+uS
        eG/JZb/bQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hVX3Q-0001oC-40; Tue, 28 May 2019 08:01:52 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8CAA52073CF8D; Tue, 28 May 2019 10:01:49 +0200 (CEST)
Date:   Tue, 28 May 2019 10:01:49 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc:     linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org, luto@kernel.org,
        dave.hansen@intel.com, namit@vmware.com
Subject: Re: [PATCH v5 0/2] Fix issues with vmalloc flush flag
Message-ID: <20190528080149.GJ2623@hirez.programming.kicks-ass.net>
References: <20190527211058.2729-1-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190527211058.2729-1-rick.p.edgecombe@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 27, 2019 at 02:10:56PM -0700, Rick Edgecombe wrote:
> These two patches address issues with the recently added
> VM_FLUSH_RESET_PERMS vmalloc flag.
> 
> Patch 1 addresses an issue that could cause a crash after other
> architectures besides x86 rely on this path.
> 
> Patch 2 addresses an issue where in a rare case strange arguments
> could be provided to flush_tlb_kernel_range(). 

Thanks!
