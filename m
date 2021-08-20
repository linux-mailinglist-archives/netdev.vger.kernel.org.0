Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBC13F323E
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 19:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbhHTR2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 13:28:43 -0400
Received: from smtprelay0233.hostedemail.com ([216.40.44.233]:36192 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233320AbhHTR2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 13:28:42 -0400
Received: from omf19.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id C2CF5101CE23F;
        Fri, 20 Aug 2021 17:28:02 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf19.hostedemail.com (Postfix) with ESMTPA id D00E220D764;
        Fri, 20 Aug 2021 17:28:00 +0000 (UTC)
Message-ID: <37ec9a36a5f7c71a8e23ab45fd3b7f20efd5da24.camel@perches.com>
Subject: What is the oldest perl version being used with the kernel ? update
 oldest supported to 5.14 ?
From:   Joe Perches <joe@perches.com>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        LukasBulwahn <lukas.bulwahn@gmail.com>,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-hardening@vger.kernel.org,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        linux-csky@vger.kernel.org
Date:   Fri, 20 Aug 2021 10:27:59 -0700
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=2.59
X-Stat-Signature: wojh18d5ecfq9mr8d36u5p8pct8mmia8
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: D00E220D764
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18C1in7YDsawPZeoRsFE518C5c7FR0zQJA=
X-HE-Tag: 1629480480-234339
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Perl 5.8 is nearly 20 years old now.

https://en.wikipedia.org/wiki/Perl_5_version_history

checkpatch uses regexes that are incompatible with perl versions
earlier than 5.10, but these uses are currently runtime checked
and skipped if the perl version is too old.  This runtime checking
skips several useful tests.

There is also some desire for tools like kernel-doc, checkpatch and
get_maintainer to use a common library of regexes and functions:
https://lore.kernel.org/lkml/YR2lexDd9N0sWxIW@casper.infradead.org/

It'd be useful to set the minimum perl version to something more modern.

I believe perl 5.14, now only a decade old, is a reasonable target.

Any objections or suggestions for a newer minimum version?

