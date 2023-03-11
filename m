Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66AEB6B5D0A
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 15:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjCKOyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 09:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCKOyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 09:54:01 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D60F117206;
        Sat, 11 Mar 2023 06:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iHHKRP69W43ACLoWxboDmANBtskKavjkbphy802RNys=; b=l2tGtxSh6V/nPKGtMzIdOJk2p6
        ZBNJu7ocSQpaOh750qKqSi2SWNH5teX4T16hzR/cYMKkz6rwy8jA9mnEwHmSzJq8cfHQlGBtucR/z
        2F2c37lgL283fhfhs1BDcyHbMDa5lWfXfQ3RBvOXut9Rrnk/eh0gXPlmsxw+8lT0IkEs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pb0bW-00749q-Hy; Sat, 11 Mar 2023 15:53:50 +0100
Date:   Sat, 11 Mar 2023 15:53:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Klaus Kudielka <klaus.kudielka@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: dsa: mv88e6xxx: re-order functions
Message-ID: <8affe7aa-55d3-4e96-b39a-99049ca8cd84@lunn.ch>
References: <20230311094141.34578-1-klaus.kudielka@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230311094141.34578-1-klaus.kudielka@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 10:41:40AM +0100, Klaus Kudielka wrote:
> Move mv88e6xxx_setup() below mv88e6xxx_mdios_register(), so that we are
> able to call the latter one from here. Do the same thing for the
> inverse functions.
> 
> Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>

Hi Klaus

If this your first patchset for netdev? There are a few process issues
you missed. Please take a look at:

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html

This patchset if for net-next, so the subject should indicate that.
It is also normal to include a patch 0/X which explains the big
picture. Part of the commit message you have in patch 2/2 would then
appear in 0/2.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
