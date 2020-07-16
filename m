Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D3222283F
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 18:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbgGPQ1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 12:27:16 -0400
Received: from www62.your-server.de ([213.133.104.62]:37876 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728837AbgGPQ1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 12:27:15 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jw6iv-00019q-Ep; Thu, 16 Jul 2020 18:27:05 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jw6iv-000KSG-4x; Thu, 16 Jul 2020 18:27:05 +0200
Subject: Re: [PATCH v7 bpf-next 0/9] introduce support for XDP programs in
 CPUMAP
To:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        lorenzo.bianconi@redhat.com, David Ahern <dsahern@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
References: <cover.1594734381.git.lorenzo@kernel.org>
 <CAADnVQLNuStgi45XT0nUDifg7yHxKFn04Ufs=fQr5DYnoMshzQ@mail.gmail.com>
 <20200714153530.GC2174@localhost.localdomain>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <246b65c9-9fb4-a3af-77eb-8c7cc811ebd6@iogearbox.net>
Date:   Thu, 16 Jul 2020 18:27:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200714153530.GC2174@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25875/Thu Jul 16 16:46:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/14/20 5:35 PM, Lorenzo Bianconi wrote:
>> On Tue, Jul 14, 2020 at 6:56 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>>>
>>> Similar to what David Ahern proposed in [1] for DEVMAPs, introduce the
>>> capability to attach and run a XDP program to CPUMAP entries.
>>> The idea behind this feature is to add the possibility to define on which CPU
>>> run the eBPF program if the underlying hw does not support RSS.
>>> I respin patch 1/6 from a previous series sent by David [2].
>>> The functionality has been tested on Marvell Espressobin, i40e and mlx5.
>>> Detailed tests results can be found here:
>>> https://github.com/xdp-project/xdp-project/blob/master/areas/cpumap/cpumap04-map-xdp-prog.org
>>>
>>> Changes since v6:
>>> - rebase on top of bpf-next
>>> - move bpf_cpumap_val and bpf_prog in the first bpf_cpu_map_entry cache-line
>>
>> fyi. I'm waiting on Daniel to do one more look, since he commented in the past.
> 
> ack, thx. I have just figured out today that v6 is not applying anymore.

LGTM, I've applied it, thanks!
