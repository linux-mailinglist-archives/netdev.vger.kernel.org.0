Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04F8292E3E
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 21:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730975AbgJSTPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 15:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730021AbgJSTPD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 15:15:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAF7E2225A;
        Mon, 19 Oct 2020 19:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603134902;
        bh=6QniT4qXChIvKKNDNwlUnu6lz7YkQMzpyMNXjiuZXIE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kidTgzSaXLHxw2frYOhHEq41zzvhp17vHGUeNGPIexRB4ao7oRZxvsowHpN9KRt7e
         kEL/+PlOhmVyGOrjPhD+e/qM6g0vZtrjjB2cB+mM3UTw4b//cpiE7H6OqPgLgYc3P8
         SX0oYfulUxTd5xe1scOJvW6OSrKNUhVj7VgWQOX0=
Date:   Mon, 19 Oct 2020 12:15:00 -0700
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
Message-ID: <20201019121500.4620e276@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201018103122.454967-1-mst@redhat.com>
References: <20201018103122.454967-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 13:32:12 -0400 Michael S. Tsirkin wrote:
> This reverts commit 3618ad2a7c0e78e4258386394d5d5f92a3dbccf8.
> 
> When the device does not have a control vq (e.g. when using a
> version of QEMU based on upstream v0.10 or older, or when specifying
> ctrl_vq=off,ctrl_rx=off,ctrl_vlan=off,ctrl_rx_extra=off,ctrl_mac_addr=off
> for the device on the QEMU command line), that commit causes a crash:

Hi Michael!

Only our very first (non-resend) version got into patchwork:

https://patchwork.ozlabs.org/project/netdev/list/?submitter=2235&state=*

Any ideas why?
