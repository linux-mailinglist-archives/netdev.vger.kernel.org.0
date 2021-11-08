Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305C6447D27
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 10:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238514AbhKHKA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 05:00:28 -0500
Received: from rs07.intra2net.com ([85.214.138.66]:50614 "EHLO
        rs07.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238511AbhKHKA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 05:00:27 -0500
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Nov 2021 05:00:26 EST
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by rs07.intra2net.com (Postfix) with ESMTPS id 3A63D1500132;
        Mon,  8 Nov 2021 10:48:47 +0100 (CET)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id 1F4C4E7C;
        Mon,  8 Nov 2021 10:48:47 +0100 (CET)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.64.48,VDF=8.18.45.132)
X-Spam-Status: 
X-Spam-Level: 0
Received: from localhost (storm.m.i2n [172.16.1.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.m.i2n (Postfix) with ESMTPS id A1E93E6A;
        Mon,  8 Nov 2021 10:48:45 +0100 (CET)
Date:   Mon, 8 Nov 2021 10:48:45 +0100
From:   Thomas Jarosch <thomas.jarosch@intra2net.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     netdev@vger.kernel.org, Tilman Schmidt <tilman@imap.cc>,
        Karsten Keil <isdn@linux-pingi.de>,
        gigaset307x-common@lists.sourceforge.net,
        Marcel Holtmann <marcel@holtmann.org>,
        Paul Bolle <pebolle@tiscali.nl>,
        isdn4linux@listserv.isdn4linux.de,
        Al Viro <viro@zeniv.linux.org.uk>,
        Holger Schurig <holgerschurig@googlemail.com>
Subject: Re: [PATCH v2 5/5] isdn: move capi drivers to staging
Message-ID: <20211108094845.cytlyen5nptv4elu@intra2net.com>
References: <20190426195849.4111040-1-arnd@arndb.de>
 <20190426195849.4111040-6-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426195849.4111040-6-arnd@arndb.de>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

You wrote on Fri, Apr 26, 2019 at 09:58:49PM +0200:
> I tried to find any indication of whether the capi drivers are still in
> use, and have not found anything from a long time ago.
> 
> With public ISDN networks almost completely shut down over the past 12
> months, there is very little you can actually do with this hardware. The
> main remaining use case would be to connect ISDN voice phones to an
> in-house installation with Asterisk or LCR, but anyone trying this in
> turn seems to be using either the mISDN driver stack, or out-of-tree
> drivers from the hardware vendors.
> 
> I may of course have missed something, so I would suggest moving these
> three drivers (avm, hysdn, gigaset) into drivers/staging/ just in case
> someone still uses them.
> 
> If nobody complains, we can remove them entirely in six months, or
> otherwise move the core code and any drivers that are still needed back
> into drivers/isdn.

just a quick follow up on this one: Intra2net is officially
removing ISDN fax support from our distribution on 2022-06-30.

Since we are still running on kernel 4.19 and plan on upgrading to 5.10 some day 
soonish, there's one less ISDN user to care about in future kernel maintenance.

This makes me even wonder how many linux ISDN users are left these days.

Cheers,
Thomas
