Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59A74D49D0
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 23:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbfJKVYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 17:24:46 -0400
Received: from www62.your-server.de ([213.133.104.62]:48994 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfJKVYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 17:24:46 -0400
Received: from 55.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.55] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iJ2Oy-00070c-Oh; Fri, 11 Oct 2019 23:24:44 +0200
Date:   Fri, 11 Oct 2019 23:24:44 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next v3 0/2] Atomic flow dissector updates
Message-ID: <20191011212444.GB21131@pc-63.home>
References: <20191011082946.22695-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011082946.22695-1-jakub@cloudflare.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25599/Fri Oct 11 10:48:23 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 10:29:44AM +0200, Jakub Sitnicki wrote:
> This patch set changes how bpf(BPF_PROG_ATTACH) operates on flow dissector
> hook when there is already a program attached. After this change the user
> is allowed to update the program in a single syscall. Please see the first
> patch for rationale.

Applied, thanks!
