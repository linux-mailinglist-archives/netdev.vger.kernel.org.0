Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C561423B5D
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 12:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237954AbhJFKU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 06:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbhJFKU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 06:20:56 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EE1C061749
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 03:19:04 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mY40n-0000jN-FU; Wed, 06 Oct 2021 12:18:57 +0200
Date:   Wed, 6 Oct 2021 12:18:57 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com, bluca@debian.org
Subject: Re: [PATCH iproute2 v3 1/3] configure: support --param=value style
Message-ID: <20211006101857.GB29206@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org,
        stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org
References: <cover.1633455436.git.aclaudi@redhat.com>
 <caa9b65bef41acd51d45e45e1a158edb1eeefe7d.1633455436.git.aclaudi@redhat.com>
 <20211006080944.GA32194@orbyte.nwl.cc>
 <YV1xLsQsADEhrJPz@renaissance-vector>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV1xLsQsADEhrJPz@renaissance-vector>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrea,

On Wed, Oct 06, 2021 at 11:49:34AM +0200, Andrea Claudi wrote:
[...]
> That was my first proposal in v1 [1]. I changed it on David's suggestion
> to consolidate the two cases into a single one.

Oh, sorry. I missed the 'v3' tag and hence didn't check any earlier
version.

> Looking at the resulting code, v3 code results in an extra check to
> discriminate between the two use cases, while v0 uses the "case"
> structure to the same end.

Given that David explicitly requested the change I'm complaining about
in his reply to your initial version, I guess any further debate about
it is irrelevant.

Thanks, Phil
