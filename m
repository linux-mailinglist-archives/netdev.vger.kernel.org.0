Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBFA1F3A26
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 13:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgFILzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 07:55:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727945AbgFILzU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 07:55:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE0FF2078D;
        Tue,  9 Jun 2020 11:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591703719;
        bh=qV4UJCt4oL3d8fYSD/QGpLUYiUgDIQDAupv4BVtBnlA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JGzQ+gOfszeVXZkHyCQ/ZEKaMDxVBo+TnASoha35Ooq7saWkOUAPwLoQbb+oKykBb
         dk8yXlvQ15C6kGV+JeTIgVELNw2noy6JIsg/Tmcq070FBiYT0IhHJxC8oN/caMl1cV
         TRVFDG9baIFtxp+mFx5foQhkipTT57mHzwhbyA3w=
Date:   Tue, 9 Jun 2020 13:55:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Gaurav Singh <gaurav1086@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bpf: alloc_record_per_cpu Add null check after malloc
Message-ID: <20200609115517.GC819153@kroah.com>
References: <20200609113839.9628-1-gaurav1086@gmail.com>
 <20200609113839.9628-2-gaurav1086@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609113839.9628-2-gaurav1086@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 07:38:39AM -0400, Gaurav Singh wrote:
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
> ---
>  samples/bpf/xdp_rxq_info_user.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

I know I don't take patches without any changelog text, maybe other
maintainers are more lax...
