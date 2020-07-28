Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C601B2307AA
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 12:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgG1KaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 06:30:00 -0400
Received: from www62.your-server.de ([213.133.104.62]:45434 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728424AbgG1K37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 06:29:59 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0Mru-0002DZ-7F; Tue, 28 Jul 2020 12:29:58 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0Mrt-000Uby-SS; Tue, 28 Jul 2020 12:29:58 +0200
Subject: Re: [PATCH bpf-next] selftests/bpf: add new bpf_iter context structs
 to fix build on old kernels
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Yonghong Song <yhs@fb.com>
References: <20200727233345.1686358-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4c14ca8a-a176-60f5-51ac-ead63447aacd@iogearbox.net>
Date:   Tue, 28 Jul 2020 12:29:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200727233345.1686358-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25886/Mon Jul 27 16:48:28 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/20 1:33 AM, Andrii Nakryiko wrote:
> Add bpf_iter__bpf_map_elem and bpf_iter__bpf_sk_storage_map to bpf_iter.h
> 
> Cc: Yonghong Song <yhs@fb.com>
> Fixes: 3b1c420bd882 ("selftests/bpf: Add a test for bpf sk_storage_map iterator")
> Fixes: 2a7c2fff7dd6 ("selftests/bpf: Add test for bpf hash map iterators")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
