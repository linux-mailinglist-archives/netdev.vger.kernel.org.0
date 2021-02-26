Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C67326A0A
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 23:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhBZWfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 17:35:17 -0500
Received: from www62.your-server.de ([213.133.104.62]:38136 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhBZWfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 17:35:16 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lFlgw-000Ejm-So; Fri, 26 Feb 2021 23:34:34 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lFlgw-000Q70-Nd; Fri, 26 Feb 2021 23:34:34 +0100
Subject: Re: [PATCH bpf-next V2 0/2] bpf: Updates for BPF-helper bpf_check_mtu
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <161364896576.1250213.8059418482723660876.stgit@firesoul>
 <20210219073638.75b3d8f3@carbon>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9e620507-6e9b-16f8-5ef9-3bbf2c2b6a3c@iogearbox.net>
Date:   Fri, 26 Feb 2021 23:34:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210219073638.75b3d8f3@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26092/Fri Feb 26 13:12:59 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/19/21 7:36 AM, Jesper Dangaard Brouer wrote:
> On Thu, 18 Feb 2021 12:49:53 +0100
> Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> 
>> The FIB lookup example[1] show how the IP-header field tot_len
>> (iph->tot_len) is used as input to perform the MTU check. The recently
>> added MTU check helper bpf_check_mtu() should also support this type
>> of MTU check.
>>
>> Lets add this feature before merge window, please. This is a followup
>> to 34b2021cc616 ("bpf: Add BPF-helper for MTU checking").
> 
> Which git tree should I send this against bpf-next or bpf, to keep this
> change together with 34b2021cc616 ("bpf: Add BPF-helper for MTU
> checking") ?

Given this is an api change, we'll take this into bpf tree after the
pending pr was merged.
