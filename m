Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647CC3F3143
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 18:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbhHTQMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 12:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235634AbhHTQLx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 12:11:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D147E61244;
        Fri, 20 Aug 2021 16:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629475875;
        bh=QtHvxXjD6Lxo5RaKara/Y2QvqxDS6ThacQcb91QFjy8=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=Cm8q6m2PtljGp+99RX9+Khsax5QCk8ma2yXHvKEh8RrOqdQSjmdQD2FlsFBC5lfPd
         hDf7fZUEaGki4tlDFutbg5ca6FLVXGfPxHWaOBD4XhqmxjD5ePMawLPi6bmTjgSHcj
         8DgCDWq5VV5OHyCMsJm5rGAQ/UScpbb7txwU6ToO1lJuBsRHIKQLuxTBS3CKRDxgkY
         zbUcPhLTjOj0CWY3U2jpczxlNukz8oI1saQ7GA/O6BTQCSTo/8mMx+D4koYcDYvj2z
         VhBU9Lvgl0wa0B8f5+WyDtCS3bjffcF1LCILvKtgT/qWDSeF7AMzYCV7dZ3fCz/Xm4
         QMcNMCjdf825A==
Date:   Fri, 20 Aug 2021 18:11:10 +0200 (CEST)
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
In-Reply-To: <202108200857.FA4AA13@keescook>
Message-ID: <nycvar.YFH.7.76.2108201810560.15313@cbobk.fhfr.pm>
References: <20210818060533.3569517-1-keescook@chromium.org> <20210818060533.3569517-56-keescook@chromium.org> <nycvar.YFH.7.76.2108201501510.15313@cbobk.fhfr.pm> <CAJr-aD=6-g7VRw2Hw0dhs+RrtA=Tago5r6Dukfw_gGPB0YYKOQ@mail.gmail.com>
 <nycvar.YFH.7.76.2108201725360.15313@cbobk.fhfr.pm> <202108200857.FA4AA13@keescook>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Aug 2021, Kees Cook wrote:

> > > > > In preparation for FORTIFY_SOURCE performing compile-time and run-time
> > > > > field bounds checking for memset(), avoid intentionally writing across
> > > > > neighboring fields.
> > > > >
> > > > > Add struct_group() to mark region of struct kone_mouse_event that should
> > > > > be initialized to zero.
> > > > >
> > > > > Cc: Stefan Achatz <erazor_de@users.sourceforge.net>
> > > > > Cc: Jiri Kosina <jikos@kernel.org>
> > > > > Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > > > Cc: linux-input@vger.kernel.org
> > > > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > >
> > > > Applied, thank you Kees.
> > > >
> > > 
> > > Eek! No, this will break the build: struct_group() is not yet in the tree.
> > > I can carry this with an Ack, etc.
> > 
> > I was pretty sure I saw struct_group() already in linux-next, but that was 
> > apparently a vacation-induced brainfart, sorry. Dropping.
> 
> Oh, for these two patches, can I add your Acked-by while I carry them?

Yes, thanks, and sorry for the noise.

-- 
Jiri Kosina
SUSE Labs

