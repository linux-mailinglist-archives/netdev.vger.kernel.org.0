Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667CA2956D8
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 05:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895476AbgJVDgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 23:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895443AbgJVDgu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 23:36:50 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3C4A21D40;
        Thu, 22 Oct 2020 03:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603337809;
        bh=5ofYYOODjN2tZGYnYAxtWdG3yeXbJGezzR2GON0Bb3U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B/bzIrNXI9o7b3AhULeCa/nD51qv1ql15Am6BQf1CG3Fc++2UqkvltkP0bFHyXohE
         2aMrWfpvUaDnBRe3YAowhrXS2rQiBR+j0i0cPFczA/dxrhwX8YRfnMdez9u840xcpn
         14l1xCIDfOGkcABjTQDGUwyE4crCUlm4mvOIVDDw=
Date:   Wed, 21 Oct 2020 20:36:46 -0700
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
Subject: Re: [PATCH v4] Revert "virtio-net: ethtool configurable RXCSUM"
Message-ID: <20201021203646.62ad7c69@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201021142944.13615-1-mst@redhat.com>
References: <20201021142944.13615-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Oct 2020 10:30:43 -0400 Michael S. Tsirkin wrote:
> This reverts commit 3618ad2a7c0e78e4258386394d5d5f92a3dbccf8.
> 
> When control vq is not negotiated, that commit causes a crash:
> 
> [   72.229171] kernel BUG at drivers/net/virtio_net.c:1667!

Applied, thank you!
