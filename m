Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D240D2944AD
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 23:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438702AbgJTVnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 17:43:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392089AbgJTVnv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 17:43:51 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44C9D22244;
        Tue, 20 Oct 2020 21:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603230231;
        bh=FmYy3cdKdcZnVWppAPofL56Fg9vXaupW07qBZifg0Co=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c3m7+rCOhvzKIHDrI/jXQLmw2DAbJsxv7oeiBXopx1AxfqhsmczAhk6Z55NiTV0n1
         NEaiaaiFwRbkmVz/xDT9w0ugD/1ZqlkTGMqGR+ZuZHv2lngntEN1y7PkiEdGLWzYmx
         59SpgGd5YTn1H6KO5C1lcnrMxBjv9ENwaayw5anw=
Date:   Tue, 20 Oct 2020 14:43:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        kernel test robot <lkp@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH net v2] Revert "virtio-net: ethtool configurable RXCSUM"
Message-ID: <20201020144348.29af571a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201020073651-mutt-send-email-mst@kernel.org>
References: <20201018103122.454967-1-mst@redhat.com>
        <20201019121500.4620e276@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201020073651-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 07:45:09 -0400 Michael S. Tsirkin wrote:
> On Mon, Oct 19, 2020 at 12:15:00PM -0700, Jakub Kicinski wrote:
> > On Mon, 19 Oct 2020 13:32:12 -0400 Michael S. Tsirkin wrote:  
> > > This reverts commit 3618ad2a7c0e78e4258386394d5d5f92a3dbccf8.
> > > 
> > > When the device does not have a control vq (e.g. when using a
> > > version of QEMU based on upstream v0.10 or older, or when specifying
> > > ctrl_vq=off,ctrl_rx=off,ctrl_vlan=off,ctrl_rx_extra=off,ctrl_mac_addr=off
> > > for the device on the QEMU command line), that commit causes a crash:  
> > 
> > Hi Michael!
> > 
> > Only our very first (non-resend) version got into patchwork:
> > 
> > https://patchwork.ozlabs.org/project/netdev/list/?submitter=2235&state=*
> > 
> > Any ideas why?  
> 
> I really don't! Any ideas?

No idea. I have a local instance of patchwork to test things, and it
didn't pick your patch up either. Weird.

Looks like there will be v3, let's not worry about it for this single
patch, worst case I'll pick it up from inbox or lore.
