Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3652B31B8
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 02:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgKOBDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 20:03:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:42978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgKOBDM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 20:03:12 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 546B524137;
        Sun, 15 Nov 2020 01:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605402191;
        bh=FU5CmdD0GZEvL9KLF89pYyDzIii67JkKi/p0LI6XAvg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Cv1/90BqGD0n1mIGO4YQbq5wCzO6xjJHHqza1rKt025/nEOe0txjhDK+4CD4ql+Q/
         BFPIQUFA7FFWFDU+vOcgAQw3ENc/zhoLoUEzhblUsVpXfb6pM81i5iCQRsQNiJ1cz6
         uzSPzBHji+XJcPTRQs/xp7OzF7A80ACJF9RiXnzA=
Date:   Sat, 14 Nov 2020 17:03:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lev Stipakov <lstipakov@gmail.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lev Stipakov <lev@openvpn.net>
Subject: Re: [PATCH v3] net: xfrm: use core API for updating/providing stats
Message-ID: <20201114170310.39e47f8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201113215939.147007-1-lev@openvpn.net>
References: <f1238670-7d0a-2311-7ee5-c254c8ef2a22@gmail.com>
        <20201113215939.147007-1-lev@openvpn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 23:59:40 +0200 Lev Stipakov wrote:
> Commit d3fd65484c781 ("net: core: add dev_sw_netstats_tx_add") has added
> function "dev_sw_netstats_tx_add()" to update net device per-cpu TX
> stats.
> 
> Use this function instead of own code.
> 
> While on it, remove xfrmi_get_stats64() and replace it with
> dev_get_tstats64().
> 
> Signed-off-by: Lev Stipakov <lev@openvpn.net>
> Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>

Since this is a follow up to Heiner's work I'll apply directly as well.

Thanks!
