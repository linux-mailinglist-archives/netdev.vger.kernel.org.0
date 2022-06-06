Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51BB853F1E5
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 23:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235000AbiFFV6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 17:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiFFV6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 17:58:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C306B03E;
        Mon,  6 Jun 2022 14:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iGWULO+VlekG2EE2L6kpDe23jcWGlAVkecnxC28q3Fk=; b=L6Jm7Qe2S7ghfnq07Yhxfp3OmP
        ae/Fd7W5GkLhDvCLrSFuHAeEaZ3dL+JPBs0gNCYZDLkMPymyVTUJTUlZW1ZUzlNd0SKEpBWpcLvKv
        7tzm9jhXcqWeBQ52wvAhYHYyswSrRJOQPzXFRup1HtJjh9/2knOQrqZ72wSUFIgCPE1w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nyKjY-005qoa-Tb; Mon, 06 Jun 2022 23:58:00 +0200
Date:   Mon, 6 Jun 2022 23:58:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Murphy <dmurphy@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] dt-bindings: dp83867: add binding for
 io_impedance_ctrl nvmem cell
Message-ID: <Yp54aOPqd5weWnFt@lunn.ch>
References: <20220606202220.1670714-1-linux@rasmusvillemoes.dk>
 <20220606202220.1670714-2-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606202220.1670714-2-linux@rasmusvillemoes.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> There is no documented mapping from the 32 possible values of the
> IO_IMPEDANCE_CTRL field to values in the range 35-70 ohms

There have been a few active TI engineers submitting patches to TI PHY
drivers. Please could you reach out to them and ask if they can
provide documentation.

Having magic values in DT is not the preferred why to use it. Ideally
you should store Ohms in the cell and convert to the register value.

    Andrew
