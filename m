Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F30F1D49CE
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 23:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbfJKVYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 17:24:00 -0400
Received: from www62.your-server.de ([213.133.104.62]:48810 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfJKVYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 17:24:00 -0400
Received: from 55.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.55] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iJ2O7-0006xY-CY; Fri, 11 Oct 2019 23:23:51 +0200
Date:   Fri, 11 Oct 2019 23:23:51 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: align struct bpf_prog_stats
Message-ID: <20191011212351.GA21131@pc-63.home>
References: <20191011181140.2898-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011181140.2898-1-edumazet@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25599/Fri Oct 11 10:48:23 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 11:11:40AM -0700, Eric Dumazet wrote:
> Do not risk spanning these small structures on two cache lines.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks!
