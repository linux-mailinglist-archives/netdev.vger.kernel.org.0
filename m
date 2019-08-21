Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4605297E44
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 17:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbfHUPL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 11:11:56 -0400
Received: from www62.your-server.de ([213.133.104.62]:42510 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbfHUPLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 11:11:55 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i0SH7-0003Vf-TQ; Wed, 21 Aug 2019 17:11:50 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i0SH7-000A6R-N0; Wed, 21 Aug 2019 17:11:49 +0200
Subject: Re: [PATCH] selftests: bpf: install files test_xdp_vlan.sh
To:     Anders Roxell <anders.roxell@linaro.org>, shuah@kernel.org,
        ast@kernel.org, davem@davemloft.net, jakub.kicinski@netronome.com,
        hawk@kernel.org, john.fastabend@gmail.com
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190820134121.25728-1-anders.roxell@linaro.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d612fdef-6c79-01be-2b71-f1828b3051ce@iogearbox.net>
Date:   Wed, 21 Aug 2019 17:11:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190820134121.25728-1-anders.roxell@linaro.org>
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
> When ./test_xdp_vlan_mode_generic.sh runs it complains that it can't
> find file test_xdp_vlan.sh.
> 
>   # selftests: bpf: test_xdp_vlan_mode_generic.sh
>   # ./test_xdp_vlan_mode_generic.sh: line 9: ./test_xdp_vlan.sh: No such
>   file or directory
> 
> Rework so that test_xdp_vlan.sh gets installed, added to the variable
> TEST_PROGS_EXTENDED.
> 
> Fixes: d35661fcf95d ("selftests/bpf: add wrapper scripts for test_xdp_vlan.sh")
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>

Applied, thanks!
