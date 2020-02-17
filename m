Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCE57161270
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 14:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728781AbgBQNAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 08:00:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49816 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728539AbgBQNAA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 08:00:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=u64M0BiFowYIT2xnwiZJEXjjngUHjJfj/tLUFkbK1JA=; b=GqoiM7XksepTCq2HiVWucVI5qf
        vIDqXPUJy/9xS5tDzgFKbCtsJZu3RTBv7jxz5/ikQrE+hXBKW7kkIL899yK3DyXyLim0YJT79uPa2
        Bp8rsAwyD/eX9/IHvWqnpDu+x8om7lHSfM99Ve7/t/cFNAhchvxsIIlLx8bIRMgm1Pvc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j3g09-0004bC-M1; Mon, 17 Feb 2020 13:59:53 +0100
Date:   Mon, 17 Feb 2020 13:59:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Paul Cercueil <paul@crapouillou.net>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mathieu Malaterre <malat@debian.org>
Subject: Re: [PATCH] net: ethernet: dm9000: Handle -EPROBE_DEFER in
 dm9000_parse_dt()
Message-ID: <20200217125953.GD32734@lunn.ch>
References: <20200216193943.81134-1-paul@crapouillou.net>
 <1513E253-0E58-4088-84E2-E35F3067BB4B@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1513E253-0E58-4088-84E2-E35F3067BB4B@goldelico.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Is the EPROBE_DEFER mechanism also working for drivers
> fully compiled into the kernel (I may have been mislead
> since EPROBE_DEFER patches are almost always done to make
> drivers work as modules)?

Yes. It is a generic mechanism and used with all driver probe
functions.

     Andrew
