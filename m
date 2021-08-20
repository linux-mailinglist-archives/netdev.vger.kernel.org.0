Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060363F324F
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 19:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhHTReh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 13:34:37 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:37202 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229516AbhHTReg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 13:34:36 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 17KHXall026146;
        Fri, 20 Aug 2021 19:33:36 +0200
Date:   Fri, 20 Aug 2021 19:33:36 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Joe Perches <joe@perches.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        LukasBulwahn <lukas.bulwahn@gmail.com>,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-hardening@vger.kernel.org,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        linux-csky@vger.kernel.org
Subject: Re: What is the oldest perl version being used with the kernel ?
 update oldest supported to 5.14 ?
Message-ID: <20210820173336.GA26130@1wt.eu>
References: <37ec9a36a5f7c71a8e23ab45fd3b7f20efd5da24.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37ec9a36a5f7c71a8e23ab45fd3b7f20efd5da24.camel@perches.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 10:27:59AM -0700, Joe Perches wrote:
> Perl 5.8 is nearly 20 years old now.
> 
> https://en.wikipedia.org/wiki/Perl_5_version_history
> 
> checkpatch uses regexes that are incompatible with perl versions
> earlier than 5.10, but these uses are currently runtime checked
> and skipped if the perl version is too old.  This runtime checking
> skips several useful tests.
> 
> There is also some desire for tools like kernel-doc, checkpatch and
> get_maintainer to use a common library of regexes and functions:
> https://lore.kernel.org/lkml/YR2lexDd9N0sWxIW@casper.infradead.org/
> 
> It'd be useful to set the minimum perl version to something more modern.
> 
> I believe perl 5.14, now only a decade old, is a reasonable target.
> 
> Any objections or suggestions for a newer minimum version?

It's probably reasonable, even the Slackware 14.2 on my home PC, which
is starting to date, ships a 5.22.

Willy
