Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE035E675D
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 17:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiIVPnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 11:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiIVPnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 11:43:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCEDEFA66
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 08:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yeZFoaSa/5FYUIcIZVxbuRFhkTOBmmc6ueKH8AJXCQ4=; b=3Ssw0umyTraWWvCIsBmOKtE8SI
        FypD/wsJkv3tw59MWHcaA+6uz0Ma6CUR0jvwWOdYyf5koqasnA0Lai8c5NZz22cXJt+5OMtOAt0AR
        7a0boFaoqTFLLM9IffssArIxeiolDpdEmrEzXeJDwoyfl0i5Na0NMKFJCJy0wduD8RKs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1obOLp-00HY43-SO; Thu, 22 Sep 2022 17:42:57 +0200
Date:   Thu, 22 Sep 2022 17:42:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Message-ID: <YyyCgQMTaXf9PXf9@lunn.ch>
References: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
 <20220921113637.73a2f383@hermes.local>
 <20220921183827.gkmzula73qr4afwg@skbuf>
 <20220921153349.0519c35d@hermes.local>
 <20220922144123.5z3wib5apai462q7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922144123.5z3wib5apai462q7@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 02:41:24PM +0000, Vladimir Oltean wrote:
> On Wed, Sep 21, 2022 at 03:33:49PM -0700, Stephen Hemminger wrote:
> > There is no reason that words with long emotional history need to be used
> > in network command.
> >
> > https://inclusivenaming.org/word-lists/
> >
> > https://inclusivenaming.org/word-lists/tier-1/
> >
> > I understand that you and others that live in different geographies may
> > have different feelings about this. But the goal as a community to
> > not use names and terms that may hinder new diverse people from
> > being involved.
> 
> The Linux kernel community is centered around a technical goal rather
> than political or emotional ones, and for this reason I don't think it's
> appropriate to go here in many more details than this.
> 
> All I will say is that I have more things to do than time to do them,
> and I'm not willing to voluntarily go even one step back about this and
> change the UAPI names while the in-kernel data structures and the
> documentation remain with the old names, because it's not going to stop
> there, and I will never have time for this.

Yes, what is being asked for is a very thin veneer. Everything
underneath still uses master, and that is very unlikely to change. Do
we really gain anything with:

.BI master " DEVICE"
- change the DSA master (host network interface) responsible for handling the
local traffic termination of the given DSA switch user port. The selected
interface must be eligible for operating as a DSA master of the switch tree
which the DSA user port is a part of. Eligible DSA masters are those interfaces
which have an "ethernet" reference towards their firmware node in the firmware
description of the platform, or LAG (bond, team) interfaces which contain only
such interfaces as their ports.
+
+ Those who wish can also use the synonym aggregator in place of master
+ in this command.
+

  Andrew
