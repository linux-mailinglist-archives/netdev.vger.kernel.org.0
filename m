Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE031F95B9
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 13:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbgFOL5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 07:57:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728510AbgFOL5r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 07:57:47 -0400
Received: from coco.lan (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6E9420707;
        Mon, 15 Jun 2020 11:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592222267;
        bh=rpbnAOKtxA3+nfUXJkVdH+zEnfJWigejr23KttLO5UY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2i3T7ir8nRePtjA7yM7lTLP8N5Mg8pTCb0g5sSudBtMQUXuSInrQXbPvspRlwfi3D
         e6dqCc5qQw1g9wuB2qHFB+MBvKWAfMx91pxYWrRiBAjO+LwOWTqj1ALsYLAOHXl0yW
         zvCtLuwvkqCilQiWyGUQ4B1EJBkYVMVC7zPzP+bg=
Date:   Mon, 15 Jun 2020 13:57:39 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Sandy Huang <hjc@rock-chips.com>,
        Heiko =?UTF-8?B?U3TDvGJuZXI=?= <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        linux-bluetooth@vger.kernel.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH 13/29] dt: fix broken links due to txt->yaml renames
Message-ID: <20200615135739.798f4489@coco.lan>
In-Reply-To: <20200615111927.GC4447@sirena.org.uk>
References: <cover.1592203542.git.mchehab+huawei@kernel.org>
        <0e4a7f0b7efcc8109c8a41a2e13c8adde4d9c6b9.1592203542.git.mchehab+huawei@kernel.org>
        <20200615111927.GC4447@sirena.org.uk>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mark,

Em Mon, 15 Jun 2020 12:19:27 +0100
Mark Brown <broonie@kernel.org> escreveu:

> On Mon, Jun 15, 2020 at 08:46:52AM +0200, Mauro Carvalho Chehab wrote:
> > There are some new broken doc links due to yaml renames
> > at DT. Developers should really run:  
> 
> I also previously acked this one in 20200504100822.GA5491@sirena.org.uk.
> Has anything changed here to cause the ack to be dropped?

Both patches are the same. I forgot to add your acks on my tree. 

My bad!

Thanks,
Mauro
