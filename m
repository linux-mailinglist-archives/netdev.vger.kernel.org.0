Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F775567B25
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 02:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiGFApU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 20:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiGFApT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 20:45:19 -0400
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687ADF5A9;
        Tue,  5 Jul 2022 17:45:18 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 2660iZre1151378;
        Wed, 6 Jul 2022 02:44:35 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 2660iZre1151378
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1657068277;
        bh=L3rpRa/OQsVNNMpzp6zZcQ0qKXpRrb4CMt3rn5fYKVc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iJemqI1qm3u4WVF2yCt1Eof/HGtC/b8ekXQJBCZYAFb8IshZZPiN8uszWzLjt5Wgd
         WJDgyHaYuNV8xXfCEXIhNh1Y1RAvzDF+YHQgw0aFrgnhoM2CpUo/TATOuKuLKvHEeg
         wZh2a63Zddl4ijOOfIbHcUYIwZk4awlAT2f06Xx4=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 2660iXJt1151376;
        Wed, 6 Jul 2022 02:44:33 +0200
Date:   Wed, 6 Jul 2022 02:44:33 +0200
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        corbet@lwn.net, jdmason@kudzu.us, vburru@marvell.com,
        jiawenwu@trustnetic.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] eth: remove neterion/vxge
Message-ID: <YsTa8QzSn/kMr5kk@electric-eye.fr.zoreil.com>
References: <20220701044234.706229-1-kuba@kernel.org>
 <Yr8rC9jXtoFbUIQ+@electric-eye.fr.zoreil.com>
 <20220701144010.5ae54364@kernel.org>
 <cbd7e14b3496229497ae49edbb68c04d4c1d7449.camel@redhat.com>
 <20220705110634.4a66389a@kernel.org>
 <20220705112713.644cf3b4@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705112713.644cf3b4@hermes.local>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Hemminger <stephen@networkplumber.org> :
> On Tue, 5 Jul 2022 11:06:34 -0700
> Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 05 Jul 2022 08:17:24 +0200 Paolo Abeni wrote:
> > > On Fri, 2022-07-01 at 14:40 -0700, Jakub Kicinski wrote:  
> > > > 100%, I really wish something like that existed. I have a vague memory
> > > > of Fedora or some other distro collecting HW data. Maybe it died because
> > > > of privacy issues?    
> > > 
> > > AFAICS that database still exists and is active:
> > > 
> > > https://linux-hardware.org/?view=search&vendor=neterion&d=AllRC
> > > 
> > > It shows no usage at all for the relevant vendor.
> > > 
> > > On the flip side, it looks like the data points come mostly/exclusively
> > > from desktop systems, not very relevant in this specific case.  
> > 
> > GTK! There is a whole bunch of old Mellanox NICs reported so I think
> > there is _some_ server coverage. I'm leaning towards applying the patch.

There are 1182 servers per
https://linux-hardware.org/?view=computers&type=Server

> Looks like S2IO became Neterion and then was acquired by Exar in 2010.
> Then MaxLinear acquired Exar in 2017.
> Looks like they dropped out of NIC business and only do switches??

Maxlinear keeps some archive material around:
https://www.maxlinear.com/Files/Documents/X3100Linux_GeneralInfo-FAQ.pdf

A search on linux-hardware with S2io vendor id from above (17d5) does
not find any part.

Patches aside, MARC does not find recent vxge material.

The driver is stable and the systems wherein it is used are (too) stable
as well. See for instance:

https://bugzilla.redhat.com/buglist.cgi?bug_status=__all__&content=vxge

Active maintenance seems useless.

-- 
Ueimor
