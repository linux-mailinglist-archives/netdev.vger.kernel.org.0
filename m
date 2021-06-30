Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087EC3B820D
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 14:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbhF3MY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 08:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234507AbhF3MYy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 08:24:54 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4594F613ED;
        Wed, 30 Jun 2021 12:22:24 +0000 (UTC)
Date:   Wed, 30 Jun 2021 08:22:22 -0400
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
Message-ID: <20210630082222.497170a3@oasis.local.home>
In-Reply-To: <e3a04d2554bfbe6a7e516c18b5f2848aa040e498.camel@perches.com>
References: <cover.1621024265.git.bristot@redhat.com>
        <2c59beee3b36b15592bfbb9f26dee7f8b55fd814.1621024265.git.bristot@redhat.com>
        <20210603172902.41648183@gandalf.local.home>
        <1e068d21106bb6db05b735b4916bb420e6c9842a.camel@perches.com>
        <20210604122128.0d348960@oasis.local.home>
        <48a056adabd8f70444475352f617914cef504a45.camel@perches.com>
        <e3a04d2554bfbe6a7e516c18b5f2848aa040e498.camel@perches.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Jun 2021 04:28:39 -0700
Joe Perches <joe@perches.com> wrote:

> On Sat, 2021-06-12 at 08:42 -0700, Joe Perches wrote:
> > The __assign_str macro has an unusual ending semicolon but the vast
> > majority of uses of the macro already have semicolon termination.  
> 
> ping?
> 

I wasn't sure I was the one to take this. I can, as I can run tests on
it as well. I have some last minute fixes sent to me on something else,
and I can apply this along with them.

-- Steve
