Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC9C3907BA
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 19:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbhEYRcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 13:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbhEYRcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 13:32:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2440EC061574;
        Tue, 25 May 2021 10:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=cGt+P5ew3IFNE7E+SH0yQkvgOG7FPUZVJvyaJoyaAFs=; b=MyuOh7i+BatRFVc1QmN8obYn30
        1vvZFrsrousSwI5KS2xXibVoOlgK33GOlPMTV0Tl/H+L0uoBWkrQPz2FuZOmQfPNJxHVSBs5PIVSv
        fNH329+jvQZVivZWKCN8k55VP+ikPi9kWdTVDIHcF87tjKTyGPqtodhgm+Hg+pIpMfqroSnjFGnMY
        UIL4yOG20Wbj3TQ1VzNc6psDbVF6b4/lh5mVfMjdquZFDuLZLvTp6Oq+VN+9+VehyNQ1IcEwAzziP
        G1TJwDd+oWZKOYPvPplIgckm0Q83lGiXK5prPy8asIyOOYfaC/ixYOX1FizHY7uKiUQmjAkOroSqc
        cVDK4o2w==;
Received: from [2601:1c0:6280:3f0::7376]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1llat8-006tJy-Qe; Tue, 25 May 2021 17:30:42 +0000
Subject: Re: linux-next: Tree for May 18 (kernel/bpf/bpf_lsm.o)
From:   Randy Dunlap <rdunlap@infradead.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
References: <20210518192729.3131eab0@canb.auug.org.au>
 <f816246b-1136-cf00-ff47-554d40ecfb38@infradead.org>
Message-ID: <7955d9e2-a584-1693-749a-5983187e0306@infradead.org>
Date:   Tue, 25 May 2021 10:30:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <f816246b-1136-cf00-ff47-554d40ecfb38@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/21 10:02 AM, Randy Dunlap wrote:
> On 5/18/21 2:27 AM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20210514:
>>
> 
> on i386:
> # CONFIG_NET is not set
> 
> ld: kernel/bpf/bpf_lsm.o: in function `bpf_lsm_func_proto':
> bpf_lsm.c:(.text+0x1a0): undefined reference to `bpf_sk_storage_get_proto'
> ld: bpf_lsm.c:(.text+0x1b8): undefined reference to `bpf_sk_storage_delete_proto'
> 
> 
> Full randconfig file is attached.
> 

Hi,
I am still seeing this build error in linux-next-20210525.

-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>

