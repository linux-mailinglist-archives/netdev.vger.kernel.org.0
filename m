Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A428F222B64
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 21:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgGPTCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 15:02:30 -0400
Received: from www62.your-server.de ([213.133.104.62]:36450 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbgGPTC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 15:02:29 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jw99D-0007pK-MD; Thu, 16 Jul 2020 21:02:23 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jw99D-000NPL-Dl; Thu, 16 Jul 2020 21:02:23 +0200
Subject: Re: [PATCH] Revert "test_bpf: flag tests that cannot be jited on
 s390"
To:     Seth Forshee <seth.forshee@canonical.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200716143931.330122-1-seth.forshee@canonical.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <daba54b3-e2c8-645c-76a6-cc6524ec0c96@iogearbox.net>
Date:   Thu, 16 Jul 2020 21:02:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200716143931.330122-1-seth.forshee@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25875/Thu Jul 16 16:46:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/20 4:39 PM, Seth Forshee wrote:
> This reverts commit 3203c9010060806ff88c9989aeab4dc8d9a474dc.
> 
> The s390 bpf JIT previously had a restriction on the maximum
> program size, which required some tests in test_bpf to be flagged
> as expected failures. The program size limitation has been removed,
> and the tests now pass, so these tests should no longer be flagged.
> 
> Fixes: d1242b10ff03 ("s390/bpf: Remove JITed image size limitations")
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Applied, thanks!
