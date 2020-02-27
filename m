Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 236FF170EFD
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 04:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgB0DV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 22:21:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39916 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728238AbgB0DV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 22:21:29 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j79jr-0002Dc-2p; Thu, 27 Feb 2020 03:21:27 +0000
Date:   Thu, 27 Feb 2020 04:21:26 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     David Miller <davem@davemloft.net>
Cc:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, pavel@ucw.cz,
        kuba@kernel.org, edumazet@google.com, stephen@networkplumber.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v6 0/9] net: fix sysfs permssions when device changes
 network
Message-ID: <20200227032126.ajmxq44epabdldwg@wittgenstein>
References: <20200225131938.120447-1-christian.brauner@ubuntu.com>
 <20200226081757.GF24447@kroah.com>
 <20200226.173750.2149877624295674225.davem@davemloft.net>
 <20200226.190644.1695114419188031888.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200226.190644.1695114419188031888.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 07:06:44PM -0800, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Wed, 26 Feb 2020 17:37:50 -0800 (PST)
> 
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Date: Wed, 26 Feb 2020 09:17:57 +0100
> > 
> >> On Tue, Feb 25, 2020 at 02:19:29PM +0100, Christian Brauner wrote:
> >>> Hey everyone,
> >>> 
> >>> /* v6 */
> >>> This is v6 with two small fixups. I missed adapting the commit message
> >>> to reflect the renamed helper for changing the owner of sysfs files and
> >>> I also forgot to make the new dpm helper static inline.
> >> 
> >> All of the sysfs and driver core bits look good to me now.  Thanks for
> >> taking the time to update the documentation and other bits based on
> >> reviews.
> >> 
> >> So now it's just up to the netdev developers to review the netdev parts :)
> >> 
> >> The sysfs and driver core patches can all go through the netdev tree to
> >> make it easier for you.
> > 
> > I'm fine with these changes, and will apply this series to net-next.
> 
> Actually, you'll need to respin this with these warnings fixed, thanks:

Hm, I haven't caught those, sorry! Give me a few minutes to fix and do a
test-compile and run.

Christian
