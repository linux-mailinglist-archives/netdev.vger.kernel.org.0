Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27EC4E192E
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 01:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244479AbiCTAna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 20:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244474AbiCTAn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 20:43:29 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3420525EC91;
        Sat, 19 Mar 2022 17:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yevVywUNsPA3xEjfhVNTSzafbMfqzWklaj/zazMJRUM=; b=CnMCSnR/HjkbP0eOCIWa/ZoQvD
        GAOXpY+6tSA2bXVjeixqjm1NQpzjRJUGAWNJ8q4kaFZTh/ERKE7clnLhFt3u3PdZspT+cvcF9z1i9
        fohBv4ErCStjNw0yznh299+6m50DDf6TSF2IKrSB8aIv/Jc/W5+H5Lk3VnaGkOvJP+mY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nVjdv-00BlTv-Rm; Sun, 20 Mar 2022 01:41:59 +0100
Date:   Sun, 20 Mar 2022 01:41:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v9 net-next 01/11] dt-bindings: net: make
 internal-delay-ps based on phy-mode
Message-ID: <YjZ4V8+d2TVB75ZW@lunn.ch>
References: <20220318085540.281721-1-prasanna.vengateshan@microchip.com>
 <20220318085540.281721-2-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318085540.281721-2-prasanna.vengateshan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 02:25:30PM +0530, Prasanna Vengateshan wrote:
> *-internal-delay-ps properties would be applicable only for RGMII interface
> modes.
> 
> It is changed as per the request,
> https://lore.kernel.org/netdev/d8e5f6a8-a7e1-dabd-f4b4-ea8ea21d0a1d@gmail.com/
> 
> Ran dt_binding_check to confirm nothing is broken and submitting as a RFC
> patch to receive feedback.
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
