Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736BB1DBA93
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 19:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgETRD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 13:03:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727917AbgETRDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 13:03:49 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DFE420708;
        Wed, 20 May 2020 17:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589994228;
        bh=/YtqEongQLlP1gJq4f41wHCnKACXtCf/GgNRIFAx/h8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C01ybvQtnzIB0EvtgCHy/2qwoBsIDW3cigmV2uHwWrQC7vsZi+YBAGHYbML7SSGjs
         2YkZY0jN7JXGK/oNAQ0OuUEFhf7xudXR7VHRs9DrrsJGtsJ6ZBOBPW45y7A8zIx1+k
         oSaGA+AV+XqTRJl6HOoqm5CMAzFdgPermilOA5MA=
Date:   Wed, 20 May 2020 10:03:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, jeffrey.t.kirsher@intel.com,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v4 09/15] ice, xsk: migrate to new
 MEM_TYPE_XSK_BUFF_POOL
Message-ID: <20200520100342.620a0979@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200520094742.337678-10-bjorn.topel@gmail.com>
References: <20200520094742.337678-1-bjorn.topel@gmail.com>
        <20200520094742.337678-10-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 11:47:36 +0200 Bj=C3=B6rn T=C3=B6pel wrote:
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>=20
> Remove MEM_TYPE_ZERO_COPY in favor of the new MEM_TYPE_XSK_BUFF_POOL
> APIs.
>=20
> Cc: intel-wired-lan@lists.osuosl.org
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

patch 8 also has a warning I can't figure out.

But here (patch 9) it's quite clear:

drivers/net/ethernet/intel/ice/ice_xsk.c:414: warning: Excess function para=
meter 'alloc' description in 'ice_alloc_rx_bufs_zc'
drivers/net/ethernet/intel/ice/ice_xsk.c:480: warning: Excess function para=
meter 'xdp' description in 'ice_construct_skb_zc'
