Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0C4DA9CC
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 12:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501972AbfJQKTg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 17 Oct 2019 06:19:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:36378 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731515AbfJQKTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 06:19:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B5E31B196;
        Thu, 17 Oct 2019 10:19:31 +0000 (UTC)
Date:   Thu, 17 Oct 2019 12:19:27 +0200
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v10 4/6] mfd: ioc3: Add driver for SGI IOC3 chip
Message-Id: <20191017121927.866d7d3b3bcec9ef570822eb@suse.de>
In-Reply-To: <20191016103813.24447c64@cakuba.netronome.com>
References: <20191015120953.2597-1-tbogendoerfer@suse.de>
        <20191015120953.2597-5-tbogendoerfer@suse.de>
        <20191015122349.612a230b@cakuba.netronome.com>
        <20191016192321.c1ef8ea7c2533d6c8e1b98a2@suse.de>
        <20191016103813.24447c64@cakuba.netronome.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 10:38:13 -0700
Jakub Kicinski <jakub.kicinski@netronome.com> wrote:

> On Wed, 16 Oct 2019 19:23:21 +0200, Thomas Bogendoerfer wrote:
> > On Tue, 15 Oct 2019 12:23:49 -0700
> > Jakub Kicinski <jakub.kicinski@netronome.com> wrote:
> > 
> > > On Tue, 15 Oct 2019 14:09:49 +0200, Thomas Bogendoerfer wrote:  
> > > > SGI IOC3 chip has integrated ethernet, keyboard and mouse interface.
> > > > It also supports connecting a SuperIO chip for serial and parallel
> > > > interfaces. IOC3 is used inside various SGI systemboards and add-on
> > > > cards with different equipped external interfaces.
> > > > 
> > > > Support for ethernet and serial interfaces were implemented inside
> > > > the network driver. This patchset moves out the not network related
> > > > parts to a new MFD driver, which takes care of card detection,
> > > > setup of platform devices and interrupt distribution for the subdevices.
> > > > 
> > > > Serial portion: Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Acked-for-MFD-by: Lee Jones <lee.jones@linaro.org>
> > > > 
> > > > Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>  
> > > 
> > > Looks good, I think.  
> > 
> > thank you. 
> > 
> > Now how do I get an Acked-by for the network part to merge it via
> > the MIPS tree ?
> 
> Oh, via the MIPS tree? It was quite unclear which these would land it,
> at least to an untrained mind like mine :) It could be useful to
> provide some info on how you want this merged and what you expect from
> whom in the cover letter in the future.

it's there in the cover letter under "Changes in v8":

 - Patches 1 and 2 are already taken to mips-next, but
   for completeness of the series they are still included.
   What's missing to get the remaining 3 patches via the MIPS
   tree is an ack from a network maintainer

> Hopefully Dave will be able to give you an official ack.

/me hopes as well.

Thomas.

-- 
SUSE Software Solutions Germany GmbH
HRB 36809 (AG Nürnberg)
Geschäftsführer: Felix Imendörffer
