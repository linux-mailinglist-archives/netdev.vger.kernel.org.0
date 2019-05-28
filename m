Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 883192C31F
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfE1J0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:26:42 -0400
Received: from www62.your-server.de ([213.133.104.62]:38192 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbfE1J0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 05:26:41 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hVYNO-0007wR-MJ; Tue, 28 May 2019 11:26:34 +0200
Received: from [178.197.249.12] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hVYNO-000NMe-EI; Tue, 28 May 2019 11:26:34 +0200
Subject: Re: [PATCH] libbpf: fix warning PTR_ERR_OR_ZERO can be used
To:     Hariprasad Kelam <hariprasad.kelam@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, xdp-newbies@vger.kernel.org
References: <20190525090257.GA12104@hari-Inspiron-1545>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a5b68a2e-b9a6-7ad4-62a0-007f815be780@iogearbox.net>
Date:   Tue, 28 May 2019 11:26:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190525090257.GA12104@hari-Inspiron-1545>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25463/Tue May 28 09:57:22 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/25/2019 11:02 AM, Hariprasad Kelam wrote:
> fix below warning reported by coccicheck
> 
> /tools/lib/bpf/libbpf.c:3461:1-3: WARNING: PTR_ERR_OR_ZERO can be used
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>

Applied, thanks!
