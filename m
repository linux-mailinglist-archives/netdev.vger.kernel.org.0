Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78142D3984
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 08:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbfJKGrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 02:47:13 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:60888 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfJKGrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 02:47:13 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iIohY-0003Kb-Qd; Fri, 11 Oct 2019 08:47:00 +0200
Message-ID: <dfc9572f853713577e3798b3ff0449483ce274f3.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v7 00/17] ethtool netlink interface, part 1
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Date:   Fri, 11 Oct 2019 08:46:59 +0200
In-Reply-To: <20191010174839.6e44158b@cakuba.netronome.com> (sfid-20191011_024857_967575_978B3526)
References: <cover.1570654310.git.mkubecek@suse.cz>
         <20191010174839.6e44158b@cakuba.netronome.com>
         (sfid-20191011_024857_967575_978B3526)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-10-10 at 17:48 -0700, Jakub Kicinski wrote:
> On Wed,  9 Oct 2019 22:59:00 +0200 (CEST), Michal Kubecek wrote:
> > This is first part of netlink based alternative userspace interface for
> > ethtool. It aims to address some long known issues with the ioctl
> > interface, mainly lack of extensibility, raciness, limited error reporting
> > and absence of notifications. The goal is to allow userspace ethtool
> > utility to provide all features it currently does but without using the
> > ioctl interface. However, some features provided by ethtool ioctl API will
> > be available through other netlink interfaces (rtnetlink, devlink) if it's
> > more appropriate.
> 
> Looks like perhaps with ETHTOOL_A_HEADER_RFLAGS checking taken out of
> the picture we can proceed as is and potentially work on defining some
> best practices around attrs and nesting for the future generations? :)
> 
> I was trying to find a way to perhaps start merging something.. Would
> it make sense to spin out patches 1, 2, 3, and 8 as they seem to be
> ready (possibly 11, too if the reorder isn't painful)?

I was surprised 3 didn't go in even last time this was posted, it seems
such an obvious thing and not necessary just for ethtool :)

johannes

