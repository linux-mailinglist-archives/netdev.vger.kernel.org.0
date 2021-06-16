Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E143A9FB6
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 17:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbhFPPkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 11:40:45 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45477 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234737AbhFPPjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 11:39:23 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 31C9D5C0045;
        Wed, 16 Jun 2021 11:37:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 16 Jun 2021 11:37:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=1WCOO+
        qvuEkTHaeUb4Py6PjcWDQjrWYWjrGCaK9VuNM=; b=tXnWJ5kyP0rT/238YVoGAh
        n/h/mPdHAlU4ZWSVUWc9LuJ+6K8dWFgKN17IMQqeio3eXAJydzZ3umfzAaV+YMCa
        V1IE0Qx1PfowsSe162zoFKVUGGX37wuME+jX2YjAhLW/kWDXXamoeDgFs9XOUbRH
        VZW9bu+M+k0v9i6oI8ZwB6Ftk8tOcPsikfN3dVkw4i8bpUXo5dAzK3nlsgMsbNjT
        rc3owkdNLAAaWEN/TtKL4EQ58RMKsE7QFaiqzlPDWuYm8iCZp3WWl/As4CcpeenJ
        siZYO7gpWEmlBiKSyIwW1+PKHYAM3tBTYoJVkNyy1wXA0OBw3paAGqCfMcQhI71g
        ==
X-ME-Sender: <xms:rBrKYOmkTC2eJHGBcnAQPEyg_FfGmaP2K50LpxvdFsmtcPxpc6jEiQ>
    <xme:rBrKYF2pjYKD4rZaGTkqnMesT4h2WVIFiQjJUup38kh_86ZWKXYrxCThlpCxiiD6-
    Fj1bXzFuinPgSc>
X-ME-Received: <xmr:rBrKYMoCl5vCM_A_z2ffD1ToWnlocgQqRaxH9GNjKngKRdKNDY-gGovh6Fw3XtfXHvgG63dv_3VMqH9lT1g0G1XX4zZE0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvledgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:rBrKYCkY6e7sOITdppmHmZ9NvYB9LsUY4-Gd2Xp5VqRDlcklG2kIqw>
    <xmx:rBrKYM3jAzUrPbzr_KS14VAlei2A8K7sVVN-dWptAJjVp1U0RlfExw>
    <xmx:rBrKYJvINFmMhtssje7OcCFxPuiI13TVuHa0g6F25BENQI4-jKBzcQ>
    <xmx:rRrKYGoWwd4JLhtx_6PnbWDhx0STCp29rr4ixiowekeVnb4SwB8cgA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Jun 2021 11:37:15 -0400 (EDT)
Date:   Wed, 16 Jun 2021 18:37:11 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     jiri@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadym Kochan <vadym.kochan@plvision.eu>, andrew@lunn.ch,
        nikolay@nvidia.com
Subject: Re: [PATCH net-next v2 3/7] drivers: net: netdevsim: add devlink
 trap_drop_counter_get implementation
Message-ID: <YMoap5Vi6ZkXgKr3@shredder>
References: <20210614130118.20395-1-oleksandr.mazur@plvision.eu>
 <20210614130118.20395-4-oleksandr.mazur@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614130118.20395-4-oleksandr.mazur@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 04:01:14PM +0300, Oleksandr Mazur wrote:
> +	debugfs_create_bool("fail_trap_counter_get", 0600,

The test is doing:

echo "y"> $DEBUGFS_DIR/fail_trap_drop_counter_get

And fails with:

./devlink_trap.sh: line 169: /sys/kernel/debug/netdevsim/netdevsim1337//fail_trap_drop_counter_get: Permission denied

Please fix netdevsim to instantiate the correct file and avoid
submitting new tests without running them first.


> +			    nsim_dev->ddir,
> +			    &nsim_dev->fail_trap_counter_get);
>  	nsim_udp_tunnels_debugfs_create(nsim_dev);
>  	return 0;
