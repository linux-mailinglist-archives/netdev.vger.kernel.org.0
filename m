Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D6B2891A7
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 21:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388550AbgJITTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 15:19:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbgJITTq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 15:19:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F5A92227E;
        Fri,  9 Oct 2020 19:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602271185;
        bh=FoN664Emd6xgE5fhzr8F3qqH1cWM2zG9+qpyq0+bgt0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NtORSbJLJ2lkD1Qf54dFMIEq/UyVcm6Vn6FlSs80npeFYuzLHxcaKn+cSs7obY3Hs
         2IebHohWn5Zpq21LzG8+27RoQGMzANwcu598OwrxCPHy7nCRNHfGGYipbnWRv+K8aN
         QYnDhHgsOWiKTv/xZeIximyPDocvU/LuTT0O0jSY=
Date:   Fri, 9 Oct 2020 12:19:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] Netfilter fixes for net
Message-ID: <20201009121944.75660189@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201007001027.2530-1-pablo@netfilter.org>
References: <20201007001027.2530-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Oct 2020 02:10:23 +0200 Pablo Neira Ayuso wrote:
> The following patchset contains Netfilter selftests fixes from
> Fabian Frederick:
> 
> 1) Extend selftest nft_meta.sh to check for meta cpu.
> 
> 2) Fix selftest nft_meta.sh error reporting.
> 
> 3) Fix shellcheck warnings in selftest nft_meta.sh.
> 
> 4) Extend selftest nft_meta.sh to check for meta time.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thank you!
