Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACDC2B08D3
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgKLPtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:49:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:52274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728416AbgKLPtK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 10:49:10 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55E1D20A8B;
        Thu, 12 Nov 2020 15:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605196149;
        bh=5Kk7Imy0DB3k9F6JjHCggVAfgxAnVjIz/uMc1OWy0HE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VzEXpiVWpaJSUKvTCPYmovhiG32I7lhIPOkK23HzDRgQrhZVecyZo7Ppohq8l6b2x
         upI76BgzFkBhrf1FlJcNnZSKRYYDB+2J9UC4BE0KJIDxISxDQOI0OBG/vFmZtjThPh
         VewglUx7VOvmwmlpzj+c/W2KHbbQAr4PmuHEBwag=
Date:   Thu, 12 Nov 2020 07:49:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Martin Willi <martin@strongswan.org>,
        David Ahern <dsahern@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] vrf: Fix fast path output packet handling with
 async Netfilter rules
Message-ID: <20201112074908.33a7335c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201111234301.GA3058@salvia>
References: <20201106073030.3974927-1-martin@strongswan.org>
        <20201110133506.GA1777@salvia>
        <2df88651a28cf77daf09e3d1282261d518794629.camel@strongswan.org>
        <20201111234301.GA3058@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 00:43:01 +0100 Pablo Neira Ayuso wrote:
> no objections from my side to this patch, thanks.

Applied, thanks!
