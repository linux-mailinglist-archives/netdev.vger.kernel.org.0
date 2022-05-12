Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53DC3524E49
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 15:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354435AbiELNaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 09:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354448AbiELNaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 09:30:18 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779F525470E;
        Thu, 12 May 2022 06:30:17 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KzXhR4ZhGz4xR7;
        Thu, 12 May 2022 23:30:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1652362216;
        bh=OHJM1f7XN6+lzOwoDZ09Fq7vQBcErz2VmaBrM25W470=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=JRtMg+tyAWDlKzhPPh9uybt1ddV4/KtdlG7b8VYxkeOYeOpVcVnKu6H/o/R88zk5F
         OJX65tNJb7/vnfdDefOPaRf4bokKLDt70KwDHa+JRI6x/EAsibZNuITfcHJc4iSeBr
         Fe1jb+l1FwjCDhsPqY0wuFTsHK0CBvASeGyGtShfxYBGJbFMJw2seBdBOcEa2KEv/9
         DkzuqCS4hSISwhDm0g0o2WFOkw/DrMH+lh1u4OIrPBuJcT6eH+gfmW2XKQPCLyQLIz
         S0VDqHnOq5lIheGAKwe+l/szU1/curzqtA18hKetlimSYfFq2lNMWfeTZa3Tx/AHw4
         PCWpgHpamKfug==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mie@igel.co.jp
Subject: Re: [GIT PULL] virtio: last minute fixup
In-Reply-To: <CAHk-=wj9zKJGA_6SJOMPiQEoYke6cKX-FV3X_5zNXOcFJX1kOQ@mail.gmail.com>
References: <20220510082351-mutt-send-email-mst@kernel.org>
 <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
 <87czgk8jjo.fsf@mpe.ellerman.id.au>
 <CAHk-=wj9zKJGA_6SJOMPiQEoYke6cKX-FV3X_5zNXOcFJX1kOQ@mail.gmail.com>
Date:   Thu, 12 May 2022 23:30:15 +1000
Message-ID: <87mtfm7uag.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
> On Wed, May 11, 2022 at 3:12 AM Michael Ellerman <mpe@ellerman.id.au> wrote:
>>
>> Which I read as you endorsing Link: tags :)
>
> I absolutely adore "Link:" tags. They've been great.
>
> But they've been great for links that are *usedful*.
>
> They are wonderful when they link to the original problem.
>
> They are *really* wonderful when they link to some long discussion
> about how to solve the problem.
>
> They are completely useless when they link to "this is the patch
> submission of the SAME DAMN PATCH THAT THE COMMIT IS".

Folks wanted to add Change-Id: tags to every commit.

You said we didn't need to, because we have the Link: to the original
patch submission, which includes the Message-Id and therefore is a
de facto change id.

Links to other random places don't serve that function.

cheers
