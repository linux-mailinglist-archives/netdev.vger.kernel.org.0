Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5066255E5F9
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347014AbiF1N4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 09:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346917AbiF1N4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 09:56:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FA633378;
        Tue, 28 Jun 2022 06:56:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 556076198B;
        Tue, 28 Jun 2022 13:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80ADC341CA;
        Tue, 28 Jun 2022 13:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656424588;
        bh=b5FsKFMrP1+S6zwgUlKhr8WAIjk2qEr4j/i4jiXKeUI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ipH9xLLON/wfF1+doX0YwzWNurZbGyHCLx43ahE7WR8jLi1R48cI2m2yJAsZCWDQT
         Un4VNsnpjcqqdwdfvJBWhdCzCR6kAmILST6sGe+QmxtUWHpxGj2/l2NK930cX7S1Vb
         ck1tdm9dVL3hHqJ5pPK6X9u94v/kg7IeqTTrypuenoyOXdLstD1jm9a1r2/Mn+hjvK
         A5gIe8GNT4XoGXRtGng12sB0ehpNIhwjOmzNMxwSBDvTu3O5JPGVxOwJ5SG66up68M
         dTuMxAaqVKV5rVpkj9AWHYexDQNYp0rXQRl//EEgGVYdOgnC2OLlmpTSGeWpC665ae
         t2Abf09RRIvCQ==
Date:   Tue, 28 Jun 2022 15:56:23 +0200
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org, dm-devel@redhat.com,
        linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-can@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, io-uring@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-mtd@lists.infradead.org,
        kasan-dev@googlegroups.com, linux-mmc@vger.kernel.org,
        nvdimm@lists.linux.dev, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-perf-users@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        v9fs-developer@lists.sourceforge.net, linux-rdma@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] treewide: uapi: Replace zero-length arrays with
 flexible-array members
Message-ID: <20220628135623.GA25163@embeddedor>
References: <20220627180432.GA136081@embeddedor>
 <6bc1e94c-ce1d-a074-7d0c-8dbe6ce22637@iogearbox.net>
 <20220628004052.GM23621@ziepe.ca>
 <20220628005825.GA161566@embeddedor>
 <20220628022129.GA8452@embeddedor>
 <20220628133651.GO23621@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628133651.GO23621@ziepe.ca>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 10:36:51AM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 28, 2022 at 04:21:29AM +0200, Gustavo A. R. Silva wrote:
> 
> > > > Though maybe we could just switch off -Wgnu-variable-sized-type-not-at-end  during configuration ?
> 
> > We need to think in a different strategy.
> 
> I think we will need to switch off the warning in userspace - this is
> doable for rdma-core.
> 
> On the other hand, if the goal is to enable the array size check
> compiler warning I would suggest focusing only on those structs that
> actually hit that warning in the kernel. IIRC infiniband doesn't
> trigger it because it just pointer casts the flex array to some other
> struct.

Yep; this is actually why I reverted those changes in rdma (before
sending out the patch) when 0-day reported the same problems you pointed
out[1].

Also, that's the strategy I'm following right now with the one-element
array into flex-array member transformations. I'm addressing those cases
in which the trailing array is actually being iterated over, first.

I just added the patch to my -next tree, so it can be build-tested by
other people, and let's see what else is reported this week. :)

--
Gustavo

[1] https://lore.kernel.org/lkml/620ca2a5.NkAEIDEfiYoxE9%2Fu%25lkp@intel.com/

> 
> It isn't actually an array it is a placeholder for a trailing
> structure, so it is never indexed.
> 
> This is also why we hit the warning because the convient way for
> userspace to compose the message is to squash the header and trailer
> structs together in a super struct on the stack, then invoke the
> ioctl.
> 
> Jason 
