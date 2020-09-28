Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6740727B35A
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 19:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgI1Rfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 13:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbgI1Rfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 13:35:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2F3C0613CE;
        Mon, 28 Sep 2020 10:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=q3VaPCdAslCCR/jQf884F8evN4sPOMU3hyuwN0qXmZs=; b=tHy0kY+BbMefAS9lAdwGUon8gS
        iIsSZiaAECDsBhcXUY9zMAiri42fgTkxr7zxW2FRImGN6MHm+1fkPKH+jljNrPQZh2DYMFI5synUO
        qLp1dODoYc8CEoz3Oe68GwvXexASAgHAXVM07CG7N6HhTvutRf9cehKcnbCFuUMJ0hurIHGi5/wVF
        /urhXuRGqxnH6PLRgVLjtQ0vAG1zqrvbcmaMA7P9SoKkEEgUSl/3xODlhx+e1aT56lp209/6qFVCn
        8owCWu+twhkX5e0KCYaKv5DSccX6ct5rP7QO6jukAPDhG8p/ORtYJemv9Dzyz7UWBj5ftz7RB2urs
        HBnUw67Q==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kMx3d-00007B-2S; Mon, 28 Sep 2020 17:35:25 +0000
Subject: Re: linux-next: Tree for Sep 28 (kernel/bpf/verifier.c)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20200928215551.2b882630@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <1762ab05-e8ba-8380-5c68-31642bb96ab4@infradead.org>
Date:   Mon, 28 Sep 2020 10:35:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200928215551.2b882630@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/20 4:55 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20200925:
> 



when CONFIG_NET is not set/enabled:

../kernel/bpf/verifier.c:3990:13: error: ‘btf_sock_ids’ undeclared here (not in a function); did you mean ‘bpf_sock_ops’?
  .btf_id = &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
             ^~~~~~~~~~~~
             bpf_sock_ops
  CC      kernel/time/tick-oneshot.o
../kernel/bpf/verifier.c:3990:26: error: ‘BTF_SOCK_TYPE_SOCK_COMMON’ undeclared here (not in a function); did you mean ‘PTR_TO_SOCK_COMMON’?
  .btf_id = &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
                          ^~~~~~~~~~~~~~~~~~~~~~~~~
                          PTR_TO_SOCK_COMMON


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
