Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53FC7188D84
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 19:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgCQS6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 14:58:33 -0400
Received: from www62.your-server.de ([213.133.104.62]:60058 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgCQS6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 14:58:32 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEHQ6-000220-EW; Tue, 17 Mar 2020 19:58:30 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEHQ6-000IWf-6U; Tue, 17 Mar 2020 19:58:30 +0100
Subject: Re: [PATCH bpf-next 1/3] selftests/bpf: fix race in tcp_rtt test
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200314013932.4035712-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9d9ce812-123a-00d1-9985-8a38f3ae62b4@iogearbox.net>
Date:   Tue, 17 Mar 2020 19:58:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200314013932.4035712-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25754/Tue Mar 17 14:09:15 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/14/20 2:39 AM, Andrii Nakryiko wrote:
> Previous attempt to make tcp_rtt more robust introduced a new race, in which
> server_done might be set to true before server can actually accept any
> connection. Fix this by unconditionally waiting for accept(). Given socket is
> non-blocking, if there are any problems with client side, it should eventually
> close listening FD and let server thread exit with failure.
> 
> Fixes: 4cd729fa022c ("selftests/bpf: Make tcp_rtt test more robust to failures")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Series applied, thanks!
