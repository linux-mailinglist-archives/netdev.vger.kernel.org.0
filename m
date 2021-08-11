Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164063E9A2B
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 23:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhHKVEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 17:04:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33771 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229655AbhHKVEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 17:04:50 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 368B25C00C4;
        Wed, 11 Aug 2021 17:04:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 11 Aug 2021 17:04:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=QgBhEM
        WhLuteJtYyzx8a0OGrYC8CjFmeV/TwKZUZ8Do=; b=vp1VZWvZIFgKH0jrCc4XjA
        9Yd9+cB2s9uRR4t28PUzIZgdYT7kw0ZHyz8qGCFCe+Mt4kk6rdJYBBQhzU4E/13A
        Zu+LVstRdZJ0Loy1CdYRelDs2Lnc/woBCXp2wxwyM/IqfIWQFVFEZ34nXF5hsnG2
        7buta3fYVterCpS9Nwz4wLoZnsiHVbqdiKWheVz/ksklBeYORXmM/w8mf/AbzxfF
        /UfozTDYlKUVlf+85KREn11tUgBnyX0/Imi3us1jrHEakGjzLqO+j3mth94oAYFn
        4JFB2YRwy/8RmWp8Vpd+17neXVxoLRaNbYhkoFvOO0suSzC2cgQt3448yRXymAOQ
        ==
X-ME-Sender: <xms:VzsUYcc7AJkqcWy7NKMqiAOO8fPLFHE8xSjpf9kJ4gnhodQ5qCGhnw>
    <xme:VzsUYeNZOFBmc_obgDcxIg3IT5ELEguIV6wad39tV9x7A6oZ2zlVUWZOAw5ioglKD
    hiB7eNhNxtVA2A>
X-ME-Received: <xmr:VzsUYdiPZHemt7QplfT7LmrazzflohrWkmHwAHwF1i9b3VnsGbIg-pmktbB8Wc_Rj-8qK7tJfUBFsQ8RQwebT4L0puOMHA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrkedugdduheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:VzsUYR-7EF_YIa4jkEoErA7KhIR2y3XjMBzsLxaWH0CNL4o_7oe6TQ>
    <xmx:VzsUYYtKFSGSAoNwKpH_EDwTMUxd6uaoL7q_NXWsCeefTypE08d5hg>
    <xmx:VzsUYYE7FPp7NYBiGfGx3v7Iew2_R3195L7haDh70xRzlvriT8qjtQ>
    <xmx:WjsUYd8iSJxvb1zkgAGTKAUVpt8CfA5mASiHnRNcb8YmFQbk-QZX_w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Aug 2021 17:04:23 -0400 (EDT)
Date:   Thu, 12 Aug 2021 00:04:19 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        pali@kernel.org, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Message-ID: <YRQ7U22H8fCj2G22@shredder>
References: <YRIqOZrrjS0HOppg@shredder>
 <YRKElHYChti9EeHo@lunn.ch>
 <20210810065954.68036568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRLlpCutXmthqtOg@shredder>
 <20210810150544.3fec5086@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRO1ck4HYWTH+74S@shredder>
 <20210811060343.014724e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRPgXWKZ2e88J1sn@lunn.ch>
 <YRQnEWeQSE22woIr@shredder>
 <20210811133006.1c9aa6db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811133006.1c9aa6db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 01:30:06PM -0700, Jakub Kicinski wrote:
> Isn't the "low-power" attr just duplicating the relevant bits from -m?

If low power is forced by hardware, then it depends on the assertion /
de-assertion of the hardware signal which is obviously not part of the
EEPROM dump.

I knew this would come up, so I mentioned it in the commit message:

"The low power mode can be queried from the kernel. In case
LowPwrAllowRequestHW was on, the kernel would need to take into account
the state of the LowPwrRequestHW signal, which is not visible to user
space."
