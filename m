Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C36D1DBA64
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 18:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgETQ5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 12:57:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbgETQ5p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 12:57:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9FBC206B6;
        Wed, 20 May 2020 16:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589993865;
        bh=7Fln7lDh9dpjDKNT4OEVlt7TZCQem7oXjLDzQGzqudI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iYub648o5vo6JOYIkDeeoPNCcGM83A7L/X/nAI4ni21B7PETfqLSPg8R046G5Ex4M
         HE/Js/cel4eOi9PpKAJBtd/0AxZn+TruihJ7BHd1NSkvJdXRKul/FBIpJRRvjKbSR7
         0Ip/cAdnhy/3l++Q7JXLlvTFVm8lAdAGo7pRE858=
Date:   Wed, 20 May 2020 09:57:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, jeffrey.t.kirsher@intel.com,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com,
        bjorn.topel@intel.com
Subject: Re: [PATCH bpf-next v4 03/15] xsk: move driver interface to
 xdp_sock_drv.h
Message-ID: <20200520095743.0d6dda04@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200520094742.337678-4-bjorn.topel@gmail.com>
References: <20200520094742.337678-1-bjorn.topel@gmail.com>
        <20200520094742.337678-4-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 11:47:30 +0200 Bj=C3=B6rn T=C3=B6pel wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
>=20
> Move the AF_XDP zero-copy driver interface to its own include file
> called xdp_sock_drv.h. This, hopefully, will make it more clear for
> NIC driver implementors to know what functions to use for zero-copy
> support.
>=20
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

With W=3D1:

net/xdp/xsk_queue.c:67:26: warning: symbol 'xsk_reuseq_prepare' was not dec=
lared. Should it be static?
net/xdp/xsk_queue.c:86:26: warning: symbol 'xsk_reuseq_swap' was not declar=
ed. Should it be static?
net/xdp/xsk_queue.c:108:6: warning: symbol 'xsk_reuseq_free' was not declar=
ed. Should it be static?
net/xdp/xsk_queue.c:67:27: warning: no previous prototype for xsk_reuseq_pr=
epare [-Wmissing-prototypes]
  67 | struct xdp_umem_fq_reuse *xsk_reuseq_prepare(u32 nentries)
     |                           ^~~~~~~~~~~~~~~~~~
net/xdp/xsk_queue.c:86:27: warning: no previous prototype for xsk_reuseq_sw=
ap [-Wmissing-prototypes]
  86 | struct xdp_umem_fq_reuse *xsk_reuseq_swap(struct xdp_umem *umem,
     |                           ^~~~~~~~~~~~~~~
net/xdp/xsk_queue.c:108:6: warning: no previous prototype for xsk_reuseq_fr=
ee [-Wmissing-prototypes]
 108 | void xsk_reuseq_free(struct xdp_umem_fq_reuse *rq)
     |      ^~~~~~~~~~~~~~~
