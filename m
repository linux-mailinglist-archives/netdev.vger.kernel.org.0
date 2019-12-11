Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B0F11AB78
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 14:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbfLKNBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 08:01:50 -0500
Received: from www62.your-server.de ([213.133.104.62]:53916 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727402AbfLKNBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 08:01:50 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1if1ch-0002OU-Os; Wed, 11 Dec 2019 14:01:47 +0100
Date:   Wed, 11 Dec 2019 14:01:47 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf v2] bpftool: Don't crash on missing jited insns or
 ksyms
Message-ID: <20191211130147.GA23383@linux.fritz.box>
References: <20191210181412.151226-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191210181412.151226-1-toke@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25660/Wed Dec 11 10:47:07 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 07:14:12PM +0100, Toke Høiland-Jørgensen wrote:
> When the kptr_restrict sysctl is set, the kernel can fail to return
> jited_ksyms or jited_prog_insns, but still have positive values in
> nr_jited_ksyms and jited_prog_len. This causes bpftool to crash when trying
> to dump the program because it only checks the len fields not the actual
> pointers to the instructions and ksyms.
> 
> Fix this by adding the missing checks.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Applied, thanks!
