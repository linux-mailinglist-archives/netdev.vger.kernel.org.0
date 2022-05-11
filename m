Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B065C523311
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 14:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242348AbiEKMYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 08:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236963AbiEKMYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 08:24:36 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47451C766D;
        Wed, 11 May 2022 05:24:35 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id D6B675A4; Wed, 11 May 2022 14:24:28 +0200 (CEST)
Date:   Wed, 11 May 2022 14:24:23 +0200
From:   =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mie@igel.co.jp
Subject: Re: [GIT PULL] virtio: last minute fixup
Message-ID: <Ynuq9wMtJKBe8WOk@8bytes.org>
References: <20220510082351-mutt-send-email-mst@kernel.org>
 <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 11:23:11AM -0700, Linus Torvalds wrote:
> And - once again - I want to complain about the "Link:" in that commit.

I have to say that for me (probably for others as well) those Link tags
pointing to the patch submission have quite some value:

	1) First of all it is an easy proof that the patch was actually
	   submitted somewhere for public review before it went into a
	   maintainers tree.

	2) The patch submission is often the entry point to the
	   discussion which lead to this patch. From that email I can
	   see what was discussed and often there is even a link to
	   previous versions and the discussions that happened there. It
	   helps to better understand how a patch came to be the way it
	   is. I know this should ideally be part of the commit message,
	   but in reality this is what I also use the link tag for.

	3) When backporting a patch to a downstream kernel it often
	   helps a lot to see the whole patch-set the change was
	   submitted in, especially when it comes to fixes. With the
	   Link: tag the whole submission thread is easy to find.

I can stop adding them to patches if you want, but as I said, I think
there is some value in them which make me want to keep them.

Regards,

	Joerg
