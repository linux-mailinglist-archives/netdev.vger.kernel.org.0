Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7900A570C35
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 22:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbiGKUz3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 11 Jul 2022 16:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiGKUz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 16:55:29 -0400
Received: from relay5.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCBE528A3
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 13:55:28 -0700 (PDT)
Received: from omf12.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay10.hostedemail.com (Postfix) with ESMTP id B2B595F8;
        Mon, 11 Jul 2022 20:55:26 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf12.hostedemail.com (Postfix) with ESMTPA id 409621B;
        Mon, 11 Jul 2022 20:55:25 +0000 (UTC)
Message-ID: <93dc367b01cdfbb68e6edf7367d2f69adfb5d407.camel@perches.com>
Subject: Re: [PATCH v3] staging: qlge: Fix indentation issue under long for
 loop
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Binyi Han <dantengknight@gmail.com>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org
Date:   Mon, 11 Jul 2022 13:55:24 -0700
In-Reply-To: <YsvZuPkbwe8yX8oi@kroah.com>
References: <20220710210418.GA148412@cloud-MacBookPro>
         <YsvZuPkbwe8yX8oi@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 409621B
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Stat-Signature: chopoje3jzpy9qmb7kz8idsut8dic5gc
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18/ZwN4JJSNAALDvoh6AB39oIXKePuMAwU=
X-HE-Tag: 1657572925-704760
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-07-11 at 10:05 +0200, Greg Kroah-Hartman wrote:
> On Sun, Jul 10, 2022 at 02:04:18PM -0700, Binyi Han wrote:
> > Fix indentation issue to adhere to Linux kernel coding style,
> > Issue found by checkpatch. Change the long for loop into 3 lines. And
> > optimize by avoiding the multiplication.
> > 
> > Signed-off-by: Binyi Han <dantengknight@gmail.com>
> > ---
> > v2:
> > 	- Change the long for loop into 3 lines.
> > v3:
> > 	- Align page_entries in the for loop to open parenthesis.
> > 	- Optimize by avoiding the multiplication.
> 
> Please do not mix coding style fixes with "optimizations" or logical
> changes.  This should be multiple patches.
> 
> Also, did you test this change on real hardware?  At first glance, it's
> not obvious that the code is still doing the same thing, so "proof" of
> that would be nice to have.

I read the code and suggested the optimization.  It's the same logic.

