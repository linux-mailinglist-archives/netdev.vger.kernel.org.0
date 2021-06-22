Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D8A3B0570
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 15:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhFVNGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 09:06:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:38362 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhFVNGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 09:06:18 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lvg4M-000CdI-QU; Tue, 22 Jun 2021 15:03:58 +0200
Received: from [85.7.101.30] (helo=linux-3.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lvg4M-000Hly-Ib; Tue, 22 Jun 2021 15:03:58 +0200
Subject: Re: [PATCH bpf] Revert "bpf: program: Refuse non-O_RDWR flags in
 BPF_OBJ_GET"
To:     Lorenz Bauer <lmb@cloudflare.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Greg Kroah-Hartman <gregkh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lorenzo Colitti <lorenzo@google.com>
References: <20210618105526.265003-1-zenczykowski@gmail.com>
 <CACAyw99k4ZhePBcRJzJn37rvGKnPHEgE3z8Y-47iYKQO2nqFpQ@mail.gmail.com>
 <CANP3RGdrpb+KiD+a29zTSU3LKR8Qo6aFdo4QseRvPdNhZ_AOJw@mail.gmail.com>
 <CACAyw9948drqRE=0tC=5OrdX=nOVR3JSPScXrkdAv+kGD_P3ZA@mail.gmail.com>
 <CAHo-Oozra2ygb4qW6s8rsgZFmdr-gaQuGzREtXuZLwzzESCYNw@mail.gmail.com>
 <CACAyw98B=uCnDY1tTw5STLUgNKvJeksJjaKiGqasJEEVv99GqA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a703516a-1566-d5fe-cf4c-f2bb004a4f4e@iogearbox.net>
Date:   Tue, 22 Jun 2021 15:03:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CACAyw98B=uCnDY1tTw5STLUgNKvJeksJjaKiGqasJEEVv99GqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26209/Tue Jun 22 13:07:55 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/21 10:59 AM, Lorenz Bauer wrote:
> On Mon, 21 Jun 2021 at 22:37, Maciej Żenczykowski
> <zenczykowski@gmail.com> wrote:
>>
>> Please revert immediately.  I've got better things to do.  I shouldn't
>> have to be thinking about this or arguing about this.
>> It already took me significantly more than a day simply to track this
>> down (arguably due to miscommunications with Greg, who'd earlier
>> actually found this in 5.12, but misunderstood the problem, but
>> still...).
> 
> You're barking up the wrong tree. I don't object to reverting the
> patch, you asked me for context and I gave it to you.

+1, this kind of barking was unnecessary and inappropriate.

I revamped the commit message a bit to have some more context for future
reference when we need to get back on this.

Anyway, applied.
