Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC8924E97F
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 21:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgHVTvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 15:51:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38486 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728654AbgHVTvq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Aug 2020 15:51:46 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k9ZYG-00Atub-Dw; Sat, 22 Aug 2020 21:51:44 +0200
Date:   Sat, 22 Aug 2020 21:51:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com,
        rmk+kernel@armlinux.org.uk, hkallweit1@gmail.com
Subject: Re: [PATCH net-next v3 0/5] Move MDIO drivers into there own
 directory
Message-ID: <20200822195144.GA2588906@lunn.ch>
References: <20200822180611.2576807-1-andrew@lunn.ch>
 <20200822.125054.873139694261192353.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200822.125054.873139694261192353.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David

I just got a 0-day warning. I will send a fixup soon.

  Andrew
