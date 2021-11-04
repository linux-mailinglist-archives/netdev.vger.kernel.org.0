Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E624456C2
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 17:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbhKDQJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 12:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbhKDQJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 12:09:26 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795FFC061714
        for <netdev@vger.kernel.org>; Thu,  4 Nov 2021 09:06:48 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mifGH-0001JZ-72; Thu, 04 Nov 2021 17:06:45 +0100
Date:   Thu, 4 Nov 2021 17:06:45 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Anssi Hannula <anssi.hannula@bitwise.fi>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>
Subject: Re: [PATCH iproute2] man: tc-u32: Fix page to match new firstfrag
 behavior
Message-ID: <20211104160645.GR1668@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Anssi Hannula <anssi.hannula@bitwise.fi>, netdev@vger.kernel.org,
        stephen@networkplumber.org,
        Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>
References: <20211104144203.3581611-1-anssi.hannula@bitwise.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104144203.3581611-1-anssi.hannula@bitwise.fi>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 04, 2021 at 04:42:05PM +0200, Anssi Hannula wrote:
> Commit 690b11f4a6b8 ("tc: u32: Fix firstfrag filter.") applied in 2012
> changed the "ip firstfrag" selector to not match non-fragmented packets
> anymore.
> 
> However, the documentation added in f15a23966fff ("tc: add a man page
> for u32 filter") in 2015 includes an example that relies on the previous
> behavior (non-fragmented packet counted as first fragment).
> 
> Due to this, the example does not work correctly and does not actually
> classify regular SSH packets.
> 
> Modify the example to use a raw u16 selector on the fragment offset to
> make it work, and also make the firstfrag description more clear about
> the current behavior.
> 
> Fixes: f15a23966fff ("tc: add a man page for u32 filter")
> Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
> Cc: Phil Sutter <phil@nwl.cc>
> Cc: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>

Acked-by: Phil Sutter <phil@nwl.cc>

> I suspect the original behavior was intentional, but the new one has
> been out for 9 years now so I guess it is too late to change again.

At least it seems nobody really depends on the old behaviour (or doesn't
update iproute2 then). :)

Thanks, Phil
