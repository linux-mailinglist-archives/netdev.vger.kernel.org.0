Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE2532598F
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 22:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbfEUUya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 16:54:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727341AbfEUUy3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 16:54:29 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6232C217F9;
        Tue, 21 May 2019 20:54:28 +0000 (UTC)
Date:   Tue, 21 May 2019 16:54:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Kris Van Hees <kris.van.hees@oracle.com>
Cc:     dtrace-devel@oss.oracle.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel@iogearbox.net, acme@kernel.org, mhiramat@kernel.org,
        ast@kernel.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190521165426.096af6fd@gandalf.local.home>
In-Reply-To: <20190521204848.GJ2422@oracle.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
        <20190521204848.GJ2422@oracle.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 May 2019 16:48:48 -0400
Kris Van Hees <kris.van.hees@oracle.com> wrote:

> As suggested, I resent the patch set as replies to the cover letter post
> to support threaded access to the patches.

Note, you should also have added a v2 in the subject:

[RFC PATCH 00/11 v2] ...

The next one should have v3.

Cheers,

-- Steve
