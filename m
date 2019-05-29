Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBE8D2DF38
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 16:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfE2OHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 10:07:21 -0400
Received: from www62.your-server.de ([213.133.104.62]:56414 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbfE2OHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 10:07:21 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hVzEd-0004ub-LD; Wed, 29 May 2019 16:07:19 +0200
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hVzEd-000P5g-E9; Wed, 29 May 2019 16:07:19 +0200
Subject: Re: [PATCH bpf v2] selftests: bpf: fix compiler warning
To:     Alakesh Haloi <alakesh.haloi@gmail.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Stanislav Fomichev <sdf@google.com>
References: <20190528190218.GA6950@ip-172-31-44-144.us-west-2.compute.internal>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f78082c5-6fd9-611d-0da3-969f076a97f8@iogearbox.net>
Date:   Wed, 29 May 2019 16:07:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190528190218.GA6950@ip-172-31-44-144.us-west-2.compute.internal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25464/Wed May 29 09:59:09 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/28/2019 09:02 PM, Alakesh Haloi wrote:
> Add missing header file following compiler warning
> 
> prog_tests/flow_dissector.c: In function ‘tx_tap’:
> prog_tests/flow_dissector.c:175:9: warning: implicit declaration of function ‘writev’; did you mean ‘write’? [-Wimplicit-function-declaration]
>   return writev(fd, iov, ARRAY_SIZE(iov));
>          ^~~~~~
>          write
> 
> Fixes: 0905beec9f52 ("selftests/bpf: run flow dissector tests in skb-less mode")
> Signed-off-by: Alakesh Haloi <alakesh.haloi@gmail.com>

Applied, thanks!
