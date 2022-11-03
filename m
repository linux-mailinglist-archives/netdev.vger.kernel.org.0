Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE71618B8D
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 23:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiKCWbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 18:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiKCWbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 18:31:43 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC2F17598
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 15:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zKqhbdG6GK/o9RbOjt4qnbbv5hp8QIadeIChom+j1WM=; b=xGZGD3se23fm1d5rLFd+hjf/12
        cgzz4K8xKG9iBiDMlrd3IxRY1cuMcMX0yg5GU3xIO2A4CV7qPw5BaVSeKHfnMrX1X+Ev7C2YNV8Up
        af0J/aHXtyOQez4KgKemzdscE4ug7KZlN2gkqYk5Q8uhqDT/O2XgP/vgZjpCzgzlehkE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oqikP-001M8o-AY; Thu, 03 Nov 2022 23:31:41 +0100
Date:   Thu, 3 Nov 2022 23:31:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH ethtool] fsl_enetc: add support for NXP ENETC driver
Message-ID: <Y2RBTTEOyIlfybyA@lunn.ch>
References: <20221026190552.2415266-1-vladimir.oltean@nxp.com>
 <20221101163453.jtouqmz3m6hrnftz@lion.mk-sys.cz>
 <20221103222014.6hi4sxn53j5s4cw2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103222014.6hi4sxn53j5s4cw2@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 10:20:15PM +0000, Vladimir Oltean wrote:
> Hi Michal,
> 
> On Tue, Nov 01, 2022 at 05:34:53PM +0100, Michal Kubecek wrote:
> > > +#define BIT(x)			(1 << (x))
> > 
> > This macro is only used to mask bits of a u32 value, wouldn't "1U" be
> > more appropriate?
> 
> I'm not sure that signed vs unsigned operands make a difference for left
> shifting (as opposed to right shifting where they definitely do), but I
> will make this change and resubmit. Thanks for the review.

From what i understand, a signed 1 shifted 31 bits is undefined
behaviour. Unsigned 1 shifted 31 is O.K.

	   Andrew
