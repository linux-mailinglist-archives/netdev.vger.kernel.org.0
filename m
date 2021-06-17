Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060733AB9C8
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 18:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhFQQfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 12:35:42 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44455 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229671AbhFQQfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 12:35:40 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 4C14F5C00B9;
        Thu, 17 Jun 2021 12:33:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 17 Jun 2021 12:33:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=SVJpsp
        UTtsMqD+SfZGja0BS7fGyqXIDisMay+SUIGPg=; b=XkoN/8Xsaa6mHDYbZvtTfW
        KFrmPdaNCSDLCpiim7PyFXovRimyvsyfHb1R5fRl2sTED+8zOlF3GOjxOkTl2qYM
        WVpY3kucaj1ysGkYwzvJyK0e6Kv4U58aLoTFcVF5D7aOaxj5VOF9y5zW4134cI7l
        LfYhs58uW4svLlFhBMMjF2RsMSfbdCkKatgLiznZ7EGo5/p+e2lzfvkrdshljy0V
        Vj5ZeUjL8xUHM60MxoqhLnUT+ptJfUcRmuTDR/eAo/HCwxRoqW3Emt1j9Tzz8gbY
        Juvr+gQ7l50p4Nq/dI2doYYO/m2SWYo1XHxyrze/WdYajSHUkaFJbu5O6lx0Mx8Q
        ==
X-ME-Sender: <xms:W3nLYF9sdDqAPCnuHLWJ4sHVU1irp1sPzUbGNoBtFXKJf5ToF8d41Q>
    <xme:W3nLYJuaeQ5DXZg7Tjs4vFRwM1l6TxNZ9NC7AErR92oCWK3elJYD76skYViwaUhf8
    ZkmX47uzX7MCwc>
X-ME-Received: <xmr:W3nLYDBu8lJhYrTNLSDjXDQM8WyJOZAgtJGJXWCFykHnbpN_HRQOl6wc3Plc7qj-RGwWYXUYY9IwBXr7L9Un2qmbKZV-ow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefuddguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:W3nLYJd2W5mTEZgjGJSPu-dcaBV-5A7je-lRsBmoMwxBvDfvl9dpIA>
    <xmx:W3nLYKPs9Pm_F9iJ0ICcdySQFAStMbBKdEAy6goKLxhXfcya6Vu78Q>
    <xmx:W3nLYLnPDXv6EfK0j31VQvz1RV6Yvv45akOFAzwToUGJfMvZJ_3prg>
    <xmx:XHnLYHqGcEzLv_eFiWPM336fE8BZvWM2yRsJ09jViwhcNVK2nhx3Qw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Jun 2021 12:33:31 -0400 (EDT)
Date:   Thu, 17 Jun 2021 19:33:27 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Amit Cohen <amcohen@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net] ethtool: strset: Fix reply_size value
Message-ID: <YMt5Vx9/Yz+3hXB+@shredder>
References: <20210617154252.688724-1-amcohen@nvidia.com>
 <20210617162923.i7cvvxszntf7mvvl@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617162923.i7cvvxszntf7mvvl@lion.mk-sys.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 06:29:23PM +0200, Michal Kubecek wrote:
> I believe this issue has been already fixed in net tree by commit
> e175aef90269 ("ethtool: strset: fix message length calculation") but as
> this commit has not been merged into net-next yet, you could hit it with
> the stricter check.

Yea. I reached the same conclusion :/
