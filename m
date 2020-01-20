Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2615E14342A
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 23:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgATWk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 17:40:26 -0500
Received: from www62.your-server.de ([213.133.104.62]:58856 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgATWk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 17:40:26 -0500
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1itfia-0002Yv-5F; Mon, 20 Jan 2020 23:40:24 +0100
Received: from [178.197.248.27] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1itfiZ-0003Eh-PX; Mon, 20 Jan 2020 23:40:23 +0100
Subject: Re: [PATCH bpf] selftests/bpf: skip perf hw events test if the setup
 disabled it
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Song Liu <songliubraving@fb.com>
References: <20200117100656.10359-1-liuhangbin@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c6b602e7-aea8-3128-1d94-4d7fc77a81ce@iogearbox.net>
Date:   Mon, 20 Jan 2020 23:40:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200117100656.10359-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25701/Mon Jan 20 12:41:43 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/17/20 11:06 AM, Hangbin Liu wrote:
> The same with commit 4e59afbbed96 ("selftests/bpf: skip nmi test when perf
> hw events are disabled"), it would make more sense to skip the
> test_stacktrace_build_id_nmi test if the setup (e.g. virtual machines) has
> disabled hardware perf events.
> 
> Fixes: 13790d1cc72c ("bpf: add selftest for stackmap with build_id in NMI context")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied to bpf-next, thanks!
