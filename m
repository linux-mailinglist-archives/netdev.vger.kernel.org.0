Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9484B432DEB
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 08:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbhJSGO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 02:14:57 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:52801 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233969AbhJSGO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 02:14:56 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 1E5623200E60;
        Tue, 19 Oct 2021 02:12:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 19 Oct 2021 02:12:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=eDbJOy
        y842JXbwvh5DIfBZK7OjA8UDWj05ncj5SFUnA=; b=E/Ou1Y5oJdOur45JXlLuCK
        TsKqcRzOsdxLVDwvLNS1U1jAHnyn6kFe8EAJfccDwl2ouyvaVwbiY/rT6P0FyyD+
        qXw+XJtKTxkZLdcDtvCIOJ8xHfF9Dat4h8eOOOFNmCzfsjlPBuY6yr2kyegSpZks
        6L6fGY4DsUWqHuOtTgztBhmwpL1FcZnLtsFQUeiqw2hubAIMzv8x4u1IsbtzMESI
        HI2a6rPsj+7bItVfBo2h5K1XSkuEJ+duLbwJKMYnY4EB5JUP7/iql/Zly1Q+hJnl
        LsdKxQJipAFnmTnGAb/wOVFheJeILKCLxj9gXXmdUDW+uMlOauXjHy2GwvQd9+fA
        ==
X-ME-Sender: <xms:22FuYaWbfce0_RjiouavLf0ZSAzUWEG3c0QthumKJafwrQUZWwTd9g>
    <xme:22FuYWmfY6Qkxs8psyyRz1_nICwxH5IjmzyQfY6mPOsAeDSrxWv9ijp7PZ8XCrNSx
    an6jCv82s8Ozvc>
X-ME-Received: <xmr:22FuYeaNz3l8qtiTRRHjUyjBLwYMTGXiKdDz-IJPHHvg32vaqd7Bo5T6I8hZhN1nMboZCehmDzqfHrM_lyNoScR5j5Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddvuddguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpedtffekkeefudffveegueejffejhf
    etgfeuuefgvedtieehudeuueekhfduheelteenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:22FuYRV7x98FdqmkH8fSyg5-P_9tRFdt0mo1MFIMJIonriVwtSd4Eg>
    <xmx:22FuYUkKJGq1dTikEClm6pMXyC34cv1-mAY2LZxZxRLahmxjxtN4cA>
    <xmx:22FuYWeTyNxBW3Mzxk1m1jkyn026uqaVZrHpPAHswYno9K094eL_bQ>
    <xmx:22FuYVB4VyZ5n9uMSHIdRePLDjU_gvWRxrLAukgRmmZwoOxl4TmTKA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Oct 2021 02:12:42 -0400 (EDT)
Date:   Tue, 19 Oct 2021 09:12:34 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, olteanv@gmail.com,
        andrew@lunn.ch, f.fainelli@gmail.com, snelson@pensando.io
Subject: Re: [PATCH net-next 5/6] ethernet: mlxsw: use eth_hw_addr_gen()
Message-ID: <YW5h0tfphxnG+GYV@shredder>
References: <20211018211007.1185777-1-kuba@kernel.org>
 <20211018211007.1185777-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018211007.1185777-6-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 02:10:06PM -0700, Jakub Kicinski wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Thanks!
