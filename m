Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07666407EA
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 14:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbiLBNqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 08:46:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbiLBNqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 08:46:49 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5A2D67AB
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 05:46:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UTnUB5+mJHBl5cjswS2smovLc1YMl3P7DGWXIQp66+Q=; b=UMecXI00sz5D869wBNQGfFcl4Q
        ht7RGRCG/55up+PnaBEl4DaAVR+IBc8FSDCvbXTBc1/1/HBsj8v0D39831pF6cwKe6ru53VjIen7K
        nv3gYp4HE3x2+73l1catvxiz2LcDOTdY1G/b1LwDxXHTIIk57QihxBpGcsNvgvkKkGWU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p16NL-004BAO-08; Fri, 02 Dec 2022 14:46:47 +0100
Date:   Fri, 2 Dec 2022 14:46:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Etienne Champetier <champetier.etienne@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Multicast packet reordering
Message-ID: <Y4oBxuq2BXDk4lSC@lunn.ch>
References: <e0f9fb60-b09c-30ad-0670-aa77cc3b2e12@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0f9fb60-b09c-30ad-0670-aa77cc3b2e12@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 11:45:53PM -0500, Etienne Champetier wrote:
> Hello all,
> 
> I'm investigating random multicast packet reordering between 2 containers
> even under moderate traffic (16 video multicast, ~80mbps total) on Alma 8.

Have you tried plain unicast UDP?

There is nothing in the UDP standard which says UDP has to arrive in
order. Your application needs to handle reordering. So your time might
be better spent optimizing your application for when it happens.

	Andrew
