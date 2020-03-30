Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E37B197399
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 06:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgC3E5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 00:57:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33170 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgC3E5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 00:57:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D6FE715C55800;
        Sun, 29 Mar 2020 21:57:03 -0700 (PDT)
Date:   Sun, 29 Mar 2020 21:57:03 -0700 (PDT)
Message-Id: <20200329.215703.1788464189000179821.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] split phylink PCS operations and add PCS
 support for dpaa2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200326151404.GB25745@shell.armlinux.org.uk>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
        <20200326151404.GB25745@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 29 Mar 2020 21:57:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Thu, 26 Mar 2020 15:14:04 +0000

> This series splits the phylink_mac_ops structure so that PCS can be
> supported separately with their own PCS operations, separating them
> from the MAC layer.  This may need adaption later as more users come
> along.

It looks like there will be a respin of this based upon Andrew's
feedback.
