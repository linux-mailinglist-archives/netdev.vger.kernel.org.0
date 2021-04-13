Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34DB35E655
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 20:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347666AbhDMS1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 14:27:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231793AbhDMS1C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 14:27:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB66D61221;
        Tue, 13 Apr 2021 18:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618338402;
        bh=tGtL/i8vNC36pdOHvsP+XsaxHMKt9/bwDNm0w1N9u4c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EdwWp90OTqVrrdc3PXK+tjO3z0HdEg26HtaETEWnh3hFf0/tsfqrVWaoghmISdKMo
         0OMLWQoC/hd846769FGtj8oKlbTxHH6BMudc+mdVvrq1u1DL2mPmOyVY7TABTuZ+ky
         1TJ3e3bohAW78ZwNl9aSs5SbWm221xSqNa7W5TgdxYYYzlWWIDc5y33D+oAdZDmxrz
         2s6zeJXe26bC2vWHRPAOp1yv6d61GEZHd4iiHBK+2GduqTGaumJv2Ok1yr9blm5Wbo
         lKlpyxxvtiEiZ/fLxp6Rkh0eInr+FblTQ+Xbud910RdyEJItzHm+6YWrWXePKXM6si
         m8r4h7PpuXZ0w==
Date:   Tue, 13 Apr 2021 11:26:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust . li" <dust.li@linux.alibaba.com>
Subject: Re: [PATCH net-next v4 01/10] netdevice: priv_flags extend to 64bit
Message-ID: <20210413112641.77cc46fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210413031523.73507-2-xuanzhuo@linux.alibaba.com>
References: <20210413031523.73507-1-xuanzhuo@linux.alibaba.com>
        <20210413031523.73507-2-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Apr 2021 11:15:14 +0800 Xuan Zhuo wrote:
> @@ -1598,72 +1600,75 @@ struct net_device_ops {
>   *	skb_headlen(skb) == 0 (data starts from frag0)
>   */
>  enum netdev_priv_flags {
> -	IFF_802_1Q_VLAN			= 1<<0,
> +	IFF_802_1Q_VLAN_BIT,

This breaks kdoc, now the kdoc documents values which don't exist 
in the enum.
