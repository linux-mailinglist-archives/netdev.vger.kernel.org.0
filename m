Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCCD5AF584
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 22:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiIFULd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 16:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbiIFULK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 16:11:10 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398D145044
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 13:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uwynac5W7xE/v+dXHiEc3qZ9dSvE4oprT5QX6rlmAhg=; b=rBn2Neiwta69q61Ucu8BaSzFyt
        hHsIHDnbP54KfPJ2b3C0le2KzL103Rj1rJw/7qeDCXxHs+rtMrK/zAdYTPl/11eNJ8YGjaeRFPOKY
        Jq3Lp1FqP4UzdfdGy2/IOqArdq+rXKarkvOPYz9wsSi+p3Gva6NPtOWfPHNoA+m7t2/U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oVepJ-00FmO5-EB; Tue, 06 Sep 2022 22:05:41 +0200
Date:   Tue, 6 Sep 2022 22:05:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH iproute2] ip link: add sub-command to view and change DSA
 master
Message-ID: <YxeoFfxWwrWmUCkm@lunn.ch>
References: <20220904190025.813574-1-vladimir.oltean@nxp.com>
 <20220906082907.5c1f8398@hermes.local>
 <20220906164117.7eiirl4gm6bho2ko@skbuf>
 <20220906095517.4022bde6@hermes.local>
 <20220906191355.bnimmq4z36p5yivo@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906191355.bnimmq4z36p5yivo@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> [ Alternative answer: how about "schnauzer"? I always liked how that word sounds. ]

Unfortunately, it is not gender neutral, which i assume is a
requirement?

Plus the plural is also schnauzer, which would make your current
multiple CPU/schnauzer patches confusing, unless you throw the rule
book out and use English pluralisation.

	 Andrew
