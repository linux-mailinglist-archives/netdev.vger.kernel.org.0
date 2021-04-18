Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302FF36375B
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 21:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbhDRTkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 15:40:37 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:47632 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230028AbhDRTkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 15:40:36 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 13IJdeHc013456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 18 Apr 2021 15:39:40 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id D9D5D15C3B0D; Sun, 18 Apr 2021 15:39:39 -0400 (EDT)
Date:   Sun, 18 Apr 2021 15:39:39 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Nico Pache <npache@redhat.com>
Cc:     linux-kernel@vger.kernel.org, brendanhiggins@google.com,
        gregkh@linuxfoundation.org, linux-ext4@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        linux-m68k@vger.kernel.org, geert@linux-m68k.org,
        mathew.j.martineau@linux.intel.com, davem@davemloft.net,
        broonie@kernel.org, davidgow@google.com, skhan@linuxfoundation.org,
        mptcp@lists.linux.dev
Subject: Re: [PATCH v2 0/6] kunit: Fix formatting of KUNIT tests to meet the
 standard
Message-ID: <YHyK+5xJEMcDDhVy@mit.edu>
References: <cover.1618388989.git.npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1618388989.git.npache@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 04:58:03AM -0400, Nico Pache wrote:
> There are few instances of KUNIT tests that are not properly defined.
> This commit focuses on correcting these issues to match the standard
> defined in the Documentation.

The word "standard" seems to be over-stating things.  The
documentation currently states, "they _usually_ have config options
ending in ``_KUNIT_TEST'' (emphasis mine).  I can imagine that there
might be some useful things we can do from a tooling perspective if we
do standardize things, but if you really want to make it a "standard",
we should first update the manpage to say so, and explain why (e.g.,
so that we can easily extract out all of the kunit test modules, and
perhaps paint a vision of what tools might be able to do with such a
standard).

Alternatively, the word "standard" could perhaps be changed to
"convention", which I think more accurately defines how things work at
the moment.

> Nico Pache (6):
>   kunit: ASoC: topology: adhear to KUNIT formatting standard
>   kunit: software node: adhear to KUNIT formatting standard
>   kunit: ext4: adhear to KUNIT formatting standard
>   kunit: lib: adhear to KUNIT formatting standard
>   kunit: mptcp: adhear to KUNIT formatting standard
>   m68k: update configs to match the proper KUNIT syntax

Also, "adhear" is not the correct spelling; the correct spelling is
"adhere" (from the Latin verb "adhaerere", "to stick", as in "to hold
fast or stick by as if by gluing", which then became "to bind oneself
to the observance of a set of rules or standards or practices").

       		       	      	       		 - Ted
