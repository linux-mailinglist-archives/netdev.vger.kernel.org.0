Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D164E2FD3
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 19:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352068AbiCUSWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 14:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352060AbiCUSWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 14:22:42 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B277E5159C;
        Mon, 21 Mar 2022 11:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uBkesKcmY/klrZAR8jR0OC1/Mj5s+2LyD/8lBmpJcCQ=; b=F9k0qL141SXkQNVI0xTKop/dcq
        ESRpLjUaAkRswqj0X4/W6kMkOCDUmQkYVueLcDmSVi10Iz3TNiYuka4+VSSDd1Xaw6B6pCbD7rvxO
        uavmv3SEuSrWNYwZirnCgeDEKuMILBUd868d8ZWVl3+TR1JQ1NqGPPi2CkUIyVK7O0EY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nWMeG-00BzRI-3a; Mon, 21 Mar 2022 19:20:56 +0100
Date:   Mon, 21 Mar 2022 19:20:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     radhey.shyam.pandey@xilinx.com, robert.hancock@calian.com,
        michal.simek@xilinx.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Greentime Hu <greentime.hu@sifive.com>
Subject: Re: [PATCH v4 1/4] net: axienet: setup mdio unconditionally
Message-ID: <YjjCCPk0qy4vt4Sg@lunn.ch>
References: <20220321152515.287119-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321152515.287119-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy

A patch series should always have a patch 0/X which explains the
overall purpose of the series. That then helps people understand how
the individual patches fit together.

Please also read the netdev FAQ. You are missing an indication of
which tree these patches are for.

      Andrew
