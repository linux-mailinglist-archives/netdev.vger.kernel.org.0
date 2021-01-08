Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6EBA2EF9E3
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 22:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbhAHVEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 16:04:50 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58084 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729181AbhAHVEt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 16:04:49 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kxyvX-00Gy7G-Sg; Fri, 08 Jan 2021 22:04:07 +0100
Date:   Fri, 8 Jan 2021 22:04:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Brian Silverman <silvermanbri@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: MDIO over I2C driver driver probe dependency issue
Message-ID: <X/jIx/brD6Aw+4sk@lunn.ch>
References: <CAJKO-jaewzeB2X-hZ4EiZiyvaKqH=B0CrhvC_buqfMTcns-b-w@mail.gmail.com>
 <4606bd55-55a6-1e81-a23b-f06230ffdb52@gmail.com>
 <X/hhT4Sz9FU4kiDe@lunn.ch>
 <CAJKO-jYwineOM5wc+FX=Nj3AOfKK06qK-iqQSP3uQufNRnuGWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJKO-jYwineOM5wc+FX=Nj3AOfKK06qK-iqQSP3uQufNRnuGWQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 03:02:52PM -0500, Brian Silverman wrote:
> Thanks for the responses - I now have a more clear picture of what's going on.
>  (Note: I'm using Xilinx's 2019.2 kernel (based off 4.19).  I believe it would
> be similar to latest kernels, but I could be wrong.)

Hi Brian

macb_main has had a lot of changes with respect to PHYs. Please try
something modern, like 5.10.

	  Andrew
