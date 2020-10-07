Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5030285634
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 03:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgJGBTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 21:19:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbgJGBTB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 21:19:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10F2620782;
        Wed,  7 Oct 2020 01:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602033540;
        bh=26dCdgz5eceYB7U+NkO7SKdBQ0YKwIYF/J77niJk95A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LfWiWBXkdnLlvtvlwLOnHVFblbSNnuO5mofEDaLUCA/uL18i1fwvNgQRT5akwNU+d
         nTUj2QAnLDm2Gfo33l2fq10KlGymX42R1HR2etawKFMAvWA2R6Z2dX3Gq8qnDEsk5E
         k+9vqEzUNnpjaFxU6LMg2iqS4MXgLkkNoXLWSB6U=
Date:   Tue, 6 Oct 2020 18:18:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH bpf-next V1 3/6] bpf: add BPF-helper for reading MTU
 from net_device via ifindex
Message-ID: <20201006181858.6003de94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201006183302.337a9502@carbon>
References: <160200013701.719143.12665708317930272219.stgit@firesoul>
        <160200018165.719143.3249298786187115149.stgit@firesoul>
        <20201006183302.337a9502@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Oct 2020 18:33:02 +0200 Jesper Dangaard Brouer wrote:
> > +static const struct bpf_func_proto bpf_xdp_mtu_lookup_proto = {
> > +	.func		= bpf_xdp_mtu_lookup,
> > +	.gpl_only	= true,
> > +	.ret_type	= RET_INTEGER,
> > +	.arg1_type      = ARG_PTR_TO_CTX,
> > +	.arg2_type      = ARG_ANYTHING,
> > +	.arg3_type      = ARG_ANYTHING,
> > +};
> > +
> > +

FWIW

CHECK: Please don't use multiple blank lines
#112: FILE: net/core/filter.c:5566:
+
+
