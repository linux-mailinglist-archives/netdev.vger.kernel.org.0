Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0105850F5F
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbfFXO7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:59:35 -0400
Received: from www62.your-server.de ([213.133.104.62]:33298 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfFXO7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:59:34 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hfQRK-00052b-Ar; Mon, 24 Jun 2019 16:59:26 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hfQRK-000ODB-2r; Mon, 24 Jun 2019 16:59:26 +0200
Subject: Re: [PATCH bpf-next] samples: bpf: Remove bpf_debug macro in favor of
 bpf_printk
To:     Michal Rostecki <mrostecki@opensuse.org>
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190618181338.24145-1-mrostecki@opensuse.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <597ff7f0-8c35-7593-c4e5-dbfa8d0d65b2@iogearbox.net>
Date:   Mon, 24 Jun 2019 16:59:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190618181338.24145-1-mrostecki@opensuse.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25490/Mon Jun 24 10:02:14 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/18/2019 08:13 PM, Michal Rostecki wrote:
> ibumad example was implementing the bpf_debug macro which is exactly the
> same as the bpf_printk macro available in bpf_helpers.h. This change
> makes use of bpf_printk instead of bpf_debug.
> 
> Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>

Applied, thanks!
