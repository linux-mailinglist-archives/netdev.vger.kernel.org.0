Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18261AA414
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 15:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388651AbfIENNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 09:13:51 -0400
Received: from www62.your-server.de ([213.133.104.62]:55524 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388358AbfIENNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 09:13:51 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i5ra2-0007XX-HJ; Thu, 05 Sep 2019 15:13:42 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i5ra2-000RJy-C0; Thu, 05 Sep 2019 15:13:42 +0200
Subject: Re: [PATCH bpf-next] selftests/bpf: precision tracking tests
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
References: <20190903225133.821243-1-ast@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <836b8cc2-dfdc-895b-f789-ed38ae39dc43@iogearbox.net>
Date:   Thu, 5 Sep 2019 15:13:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190903225133.821243-1-ast@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25563/Thu Sep  5 10:24:28 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/4/19 12:51 AM, Alexei Starovoitov wrote:
> Add two tests to check that stack slot marking during backtracking
> doesn't trigger 'spi > allocated_stack' warning.
> One test is using BPF_ST insn. Another is using BPF_STX.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Applied, thanks!
