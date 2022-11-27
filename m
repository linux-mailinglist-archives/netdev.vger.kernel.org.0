Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE275639B7D
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 16:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiK0PHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 10:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiK0PHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 10:07:53 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899AFA193;
        Sun, 27 Nov 2022 07:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9NdXCH+5Yf+i6OJS1Ny95eYqibE3km5noeNhlOnIk7Q=; b=nKSi8xbJob0n0p+HFPFPoMHK0m
        aZRJcUDQwwszF7J1P1Z1FnoblDx/lzqYiWcFRODSxWYHc47gdwKQo8bVjjh9YkPWpRPMJn1FlxLHN
        WvzM6w8Qgjt9LNKmpbo2+NSJQu0F18DrjI7jsyPtlmepi26hMeIoQP1VAqSgiixx/qSw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ozJFQ-003ZU2-4c; Sun, 27 Nov 2022 16:07:12 +0100
Date:   Sun, 27 Nov 2022 16:07:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>
Subject: Re: [PATCH v4 3/6] can: etas_es58x: export product information
 through devlink_ops::info_get()
Message-ID: <Y4N9IAlQVsdyIJ9Q@lunn.ch>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-4-mailhol.vincent@wanadoo.fr>
 <Y4JJ8Dyz7urLz/IM@lunn.ch>
 <CAMZ6Rq+K+6gbaZ35SOJcR9qQaTJ7KR0jW=XoDKFkobjhj8CHhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZ6Rq+K+6gbaZ35SOJcR9qQaTJ7KR0jW=XoDKFkobjhj8CHhw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I checked, none of gcc and clang would trigger a warning even for a
> 'make W=12'. More generally speaking, I made sure that my driver is
> free of any W=12.

That is good enough for me.

> I do not care any more as long as it does not result in
> undefined behaviour.

Agreed. Hopefully sscanf cannot go completely wrong and go off the end
of the buffer. That i would care about. Bit i guess the USB fuzzers
would of hit such problems already.

	Andrew
