Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4236245D
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 17:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403789AbfGHPmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 11:42:10 -0400
Received: from www62.your-server.de ([213.133.104.62]:45100 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388642AbfGHPZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 11:25:40 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hkVWM-0000gJ-LW; Mon, 08 Jul 2019 17:25:38 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hkVWM-0001Pw-G6; Mon, 08 Jul 2019 17:25:38 +0200
Subject: Re: [PATCH bpf-next] selftests/bpf: fix test_attach_probe map
 definition
To:     Andrii Nakryiko <andriin@fb.com>, andrii.nakryiko@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        kernel-team@fb.com
References: <20190706044420.1582763-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1ea4f7b0-258c-26d9-6d07-3df75324703a@iogearbox.net>
Date:   Mon, 8 Jul 2019 17:25:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190706044420.1582763-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25504/Mon Jul  8 10:05:57 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/06/2019 06:44 AM, Andrii Nakryiko wrote:
> ef99b02b23ef ("libbpf: capture value in BTF type info for BTF-defined map
> defs") changed BTF-defined maps syntax, while independently merged
> 1e8611bbdfc9 ("selftests/bpf: add kprobe/uprobe selftests") added new
> test using outdated syntax of maps. This patch fixes this test after
> corresponding patch sets were merged.
> 
> Fixes: ef99b02b23ef ("libbpf: capture value in BTF type info for BTF-defined map defs")
> Fixes: 1e8611bbdfc9 ("selftests/bpf: add kprobe/uprobe selftests")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
