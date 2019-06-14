Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90149467CD
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 20:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfFNSpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 14:45:15 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36370 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfFNSpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 14:45:14 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
        (envelope-from <linville@tuxdriver.com>)
        id 1hbrCK-0002jn-T2; Fri, 14 Jun 2019 14:45:12 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by localhost.localdomain (8.15.2/8.14.6) with ESMTP id x5EIeHaw027745;
        Fri, 14 Jun 2019 14:40:17 -0400
Received: (from linville@localhost)
        by localhost.localdomain (8.15.2/8.15.2/Submit) id x5EIeF9i027744;
        Fri, 14 Jun 2019 14:40:15 -0400
Date:   Fri, 14 Jun 2019 14:40:15 -0400
From:   "John W. Linville" <linville@tuxdriver.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linville@redhat.com, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] Add 100BaseT1 and 1000BaseT1
Message-ID: <20190614184013.GD23700@tuxdriver.com>
References: <20190531135748.23740-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531135748.23740-1-andrew@lunn.ch>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 03:57:46PM +0200, Andrew Lunn wrote:
> Import the latest ethtool.h and add two new links modes.
> 
> v2:
> Move the new speeds to the end of the all_advertised_modes_bits[].
> Remove the same_line bit for the new moved
> Add the new modes to the man page.
> 
> Andrew Lunn (2):
>   ethtool: sync ethtool-copy.h with linux-next from 30/05/2019
>   ethtool: Add 100BaseT1 and 1000BaseT1 link modes
> 
>  ethtool-copy.h | 7 ++++++-
>  ethtool.8.in   | 2 ++
>  ethtool.c      | 6 ++++++
>  3 files changed, 14 insertions(+), 1 deletion(-)

Thanks for the patches! Queued for next release...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
