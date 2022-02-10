Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD88C4B0F05
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 14:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242362AbiBJNpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 08:45:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242357AbiBJNpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 08:45:04 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A2BD89
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 05:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=fN7+FW3gDHkar8M5VJ+hYGNgeVgCTdu60n/qFpOf5xY=; b=Ve
        i4bD4fcTpo8b6HsYAOV7SEzRZTIPRffqFd7KrAAqlEOEnhg9NHJJZNMpslTa4j3/2OnO+Y3ScNa5m
        wZwDs80+omo7rvtojiK7k23zz5/XeGhKv3relAz/GiMnfoVut0F5oQVhWT1G/AYTI2xX0dmmV0cUO
        Ymje+CRIKhl8fQU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nI9ks-005ItL-P1; Thu, 10 Feb 2022 14:45:02 +0100
Date:   Thu, 10 Feb 2022 14:45:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Holger Brunck <holger.brunck@hitachienergy.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [v6] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude
 configurable
Message-ID: <YgUW3hcGW9Zh9zNC@lunn.ch>
References: <20220210084322.15467-1-holger.brunck@hitachienergy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220210084322.15467-1-holger.brunck@hitachienergy.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 09:43:22AM +0100, Holger Brunck wrote:
> The mv88e6352, mv88e6240 and mv88e6176  have a serdes interface. This patch
> allows to configure the output swing to a desired value in the
> phy-handle of the port. The value which is peak to peak has to be
> specified in microvolts. As the chips only supports eight dedicated
> values we return EINVAL if the value in the DTS does not match one of
> these values.
> 
> CC: Andrew Lunn <andrew@lunn.ch>
> CC: Jakub Kicinski <kuba@kernel.org>
> CC: Marek Behún <kabel@kernel.org>
> Signed-off-by: Holger Brunck <holger.brunck@hitachienergy.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
