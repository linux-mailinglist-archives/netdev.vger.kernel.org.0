Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371893F2F75
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 17:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241080AbhHTP2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 11:28:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240472AbhHTP2S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 11:28:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9331A60F44;
        Fri, 20 Aug 2021 15:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629473260;
        bh=OwwtgX2M/Z1j8G1sPd2l0muzQPlxYWaQWBaFFSOCB3I=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=hD1bmNxq2pXA6JY0w3JSfU6ec1u4utu+1+zz9abtVNra03vaEswGGJOV+Z2853GXD
         oWJ5vmjMvcenUtdBVw1+fZ+L5fZOztbObkcT5iIaya9Tcvq/cYGfTGfh6LnoChpBR+
         iGroeoSTE1zbRytr6N7HLC8nAHksqo/5ucG0afMSW2Famnb5JgFraG/JaJFaJandAh
         zToyO+JNLN+2FsSfuo9qIsrx3YbBTwpSaj8JU5ZQwb83Adi++CTjgtUK8mlvC1lY6x
         2angoBbLeQxbPm9CmNpz2Vmc9cCVXYEkeNBrRT70CAVatQvZR6NiwmD3WIRrEnz9q1
         PGj2wVDAgorvQ==
Date:   Fri, 20 Aug 2021 17:27:35 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Kees Cook <keescook@chromium.org>
cc:     LKML <linux-kernel@vger.kernel.org>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input <linux-input@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>, linux-staging@lists.linux.dev,
        linux-block <linux-block@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 55/63] HID: roccat: Use struct_group() to zero
 kone_mouse_event
In-Reply-To: <CAJr-aD=6-g7VRw2Hw0dhs+RrtA=Tago5r6Dukfw_gGPB0YYKOQ@mail.gmail.com>
Message-ID: <nycvar.YFH.7.76.2108201725360.15313@cbobk.fhfr.pm>
References: <20210818060533.3569517-1-keescook@chromium.org> <20210818060533.3569517-56-keescook@chromium.org> <nycvar.YFH.7.76.2108201501510.15313@cbobk.fhfr.pm> <CAJr-aD=6-g7VRw2Hw0dhs+RrtA=Tago5r6Dukfw_gGPB0YYKOQ@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Aug 2021, Kees Cook wrote:

> > > In preparation for FORTIFY_SOURCE performing compile-time and run-time
> > > field bounds checking for memset(), avoid intentionally writing across
> > > neighboring fields.
> > >
> > > Add struct_group() to mark region of struct kone_mouse_event that should
> > > be initialized to zero.
> > >
> > > Cc: Stefan Achatz <erazor_de@users.sourceforge.net>
> > > Cc: Jiri Kosina <jikos@kernel.org>
> > > Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > Cc: linux-input@vger.kernel.org
> > > Signed-off-by: Kees Cook <keescook@chromium.org>
> >
> > Applied, thank you Kees.
> >
> 
> Eek! No, this will break the build: struct_group() is not yet in the tree.
> I can carry this with an Ack, etc.

I was pretty sure I saw struct_group() already in linux-next, but that was 
apparently a vacation-induced brainfart, sorry. Dropping.

-- 
Jiri Kosina
SUSE Labs

