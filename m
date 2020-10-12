Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999CF28C51D
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 01:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391009AbgJLXOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 19:14:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388602AbgJLXOJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 19:14:09 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7D1520838;
        Mon, 12 Oct 2020 23:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602544449;
        bh=Kj22Am2aNrpYyeAdtg70srghDDseB3L1dNjWN/HmX74=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ox7j3jS6SQBsF6zksyi2s/jMfP+PbcueCpjMnR5Nvkn4EOKZ3PYwDp0Yy1nclBXnq
         07vin+QGAteQ2LnsdTW/U3ewxAZfmwJPn5Qqh/ZbkdDEHh8SYPnMXf9rs+Nk/i3hSc
         LPaBkHz9ZmtZUwdzT3nGEez8P9F/y148Je7JlZOI=
Date:   Mon, 12 Oct 2020 16:14:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/6] Netfilter/IPVS updates for net-next
Message-ID: <20201012161407.251efb1b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201012013819.23128-1-pablo@netfilter.org>
References: <20201012013819.23128-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 03:38:13 +0200 Pablo Neira Ayuso wrote:
> Hi,
> 
> The following patchset contains Netfilter/IPVS updates for net-next:
> 
> 1) Inspect the reply packets coming from DR/TUN and refresh connection
>    state and timeout, from longguang yue and Julian Anastasov.
> 
> 2) Series to add support for the inet ingress chain type in nf_tables.

Pulled, thanks!
