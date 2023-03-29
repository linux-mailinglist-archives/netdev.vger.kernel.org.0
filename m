Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8B96CEC75
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 17:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjC2PMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 11:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjC2PMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 11:12:12 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF0B1BC1
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=28Pr4zR7IRQvHXOHnlOjcxNUvBchaLpHZZNI3iIoHjk=; b=dm
        L4zuIMWyQneQEZZZF9BDeuzfUZ023YdpFminCDBma5Ngm4NhDfh4Em3PN8hTawgMQndWRbAttAVxt
        6DfMen4kxO7Pnm9av/awC9oDG8weDk9RmWmgskq6ieSFXU9eTkirngkuj1kLn5u65DUXvQwI1rqwi
        lhviN6CGI5OdaVw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1phXT5-008ltC-LK; Wed, 29 Mar 2023 17:12:07 +0200
Date:   Wed, 29 Mar 2023 17:12:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     kuba@kernel.org, olteanv@gmail.com, netdev@vger.kernel.org,
        steffen@innosonix.de, Fabio Estevam <festevam@denx.de>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Enable IGMP snooping on user
 ports only
Message-ID: <e81dae2b-654b-4922-afd8-255be4b92a7a@lunn.ch>
References: <20230329150140.701559-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230329150140.701559-1-festevam@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 12:01:40PM -0300, Fabio Estevam wrote:
> From: Steffen Bätz <steffen@innosonix.de>
> 
> Do not set the MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP bit on CPU or DSA ports.
> 
> This allows the host CPU port to be a regular IGMP listener by sending out
> IGMP Membership Reports, which would otherwise not be forwarded by the
> mv88exxx chip, but directly looped back to the CPU port itself.
> 
> Fixes: 54d792f257c6 ("net: dsa: Centralise global and port setup code into mv88e6xxx.")
> Signed-off-by: Steffen Bätz <steffen@innosonix.de>
> Signed-off-by: Fabio Estevam <festevam@denx.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
