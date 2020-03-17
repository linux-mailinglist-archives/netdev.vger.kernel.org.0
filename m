Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA7C188D8A
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 19:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgCQS70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 14:59:26 -0400
Received: from www62.your-server.de ([213.133.104.62]:60168 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgCQS7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 14:59:25 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEHQx-00024O-IJ; Tue, 17 Mar 2020 19:59:23 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEHQx-000NjW-Al; Tue, 17 Mar 2020 19:59:23 +0100
Subject: Re: [PATCH] bpf: Fix ___bpf_kretprobe_args1(x) macro definition.
To:     Wenbo Zhang <ethercflow@gmail.com>, ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200315083252.22274-1-ethercflow@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <30ad74fa-47ad-23a9-df96-bb92679af48a@iogearbox.net>
Date:   Tue, 17 Mar 2020 19:59:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200315083252.22274-1-ethercflow@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25754/Tue Mar 17 14:09:15 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/20 9:32 AM, Wenbo Zhang wrote:
> Use PT_REGS_RC instead of PT_REGS_RET to get ret currectly.
> 
> Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>

Applied & fixed typo in commit message, thanks!
