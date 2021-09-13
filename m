Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A48DA40A10A
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 00:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350094AbhIMWxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 18:53:39 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53580 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349745AbhIMWxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 18:53:02 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8C71860056;
        Tue, 14 Sep 2021 00:49:30 +0200 (CEST)
Date:   Tue, 14 Sep 2021 00:50:37 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH 1/1] netfilter: ipset: Fix oversized kvmalloc() calls
Message-ID: <20210913225037.GA5737@salvia>
References: <4591ee34-aa44-92d-51a8-22e8be5db20@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4591ee34-aa44-92d-51a8-22e8be5db20@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 06, 2021 at 06:26:34PM +0200, Jozsef Kadlecsik wrote:
> The commit 
> 
> commit 7661809d493b426e979f39ab512e3adf41fbcc69
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Wed Jul 14 09:45:49 2021 -0700
> 
>     mm: don't allow oversized kvmalloc() calls
> 
> limits the max allocatable memory via kvmalloc() to MAX_INT. Apply the
> same limit in ipset.

Applied, thanks Jozsef.
