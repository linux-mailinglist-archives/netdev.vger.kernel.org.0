Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5303F27F27F
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbgI3TT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:19:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36684 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728031AbgI3TT5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 15:19:57 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNhds-00Gwtg-5v; Wed, 30 Sep 2020 21:19:56 +0200
Date:   Wed, 30 Sep 2020 21:19:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Peter Vollmer <peter.vollmer@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>
Subject: Re: dsa/mv88e6xxx: leaking packets on MV88E6341 switch
Message-ID: <20200930191956.GV3996795@lunn.ch>
References: <CAGwvh_MAQWuKuhu5VuYjibmyN-FRxCXXhrQBRm34GShZPSN6Aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGwvh_MAQWuKuhu5VuYjibmyN-FRxCXXhrQBRm34GShZPSN6Aw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What would be the best way to debug this ? Is there a way to dump the
> ATU MAC tables to see what's going on with the address learning ?

If you jump to net-next, and use

https://github.com/lunn/mv88e6xxx_dump

You can dump the full ATU from the switch.

bridge fdb show

can give you some idea what is going on, but it is less clear what is
in the hardware and what is in software.

   Andrew
