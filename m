Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936E9436E0B
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 01:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbhJUXPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 19:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230280AbhJUXPy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 19:15:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3138260F57;
        Thu, 21 Oct 2021 23:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634858017;
        bh=eDyP8f7UUPt+1FdUXtMtj3LqM/nWamnVpjP5JHo2SrM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fb2YrbMOJQbYFQsJGbPn/Lj7bCF3oQMY26/yoy8g8c3t1a0IGX+tv5VIDCHF1oJsW
         VCfg7a9EnM5BDTPVchXme5D9xOW1/vek/FpQZ6hEbbgoEIFg+olrUgQrTA3zjAgj8f
         5SZCck7bg/ZKp+0Mf2w66AXORXgwbjR2uudgZPYvArrisiIUcRodRYnxjDWZADcgbR
         aNQmOFnQ3EV61ZFdonTaKPyzTbVDuCl0amuq5qerwnfjwOIXdH6sj1AK+184vu/Ln9
         y2tNWnrspJwAAgWAtJcg791hnZnonv5qKzagswVJ4L73prsyPHGo0d6HDSoWj4JW9E
         I4kSRsYKQMV5w==
Date:   Thu, 21 Oct 2021 16:13:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     andrew@lunn.ch, mickeyr@marvell.com, serhiy.pshyk@plvision.eu,
        taras.chornyi@plvision.eu, Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: marvell: prestera: add firmware v4.0
 support
Message-ID: <20211021161336.76885ef8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1634722349-23693-1-git-send-email-volodymyr.mytnyk@plvision.eu>
References: <1634722349-23693-1-git-send-email-volodymyr.mytnyk@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Oct 2021 12:32:28 +0300 Volodymyr Mytnyk wrote:
> +struct prestera_port_mac_state {
> +	bool oper;
> +	u32 mode;
> +	u32 speed;
> +	u8 duplex;
> +	u8 fc;
> +	u8 fec;
> +};
> +
> +struct prestera_port_phy_state {
> +	u64 lmode_bmap;
> +	struct {
> +		bool pause;
> +		bool asym_pause;
> +	} remote_fc;
> +	u8 mdix;
> +};
> +
> +struct prestera_port_mac_config {
> +	bool admin;
> +	u32 mode;
> +	u8 inband;
> +	u32 speed;
> +	u8 duplex;
> +	u8 fec;

Is it just me or these structures are offensively badly laid out?

pahole is your friend.

> +};
> +
> +/* TODO: add another parameters here: modes, etc... */
> +struct prestera_port_phy_config {
> +	bool admin;
> +	u32 mode;
> +	u8 mdix;
> +};
