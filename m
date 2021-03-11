Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D96336C5E
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhCKGjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:39:43 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:44503 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229932AbhCKGjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 01:39:21 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0URPwQhx_1615444758;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0URPwQhx_1615444758)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 11 Mar 2021 14:39:18 +0800
Date:   Thu, 11 Mar 2021 14:39:17 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     davem@davemloft.net, mingo@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: add net namespace inode for all net_dev events
Message-ID: <YEm7FcfJ5NY6WM+J@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20210309044349.6605-1-tonylu@linux.alibaba.com>
 <20210309124011.709c6cd3@gandalf.local.home>
 <YEiLbLiXe6ju/vCO@TonyMac-Alibaba>
 <20210310113112.743dcf17@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310113112.743dcf17@gandalf.local.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 11:31:12AM -0500, Steven Rostedt wrote:
> On Wed, 10 Mar 2021 17:03:40 +0800
> Tony Lu <tonylu@linux.alibaba.com> wrote:
> 
> > I use pahole to read vmlinux.o directly with defconfig and
> > CONFIG_DEBUG_INFO enabled, the result shows 22 structs prefixed with
> > trace_event_raw_ that have at least one hole.
> 
> I was thinking of pahole too ;-)
> 
> But the information can also be captured from the format files with simple
> scripts as well. And perhaps be more tuned to see if there's actually a fix
> for them, and ignore reporting it if there is no fix, as all trace events
> are 4 byte aligned, and if we are off by one, sometimes it doesn't matter.

I am going to send a patch to fix this issue later. There are many
events have more than 1 holes, I am trying to pick up the events that are
really to be fixed.


Cheers,
Tony Lu

> 
> -- Steve
