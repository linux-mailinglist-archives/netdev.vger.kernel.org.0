Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68B53A3736
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 00:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbhFJWic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 18:38:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229963AbhFJWib (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 18:38:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0C1460FDA;
        Thu, 10 Jun 2021 22:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623364594;
        bh=RvRenoYzl8sz4gk4Gp+AZG1jbHQSaEdP2sHG3M8vbgs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iq1Wl/5qvhFOWbe2JFuDupjZrSVjiAFPgkwAc2AyGJ3MT0bPRCyfGHXVt56LiGa7G
         57EFMUE9XH0gj7Y4MXnLF0v683/Vj3HaZ2jfqU3uADhHXkMXYmw6hi8+ldr0BJv4NE
         tkRcVxS45yWfDk6aSwepka71LKHz2kITiV5L73b1QhwEoWA9XrabMTi3jyOx1Z0Hdm
         uf17sQJgiE+uFJlKzGkHMjx/NqKNWOmAIM2CCg+rb3FGI8KKOwBWbkuMjplnKDrco+
         6rZ8UsrWWnV/bjezPuGHhZRrUIp5SvlK7wQfWsv9V+u2iokcme4Jhlsyj17atkfAgj
         qog0Zosr02AYg==
Date:   Thu, 10 Jun 2021 15:36:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [pull request][net-next 00/16] mlx5 updates 2021-06-09
Message-ID: <20210610153633.7ee38b2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210610025814.274607-1-saeed@kernel.org>
References: <20210610025814.274607-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Jun 2021 19:57:58 -0700 Saeed Mahameed wrote:
> This series introduces insert/remove header support
> for sw steering and switchdev bridge offloads support.

Great to see bridge offload for NICs! :)
