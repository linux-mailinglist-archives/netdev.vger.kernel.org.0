Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6148997E40
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 17:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfHUPLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 11:11:22 -0400
Received: from www62.your-server.de ([213.133.104.62]:42076 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbfHUPLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 11:11:22 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i0SGe-0003Tb-3R; Wed, 21 Aug 2019 17:11:20 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i0SGd-0005Yq-TY; Wed, 21 Aug 2019 17:11:19 +0200
Subject: Re: [PATCH] selftests: bpf: add config fragment BPF_JIT
To:     Anders Roxell <anders.roxell@linaro.org>, shuah@kernel.org,
        ast@kernel.org
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190820134134.25818-1-anders.roxell@linaro.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f85f888f-053c-08b3-dad6-21088e5e19e7@iogearbox.net>
Date:   Wed, 21 Aug 2019 17:11:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190820134134.25818-1-anders.roxell@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25548/Wed Aug 21 10:27:18 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/19 3:41 PM, Anders Roxell wrote:
> When running test_kmod.sh the following shows up
> 
>   # sysctl cannot stat /proc/sys/net/core/bpf_jit_enable No such file or directory
>   cannot: stat_/proc/sys/net/core/bpf_jit_enable #
>   # sysctl cannot stat /proc/sys/net/core/bpf_jit_harden No such file or directory
>   cannot: stat_/proc/sys/net/core/bpf_jit_harden #
> 
> Rework to enable CONFIG_BPF_JIT to solve "No such file or directory"
> 
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>

Applied, thanks!
