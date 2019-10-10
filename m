Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD220D346D
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 01:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfJJXio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 19:38:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:36404 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbfJJXin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 19:38:43 -0400
Received: from 55.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.55] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iIi13-00017X-FK; Fri, 11 Oct 2019 01:38:41 +0200
Date:   Fri, 11 Oct 2019 01:38:40 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Stanislav Fomichev <sdf@fomichev.me>
Subject: Re: [PATCH bpf-next v2 0/2] Atomic flow dissector updates
Message-ID: <20191010233840.GA20202@pc-63.home>
References: <20191010181750.5964-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010181750.5964-1-jakub@cloudflare.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25598/Thu Oct 10 10:50:35 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 08:17:48PM +0200, Jakub Sitnicki wrote:
> This patch set changes how bpf(BPF_PROG_ATTACH) operates on flow dissector
> hook when there is already a program attached. After this change the user
> is allowed to update the program in a single syscall. Please see the first
> patch for rationale.
> 
> v1 -> v2:
> 
> - Don't use CHECK macro which expects BPF program run duration, which we
>   don't track in attach/detach tests. Suggested by Stanislav Fomichev.
> 
> - Test re-attaching flow dissector in both root and non-root network
>   namespace. Suggested by Stanislav Fomichev.
> 
> 
> Jakub Sitnicki (2):
>   flow_dissector: Allow updating the flow dissector program atomically
>   selftests/bpf: Check that flow dissector can be re-attached
> 
>  net/core/flow_dissector.c                     |  10 +-
>  .../bpf/prog_tests/flow_dissector_reattach.c  | 127 ++++++++++++++++++
>  2 files changed, 134 insertions(+), 3 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c

This needs a new rebase, doesn't apply cleanly. Please carry on Martin
and Stanislav's tags. Thanks!
