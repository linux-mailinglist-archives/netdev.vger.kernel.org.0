Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0D629EE28
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 15:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgJ2O1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 10:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbgJ2O0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 10:26:11 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98665C0613D2;
        Thu, 29 Oct 2020 07:26:11 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kY8s6-00EpZx-Ey; Thu, 29 Oct 2020 15:25:46 +0100
Message-ID: <bff39a3d645afc424478981cd7d9ad69c2b9b346.camel@sipsolutions.net>
Subject: Re: [PATCH, net -> staging, v2] wimax: move out to staging
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arnd Bergmann <arnd@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org
Date:   Thu, 29 Oct 2020 15:25:30 +0100
In-Reply-To: <20201029134722.3965095-1-arnd@kernel.org>
References: <20201029134722.3965095-1-arnd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-29 at 14:43 +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> There are no known users of this driver as of October 2020, and it will
> be removed unless someone turns out to still need it in future releases.
> 
> According to https://en.wikipedia.org/wiki/List_of_WiMAX_networks, there
> have been many public wimax networks, but it appears that many of these
> have migrated to LTE or discontinued their service altogether.
> As most PCs and phones lack WiMAX hardware support, the remaining
> networks tend to use standalone routers. These almost certainly
> run Linux, but not a modern kernel or the mainline wimax driver stack.
> 
> NetworkManager appears to have dropped userspace support in 2015
> https://bugzilla.gnome.org/show_bug.cgi?id=747846, the
> www.linuxwimax.org
> site had already shut down earlier.
> 
> WiMax is apparently still being deployed on airport campus networks
> ("AeroMACS"), but in a frequency band that was not supported by the old
> Intel 2400m (used in Sandy Bridge laptops and earlier), which is the
> only driver using the kernel's wimax stack.
> 
> Move all files into drivers/staging/wimax, including the uapi header
> files and documentation, to make it easier to remove it when it gets
> to that. Only minimal changes are made to the source files, in order
> to make it possible to port patches across the move.
> 
> Also remove the MAINTAINERS entry that refers to a broken mailing
> list and website.
> 
> Suggested-by: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> changes in v2:
> - fix a build regression
> - add more information about remaining networks (Dan Carpenter)_
> 
> For v1, Greg said he'd appply the patch when he gets an Ack
> from the maintainers.
> 
> Inaky, Johannes, Jakub: are you happy with this version?

Sure, looks fine to me.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Not that I have much relation to this code other than having fixed up
genetlink stuff over the years :)

johannes

