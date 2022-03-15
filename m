Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702264DA432
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 21:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344200AbiCOUrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 16:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235380AbiCOUrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 16:47:07 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3E31EAFD
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 13:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RwR+fb2O3sKS0Av7dD02pf3NNfG85X+/57brX3nkP8s=; b=eCIOLOFhcmK8OmEgY6kQsvnF55
        QoYniMJX8Wc192Wvek9ZxjbOMvD9rN+jSAr4F5Kv2Do5VFMLyhpg5fsqz7PUhqVmz2mi31utJSrk/
        kOa5c2jOE9TLry8A/YUHah8e1Ltt1z18MzQev42FJqQ3AdlzkIo1Bdl89By7K9qgJrwI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nUE3F-00B2Sl-1z; Tue, 15 Mar 2022 21:45:53 +0100
Date:   Tue, 15 Mar 2022 21:45:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        UNGLinuxDriver@microchip.com, Ian.Saturley@microchip.com
Subject: Re: [PATCH net-next 4/5] net: lan743x: Add support for PTP-IO Event
 Input External Timestamp (extts)
Message-ID: <YjD7Ac02mZ5ZBhSg@lunn.ch>
References: <20220315061701.3006-1-Raju.Lakkaraju@microchip.com>
 <20220315061701.3006-5-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315061701.3006-5-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 11:47:00AM +0530, Raju Lakkaraju wrote:
> PTP-IOs block provides for time stamping PTP-IO input events.
> PTP-IOs are numbered from 0 to 11.
> When a PTP-IO is enabled by the corresponding bit in the PTP-IO
> Capture Configuration Register, a rising or falling edge,
> respectively, will capture the 1588 Local Time Counter

For PTP patches, please always Cc: the PTP maintainer.

    Andrew
