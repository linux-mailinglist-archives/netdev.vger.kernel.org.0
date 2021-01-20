Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2242FCAEC
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 07:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbhATGJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 01:09:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:42904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbhATGI6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 01:08:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C44C6217BA;
        Wed, 20 Jan 2021 06:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611122897;
        bh=RR54Qs4HyvFncXLjeeZ8ZNoWbpER2eGQN67MAA65J8g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n8ZMmcVpD1uURQ5NGIAawLGiLgoRL2IAUVgy9CnCdUSYva1zb9C/4vq4IQ4uIJ7EM
         HGTqKG7/BNZL4PfOqcKP3WNISw6EtYR1OrQaf/ea19W3qq8JLPmfrwkdWXwOH5qQk2
         q9U+gthlT1Pz61jqJBZR2LNKJ8OPL7aAMeg2UFJJaFrNJB/4dHuLljKNc2s12Tqki+
         SqiWM0xJNMLD1oIZPU6ay0Mh1AitLYMB6UCbBVKVrYm7jji9KAke9dlTjN+azi7ufg
         2yp5Xo9bYxFK6y+BhMS1cNATbYAiH39s4auOZJ7lz9TlsRiLBo3rsH+HRRR8nWE2hx
         zD5LenpclqHHQ==
Date:   Tue, 19 Jan 2021 22:08:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Wu <david.wu@rock-chips.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.10 28/45] net: stmmac: Fixed mtu channged by
 cache aligned
Message-ID: <20210119220815.039ac330@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210120012602.769683-28-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
        <20210120012602.769683-28-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jan 2021 20:25:45 -0500 Sasha Levin wrote:
> From: David Wu <david.wu@rock-chips.com>
> 
> [ Upstream commit 5b55299eed78538cc4746e50ee97103a1643249c ]
> 
> Since the original mtu is not used when the mtu is updated,
> the mtu is aligned with cache, this will get an incorrect.
> For example, if you want to configure the mtu to be 1500,
> but mtu 1536 is configured in fact.
> 
> Fixed: eaf4fac478077 ("net: stmmac: Do not accept invalid MTU values")
> Signed-off-by: David Wu <david.wu@rock-chips.com>
> Link: https://lore.kernel.org/r/20210113034109.27865-1-david.wu@rock-chips.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This was applied 6 days ago, I thought you said you wait two weeks.
What am I missing?
