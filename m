Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0F44E2EEC
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 18:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351732AbiCURSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 13:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234380AbiCURSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 13:18:31 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB17764BDC
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 10:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=c4Horm4qkydWgf+8SNTqxkSm8Uw7oPdwbuouc3s10pw=; b=51YNAryAR4XldoCjV/ifVjQY8Y
        QXUoWWkP+U/bRPC9HOZO7Gzhdpe1LL6HjY5X7Nz08lgtSqSDhUawv4eXC5WKTWY6nfkAQxE7fA+mG
        sas2kzxJLTduFu1FpaWvXk3cmP0WnA68mru56wGzDgf0Bhmn3RYc8ykCRmHJuC775x+Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nWLeQ-00BygF-GS; Mon, 21 Mar 2022 18:17:02 +0100
Date:   Mon, 21 Mar 2022 18:17:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andreas Svensson <andreas93.svensson@gmail.com>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: Comment about unstable DSA devicetree binding in marvell.txt
Message-ID: <YjizDlrhNrCzxpjn@lunn.ch>
References: <CAN9FmivnSq-AmNC32EEy__vmB+GSBn2YxSy-jBHZyiDf3ymgoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN9FmivnSq-AmNC32EEy__vmB+GSBn2YxSy-jBHZyiDf3ymgoA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 06:03:59PM +0100, Andreas Svensson wrote:
> Hi,
> 
> I'm looking at using mv88e6xxx-mdio-external for the external MDIO
> bus to communicate with a PHY.
> 
> I couldn't help but notice the comment about the devicetree binding
> being unstable in Documentation/devicetree/bindings/net/dsa/marvell.txt:
> 
> "WARNING: This binding is currently unstable. Do not program it into a
> FLASH never to be changed again. Once this binding is stable, this
> warning will be removed."
> 
> Any update on this, is marvell.txt still considered unstable?

I personally would never write it to FLASH never to be changed
again. I would always load the DT blob from disk, a version which
matches the kernel. DT blobs do contain bugs and they need to be
fixed.

The marvell binding has not changed for a long time, so in practice
you can consider it stable. But just because it is stable does not
mean DT blobs are bug free.

     Andrew
