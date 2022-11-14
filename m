Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B82628B27
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 22:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237374AbiKNVM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 16:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237710AbiKNVMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 16:12:22 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4345E6408;
        Mon, 14 Nov 2022 13:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xIjWcPtAcihDqkDiY25oZnjoC9bawELovlYmR4og6Ws=; b=iFNVs+rEtjUkYYZk2e9QPoMBlC
        Y9OUUcY1YF7c0FxYMtoQ2DgoqjtH9mw+92Y4fPKzO41Hwr0yv5N1TfC4aoHR2IhTXLsIBm8rMQ6Qq
        4Xf7mwJ2EiyREKW5mkUCttU0ilSkPUc2n3f+f+GCvZFWnvRKoxDggeic3dT+SEXyuwJk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ougk8-002Nn3-06; Mon, 14 Nov 2022 22:11:48 +0100
Date:   Mon, 14 Nov 2022 22:11:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next][PATCH] dsa: lan9303: Changed ethtool stats
Message-ID: <Y3KvE+4kYUYTDzZe@lunn.ch>
References: <20221114210233.27225-1-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114210233.27225-1-jerry.ray@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jerry

> Added a version number to the module.

Don't bother, it is useless. A driver is not standalone, it depends on
the rest of the kernel around it. Somebody telling you version 1.1 is
broken is no help, you have no idea what version of mainline is around
it, or if it is a backport in a vendor kernel along with 1000 other
patches.

And as a general comment, one patch should do one thing. Please break
this up into a patchset.

     Andrew
