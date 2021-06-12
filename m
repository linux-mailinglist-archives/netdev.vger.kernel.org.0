Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23DF3A5148
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 01:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhFLXNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 19:13:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhFLXNJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Jun 2021 19:13:09 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57A66610C8;
        Sat, 12 Jun 2021 23:11:08 +0000 (UTC)
Date:   Sat, 12 Jun 2021 19:11:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Joe Perches <joe@perches.com>
Cc:     amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, lima@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH V2] treewide: Add missing semicolons to __assign_str
 uses
Message-ID: <20210612191107.24c1bfbb@rorschach.local.home>
In-Reply-To: <48a056adabd8f70444475352f617914cef504a45.camel@perches.com>
References: <cover.1621024265.git.bristot@redhat.com>
        <2c59beee3b36b15592bfbb9f26dee7f8b55fd814.1621024265.git.bristot@redhat.com>
        <20210603172902.41648183@gandalf.local.home>
        <1e068d21106bb6db05b735b4916bb420e6c9842a.camel@perches.com>
        <20210604122128.0d348960@oasis.local.home>
        <48a056adabd8f70444475352f617914cef504a45.camel@perches.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Jun 2021 08:42:27 -0700
Joe Perches <joe@perches.com> wrote:

> The __assign_str macro has an unusual ending semicolon but the vast
> majority of uses of the macro already have semicolon termination.
> 
> $ git grep -P '\b__assign_str\b' | wc -l
> 551
> $ git grep -P '\b__assign_str\b.*;' | wc -l
> 480
> 
> Add semicolons to the __assign_str() uses without semicolon termination
> and all the other uses without semicolon termination via additional defines
> that are equivalent to __assign_str() with the eventual goal of removing
> the semicolon from the __assign_str() macro definition.
> 
> Link: https://lore.kernel.org/lkml/1e068d21106bb6db05b735b4916bb420e6c9842a.camel@perches.com/

FYI, please send new patches as new threads. Otherwise it is likely to
be missed.

-- Steve
