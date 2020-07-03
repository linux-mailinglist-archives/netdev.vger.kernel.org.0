Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D832140D9
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 23:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgGCVa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 17:30:59 -0400
Received: from www62.your-server.de ([213.133.104.62]:60954 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbgGCVa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 17:30:59 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jrTGs-0007uq-1i; Fri, 03 Jul 2020 23:30:58 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jrTGr-00049V-Re; Fri, 03 Jul 2020 23:30:57 +0200
Subject: Re: [PATCH bpf-next] selftests/bpf: fix compilation error of
 bpf_iter_task_stack.c
To:     Song Liu <songliubraving@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     ast@kernel.org, kernel-team@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, brouer@redhat.com
References: <20200703181719.3747072-1-songliubraving@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1c82c7d9-4f3e-feb1-05b2-a655acada7e3@iogearbox.net>
Date:   Fri, 3 Jul 2020 23:30:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200703181719.3747072-1-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25862/Fri Jul  3 15:56:19 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/3/20 8:17 PM, Song Liu wrote:
> selftests/bpf shows compilation error as
> 
>    libbpf: invalid relo for 'entries' in special section 0xfff2; forgot to
>    initialize global var?..
> 
> Fix it by initializing 'entries' to zeros.
> 
> Fixes: c7568114bc56 ("selftests/bpf: Add bpf_iter test with bpf_get_task_stack()")
> Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>

Applied, thanks!
