Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4388334314
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 17:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhCJQbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 11:31:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:34960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230035AbhCJQbO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 11:31:14 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C15B764FC4;
        Wed, 10 Mar 2021 16:31:13 +0000 (UTC)
Date:   Wed, 10 Mar 2021 11:31:12 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     davem@davemloft.net, mingo@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: add net namespace inode for all net_dev events
Message-ID: <20210310113112.743dcf17@gandalf.local.home>
In-Reply-To: <YEiLbLiXe6ju/vCO@TonyMac-Alibaba>
References: <20210309044349.6605-1-tonylu@linux.alibaba.com>
        <20210309124011.709c6cd3@gandalf.local.home>
        <YEiLbLiXe6ju/vCO@TonyMac-Alibaba>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Mar 2021 17:03:40 +0800
Tony Lu <tonylu@linux.alibaba.com> wrote:

> I use pahole to read vmlinux.o directly with defconfig and
> CONFIG_DEBUG_INFO enabled, the result shows 22 structs prefixed with
> trace_event_raw_ that have at least one hole.

I was thinking of pahole too ;-)

But the information can also be captured from the format files with simple
scripts as well. And perhaps be more tuned to see if there's actually a fix
for them, and ignore reporting it if there is no fix, as all trace events
are 4 byte aligned, and if we are off by one, sometimes it doesn't matter.

-- Steve
