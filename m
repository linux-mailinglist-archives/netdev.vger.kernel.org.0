Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE3823F19E
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 19:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgHGRCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 13:02:53 -0400
Received: from www62.your-server.de ([213.133.104.62]:42398 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgHGRCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 13:02:51 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k45lZ-00060w-Q4; Fri, 07 Aug 2020 19:02:49 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k45lZ-000UTI-KH; Fri, 07 Aug 2020 19:02:49 +0200
Subject: Re: [PATCH bpf] selftests/bpf: fix silent Makefile output
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200807033058.848677-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <717ce941-5f80-dcfa-6c75-1fd230bc67a2@iogearbox.net>
Date:   Fri, 7 Aug 2020 19:02:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200807033058.848677-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25897/Fri Aug  7 14:45:59 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/20 5:30 AM, Andrii Nakryiko wrote:
> 99aacebecb75 ("selftests: do not use .ONESHELL") removed .ONESHELL, which
> changes how Makefile "silences" multi-command target recipes. selftests/bpf's
> Makefile relied (a somewhat unknowingly) on .ONESHELL behavior of silencing
> all commands within the recipe if the first command contains @ symbol.
> Removing .ONESHELL exposed this hack.
> 
> This patch fixes the issue by explicitly silencing each command with $(Q).
> 
> Also explicitly define fallback rule for building *.o from *.c, instead of
> relying on non-silent inherited rule. This was causing a non-silent output for
> bench.o object file.
> 
> Fixes: 92f7440ecc93 ("selftests/bpf: More succinct Makefile output")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Looks good, applied thanks!
