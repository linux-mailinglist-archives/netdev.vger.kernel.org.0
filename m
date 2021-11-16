Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76BD452C4E
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 09:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhKPIEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 03:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbhKPIEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 03:04:04 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E952C061570;
        Tue, 16 Nov 2021 00:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NZ6V5TOIzgHCm0vuXK7I9PnJf/d76XttZxhxpQ+4by4=; b=SfCqd5MwaEgtJlsTgsy5Ykr9Sa
        WdLsRm0y7FCHyWPmmRTWs+T5Z5bcJJd/uY5x149jAGUNRHN70zRSAvQOcfJ2eZrlskSqptdsNQ24d
        dKCJ2HHXVbsdm8srYvjBkC7sX3ArEeOAEuvJKDYVou5fse7any6pxO9pd0Ub6yH6r2stS63UZs8Dq
        154xPu4ZyXq9MMslGGuevn3ulh8nFLj9J/8ecFyF2pHWRA5IwmSNUYUJVL+QFiI+4BtyfND7gHZzt
        aylUU234IpklBd++rsilHdIcVM6KFcCUlvimjlN2PIrhJaiGKcvW5+jNIkscs+pSg2jbYTYDAvdzW
        t5iiJdtw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmtOe-00GHPd-To; Tue, 16 Nov 2021 08:00:53 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id A1E9198651D; Tue, 16 Nov 2021 09:00:51 +0100 (CET)
Date:   Tue, 16 Nov 2021 09:00:51 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     x86@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 2/7] set_memory: introduce
 set_memory_[ro|x]_noalias
Message-ID: <20211116080051.GU174703@worktop.programming.kicks-ass.net>
References: <20211116071347.520327-1-songliubraving@fb.com>
 <20211116071347.520327-3-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116071347.520327-3-songliubraving@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 11:13:42PM -0800, Song Liu wrote:
> These allow setting ro/x for module_alloc() mapping, while leave the
> linear mapping rw/nx.

This needs a very strong rationale for *why*. How does this not
trivially circumvent W^X ?
