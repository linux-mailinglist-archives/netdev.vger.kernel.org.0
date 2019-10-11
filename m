Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59BE5D49D2
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 23:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbfJKVZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 17:25:20 -0400
Received: from www62.your-server.de ([213.133.104.62]:49180 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfJKVZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 17:25:20 -0400
Received: from 55.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.55] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iJ2PV-00071p-Oa; Fri, 11 Oct 2019 23:25:17 +0200
Date:   Fri, 11 Oct 2019 23:25:17 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com
Subject: Re: [PATCH v2 bpf-next] bpf: fix cast to pointer from integer of
 different size warning
Message-ID: <20191011212517.GC21131@pc-63.home>
References: <20191011172053.2980619-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011172053.2980619-1-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25599/Fri Oct 11 10:48:23 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 10:20:53AM -0700, Andrii Nakryiko wrote:
> Fix "warning: cast to pointer from integer of different size" when
> casting u64 addr to void *.
> 
> Fixes: a23740ec43ba ("bpf: Track contents of read-only maps as scalars")
> Reported-by: kbuild test robot <lkp@intel.com>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
