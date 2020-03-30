Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE1D619824B
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbgC3RZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:25:49 -0400
Received: from www62.your-server.de ([213.133.104.62]:39284 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727890AbgC3RZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:25:49 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jIyAK-0006tP-Rk; Mon, 30 Mar 2020 19:25:36 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jIyAK-000GDI-D1; Mon, 30 Mar 2020 19:25:36 +0200
Subject: Re: linux-next: Tree for Mar 30 (bpf)
To:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kpsingh@chromium.org
References: <20200330204307.669bbb4d@canb.auug.org.au>
 <86f7031a-57c6-5d50-2788-ae0e06a7c138@infradead.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d5b4bd95-7ef9-58cb-1955-900e6edb2467@iogearbox.net>
Date:   Mon, 30 Mar 2020 19:25:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <86f7031a-57c6-5d50-2788-ae0e06a7c138@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25767/Mon Mar 30 15:08:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Cc KP, ptal]

On 3/30/20 7:15 PM, Randy Dunlap wrote:
> On 3/30/20 2:43 AM, Stephen Rothwell wrote:
>> Hi all,
>>
>> The merge window has opened, so please do not add any material for the
>> next release into your linux-next included trees/branches until after
>> the merge window closes.
>>
>> Changes since 20200327:
> 
> (note: linux-next is based on linux 5.6-rc7)
> 
> 
> on i386:
> 
> ld: kernel/bpf/bpf_lsm.o:(.rodata+0x0): undefined reference to `bpf_tracing_func_proto'
> 
> 
> Full randconfig file is attached.
> 

