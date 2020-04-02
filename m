Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0B119CD13
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 00:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390028AbgDBWvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 18:51:00 -0400
Received: from www62.your-server.de ([213.133.104.62]:35008 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387919AbgDBWvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 18:51:00 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jK8fm-0004Lw-A4; Fri, 03 Apr 2020 00:50:54 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jK8fl-000Viz-Qm; Fri, 03 Apr 2020 00:50:53 +0200
Subject: Re: [PATCH][next] bpf: Test_verifier: fix spelling mistake
 "arithmatic" -> "arithmetic"
To:     Colin King <colin.king@canonical.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200331100030.41372-1-colin.king@canonical.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <512f5aad-1031-0477-31cc-6e8342396bf5@iogearbox.net>
Date:   Fri, 3 Apr 2020 00:50:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200331100030.41372-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25770/Thu Apr  2 14:58:54 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/20 12:00 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There are a couple of spelling mistakes in two literal strings, fix them.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thanks!
