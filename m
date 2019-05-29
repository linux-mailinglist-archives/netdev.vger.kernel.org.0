Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8579D2DF34
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 16:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfE2OHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 10:07:04 -0400
Received: from www62.your-server.de ([213.133.104.62]:56354 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbfE2OHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 10:07:03 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hVzED-0004sn-Qx; Wed, 29 May 2019 16:06:53 +0200
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hVzED-000L0r-KH; Wed, 29 May 2019 16:06:53 +0200
Subject: Re: [PATCH bpf-next] selftests/bpf: fix compilation error for
 flow_dissector.c
To:     Alan Maguire <alan.maguire@oracle.com>, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        davem@davemloft.net, nicolas.dichtel@6wind.com,
        ktkhai@virtuozzo.com
References: <1559123294-2027-1-git-send-email-alan.maguire@oracle.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <eafd0738-c78d-ac5e-ebd2-1f70936fc8dd@iogearbox.net>
Date:   Wed, 29 May 2019 16:06:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <1559123294-2027-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25464/Wed May 29 09:59:09 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/29/2019 11:48 AM, Alan Maguire wrote:
> When building the tools/testing/selftest/bpf subdirectory,
> (running both a local directory "make" and a
> "make -C tools/testing/selftests/bpf") I keep hitting the
> following compilation error:
> 
> prog_tests/flow_dissector.c: In function ‘create_tap’:
> prog_tests/flow_dissector.c:150:38: error: ‘IFF_NAPI’ undeclared (first
> use in this function)
>    .ifr_flags = IFF_TAP | IFF_NO_PI | IFF_NAPI | IFF_NAPI_FRAGS,
>                                       ^
> prog_tests/flow_dissector.c:150:38: note: each undeclared identifier is
> reported only once for each function it appears in
> prog_tests/flow_dissector.c:150:49: error: ‘IFF_NAPI_FRAGS’ undeclared
> 
> Adding include/uapi/linux/if_tun.h to tools/include/uapi/linux
> resolves the problem and ensures the compilation of the file
> does not depend on having up-to-date kernel headers locally.
> 
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>

Applied, thanks!
