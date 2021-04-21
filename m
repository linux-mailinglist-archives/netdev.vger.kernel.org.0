Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487FC366AF3
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 14:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239832AbhDUMjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 08:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235345AbhDUMjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 08:39:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61067C06174A;
        Wed, 21 Apr 2021 05:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Qh8w6W1RTQVTT8r1EuB9WtIiSIZsU2fv/VFDqOMIuwQ=; b=H6UVNAq6KUvcMXWk3iMsO/UZ2Y
        ILGNp1MmzjG/5qy0rL1OPYCCvX6jgYpA5h+aLunNqmufcnRugmUW+LU861g+4YhrlZa6qb7gRMqWf
        uLJQfLr7vHSs3cyDv1Z7EdIgQ7Bf7shteCcrTloh7pZVWEPXHZXtzh4XJmg7M6BHsmB+DficsjHqT
        RVHN3lVrg+vK3ZSNxwXs2iG+yeILTLMaHl5+NVPieScgfqgRSGhGnkScG+pj4ieiSBVU+M0LWgqht
        HXNVKeewD+cCnmezahUiDJo81PcD0WY7QaJf08dnxlFe1p0K3AHLm4UN3j6Fe06NOw1/DObrTfkoU
        lCialyCg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lZC73-00GVhi-L3; Wed, 21 Apr 2021 12:38:03 +0000
Date:   Wed, 21 Apr 2021 13:37:49 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@linux.ibm.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3] docs: proc.rst: meminfo: briefly describe gaps in
 memory accounting
Message-ID: <20210421123749.GH3596236@casper.infradead.org>
References: <20210421061127.1182723-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421061127.1182723-1-rppt@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 09:11:27AM +0300, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> Add a paragraph that explains that it may happen that the counters in
> /proc/meminfo do not add up to the overall memory usage.
> 
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
