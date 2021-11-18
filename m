Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2185F455978
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 11:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245610AbhKRK57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 05:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245090AbhKRK5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 05:57:55 -0500
X-Greylist: delayed 316 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 18 Nov 2021 02:54:54 PST
Received: from citadel.ch.unfix.org (citadel.ch.unfix.org [IPv6:2001:1620:20b0::50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E27C061570
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 02:54:54 -0800 (PST)
Received: from yomi.ch.unfix.org (adsl-130-212.dsl.init7.net [213.144.130.212])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: jeroen@massar.ch)
        by citadel.ch.unfix.org (Postfix) with ESMTPSA id 5F56C22B056B9;
        Thu, 18 Nov 2021 10:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=massar.ch; s=DKIM2009;
        t=1637232570; bh=o9b4CsH2irEaMy2eWMRcONr7I24Y7wONHnaLIdEWM6w=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To;
        b=oQ5KNpMISt6IrpdETwCPeP+Ud8iNq4sKn08r5vbm0vP+yABgkzGS84l22cyTrH4Yk
         q9HBTjzPXj5px9YE6VfngcMi912dmPhopWEocAhn/FZnVpZb+sXEkkc+Sqm2udX9hF
         Ga1chLDBbWg6QhWezD5KHw4PBApA8sn5DzPOoVW7y+Mn46xBtY+BNzF8dWz19qdD6v
         9q7/3EcNN8sufP2o1iv50Ts9R55u89DWvdWNM19vVOyS7TIsbXwz59AkUcC/D2jJq3
         Az9HmufHGEM8JKvUQyizdcui1Ny6FczMi2L661xs0ofefDNo+xOK3gXDRPY6yBd043
         jwaJ4GCF9u7tQ==
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: IPv6 Router Advertisement Router Preference (RFC 4191) behavior
 issue
From:   Jeroen Massar <jeroen@massar.ch>
In-Reply-To: <CACS3ZpA=QDLqXE6RyCox8sCX753B=8+JC3jSxpv+vkbKAOwkYQ@mail.gmail.com>
Date:   Thu, 18 Nov 2021 11:49:29 +0100
Cc:     netdev@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3DEFF398-F151-487E-A2F8-5AB593E4A21B@massar.ch>
References: <CACS3ZpA=QDLqXE6RyCox8sCX753B=8+JC3jSxpv+vkbKAOwkYQ@mail.gmail.com>
To:     Juhamatti Kuusisaari <juhamatk@gmail.com>
X-Mailer: Apple Mail (2.3445.9.7)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 20211118, at 11:35, Juhamatti Kuusisaari <juhamatk@gmail.com> =
wrote:
>=20
> Hello,
>=20
> I have been testing IPv6 Router Advertisement Default Router
> Preference on 5.1X and it seems it is not honoured by the Linux
> networking stack. Whenever a new default router preference with a
> higher or lower preference value is received, a new default gateway is
> added as an ECMP route in the routing table with equal weight. This is
> a bit surprising as RFC 4191 Sec. 3.2 mentions that the higher
> preference value should be preferred. This part seems to be missing
> from the Linux implementation.

Do watch out that there are a couple of user space tools (yes, that =
thing) that think that they have to handle RAs.... and thus one might =
get conflicts about reasoning between the kernel doing it or that user =
space daemon thing.

Greets,
 Jeroen

