Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB116483A4
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 15:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiLIOUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 09:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiLIOTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 09:19:47 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18D8531B;
        Fri,  9 Dec 2022 06:19:39 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A0C1C23A;
        Fri,  9 Dec 2022 06:19:45 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.41.252])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 869A83F73D;
        Fri,  9 Dec 2022 06:19:37 -0800 (PST)
Date:   Fri, 9 Dec 2022 14:19:34 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+09329bd987ebca21bced@syzkaller.appspotmail.com>,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [syzbot] kernel stack overflow in sock_close
Message-ID: <Y5ND9qNFXOxOuEMQ@FVFF77S0Q05N>
References: <000000000000b2d33705ef4e2d70@google.com>
 <20221209133214.1934-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209133214.1934-1-hdanton@sina.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 09:32:14PM +0800, Hillf Danton wrote:
> On 9 Dec 2022 13:15:39 +0000 Mark Rutland <mark.rutland@arm.com>
> > On Thu, Dec 08, 2022 at 02:05:36AM -0800, syzbot wrote:
> > > Hello,
> > > 
> > > syzbot found the following issue on:
> > > 
> > > HEAD commit:    e3cb714fb489 Merge branch 'for-next/core' into for-kernelci
> > 
> > This commit has a known-broken parent where some uaccess copies appeared to
> > result in stack corruption:
> > 
> >   https://lore.kernel.org/linux-arm-kernel/Y44gVm7IEMXqilef@FVFF77S0Q05N.cambridge.arm.com/
> > 
> > ... which has now been dropped from the arm64 for-next/core branch, but
> > anything found on commit e3cb714fb489 will be suspect due to that.
> > 
> > This *might* a manifestation of the same issue; I'll have a go at reproducing
> > it locally.
> 
> Take a look at the reproducer [1] before kicking off your Harley.
> 
> [1] https://lore.kernel.org/lkml/00000000000073b14905ef2e7401@google.com/

Ah, yes; this is clearly not arm64-specific, and therefore has
nothing to do with the uaccess issue.

Sorry for the noise, and thanks for the pointer!

Mark.
