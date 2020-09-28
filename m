Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFC927B6FF
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 23:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgI1V1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 17:27:39 -0400
Received: from www62.your-server.de ([213.133.104.62]:34674 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgI1V1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 17:27:38 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kN0gK-00021M-Hv; Mon, 28 Sep 2020 23:27:36 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kN0gK-000283-Bo; Mon, 28 Sep 2020 23:27:36 +0200
Subject: Re: [PATCH v6 bpf-next 0/3] enable BPF_PROG_TEST_RUN for raw_tp
To:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-team@fb.com, ast@kernel.org, john.fastabend@gmail.com,
        kpsingh@chromium.org
References: <20200925205432.1777-1-songliubraving@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <86d5e191-dd0f-d025-a68a-15b4472f0063@iogearbox.net>
Date:   Mon, 28 Sep 2020 23:27:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200925205432.1777-1-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25941/Mon Sep 28 15:55:11 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/25/20 10:54 PM, Song Liu wrote:
> This set enables BPF_PROG_TEST_RUN for raw_tracepoint type programs. This
> set also enables running the raw_tp program on a specific CPU. This feature
> can be used by user space to trigger programs that access percpu resources,
> e.g. perf_event, percpu variables.

Applied, thanks!
