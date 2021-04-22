Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3418D3684C7
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 18:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236615AbhDVQ1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 12:27:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236058AbhDVQ1L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 12:27:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF1B661077;
        Thu, 22 Apr 2021 16:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619108796;
        bh=mNGR1kwwmLfDQaatKtt0BJE28FQuiJQhoYYBiS31MZw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b3v82huMOcUHGYGKwzrowyWa9IoEHv/lHcbTsdACq/X61RnZBAiH35oEaZmgVD39K
         2j8x2dnpe4t/c8/E5Z3yC9p6abJd7Yc5UdcnUcNAnixxpE6aIrhQLjnlDyRdNtJPMP
         sJ/dPe0Hr9ZfEF/UGV/NBmwMA0W0zJGME2aGSVvvoGA1ZAD+XP4trnU0TL0Jp7C5C/
         sUDEjNA2F6BJX9kZ+2m2UUiR98R4TKogvc6WZe6Zx5W2/RgXgZwxFOT69QLvIx4QG9
         C+Ym9fUXSsJMlEoa8m1FRm0yegdDGYiwrfJ8trfPCiU66prZNoIe6/wlBj6/dMQhwR
         8OkRTkPSyiiJQ==
Date:   Thu, 22 Apr 2021 09:26:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next] netdevsim: Only use sampling truncation length
 when valid
Message-ID: <20210422092634.18f23f8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YIGikZ2xZhH7ZRZc@shredder.lan>
References: <20210422135050.2429936-1-idosch@idosch.org>
        <20210422091426.6fda8280@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YIGikZ2xZhH7ZRZc@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Apr 2021 19:21:37 +0300 Ido Schimmel wrote:
> > > +	md->trunc_size = psample->trunc_size ? psample->trunc_size : len;  
> > 
> > nit:  ... = psample->trunc_size ? : len;  ?  
> 
> Yea, I don't find this form too readable and always prefer the one I
> used when it fits in a single line :)

Fair enough.
