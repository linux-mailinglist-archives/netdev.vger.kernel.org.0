Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4807B15863A
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 00:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbgBJXjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 18:39:55 -0500
Received: from www62.your-server.de ([213.133.104.62]:51726 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727452AbgBJXjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 18:39:55 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j1IeY-0000aS-7d; Tue, 11 Feb 2020 00:39:46 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j1IeX-0009BV-R6; Tue, 11 Feb 2020 00:39:45 +0100
Subject: Re: [PATCH bpf-next] bpf: make btf_check_func_type_match() static
To:     Hongbo Yao <yaohongbo@huawei.com>, ast@kernel.org
Cc:     chenzhou10@huawei.com, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <20200210011441.147102-1-yaohongbo@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4393e977-0801-6137-208d-f2ec15dc5ec9@iogearbox.net>
Date:   Tue, 11 Feb 2020 00:39:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200210011441.147102-1-yaohongbo@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.1/25720/Mon Feb 10 12:53:41 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/20 2:14 AM, Hongbo Yao wrote:
> Fix sparse warning:
> kernel/bpf/btf.c:4131:5: warning: symbol 'btf_check_func_type_match' was
> not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Hongbo Yao <yaohongbo@huawei.com>

Given this fixes a warning, applied to bpf.
