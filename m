Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C46CF340D
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387416AbfKGQEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:04:22 -0500
Received: from www62.your-server.de ([213.133.104.62]:43824 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727401AbfKGQEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:04:22 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iSkGi-0005v5-13; Thu, 07 Nov 2019 17:04:20 +0100
Received: from [178.197.249.41] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iSkGh-000VWr-ML; Thu, 07 Nov 2019 17:04:19 +0100
Subject: Re: [PATCH bpf-next] libbpf: fix negative FD close() in
 xsk_setup_xdp_prog()
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, jonathan.lemon@gmail.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20191107054059.313884-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f12ee295-3759-1a53-545f-5c65ced3aa7e@iogearbox.net>
Date:   Thu, 7 Nov 2019 17:04:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191107054059.313884-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25626/Thu Nov  7 10:50:48 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/19 6:40 AM, Andrii Nakryiko wrote:
> Fix issue reported by static analysis (Coverity). If bpf_prog_get_fd_by_id()
> fails, xsk_lookup_bpf_maps() will fail as well and clean-up code will attempt
> close() with fd=-1. Fix by checking bpf_prog_get_fd_by_id() return result and
> exiting early.
> 
> Fixes: 10a13bb40e54 ("libbpf: remove qidconf and better support external bpf programs.")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
