Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69A1013DD80
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 15:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgAPOdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 09:33:31 -0500
Received: from www62.your-server.de ([213.133.104.62]:38724 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbgAPOdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 09:33:31 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1is6D1-0007e5-NB; Thu, 16 Jan 2020 15:33:19 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1is6D1-000CKw-C1; Thu, 16 Jan 2020 15:33:19 +0100
Subject: Re: [PATCH bpf-next] libbpf: Fix unneeded extra initialization in
 bpf_map_batch_common
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>
References: <20200116045918.75597-1-brianvv@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b2e7e80e-a738-b99e-62b9-66efcf31e6f7@iogearbox.net>
Date:   Thu, 16 Jan 2020 15:33:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200116045918.75597-1-brianvv@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25697/Thu Jan 16 12:42:45 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/20 5:59 AM, Brian Vazquez wrote:
> bpf_attr doesn't required to be declared with '= {}' as memset is used
> in the code.
> 
> Fixes: 2ab3d86ea1859 ("libbpf: Add libbpf support to batch ops")
> Reported-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>

Applied, thanks!
