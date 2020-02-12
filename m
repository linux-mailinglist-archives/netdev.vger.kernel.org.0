Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8DA515ADB0
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 17:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgBLQus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 11:50:48 -0500
Received: from www62.your-server.de ([213.133.104.62]:40612 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgBLQus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 11:50:48 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j1vDq-0003ox-DO; Wed, 12 Feb 2020 17:50:46 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j1vDq-000GZJ-55; Wed, 12 Feb 2020 17:50:46 +0100
Subject: Re: [PATCH bpf] selftests/bpf: Mark SYN cookie test skipped for UDP
 sockets
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Lorenz Bauer <lmb@cloudflare.com>
References: <20200212103208.438419-1-jakub@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <064808a8-c6e1-885f-507e-63211b2f139a@iogearbox.net>
Date:   Wed, 12 Feb 2020 17:50:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200212103208.438419-1-jakub@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.1/25721/Wed Feb 12 06:24:38 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/12/20 11:32 AM, Jakub Sitnicki wrote:
> SYN cookie test with reuseport BPF doesn't make sense for UDP sockets. We
> don't run it but the test_progs test runner doesn't know about it. Mark the
> test as skipped so the test_progs can report correctly how many tests were
> skipped.
> 
> Fixes: 7ee0d4e97b88 ("selftests/bpf: Switch reuseport tests for test_progs framework")
> Reported-by: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

Applied, thanks!
