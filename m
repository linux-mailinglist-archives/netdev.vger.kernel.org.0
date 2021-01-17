Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1082F938E
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 16:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbhAQPa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 10:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728895AbhAQPax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 10:30:53 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E38CC061574
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 07:30:11 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1l1A0C-0001Xf-MB; Sun, 17 Jan 2021 16:30:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.94)
        (envelope-from <laforge@gnumonks.org>)
        id 1l19vc-00EJlq-ID; Sun, 17 Jan 2021 16:25:20 +0100
Date:   Sun, 17 Jan 2021 16:25:20 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pbshelar@fb.com>, netdev@vger.kernel.org,
        pablo@netfilter.org
Subject: Re: [PATCH net-next v5] GTP: add support for flow based tunneling API
Message-ID: <YARW4DN9qxOZ7b25@nataraja>
References: <20210110070021.26822-1-pbshelar@fb.com>
 <20210116164642.4af4de8e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <8adc4450-c32d-625e-3c8c-70dbd7cbf052@norrbonn.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8adc4450-c32d-625e-3c8c-70dbd7cbf052@norrbonn.se>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jonas, Jakub and others,

On Sun, Jan 17, 2021 at 02:23:52PM +0100, Jonas Bonn wrote:
> This patch hasn't received any ACK's from either the maintainers or anyone
> else providing review.  The following issues remain unaddressed after
> review:

[...]

Full ACK from my point of view.  The patch is so massive that I
as the original co-author and co-maintainer of the GTP kernel module
have problems understanding what it is doing at all.  Furthermore,
I am actually wondering if there is any commonality between the existing
use cases and whatever the modified gtp.ko is trying to achieve.  Up to
the point on whether or not it makes sense to have both functionalities
in the same driver/module at all

> I'm not sure what the hurry is to get this patch into mainline.  Large and
> complicated patches like this take time to review; please revert this and
> allow that process to happen.

Also acknowledged and supported from my side.

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
