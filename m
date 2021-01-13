Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD572F4319
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbhAME1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:27:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:54226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725681AbhAME1O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 23:27:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4C3C2312E;
        Wed, 13 Jan 2021 04:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610511994;
        bh=ebWVBNgjIS95zbpspVZ4MTQupc/TKqWi3PdJD+H0BkQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cq6PZu6/bbI0/Z8ZxBqURoT2oxNksJ1tKYuGg4Gbxwh4PkELdLbT9IIGmbKYFex2m
         66p5UhknPIzBuH6yvyJgJxaa9WCCtcqiig85j6WqbWPGOBC1qOGViugjRJJXDS7p6w
         8g/BfOYO2k/Rf6KFLFuNTDLTGmf+dOntFh30sXu8OVU3KiJYVdTNlG3BdSbkU5f+uK
         0gl6/dW/2/dNtvT8kmswK3w/Ug+DKPMlgCQKqqp0kl6Jt8/3xdTzHo07oElfUtrkC0
         dmUCMuZ3SAsb6p2OSf/kYSYXrmW9CUhTxphRi4eFC+SlBIC6DMquw09G8zCyuRhz7L
         4Rk2Dn9w8CqmA==
Date:   Tue, 12 Jan 2021 20:26:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 0/3] Netfilter fixes for net
Message-ID: <20210112202632.7286b8a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210112222033.9732-1-pablo@netfilter.org>
References: <20210112222033.9732-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 23:20:30 +0100 Pablo Neira Ayuso wrote:
> The following patchset contains Netfilter fixes for net:
> 
> 1) Pass conntrack -f to specify family in netfilter conntrack helper
>    selftests, from Chen Yi.
> 
> 2) Honor hashsize modparam from nf_conntrack_buckets sysctl,
>    from Jesper D. Brouer.
> 
> 3) Fix memleak in nf_nat_init() error path, from Dinghao Liu.

Pulled, thanks!
