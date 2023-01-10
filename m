Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88500664F8A
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 00:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbjAJXCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 18:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbjAJXCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 18:02:12 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C3DBF41
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 15:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6GlYFbPkyIwOJzOvZwDm2DDfrEod8/wTLHFswq6zmXE=; b=vmCqJD4+PcIt2g+fZQIC+plxv9
        aexAx21MFaRlcacJmWsHEVZ7eVOXWcs3xyyfmNY6/9aByMXls49F+RuZ6UAY8DfbKFaEO9SHUARge
        bG8QLeLmWL+z6pEyUNo9ZoV8esZZbd1CNne7HQw9BhqWisELo8YOu4Xv5VPFdyDzh0FA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pFNd9-001igu-Vt; Wed, 11 Jan 2023 00:02:07 +0100
Date:   Wed, 11 Jan 2023 00:02:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Angelo Dureghello <angelo@kernel-space.org>, netdev@vger.kernel.org
Subject: Re: mv88e6321, dual cpu port
Message-ID: <Y73ub0xgNmY5/4Qr@lunn.ch>
References: <5a746f99-8ded-5ef1-6b82-91cd662f986a@kernel-space.org>
 <Y7yIK4a8mfAUpQ2g@lunn.ch>
 <ed027411-c1ec-631a-7560-7344c738754e@kernel-space.org>
 <20230110222246.iy7m7f36iqrmiyqw@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110222246.iy7m7f36iqrmiyqw@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I cannot actually upgrade the kernel, due to cpu producer
> > customizations that are not mainlined, so would try to
> > downgrade the driver.
> 
> The delta between v5.4 and the kernel where support for multiple CPU
> ports was added is ~600 patches to the net/dsa/ folder alone. There are
> some non-trivial interdependencies with phylib, phylink, devlink, switchdev.
> You might also need support for the end result, if you end up cherry picking
> only what you think is useful. Hopefully that will help you reconsider.

v5.4 is really old, v5.10, v5.15 and v6.1 are also LTS kernels. I
suggest you ask your CPU vendor for a v6.1, or v5.15 port of their
vendor tree. v5.4 has a projected End Of Life December 2025, so if you
are going to invest a few months effort trying to get this working, do
you have enough time left to get some return on your investment? And a
plan what to do once it is EOL?

       Andrew
