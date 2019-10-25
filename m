Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC704E560C
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 23:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbfJYVkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 17:40:09 -0400
Received: from www62.your-server.de ([213.133.104.62]:38612 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfJYVkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 17:40:09 -0400
Received: from 33.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.33] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iO7JU-0002ko-2X; Fri, 25 Oct 2019 23:40:04 +0200
Date:   Fri, 25 Oct 2019 23:40:03 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH] bpftool: Allow to read btf as raw data
Message-ID: <20191025214003.GB14547@pc-63.home>
References: <20191024133025.10691-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024133025.10691-1-jolsa@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25613/Fri Oct 25 11:00:25 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 03:30:25PM +0200, Jiri Olsa wrote:
> The bpftool interface stays the same, but now it's possible
> to run it over BTF raw data, like:
> 
>   $ bpftool btf dump file /sys/kernel/btf/vmlinux
>   [1] INT '(anon)' size=4 bits_offset=0 nr_bits=32 encoding=(none)
>   [2] INT 'long unsigned int' size=8 bits_offset=0 nr_bits=64 encoding=(none)
>   [3] CONST '(anon)' type_id=2
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Applied, thanks!
