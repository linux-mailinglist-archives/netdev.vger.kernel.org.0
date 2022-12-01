Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC47263F963
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 21:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiLAUsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 15:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiLAUsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 15:48:47 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1463C6E0;
        Thu,  1 Dec 2022 12:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2SVV90pj+UQ0Fb13WshMPyga636VKNklNN1qenW6MPs=; b=mZBoXJQWKIjm6sASM2q/jSB8m0
        LAdGBlOLd1x/SgUws3pqt6gjOGjvdd+6o8L5N3inLGSL+9XFplmmZzlWT1JCavc70Z9UcPvvA4lu+
        UAGUzNwbitf120OXQ0LVB9LHjkRe4mS8jm+8jr/jHMgEWDRt8yZDcekUlcaK1geNyu1I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0qTl-00462v-3h; Thu, 01 Dec 2022 21:48:21 +0100
Date:   Thu, 1 Dec 2022 21:48:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: swphy: Only warn once for unknown
 speed
Message-ID: <Y4kTFRBvsN/JCeNd@lunn.ch>
References: <20221201202254.561103-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201202254.561103-1-sean.anderson@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 03:22:53PM -0500, Sean Anderson wrote:
> swphy_read_reg is called quite frequently during normal operation. If an
> invalid speed is used for state, then it can turn dmesg into a firehose.
> Although the first warn will likely contain a backtrace for the
> offending driver, later warnings will usually just contain a backtrace
> from the phy state machine. Just warn once.

Hi Sean

How did you trigger this? I have a patch in this area as well, which i
want Russells opinion on. I'm wondering if we are hitting the same
problem.

	Andrew
