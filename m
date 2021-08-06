Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0CA3E2D02
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 16:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241958AbhHFO4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 10:56:41 -0400
Received: from www62.your-server.de ([213.133.104.62]:38524 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbhHFO4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 10:56:41 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mC1Gh-000GyB-U1; Fri, 06 Aug 2021 16:56:15 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mC1Gh-0004bg-L6; Fri, 06 Aug 2021 16:56:15 +0200
Subject: Re: [PATCH bpf-next 0/3] tools: ksnoop: tracing kernel function
 entry/return with argument/return value display
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, quentin@isovalent.com, toke@redhat.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org
References: <1628025796-29533-1-git-send-email-alan.maguire@oracle.com>
 <9fab5327-b629-c6bf-454c-dffe181e1cb1@iogearbox.net>
 <alpine.LRH.2.23.451.2108051210470.19742@localhost>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c854434c-20ba-b181-9bed-9cf289030e12@iogearbox.net>
Date:   Fri, 6 Aug 2021 16:56:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.23.451.2108051210470.19742@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26255/Fri Aug  6 10:24:06 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/5/21 1:14 PM, Alan Maguire wrote:
> On Wed, 4 Aug 2021, Daniel Borkmann wrote:
>> On 8/3/21 11:23 PM, Alan Maguire wrote:
>>> Recent functionality added to libbpf [1] enables typed display of kernel
>>> data structures; here that functionality is exploited to provide a
>>> simple example of how a tracer can support deep argument/return value
>>> inspection.  The intent is to provide a demonstration of these features
>>> to help facilitate tracer adoption, while also providing a tool which
>>> can be useful for kernel debugging.
>>
>> Thanks a lot for working on this tool, this looks _super useful_! Right now
>> under tools/bpf/ we have bpftool and resolve_btfids as the two main tools,
>> the latter used during kernel build, and the former evolving with the kernel
>> together with libbpf. The runqslower in there was originally thought of as
>> a single/small example tool to demo how to build stand-alone tracing tools
>> with all the modern practices, though the latter has also been added to [0]
>> (thus could be removed). I would rather love if you could add ksnoop for
>> inclusion into bcc's libbpf-based tracing tooling suite under [0] as well
>> which would be a better fit long term rather than kernel tree for the tool
>> to evolve. We don't intend to add a stand-alone tooling collection under the
>> tools/bpf/ long term since these can evolve better outside of kernel tree.
> 
> Sounds good; I'll look into contributing the tool to bcc.

Awesome, thanks a lot Alan!
