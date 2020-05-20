Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D735F1DBACF
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 19:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgETRLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 13:11:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgETRLr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 13:11:47 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C15B3206B6;
        Wed, 20 May 2020 17:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589994707;
        bh=k5TaWDjbwsX4rrKefKaecbMHS9eHg0MTYi5+K2fa3Co=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yopwfc8zh2/oP9qbMEhFYLMM+AqCmfhuL3wjguXNa9d0Reqnyiteq8P2CCZGbertM
         BdIQTNiatev74kgSc4wqUWwHAIx40TaKFitmn6Wdy/nnkjzt9jRZRA/vLsDWSKIu2w
         lAmSanLkFokuHTnKyZAQBezfb16d1hWlug39AIVM=
Date:   Wed, 20 May 2020 10:11:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>
Subject: Re: [PATCH net-next 07/12] net: atlantic: QoS implementation:
 max_rate
Message-ID: <20200520101135.31aa1a13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200520134734.2014-8-irusskikh@marvell.com>
References: <20200520134734.2014-1-irusskikh@marvell.com>
        <20200520134734.2014-8-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 16:47:29 +0300 Igor Russkikh wrote:
> From: Mark Starovoytov <mstarovoitov@marvell.com>
> 
> This patch adds initial support for mqprio rate limiters (max_rate only).
> 
> Atlantic HW supports Rate-Shaping for time-sensitive traffic at per
> Traffic Class (TC) granularity.
> Target rate is defined by:
> * nominal link rate (always 10G);
> * rate factor (ratio between nominal rate and max allowed).
> 
> Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>

drivers/net/ethernet/aquantia/atlantic/aq_main.c: In function aq_ndo_setup_tc:
drivers/net/ethernet/aquantia/atlantic/aq_main.c:369:7: warning: variable has_max_rate set but not used [-Wunused-but-set-variable]
 369 |  bool has_max_rate;
     |       ^~~~~~~~~~~~
drivers/net/ethernet/aquantia/atlantic/aq_main.c:368:7: warning: variable has_min_rate set but not used [-Wunused-but-set-variable]
 368 |  bool has_min_rate;
     |       ^~~~~~~~~~~~

This probably needs to moved to patch 11 where it's used.
