Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347314329DA
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 00:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhJRWu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 18:50:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhJRWuZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 18:50:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E333B610A3;
        Mon, 18 Oct 2021 22:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634597294;
        bh=eo/6GohdC/CRxBU2Xdc7IHx0o0lmHc/3UIkGWZz2qhQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sNjLrXYsNQxIvpN4e40V4XHDrCw8MedrCnGN3aFSdcnEoUDFLdGsx69PR8G8e8NYn
         kr6SOHyH7nBR1e1fg86wjh55iCyPkLJqObO6QAdUB/3/WphxT5/g5rb3lyg9xHTANw
         i7rhiGqnzlKzW9iy5B//UnVgRlt6BbH1+1kzjRh1qgcM4v7030VHwC+8pNBOmJO8Xi
         9CQO0Kupv9ZfiUU12/NpUybuJIIgM+ReYawZpZdcxzKkWAFbRHPbMvL7/vEFxKh7TZ
         D9e+KUqy1/Y7SCqsYtNe9emOig4msG13xaZeDM/HkN8AmhknNrRLixPiKsqAZdhbMB
         JwD5Nov1I2MsQ==
Date:   Mon, 18 Oct 2021 15:48:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [net-next RESEND PATCH 1/2] net: dsa: qca8k: tidy for loop in
 setup and add cpu port check
Message-ID: <20211018154812.54dbc3ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211017145646.56-1-ansuelsmth@gmail.com>
References: <20211017145646.56-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 Oct 2021 16:56:45 +0200 Ansuel Smith wrote:
> Tidy and organize qca8k setup function from multiple for loop.
> Change for loop in bridge leave/join to scan all port and skip cpu port.
> No functional change intended.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

There's some confusion in patchwork. I think previous posting got
applied, but patch 1 of this series git marked as applied.. while 
it was patch 2 that corresponds to previous posting..?

Please make sure you mark new postings as v2 v3 etc. It's not a problem
to post a vN+1 and say "no changes" in the change log, while it may be 
a problem if patchwork bot gets confused and doesn't mark series as
superseded appropriately.

I'm dropping the remainder of this series from patchwork, please rebase
and resend what's missing in net-next.

Thanks!
