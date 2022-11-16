Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5443462BFEA
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 14:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbiKPNql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 08:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbiKPNqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 08:46:40 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B466B17E29;
        Wed, 16 Nov 2022 05:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pefjafUqIIIDXpqaasVAKbU2CnZvuItW0KOov0jNJWk=; b=ZUqNLY66MzSOhd4yZEOq32HA9w
        l85AxyW0RhyRztBgGBYkauOHhKOph57L6usUE94sMgIyPHJoQml/jMbwPh6/CZMtvMmLNTIJ0Lm6i
        v6TUegfVp13hb9SnpU2e97LoWYINp8SWR53iSUaJFLHC6QSAFp9EHx9C4Pk5Z6yxopU0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ovIjz-002ZXZ-KD; Wed, 16 Nov 2022 14:46:11 +0100
Date:   Wed, 16 Nov 2022 14:46:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Tachici <alexandru.tachici@analog.com>
Cc:     linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        steve.glendinning@shawell.net, UNGLinuxDriver@microchip.com,
        andre.edich@microchip.com, linux-usb@vger.kernel.org
Subject: Re: [net v2 1/1] net: usb: smsc95xx: fix external PHY reset
Message-ID: <Y3Tpo6wo2ytMRpXf@lunn.ch>
References: <20221115114434.9991-1-alexandru.tachici@analog.com>
 <20221115114434.9991-2-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115114434.9991-2-alexandru.tachici@analog.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 01:44:34PM +0200, Alexandru Tachici wrote:
> An external PHY needs settling time after power up or reset.
> In the bind() function an mdio bus is registered. If at this point
> the external PHY is still initialising, no valid PHY ID will be
> read and on phy_find_first() the bind() function will fail.
> 
> If an external PHY is present, wait the maximum time specified
> in 802.3 45.2.7.1.1.
> 
> Fixes: 05b35e7eb9a1 ("smsc95xx: add phylib support")
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>

Thanks for making Russell suggested change.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
