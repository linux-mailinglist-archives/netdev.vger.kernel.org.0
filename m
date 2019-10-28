Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB30E79AC
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 21:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbfJ1UJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 16:09:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38980 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbfJ1UJz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 16:09:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vvs6/1ZE5Cq4PLZYjH3T1fIgZxPvlq2T/p9dncyoJ8s=; b=gRPhcZwtUp/5mQ43ufGjVJrSQi
        p0MWdgMJRxioBjiLBYexk+QHKAHrkB3C2iayE4aPh2cTqUiMutxQ18ko6E9xXego0SiCpa6db6JLr
        AWnWuJrj6p/LFgcqtosWMUVIArUlZUmnaGNuVPSJAfY6z6CbNRZz2xarHeEMvRyWiFaM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iPBKq-0008P3-0p; Mon, 28 Oct 2019 21:09:52 +0100
Date:   Mon, 28 Oct 2019 21:09:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>
Subject: Re: [PATCH net-next 3/4] net: phy: marvell: add downshift support
 for M88E1111
Message-ID: <20191028200952.GH17625@lunn.ch>
References: <4ae7d05a-4d1d-024f-ebdf-c92798f1a770@gmail.com>
 <7c5be98d-6b75-68fe-c642-568943c5c4b6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c5be98d-6b75-68fe-c642-568943c5c4b6@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 08:53:25PM +0100, Heiner Kallweit wrote:
> This patch adds downshift support for M88E1111. This PHY version uses
> another register for downshift configuration, reading downshift status
> is possible via the same register as for other PHY versions.

Hi Heiner

I think this method is also valid for the 88E1145.

  Andrew
