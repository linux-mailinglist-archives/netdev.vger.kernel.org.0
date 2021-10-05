Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C439C422082
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 10:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbhJEIUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 04:20:11 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:55667 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232108AbhJEIUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 04:20:05 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7FCA5580B38;
        Tue,  5 Oct 2021 04:18:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 05 Oct 2021 04:18:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=SW2Dra
        EWdIArbf3vHzKpDWWktQRGgxnTlg/lBPBfWsA=; b=EAfU1YI7BhZPisjHuxnBSR
        NK2LvqwhJAJ7/Q9WwMUd9CoceyYBb0eLVvCuBxxpj53OvNdEYn6CuLJTRD+LChvC
        FFCGCGnKvfZRN8Mf0jVGSJeHlutmoeF7i7P0uxGLxtq/IR3zt85oM3K97lD8Lb3Q
        LpKj14jKhyW+Pp175AnQCKReoQJEiqGkGkhXtnJ9Vetxl/CDsnPvaygvOuSR+16F
        he16KhGunv/atnyPbqmdsGKQK8Amq3OFUdDai/dtgH2COeodnCQDl6Skm/uF3kYN
        eZpFdljOKEsjtK1dLbrIhqf97v5PFELwLGlb9wWgWraLy145lobFIQTxvnk5vV+g
        ==
X-ME-Sender: <xms:RgpcYSetg1AOJ_S0Og_GlC0mUNiUZtbPFcOjNqvubXW_rXeBfwr6Qw>
    <xme:RgpcYcPfi08SfwtIJgc36u0eo33_RuarFev77D1ebcGRm1iaujrCEIPbpKvNcdUxW
    09M2RXuadBPd9o>
X-ME-Received: <xmr:RgpcYTjQu-IYeHNHf2snkEJKZNYMC3P6a_hE82SgzqrDeA-B323jPu8IJydWAEH94u3PKsy-Az4VAN85l4ir1YUcrLZSSA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudelgedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpefgjeevhfdvgeeiudekteduveegueejfefffeefteekkeeuueehjeduledtjeeu
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:RgpcYf9jjQ8ElSr05NuoPRdINSGYskONWfm0azVj2F_s-iAXdCxK4g>
    <xmx:RgpcYetxYjRr-wR4pXrgAipAO2LUhViFdHEA96jVkxMLJXB2GKpg9Q>
    <xmx:RgpcYWE_zg-24-arEKcdb1FV5zJ_m_nTX592U3ff2TOx0kEcs0r9tg>
    <xmx:RgpcYeGuodsZW9lUk0WotmJkhMXGAgV4xsAcvt4G8TGiN19at8tjkA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 5 Oct 2021 04:18:13 -0400 (EDT)
Date:   Tue, 5 Oct 2021 11:18:09 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        mlxsw@nvidia.com, Moshe Shemesh <moshe@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shay Drory <shayd@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next v2 5/5] devlink: Delete reload enable/disable
 interface
Message-ID: <YVwKQWrlsuiGtmei@shredder>
References: <cover.1633284302.git.leonro@nvidia.com>
 <06ebba9e115d421118b16ac4efda61c2e08f4d50.1633284302.git.leonro@nvidia.com>
 <YVsNfLzhGULiifw2@shredder>
 <YVshg3a9OpotmOQg@unreal>
 <YVsxqsEGkV0A5lvO@shredder>
 <YVtPruw9kzOQvhZu@unreal>
 <YVvsR4CxOW09k8KX@shredder>
 <YVwBiomKH9Bju/KV@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVwBiomKH9Bju/KV@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 10:40:58AM +0300, Leon Romanovsky wrote:
> Can I added your TOB to the patch?

Yes

Tested-by: Ido Schimmel <idosch@nvidia.com>
