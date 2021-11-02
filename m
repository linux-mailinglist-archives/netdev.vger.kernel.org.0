Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16AE4442EC7
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 14:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhKBNIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 09:08:24 -0400
Received: from www62.your-server.de ([213.133.104.62]:37862 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbhKBNIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 09:08:23 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mhtU2-0003e9-Qh; Tue, 02 Nov 2021 14:05:46 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mhtU2-000SUc-Kf; Tue, 02 Nov 2021 14:05:46 +0100
Subject: Re: bpf, cgroups: Fix cgroup v2 fallback on v1/v2 mixed mode
 [backport]
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>, Tejun Heo <tj@kernel.org>,
        gregkh@linuxfoundation.org
References: <CABWYdi1XNPbCHfR7-8NiSnjNG4cCy=KTHPKcHiDYp5E-0F2g0A@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8dbbb2e5-0e18-8749-550b-14539bc30a5d@iogearbox.net>
Date:   Tue, 2 Nov 2021 14:05:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CABWYdi1XNPbCHfR7-8NiSnjNG4cCy=KTHPKcHiDYp5E-0F2g0A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26341/Tue Nov  2 09:18:13 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/29/21 11:50 PM, Ivan Babrou wrote:
> Hello,
> 
> We have re-discovered the issue fixed by the following commit in v5.15:
> 
> * https://github.com/torvalds/linux/commit/8520e224f54
> 
> Is it possible to also backport the fix to 5.10 series, where the
> issue is also present?

No objections from my side, relevant commit SHAs aside from selftests should be:

  - 8520e224f547cd070c7c8f97b1fc6d58cff7ccaa
  - 78cc316e9583067884eb8bd154301dc1e9ee945c
  - 435b08ec0094ac1e128afe6cfd0d9311a8c617a7

If you have a chance, could you craft & submit a backport for stable?

Thanks Ivan!
