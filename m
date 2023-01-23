Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46B4E67873E
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbjAWUIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbjAWUIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:08:16 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8084F13D42
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 12:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sIG7nYvBQbS5Lyw6cX8OXf3p/zAnUJCOwUnzzjNe8eE=; b=6H9mdu7ZIqjwzZFdegCcBipczX
        uCvFlORukAqZRdv0u7QYZCt2rO1Woh/08OTcrIY7uxcax37Oj/gAkMXg0Gs1/Yfl7Dwl+PGPomUTu
        dpLw2Z6cT3S2XRc4SKKdVzc04kdx4D7BQGXEZF9nQE6tm3rMsAGiE1uPm04DnB+2SVWA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pK36z-002wn2-Dr; Mon, 23 Jan 2023 21:08:13 +0100
Date:   Mon, 23 Jan 2023 21:08:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Angelo Dureghello <angelo@kernel-space.org>, netdev@vger.kernel.org
Subject: Re: mv88e6321, dual cpu port
Message-ID: <Y87pLbMC4GRng6fa@lunn.ch>
References: <5a746f99-8ded-5ef1-6b82-91cd662f986a@kernel-space.org>
 <Y7yIK4a8mfAUpQ2g@lunn.ch>
 <ed027411-c1ec-631a-7560-7344c738754e@kernel-space.org>
 <20230110222246.iy7m7f36iqrmiyqw@skbuf>
 <Y73ub0xgNmY5/4Qr@lunn.ch>
 <8d0fce6c-6138-4594-0d75-9a030d969f99@kernel-space.org>
 <20230123112828.yusuihorsl2tyjl3@skbuf>
 <7e29d955-2673-ea54-facb-3f96ce027e96@kernel-space.org>
 <20230123191844.ltcm7ez5yxhismos@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123191844.ltcm7ez5yxhismos@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I don't know what this means:
> 
> | I am now trying this way on mv88e6321,
> | - one vlan using dsa kernel driver,
> | - other vlan using dsdt userspace driver.
> 
> specifically what is "dsdt userspace driver".

I think DSDT is Marvells vendor crap code.

Having two drivers for the same hardware is a recipe for disaster.

  Andrew
