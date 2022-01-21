Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D094957D1
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 02:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235863AbiAUBiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 20:38:12 -0500
Received: from relay036.a.hostedemail.com ([64.99.140.36]:2248 "EHLO
        relay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233355AbiAUBiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 20:38:12 -0500
Received: from omf06.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay06.hostedemail.com (Postfix) with ESMTP id DAEDB22DB5;
        Fri, 21 Jan 2022 01:38:07 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf06.hostedemail.com (Postfix) with ESMTPA id 3264F20010;
        Fri, 21 Jan 2022 01:37:54 +0000 (UTC)
Message-ID: <5da3e02454c8c9ff3335c7199f3ae48af2864981.camel@perches.com>
Subject: Re: [PATCH 1/3] lib/string_helpers: Consolidate yesno()
 implementation
From:   Joe Perches <joe@perches.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-security-module@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Emma Anholt <emma@anholt.net>, Eryk Brol <eryk.brol@amd.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Leo Li <sunpeng.li@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Petr Mladek <pmladek@suse.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Vishal Kulkarni <vishal@chelsio.com>
Date:   Thu, 20 Jan 2022 17:37:53 -0800
In-Reply-To: <20220119160017.65bd1fa5@gandalf.local.home>
References: <20220119072450.2890107-1-lucas.demarchi@intel.com>
         <20220119072450.2890107-2-lucas.demarchi@intel.com>
         <YefXg03hXtrdUj6y@paasikivi.fi.intel.com>
         <20220119100635.6c45372b@gandalf.local.home>
         <YehllDq7wC3M2PQZ@smile.fi.intel.com>
         <20220119160017.65bd1fa5@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7rtkhruhzyxmaz9kz4md8szkb6csicqt
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 3264F20010
X-Spam-Status: No, score=-0.98
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+2KBCQ3/oG0QJHNmpFhxNu1Bw+ZDwRWLg=
X-HE-Tag: 1642729074-280175
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-01-19 at 16:00 -0500, Steven Rostedt wrote:
> On Wed, 19 Jan 2022 21:25:08 +0200
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> 
> > > I say keep it one line!
> > > 
> > > Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>  
> > 
> > I believe Sakari strongly follows the 80 rule, which means...
> 
> Checkpatch says "100" I think we need to simply update the docs (the
> documentation always lags the code ;-)

checkpatch doesn't say anything normally, it's a stupid script.
It just mindlessly bleats a message when a line exceeds 100 chars...

Just fyi: I think it's nicer on a single line too.


