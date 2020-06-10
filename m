Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6251F4D47
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 07:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgFJFxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 01:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgFJFxn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 01:53:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 481F32074B;
        Wed, 10 Jun 2020 05:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591768423;
        bh=/2TgyOGEKrd2FU+b646mx1YVglemkJKs7lxOPjEWCO8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZDEoFQ4frCiEzR+mN5Sk4MObIpGkmJ8vaIeJgYBsf8dx7/0YZORDC4LYzIbkoBQtN
         o2bUNLHnfP9dSG5qC4s+gfiM11CLPoJjHtBJ9VfdDUPrsj/nVDPLNFReMMGtIgggBC
         pKjpNjWDaTmqJDbJmZRZKEEiwmleYobMNTeQqdJg=
Date:   Wed, 10 Jun 2020 07:53:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Gaurav Singh <gaurav1086@gmail.com>
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Alex Dewar <alex.dewar@gmx.co.uk>,
        "open list:USER-MODE LINUX (UML)" <linux-um@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
Subject: Re: [PATCH] Fix null pointer dereference in vector_user_bpf
Message-ID: <20200610055339.GA1865470@kroah.com>
References: <20200610034314.9290-1-gaurav1086@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610034314.9290-1-gaurav1086@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 11:43:00PM -0400, Gaurav Singh wrote:
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
> 
> The bpf_prog is being checked for !NULL after uml_kmalloc but
> later its used directly for example: 
> bpf_prog->filter = bpf and is also later returned upon success.
> Fix this, do a NULL check and return right away.
> 
> ---
>  arch/um/drivers/vector_user.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

No signed-off-by?
