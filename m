Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA5E6143375
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 22:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbgATVj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 16:39:28 -0500
Received: from www62.your-server.de ([213.133.104.62]:50446 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgATVj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 16:39:28 -0500
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1itelX-0006K0-5E; Mon, 20 Jan 2020 22:39:23 +0100
Received: from [178.197.248.27] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1itelW-0001HR-LT; Mon, 20 Jan 2020 22:39:22 +0100
Subject: Re: [PATCH v2 bpf-next] bpf: Fix memory leaks in generic
 update/delete batch ops
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Yonghong Song <yhs@fb.com>
References: <20200119194040.128369-1-brianvv@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <39e16779-39e8-3dd3-455e-949b6bd04de9@iogearbox.net>
Date:   Mon, 20 Jan 2020 22:39:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200119194040.128369-1-brianvv@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25701/Mon Jan 20 12:41:43 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/20 8:40 PM, Brian Vazquez wrote:
> generic update/delete batch ops functions were using __bpf_copy_key
> without properly freeing the memory. Handle the memory allocation and
> copy_from_user separately.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: aa2e93b8e58e ("bpf: Add generic support for update and delete batch ops")
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> Acked-by: Yonghong Song <yhs@fb.com>

Applied, thanks!
