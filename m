Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A21C5EDCB1
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 14:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbiI1Ma7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 08:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233840AbiI1Mak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 08:30:40 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E589835A
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 05:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cV5y5XDtt0aliJJQquFLsw7W9lVOiZPuxfXBOG1Mi+U=; b=jymjffnml/I3RA04L7nIaIyL4G
        LQ4EEsKOHtji+6o9/R/0OVbN2sEoBnP7xT20SlsQdRcSaF4QKnQJRVI5JzuXeEfqiRbNdDac4PhB0
        VPvVx5GFURi5q1AJKi+LAKDf4V146xM33NHpJB+bW2Hrj9Sz0r/1XWxn1Ja7KID5/4IY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1odWCK-000Vgc-RR; Wed, 28 Sep 2022 14:29:56 +0200
Date:   Wed, 28 Sep 2022 14:29:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [net-next] net: phy: Convert to use sysfs_emit() APIs
Message-ID: <YzQ+RLFu2qOsB8mo@lunn.ch>
References: <1664364860-29153-1-git-send-email-wangyufen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1664364860-29153-1-git-send-email-wangyufen@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 07:34:20PM +0800, Wang Yufen wrote:
> Follow the advice of the Documentation/filesystems/sysfs.rst and show()
> should only use sysfs_emit() or sysfs_emit_at() when formatting the value
> to be returned to user space.
> 
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
