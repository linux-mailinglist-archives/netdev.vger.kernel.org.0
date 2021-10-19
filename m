Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61B8433AE6
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhJSPoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 11:44:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46900 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231848AbhJSPoI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 11:44:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+OlbF0jSuR1cXQ3cNgQFhYBGf1ZZmkVncY84uNcWU8Y=; b=wlZeNwBvlU25W+mRhLeX89o/rQ
        pHdRSigCWgOSi+Y3P4l1ivNhiHMWCREGUNgrUNgFvHowdLiRksDHUzuzxHa9zUeDVd1xYyNzV8hLO
        pP+Aq2UJax0wTmrigSurIypV2omnepek1WATh7i5oXrHZ2fCPU+HuQI6TaaXi3EpauDg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mcrFN-00B5hX-MU; Tue, 19 Oct 2021 17:41:49 +0200
Date:   Tue, 19 Oct 2021 17:41:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: Re: [PATCH] net: renesas: Fix rgmii-id delays
Message-ID: <YW7nPfzjstmeoMbf@lunn.ch>
References: <20211019145719.122751-1-kory.maincent@bootlin.com>
 <CAMuHMdWghZ7HM5RRFRsZu8P_ikna0QWoRfCKeym61N-Lv-v4Xw@mail.gmail.com>
 <20211019173520.0154a8cb@kmaincent-XPS-13-7390>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211019173520.0154a8cb@kmaincent-XPS-13-7390>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> When people update the kernel version don't they update also the devicetree?

DT is ABI. Driver writers should not break old blobs running on new
kernels. Often the DT blob is updated with the kernel, but it is not
required. It could be stored in a hard to reach place, shared with
u-boot etc.

	Andrew
