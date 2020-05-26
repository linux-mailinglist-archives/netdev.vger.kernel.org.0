Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FAE1E3101
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 23:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390719AbgEZVPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 17:15:45 -0400
Received: from www62.your-server.de ([213.133.104.62]:44972 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390435AbgEZVPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 17:15:45 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdgv5-0007kT-O4; Tue, 26 May 2020 23:15:31 +0200
Date:   Tue, 26 May 2020 23:15:29 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     bpf@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, toke@redhat.com
Subject: Re: [PATCH bpf-next v2] libbpf: add API to consume the perf ring
 buffer content
Message-ID: <20200526211529.GB3853@pc-9.home>
References: <159048487929.89441.7465713173442594608.stgit@ebuild>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159048487929.89441.7465713173442594608.stgit@ebuild>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25824/Tue May 26 14:27:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 11:21:42AM +0200, Eelco Chaudron wrote:
> This new API, perf_buffer__consume, can be used as follows:
> - When you have a perf ring where wakeup_events is higher than 1,
>   and you have remaining data in the rings you would like to pull
>   out on exit (or maybe based on a timeout).
> - For low latency cases where you burn a CPU that constantly polls
>   the queues.
> 
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

Applied, thanks!
