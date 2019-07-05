Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B411560DB5
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 00:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbfGEWVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 18:21:39 -0400
Received: from www62.your-server.de ([213.133.104.62]:60410 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfGEWVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 18:21:39 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hjWaC-0006LW-Ia; Sat, 06 Jul 2019 00:21:32 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hjWaC-0005oR-C7; Sat, 06 Jul 2019 00:21:32 +0200
Subject: Re: [PATCH bpf-next] selftests/bpf: fix test_align liveliness
 expectations
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org
References: <20190703212907.189141-1-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <46a90dba-8032-1ef1-153c-88c5bb2083c8@iogearbox.net>
Date:   Sat, 6 Jul 2019 00:21:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190703212907.189141-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25501/Fri Jul  5 10:01:52 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/03/2019 11:29 PM, Stanislav Fomichev wrote:
> Commit 2589726d12a1 ("bpf: introduce bounded loops") caused a change
> in the way some registers liveliness is reported in the test_align.
> Add missing "_w" to a couple of tests. Note, there are no offset
> changes!
> 
> Fixes: 2589726d12a1 ("bpf: introduce bounded loops")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Applied, thanks!
