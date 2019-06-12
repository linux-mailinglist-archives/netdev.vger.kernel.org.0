Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66E5F429D9
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 16:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406449AbfFLOsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 10:48:33 -0400
Received: from www62.your-server.de ([213.133.104.62]:45052 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392030AbfFLOsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 10:48:33 -0400
Received: from [88.198.220.132] (helo=sslproxy03.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hb4Y5-0007eZ-8M; Wed, 12 Jun 2019 16:48:25 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hb4Y5-0000kb-0T; Wed, 12 Jun 2019 16:48:25 +0200
Subject: Re: [PATCH bpf] bpf: net: Set sk_bpf_storage back to NULL for cloned
 sk
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@fb.com>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com
References: <20190611214557.2700117-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <90b81b8f-1ce1-4dd7-bdbb-b51c03839ca7@iogearbox.net>
Date:   Wed, 12 Jun 2019 16:48:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190611214557.2700117-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25478/Wed Jun 12 10:14:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/11/2019 11:45 PM, Martin KaFai Lau wrote:
> The cloned sk should not carry its parent-listener's sk_bpf_storage.
> This patch fixes it by setting it back to NULL.
> 
> Fixes: 6ac99e8f23d4 ("bpf: Introduce bpf sk local storage")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Applied, thanks!
