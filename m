Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E86207586
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 16:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391166AbgFXOTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 10:19:16 -0400
Received: from www62.your-server.de ([213.133.104.62]:37450 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388115AbgFXOTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 10:19:15 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jo6F5-0004Nv-BL; Wed, 24 Jun 2020 16:19:11 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jo6F4-000Rp3-VY; Wed, 24 Jun 2020 16:19:10 +0200
Subject: Re: [PATCH][next] libbpf: fix spelling mistake "kallasyms" ->
 "kallsyms"
To:     Colin King <colin.king@canonical.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200623084207.149253-1-colin.king@canonical.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8049526c-3b1e-4551-8157-4a5860eee15f@iogearbox.net>
Date:   Wed, 24 Jun 2020 16:19:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200623084207.149253-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25853/Wed Jun 24 15:13:27 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/23/20 10:42 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a pr_warn message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thanks!
