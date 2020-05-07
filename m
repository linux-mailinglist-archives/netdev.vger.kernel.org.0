Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9B71C95BF
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 17:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgEGP6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 11:58:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:55438 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbgEGP6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 11:58:47 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jWiuH-0008Cw-Lt; Thu, 07 May 2020 17:57:53 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jWiuH-0008HP-1i; Thu, 07 May 2020 17:57:53 +0200
Subject: Re: [PATCH v2] bpf, i386: remove unneeded conversion to bool
To:     Martin KaFai Lau <kafai@fb.com>, Jason Yan <yanaijie@huawei.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        udknight@gmail.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, ast@kernel.org,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        lukenels@cs.washington.edu, xi.wang@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200506140352.37154-1-yanaijie@huawei.com>
 <20200506220443.pmszq4jnfr2pcjp4@kafai-mbp>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1f762d57-7439-37e4-1cfb-f53df6dd47d0@iogearbox.net>
Date:   Thu, 7 May 2020 17:57:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200506220443.pmszq4jnfr2pcjp4@kafai-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25805/Thu May  7 14:14:46 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/7/20 12:04 AM, Martin KaFai Lau wrote:
> On Wed, May 06, 2020 at 10:03:52PM +0800, Jason Yan wrote:
>> The '==' expression itself is bool, no need to convert it to bool again.
>> This fixes the following coccicheck warning:
> Make sense.
> 
> It may belong to bpf-next instead.
> 
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Applied, thanks!
