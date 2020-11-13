Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F272B1EC1
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 16:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgKMPcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 10:32:15 -0500
Received: from www62.your-server.de ([213.133.104.62]:55972 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgKMPcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 10:32:15 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kdb3a-0000SZ-Oi; Fri, 13 Nov 2020 16:32:10 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kdb3a-000NMT-Iv; Fri, 13 Nov 2020 16:32:10 +0100
Subject: Re: [PATCH v4 bpf] tools: bpftool: Add missing close before bpftool
 net attach exit
To:     Wang Hai <wanghai38@huawei.com>, andrii.nakryiko@gmail.com,
        mrostecki@opensuse.org, john.fastabend@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201113115152.53178-1-wanghai38@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c5831dbd-04be-cd4d-e18f-2c2388c69aa7@iogearbox.net>
Date:   Fri, 13 Nov 2020 16:32:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201113115152.53178-1-wanghai38@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25987/Fri Nov 13 14:19:33 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/20 12:51 PM, Wang Hai wrote:
> progfd is created by prog_parse_fd(), before 'bpftool net attach' exit,
> it should be closed.
> 
> Fixes: 04949ccc273e ("tools: bpftool: add net attach command to attach XDP on interface")
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Applied & improved commit msg a bit, thanks!
