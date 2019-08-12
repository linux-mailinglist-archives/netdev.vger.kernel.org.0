Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCD08A2E7
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 18:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfHLQG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 12:06:27 -0400
Received: from www62.your-server.de ([213.133.104.62]:57682 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbfHLQG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 12:06:27 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hxCq1-0006iR-DJ; Mon, 12 Aug 2019 18:06:25 +0200
Received: from [178.193.45.231] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hxCq1-000TxY-7h; Mon, 12 Aug 2019 18:06:25 +0200
Subject: Re: [PATCH bpf] s390/bpf: fix lcgr instruction encoding
To:     Ilya Leoshkevich <iii@linux.ibm.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     gor@linux.ibm.com, heiko.carstens@de.ibm.com
References: <20190812150332.98109-1-iii@linux.ibm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b1b85cd7-fbf8-af4a-344a-54ffad867585@iogearbox.net>
Date:   Mon, 12 Aug 2019 18:06:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190812150332.98109-1-iii@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25539/Mon Aug 12 10:15:24 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/12/19 5:03 PM, Ilya Leoshkevich wrote:
> "masking, test in bounds 3" fails on s390, because
> BPF_ALU64_IMM(BPF_NEG, BPF_REG_2, 0) ignores the top 32 bits of
> BPF_REG_2. The reason is that JIT emits lcgfr instead of lcgr.
> The associated comment indicates that the code was intended to emit lcgr
> in the first place, it's just that the wrong opcode was used.
> 
> Fix by using the correct opcode.
> 
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>

Applied, thanks!
