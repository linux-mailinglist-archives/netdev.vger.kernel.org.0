Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73F312529E
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 16:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbfEUOsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 10:48:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:50732 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728137AbfEUOsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 10:48:46 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hT64L-0001l9-Di; Tue, 21 May 2019 16:48:45 +0200
Received: from [178.197.249.20] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hT64L-000HV4-7T; Tue, 21 May 2019 16:48:45 +0200
Subject: Re: [PATCH] samples: bpf: fix: change the buffer size for read()
To:     Chang-Hsien Tsai <luke.tw@gmail.com>, netdev@vger.kernel.org
Cc:     ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com
References: <20190519090544.26971-1-luke.tw@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4c2f0053-9cd9-94aa-7b2b-7d458bd8127c@iogearbox.net>
Date:   Tue, 21 May 2019 16:48:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190519090544.26971-1-luke.tw@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25456/Tue May 21 09:56:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/19/2019 11:05 AM, Chang-Hsien Tsai wrote:
> If the trace for read is larger than 4096,
> the return value sz will be 4096.
> This results in off-by-one error on buf.
> 
>     static char buf[4096];
>     ssize_t sz;
> 
>     sz = read(trace_fd, buf, sizeof(buf));
>     if (sz > 0) {
>         buf[sz] = 0;
>         puts(buf);
>     }
> 
> Signed-off-by: Chang-Hsien Tsai <luke.tw@gmail.com>

Applied, thanks!
