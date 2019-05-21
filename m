Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42AF325287
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 16:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbfEUOrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 10:47:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:50462 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbfEUOrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 10:47:31 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hT638-0001eu-B6; Tue, 21 May 2019 16:47:30 +0200
Received: from [178.197.249.20] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hT638-0006GG-4q; Tue, 21 May 2019 16:47:30 +0200
Subject: Re: [PATCH bpf] bpf: fix out-of-bounds read in __bpf_skc_lookup
To:     Lorenz Bauer <lmb@cloudflare.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.com
Cc:     joe@isovalent.com
References: <20190521075238.26803-1-lmb@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <683d7499-4466-197e-b053-a4962e99ae76@iogearbox.net>
Date:   Tue, 21 May 2019 16:47:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190521075238.26803-1-lmb@cloudflare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25456/Tue May 21 09:56:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/21/2019 09:52 AM, Lorenz Bauer wrote:
> __bpf_skc_lookup takes a socket tuple and the length of the
> tuple as an argument. Based on the length, it decides which
> address family to pass to the helper function sk_lookup.
> 
> In case of AF_INET6, it fails to verify that the length
> of the tuple is long enough. sk_lookup may therefore access
> data past the end of the tuple.
> 
> Fixes: 6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF")
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>

Applied, thanks!
