Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680A2314058
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbhBHUXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:23:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:52468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236841AbhBHUWz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 15:22:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4613B64DD5;
        Mon,  8 Feb 2021 20:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612815734;
        bh=88qXcijOkj93fMJLtTRsRywpwLWnrSzE/1LXjN13eAg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hJ7Nsh0C9kpc0aPwq25y7d43YfIqsvhcQHqsvL1H1bvoH7gIhfEQ0S9E7gpjnP09K
         E9S0VWanzAVOyA4I+OGkH0JZzw602hd8DbNFAHUCl4MwR5n70FrJEhbWVKjgpj175o
         1ACCkW/BrO1wyPakYayrVsy/vJ7iZRZmy2FAhFcqLzbfLq/AYiDYoebO9efmDDFgdh
         7sks/joMGtxqbQY9FYukp7/uNsGLX4gfd7I0U9dNbVtdpAw49EcKKVqnfdZCqWJdD9
         inKcWSPh1dYlmf4l8peCY3BSl1daRclUdF2N/Xqcn2aMsehpXHAfdsyk/xhR3Jn/Tw
         1nhsvaQTYiMpw==
Date:   Mon, 8 Feb 2021 12:22:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Mark Bloch" <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next V2 01/17] net/mlx5: E-Switch, Refactor setting source
 port
Message-ID: <20210208122213.338a673e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ygnhtuqngebi.fsf@nvidia.com>
References: <20210206050240.48410-1-saeed@kernel.org>
        <20210206050240.48410-2-saeed@kernel.org>
        <20210206181335.GA2959@horizon.localdomain>
        <ygnhtuqngebi.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Feb 2021 10:21:21 +0200 Vlad Buslov wrote:
> > These operations imply that 7.7.7.5 is configured on some interface on
> > the host. Most likely the VF representor itself, as that aids with ARP
> > resolution. Is that so?
> 
> Hi Marcelo,
> 
> The tunnel endpoint IP address is configured on VF that is represented
> by enp8s0f0_0 representor in example rules. The VF is on host.

This is very confusing, are you saying that the 7.7.7.5 is configured
both on VF and VFrep? Could you provide a full picture of the config
with IP addresses and routing? 
