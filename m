Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02D07D98B2
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 19:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394103AbfJPRpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 13:45:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52220 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727400AbfJPRpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 13:45:05 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 382FB142395C2;
        Wed, 16 Oct 2019 10:45:04 -0700 (PDT)
Date:   Wed, 16 Oct 2019 13:45:03 -0400 (EDT)
Message-Id: <20191016.134503.2122228633763051149.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     o.rempel@pengutronix.de, chris.snook@gmail.com,
        f.fainelli@gmail.com, jhogan@kernel.org, jcliburn@gmail.com,
        mark.rutland@arm.com, paul.burton@mips.com, ralf@linux-mips.org,
        robh+dt@kernel.org, linux@armlinux.org.uk,
        vivien.didelot@gmail.com, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH v1 1/4] net: ag71xx: port to phylink
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191016133215.GA17013@lunn.ch>
References: <20191016121216.GD4780@lunn.ch>
        <20191016122401.jnldnlwruv7h5kgy@pengutronix.de>
        <20191016133215.GA17013@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Oct 2019 10:45:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Wed, 16 Oct 2019 15:32:15 +0200

> I don't know if there are any strict rules, but i tend to use To: for
> the maintainer you expect to merge the patch, and Cc: for everybody
> else, and the lists.

This is a good way to handle things.
