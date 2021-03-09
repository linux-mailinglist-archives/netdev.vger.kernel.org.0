Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5DA332F81
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 21:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhCIUCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 15:02:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:48238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230431AbhCIUCb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 15:02:31 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13CE960C3E;
        Tue,  9 Mar 2021 20:02:29 +0000 (UTC)
Date:   Tue, 9 Mar 2021 15:02:27 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        mingo@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: add net namespace inode for all net_dev events
Message-ID: <20210309150227.48281a18@gandalf.local.home>
In-Reply-To: <5fda3ef7-d760-df4f-e076-23b635f6c758@gmail.com>
References: <20210309044349.6605-1-tonylu@linux.alibaba.com>
        <20210309124011.709c6cd3@gandalf.local.home>
        <5fda3ef7-d760-df4f-e076-23b635f6c758@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Mar 2021 12:53:37 -0700
David Ahern <dsahern@gmail.com> wrote:

> Changing the order of the fields will impact any bpf programs expecting
> the existing format

I thought bpf programs were not API. And why are they not parsing this
information? They have these offsets hard coded???? Why would they do that!
The information to extract the data where ever it is has been there from
day 1! Way before BPF ever had access to trace events.

Please, STOP HARD CODING FIELD OFFSETS!!!! This is why people do not want
to use trace points in the first place. Because tools do stupid things.

-- Steve
