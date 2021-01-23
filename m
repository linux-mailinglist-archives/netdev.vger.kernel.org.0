Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A81630121F
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 02:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbhAWBuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 20:50:13 -0500
Received: from www62.your-server.de ([213.133.104.62]:33392 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbhAWBuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 20:50:11 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l383O-0004yL-0B; Sat, 23 Jan 2021 02:49:30 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l383N-0005tE-Mx; Sat, 23 Jan 2021 02:49:29 +0100
Subject: Re: [PATCH bpf-next V12 7/7] bpf/selftests: tests using bpf_check_mtu
 BPF-helper
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
References: <161098881526.108067.7603213364270807261.stgit@firesoul>
 <161098888542.108067.3212673708592909660.stgit@firesoul>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a44f45cf-5c0b-9d59-3368-a1be4b50465d@iogearbox.net>
Date:   Sat, 23 Jan 2021 02:49:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <161098888542.108067.3212673708592909660.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26057/Fri Jan 22 13:30:31 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/21 5:54 PM, Jesper Dangaard Brouer wrote:
> Adding selftest for BPF-helper bpf_check_mtu(). Making sure
> it can be used from both XDP and TC.
> 
[...]

(small nit: your subject lines are mixed up with 'bpf/selftests' vs
  'selftests/bpf')
