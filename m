Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15242307EA
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 12:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbgG1KoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 06:44:01 -0400
Received: from www62.your-server.de ([213.133.104.62]:47752 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728825AbgG1KoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 06:44:00 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0N5P-0003Hy-B5; Tue, 28 Jul 2020 12:43:55 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0N5P-000Whq-0j; Tue, 28 Jul 2020 12:43:55 +0200
Subject: Re: [PATCH][next] bpf: fix swapped arguments in calls to
 check_buffer_access
To:     Yonghong Song <yhs@fb.com>, Colin King <colin.king@canonical.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200727175411.155179-1-colin.king@canonical.com>
 <c9ea156a-20fa-5415-0d35-0521e8740ddc@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <882cd37d-0af2-3412-6bd7-73aa466df23c@iogearbox.net>
Date:   Tue, 28 Jul 2020 12:43:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <c9ea156a-20fa-5415-0d35-0521e8740ddc@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25886/Mon Jul 27 16:48:28 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/20 11:39 PM, Yonghong Song wrote:
> On 7/27/20 10:54 AM, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> There are a couple of arguments of the boolean flag zero_size_allowed
>> and the char pointer buf_info when calling to function check_buffer_access
>> that are swapped by mistake. Fix these by swapping them to correct
>> the argument ordering.
>>
>> Addresses-Coverity: ("Array compared to 0")
>> Fixes: afbf21dce668 ("bpf: Support readonly/readwrite buffers in verifier")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> Thanks for the fix!
> Acked-by: Yonghong Song <yhs@fb.com>

Sigh, thanks for the fix Colin, applied! Yonghong, could you follow-up with
BPF selftest test cases that exercise these paths? Thx
