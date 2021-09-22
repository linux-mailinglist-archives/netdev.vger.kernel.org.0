Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB82414B74
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 16:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbhIVONg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 10:13:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54526 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234515AbhIVONf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 10:13:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GMMBKyUAi82Lq2P//wOPOfZhCuFKigywARlk3BQCVPc=; b=vbF9645RrANE0ljI02yKKC2yPy
        6eHViEEV3H5H82pHla2wXOVDexXI9tdxd9Ib3m9NXufdYNChpRmatFthqBloGLpSnNqt5vYfMUU47
        Z4sO5AXjutM9lrpB2REqZM1nchmyjk68JqykhnAP6lPUHe767RDFAjgVvRjtZgyLQ4R0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mT2yh-007n8e-Jk; Wed, 22 Sep 2021 16:12:03 +0200
Date:   Wed, 22 Sep 2021 16:12:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     John Smith <4eur0pe2006@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: stmmac: Disappointing or normal DMA performance?
Message-ID: <YUs5s4AcZJrNhCqj@lunn.ch>
References: <CADZJnBbMmE-zktRyq-gZWPuEOHRLyuQRmheqKP1_HWuHRymK0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADZJnBbMmE-zktRyq-gZWPuEOHRLyuQRmheqKP1_HWuHRymK0g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Is there a way to increase the ratio of packets / IRQs? I want fewer
> IRQs with more packets as the current performance overloads my
> embedded chip,

Have you played with ethtool -c/-C.

     Andrew
