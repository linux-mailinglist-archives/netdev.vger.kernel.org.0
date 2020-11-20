Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4C92BB8C9
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbgKTWTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:19:19 -0500
Received: from www62.your-server.de ([213.133.104.62]:47664 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbgKTWTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:19:19 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kgEkO-0003QV-K7; Fri, 20 Nov 2020 23:19:16 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kgEkN-000Wf7-Q2; Fri, 20 Nov 2020 23:19:16 +0100
Subject: Re: [PATCH bpf-next] bpf: simplify task_file_seq_get_next()
To:     Song Liu <songliubraving@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-team@fb.com, ast@kernel.org, andrii@kernel.org,
        kpsingh@chromium.org, john.fastabend@gmail.com,
        Yonghong Song <yhs@fb.com>
References: <20201120002833.2481110-1-songliubraving@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9c2ef257-7eed-2440-661d-36e1e67613d8@iogearbox.net>
Date:   Fri, 20 Nov 2020 23:19:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201120002833.2481110-1-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25994/Fri Nov 20 14:09:26 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/20 1:28 AM, Song Liu wrote:
> Simplify task_file_seq_get_next() by removing two in/out arguments: task
> and fstruct. Use info->task and info->files instead.
> 
> Cc: Yonghong Song <yhs@fb.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>

Applied, thanks!
