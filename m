Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52BB2BAC2A
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 15:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgKTOug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 09:50:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41362 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbgKTOug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 09:50:36 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kg7k2-0087lL-LC; Fri, 20 Nov 2020 15:50:26 +0100
Date:   Fri, 20 Nov 2020 15:50:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joe Perches <joe@perches.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mdio_bus: suppress err message for reset gpio
 EPROBE_DEFER
Message-ID: <20201120145026.GM1853236@lunn.ch>
References: <20201119203446.20857-1-grygorii.strashko@ti.com>
 <1a59fbe1-6a5d-81a3-4a86-fa3b5dbfdf8e@gmail.com>
 <cabad89e-23cc-18b3-8306-e5ef1ee4bfa6@ti.com>
 <44a3c8c0-9dbd-4059-bde8-98486dde269f@gmail.com>
 <20201119214139.GL1853236@lunn.ch>
 <221941d6-2bb1-9be8-7031-08071a509542@gmail.com>
 <20201119212122.665d5396@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <f722b8c425fb78f2434b4e66bbe4fbd69165903e.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f722b8c425fb78f2434b4e66bbe4fbd69165903e.camel@perches.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joe

> reverse xmas tree is completely crazy.
> 
> But I posted a patch to checkpatch to suggest it for net/
> and drivers/net/ once
> 
> https://lkml.org/lkml/2016/11/4/54
 

> From Joe Perches <> 
>
...

> and the reverse xmas tree helpfulness of looking up the
> type of bar is neither obvious nor easy.
>
> My preference would be for a bar that serves coffee and alcohol.

Ah, those were the days.

Anyway, can this patch be brought back to life, with the problem
pointed out fixed? It is still something we do in netdev, and a
machine can spot these problems better than a human maintainer or
developer.

Thanks
	Andrew
