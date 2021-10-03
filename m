Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB530420107
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 11:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhJCJR3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 3 Oct 2021 05:17:29 -0400
Received: from gloria.sntech.de ([185.11.138.130]:57604 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhJCJR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 05:17:28 -0400
Received: from ip5f5a6e92.dynamic.kabel-deutschland.de ([95.90.110.146] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1mWxar-0003m9-17; Sun, 03 Oct 2021 11:15:37 +0200
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     Jakub Kicinski <kuba@kernel.org>,
        Andreas Rammhold <andreas@rammhold.de>
Cc:     netdev@vger.kernel.org, Punit Agrawal <punitagrawal@gmail.com>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        Michael Riesch <michael.riesch@wolfvision.net>
Subject: Re: [PATCH] net: stmmac: dwmac-rk: Fix ethernet on rk3399 based devices
Date:   Sun, 03 Oct 2021 11:15:35 +0200
Message-ID: <2664637.bMcS0GE8HR@diego>
In-Reply-To: <20211003004103.6jdl2v6udxgl5ivx@wrt>
References: <20210929135049.3426058-1-punitagrawal@gmail.com> <20211002172056.76c6c2d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20211003004103.6jdl2v6udxgl5ivx@wrt>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Sonntag, 3. Oktober 2021, 02:41:03 CEST schrieb Andreas Rammhold:
> On 17:20 02.10.21, Jakub Kicinski wrote:
> > On Sat, 2 Oct 2021 23:33:03 +0200 Andreas Rammhold wrote:
> > > On 16:02 01.10.21, Jakub Kicinski wrote:
> > > > On Wed, 29 Sep 2021 23:02:35 +0200 Heiko Stübner wrote:  
> > > > > On a rk3399-puma which has the described issue,
> > > > > Tested-by: Heiko Stuebner <heiko@sntech.de>  
> > > > 
> > > > Applied, thanks!  
> > > 
> > > This also fixed the issue on a RockPi4.
> > > 
> > > Will any of you submit this to the stable kernels (as this broke within
> > > 3.13 for me) or shall I do that?
> > 
> > I won't. The patch should be in Linus's tree in around 1 week - at which
> > point anyone can request the backport.
> > 
> > That said, as you probably know, 4.4 is the oldest active stable branch,
> > the ship has sailed for anything 3.x.
> 
> I am sorry. I meant 5.13.
> 

As the commit has "fixes" tag, it should be picked up automatically
for stable kernels that include the original commit.


Heiko



