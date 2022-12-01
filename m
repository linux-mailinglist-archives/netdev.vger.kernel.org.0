Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88D063F271
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 15:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbiLAOPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 09:15:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbiLAOPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 09:15:46 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CE8C6E5F;
        Thu,  1 Dec 2022 06:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EszH/zNIYaz64egD0a7DIaikbWMUw7R53ett48hdP0M=; b=RJ+2lk9FGd+Nx2qCzcsZC5QLqB
        T681SpFm2r/MkVP9js+jPgto/2UmiGtcADzGKo45hF4W4eJS/vy7GdWmWMegWxmcNXicjva1PTs9e
        8nQtUfrE719YIjPl75BkHvPF2kd5gcB9GBb6/jzNBd/W7MhPJ9rs9v2DS0ek1c1KkD9E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0kL5-0044FH-1m; Thu, 01 Dec 2022 15:14:59 +0100
Date:   Thu, 1 Dec 2022 15:14:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     Brian Masney <bmasney@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        cth451@gmail.com
Subject: Re: [EXT] Re: [PATCH] net: atlantic: fix check for invalid ethernet
 addresses
Message-ID: <Y4i24x8gSAs8/i0I@lunn.ch>
References: <20221130174259.1591567-1-bmasney@redhat.com>
 <Y4ex6WqiY8IdwfHe@lunn.ch>
 <Y4fGORYQRfYTabH1@x1>
 <Y4fMBl6sv+SUyt9Z@lunn.ch>
 <7ed83813-0df4-b6ac-f1d2-a28d8011b1aa@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ed83813-0df4-b6ac-f1d2-a28d8011b1aa@marvell.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Igor

> You should work with Qualcomm on how to update mac addresses of your boards.

Why Qualcomm? I assume the fuses are part of the MAC chip? So Marvell
should have a tool to program them? Ideally, it should be part of

ethtool -E|--change-eeprom

but when i took a quick look, i could not see anything.

    Andrew
