Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6442AEE7F
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 11:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbgKKKHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 05:07:40 -0500
Received: from www62.your-server.de ([213.133.104.62]:36856 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727000AbgKKKHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 05:07:39 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kcn2J-00071P-FE; Wed, 11 Nov 2020 11:07:31 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kcn2J-00026R-65; Wed, 11 Nov 2020 11:07:31 +0100
Subject: Re: [PATCH v3] bpf: Fix unsigned 'datasec_id' compared with zero in
 check_pseudo_btf_id
To:     xiakaixu1987@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, kpsingh@chromium.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
References: <1605071026-25906-1-git-send-email-kaixuxia@tencent.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <154e8851-ace8-1701-00e4-beb3dd24da51@iogearbox.net>
Date:   Wed, 11 Nov 2020 11:07:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1605071026-25906-1-git-send-email-kaixuxia@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25984/Tue Nov 10 14:18:29 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/20 6:03 AM, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The unsigned variable datasec_id is assigned a return value from the call
> to check_pseudo_btf_id(), which may return negative error code.
> 
> Fixes coccicheck warning:
> 
> ./kernel/bpf/verifier.c:9616:5-15: WARNING: Unsigned expression compared with zero: datasec_id > 0
> 
> Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Looks good, applied & also added Fixes tags, thanks!
