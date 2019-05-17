Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44EBD2181A
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 14:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbfEQMXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 08:23:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:47244 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbfEQMXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 08:23:47 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hRbtj-0005wW-D0; Fri, 17 May 2019 14:23:39 +0200
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hRbtj-0005Js-7a; Fri, 17 May 2019 14:23:39 +0200
Subject: Re: [PATCH bpf] selftests/bpf: fix bpf_get_current_task
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
References: <20190517043411.3796806-1-ast@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2d6d95a9-fccf-4c7a-2a68-247b4df1c55f@iogearbox.net>
Date:   Fri, 17 May 2019 14:23:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190517043411.3796806-1-ast@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25452/Fri May 17 09:57:24 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/17/2019 06:34 AM, Alexei Starovoitov wrote:
> Fix bpf_get_current_task() declaration.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Applied, thanks!
