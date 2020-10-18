Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAC8291827
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 17:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbgJRP6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 11:58:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33344 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbgJRP6Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 11:58:24 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUB4c-002Jm1-7m; Sun, 18 Oct 2020 17:58:18 +0200
Date:   Sun, 18 Oct 2020 17:58:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     michael alayev <mic.al.linux@gmail.com>
Cc:     vivien.didelot@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, adror@iai.co.il
Subject: Re: Dts for eth network based on marvell's mv88e6390x crashes
 Xilinx's linux-kernel v5.4
Message-ID: <20201018155818.GB456889@lunn.ch>
References: <CANBsoPmgct2UTq=Cuf1rXJRitiF1mWhWwdtH2=73yyZiJbT0rg@mail.gmail.com>
 <20201016033142.GB456889@lunn.ch>
 <CANBsoPkCEZadmBaeZ=8EAOP6Ctw5deLen7yKQk__1-ZVoJE6yA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANBsoPkCEZadmBaeZ=8EAOP6Ctw5deLen7yKQk__1-ZVoJE6yA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 10:18:53AM +0300, michael alayev wrote:
> Hello andrew,
> > This is pretty unreadable with all the white space removed.
> > Please could you post again with the white space.
> Its formatted better here:
> https://stackoverflow.com/q/64301750/8926995?sem=2

Better, but the indentation is still wrong.

Please fix your email client and post the DT file for review. I will
then point out some of the errors.

    Andrew
