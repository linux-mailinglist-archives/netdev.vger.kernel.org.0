Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15E7623176
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 18:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiKIR12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 12:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKIR11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 12:27:27 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA81222B5
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 09:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WfJ5cMBh0jpLJ+9VpOvT0Dmxg/DIi1Nta4xBjAzq8EM=; b=eq/dlf/jerbgu5cnqFXA+THO1b
        wW4GqA4nPXpxa6aTVbdXPMBIKu7wKcSOOgF7KfbB3DLtRK3UgDAciBLeiwJ2+BcEltCRxxoH3UyqC
        MgGYcs3u663NNdzuNO9du5O3cw4gm9WuNcsfEz2GPhErJ/RT+07OK1acxWfh1P4i+3tE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osorE-001w1C-IJ; Wed, 09 Nov 2022 18:27:24 +0100
Date:   Wed, 9 Nov 2022 18:27:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ian Abbott <abbotti@mev.co.uk>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC] option to use proper skew timings for Micrel KSZ9021
Message-ID: <Y2vi/IxoTpfwR65T@lunn.ch>
References: <c3755dfd-004a-d869-3fcf-589297dd17bd@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3755dfd-004a-d869-3fcf-589297dd17bd@mev.co.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I would like to add an optional boolean property to indicate that the skew
> timing properties are to be interpreted as "proper" skew timings (in 120ps
> steps) rather than fake skew timings.  When this property is true, the
> driver can divide the specified skew timing values by 120 instead of 200.
> The advantage of this is that the same skew timing property values can be
> used in the device node and will apply to both KSZ9021 and KSZ9031 as long
> as the values are in range for both chips.

Hi Ian

I don't see why this is an advantage. Yes, it is all messed up, but it
is a well defined and documented mess. All this boolean will do is
make it a more complex mess, leading it more errors with the wrong
value set.

      Andrew
