Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C60C2C31A
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfE1JYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:24:43 -0400
Received: from www62.your-server.de ([213.133.104.62]:37870 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbfE1JYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 05:24:43 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hVYLZ-0007mN-Eu; Tue, 28 May 2019 11:24:41 +0200
Received: from [178.197.249.12] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hVYLZ-0005Pl-7b; Tue, 28 May 2019 11:24:41 +0200
Subject: Re: [PATCH bpf-next] bpf: check signal validity in nmi for
 bpf_send_signal() helper
To:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@fb.com>, kernel-team@fb.com
References: <20190525185753.2467090-1-yhs@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <225be034-3d54-b3e9-99e2-b5f5d4f3e0a7@iogearbox.net>
Date:   Tue, 28 May 2019 11:24:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190525185753.2467090-1-yhs@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25463/Tue May 28 09:57:22 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/25/2019 08:57 PM, Yonghong Song wrote:
> Commit 8b401f9ed244 ("bpf: implement bpf_send_signal() helper")
> introduced bpf_send_signal() helper. If the context is nmi,
> the sending signal work needs to be deferred to irq_work.
> If the signal is invalid, the error will appear in irq_work
> and it won't be propagated to user.
> 
> This patch did an early check in the helper itself to
> notify user invalid signal, as suggested by Daniel.
> 
> Signed-off-by: Yonghong Song <yhs@fb.com>

Applied, thanks!
