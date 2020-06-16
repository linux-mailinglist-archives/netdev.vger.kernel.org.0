Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD551FA4FB
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 02:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgFPATe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 20:19:34 -0400
Received: from www62.your-server.de ([213.133.104.62]:60548 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgFPATd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 20:19:33 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jkzK7-0003x8-Lk; Tue, 16 Jun 2020 02:19:31 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jkzK7-0005YW-Dt; Tue, 16 Jun 2020 02:19:31 +0200
Subject: Re: [PATCH bpf] bpf: fix definition of bpf_ringbuf_output() helper in
 UAPI comments
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200615214926.3638836-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c76c267f-a58a-c10f-6e00-90fe90f6dfb5@iogearbox.net>
Date:   Tue, 16 Jun 2020 02:19:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200615214926.3638836-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25844/Mon Jun 15 15:06:22 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/20 11:49 PM, Andrii Nakryiko wrote:
> Fix definition of bpf_ringbuf_output() in UAPI header comments, which is used
> to generate libbpf's bpf_helper_defs.h header. Return value is a number (erro
> code), not a pointer.
> 
> Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
