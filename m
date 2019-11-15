Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3F6FE7BE
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 23:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfKOW1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 17:27:31 -0500
Received: from www62.your-server.de ([213.133.104.62]:50518 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbfKOW1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 17:27:30 -0500
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVk3a-0007LO-Kw; Fri, 15 Nov 2019 23:27:10 +0100
Received: from [178.197.248.45] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVk3a-0005RK-3Z; Fri, 15 Nov 2019 23:27:10 +0100
Subject: Re: [PATCH net] bpf: doc: change right arguments for JIT example code
To:     Mao Wenan <maowenan@huawei.com>, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        davem@davemloft.net, corbet@lwn.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20191114034351.162740-1-maowenan@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <25c0fbd4-29d3-f9a3-3829-2bfe45368b72@iogearbox.net>
Date:   Fri, 15 Nov 2019 23:27:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191114034351.162740-1-maowenan@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25634/Fri Nov 15 10:44:37 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/19 4:43 AM, Mao Wenan wrote:
> The example codes for JIT of x86_64, use wrong
> arguments to when call function bar().
> 
> Signed-off-by: Mao Wenan <maowenan@huawei.com>

Applied, thanks!
