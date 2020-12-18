Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0180D2DEBD0
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 00:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgLRW7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 17:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgLRW7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 17:59:45 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F741C0617A7
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 14:59:05 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kqOiD-0006wu-WE; Fri, 18 Dec 2020 23:59:02 +0100
Date:   Fri, 18 Dec 2020 23:59:01 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com
Subject: Re: [PATCH iproute2 1/2] lib/fs: avoid double call to mkdir on
 make_path()
Message-ID: <20201218225901.GX28824@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org,
        stephen@networkplumber.org, dsahern@gmail.com
References: <cover.1608315719.git.aclaudi@redhat.com>
 <625c55227b1f4e03320940cb087e466f019ca67e.1608315719.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <625c55227b1f4e03320940cb087e466f019ca67e.1608315719.git.aclaudi@redhat.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrea,

On Fri, Dec 18, 2020 at 08:09:22PM +0100, Andrea Claudi wrote:
> make_path() function calls mkdir two times in a row. The first one it
> stores mkdir return code, and then it calls it again to check for errno.

To me it rather seems like I rebased the original commit into a mess. Or
I got really confused by the covscan error message this is based upon.
Either way, I don't see why this would not be a bug. :)

> This seems unnecessary, as we can use the return code from the first
> call and check for errno if not 0.
> 

Fixes: ac3415f5c1b1d ("lib/fs: Fix and simplify make_path()")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
Acked-by: Phil Sutter <phil@nwl.cc>

Thanks, Phil
