Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A482BF8257
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 22:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfKKVhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 16:37:01 -0500
Received: from www62.your-server.de ([213.133.104.62]:54922 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfKKVhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 16:37:01 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iUHMf-0001Ar-Nt; Mon, 11 Nov 2019 22:36:49 +0100
Received: from [178.197.248.27] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iUHMf-000UDU-8u; Mon, 11 Nov 2019 22:36:49 +0100
Subject: Re: [PATCH] selftests: bpf: add missing object file to TEST_FILES
To:     Anders Roxell <anders.roxell@linaro.org>, ast@kernel.org,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuah@kernel.org, songliubraving@fb.com, simon.horman@netronome.com
References: <20191111161728.8854-1-anders.roxell@linaro.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <17957196-a9a3-e7d5-c881-a240d33e0a82@iogearbox.net>
Date:   Mon, 11 Nov 2019 22:36:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191111161728.8854-1-anders.roxell@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25630/Mon Nov 11 10:59:49 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/19 5:17 PM, Anders Roxell wrote:
> When installing kselftests to its own directory and run the
> test_lwt_ip_encap.sh it will complain that test_lwt_ip_encap.o can't be
> found. Same with the test_tc_edt.sh test it will complain that
> test_tc_edt.o can't be found.
> 
> $ ./test_lwt_ip_encap.sh
> starting egress IPv4 encap test
> Error opening object test_lwt_ip_encap.o: No such file or directory
> Object hashing failed!
> Cannot initialize ELF context!
> Failed to parse eBPF program: Invalid argument
> 
> Rework to add test_lwt_ip_encap.o and test_tc_edt.o to TEST_FILES so the
> object file gets installed when installing kselftest.
> 
> Fixes: 74b5a5968fe8 ("selftests/bpf: Replace test_progs and test_maps w/ general rule")
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> Acked-by: Song Liu <songliubraving@fb.com>

Applied, thanks!
