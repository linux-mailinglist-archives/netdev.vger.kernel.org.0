Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E936623A7EB
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 15:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgHCNxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 09:53:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:60002 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726676AbgHCNxj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 09:53:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DB75BAD85;
        Mon,  3 Aug 2020 13:53:52 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 8486B60754; Mon,  3 Aug 2020 15:53:37 +0200 (CEST)
Date:   Mon, 3 Aug 2020 15:53:37 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 0/7] compiler warnings cleanup, part 1
Message-ID: <20200803135337.37qdwe33z532h76d@lion.mk-sys.cz>
References: <cover.1596451857.git.mkubecek@suse.cz>
 <20200803133125.GN1862409@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200803133125.GN1862409@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 03:31:25PM +0200, Andrew Lunn wrote:
> On Mon, Aug 03, 2020 at 01:57:03PM +0200, Michal Kubecek wrote:
> > Maciej ¯enczykowski recently cleaned up many "unused parameter" compiler
> > warnings but some new occurences appeared since (mostly in netlink code).
> 
> Hi Michal
> 
> Could you modify the compiler flags to get gcc to warn about these?
> Otherwise they will just come back again.

Good point. I'll add "-Wextra" to default CFLAGS in Makefile.am with the
second part of the cleanup (shortly after 5.8 release). At that point
there will be no warnings so that it will be easy to spot any new ones.

Michal
