Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8893F28D76A
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 02:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbgJNA2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 20:28:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbgJNA2s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 20:28:48 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C0352078A;
        Wed, 14 Oct 2020 00:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602635327;
        bh=KE/8MMS74BQXbDfEIlt1YsQYNT3kHjwm6Nje58qXgsU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DOo+XyE+jhujXtxlhFI3Z3j9F4EC/RNxmXOQuE+dUEp2nrbS9H+NfXEqHytnhpzkn
         RD1qdbHQ/KDjB44rVH5Vl9IcP4BeajDoU/KYSEP34ZyP5AvGh+AIPW0TmwfJqkJ7Us
         Tbi1IvnnRaCZPdVr8XDlkMVsKekkzNbXzl0nAVts=
Date:   Tue, 13 Oct 2020 17:28:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     xiangxia.m.yue@gmail.com
Cc:     jasowang@redhat.com, mst@redhat.com, willemb@google.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3] virtio-net: ethtool configurable RXCSUM
Message-ID: <20201013172845.65585d63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201012015820.62042-1-xiangxia.m.yue@gmail.com>
References: <20201012015820.62042-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 09:58:20 +0800 xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> Allow user configuring RXCSUM separately with ethtool -K,
> reusing the existing virtnet_set_guest_offloads helper
> that configures RXCSUM for XDP. This is conditional on
> VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
> 
> If Rx checksum is disabled, LRO should also be disabled.
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Applied, thanks everyone!
