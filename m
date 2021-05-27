Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEAF39353F
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 20:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbhE0SJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 14:09:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231226AbhE0SJF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 14:09:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 815F460FF2;
        Thu, 27 May 2021 18:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622138851;
        bh=iadBsht2ofCApk6Ndf7ZgoNDIxy9VU8M+44A3KxQQF4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mUyUQMM9Z6h/wQ+P56CN7Gg7klZTICdzT78KG8dpC7WNjgpuBWgTs+3E9lDbjhOnu
         CO3Jhw5HUvq9XvdWTFkCM9N2wGE8C4EtoCUn1XRFAwCd7jnrBmLdXw4yOPz6z1Tpb8
         S4Y9QrqUxxDsQNKR8IrIxjYPGS7hQ0+yF6feaf7om+OIFSya9uO6/qyTF33r367RCt
         lHMMVpRUWROQ7pv6cNM2equjAJFLRqe0qLBPLNVhZ9UxuefYV/p3JZnKtB22MEb5Xh
         18/K3+QmDyy9I7ntcAzcy+BRE5XzwiG+p5eW5GStoTbtVtncoO7QQIwN/8a89ZAueu
         BM8RI+v3/VIqw==
Date:   Thu, 27 May 2021 11:07:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] virtio-net: Add validation for used length
Message-ID: <20210527110730.7a5cc468@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210527073643.123-1-xieyongji@bytedance.com>
References: <20210527073643.123-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 May 2021 15:36:43 +0800 Xie Yongji wrote:
> This adds validation for used length (might come
> from an untrusted device) to avoid data corruption
> or loss.
> 
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>

This does not apply to net nor net-next.
