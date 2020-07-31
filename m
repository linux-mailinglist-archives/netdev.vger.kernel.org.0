Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE653234911
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 18:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731140AbgGaQT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 12:19:28 -0400
Received: from www62.your-server.de ([213.133.104.62]:34522 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbgGaQT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 12:19:27 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k1XkY-0002nW-6m; Fri, 31 Jul 2020 18:19:14 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k1XkX-0001k5-8D; Fri, 31 Jul 2020 18:19:13 +0200
Subject: Re: [PATCH bpf-next v3] Documentation/bpf: Use valid and new links in
 index.rst
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Tobin C. Harding" <me@tobin.cc>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1596184142-18476-1-git-send-email-yangtiezhu@loongson.cn>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4217b24b-f33f-52f2-908a-25291e26c65a@iogearbox.net>
Date:   Fri, 31 Jul 2020 18:19:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1596184142-18476-1-git-send-email-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25890/Fri Jul 31 17:04:57 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/31/20 10:29 AM, Tiezhu Yang wrote:
> There exists an error "404 Not Found" when I click the html link of
> "Documentation/networking/filter.rst" in the BPF documentation [1],
> fix it.
> 
> Additionally, use the new links about "BPF and XDP Reference Guide"
> and "bpf(2)" to avoid redirects.
> 
> [1] https://www.kernel.org/doc/html/latest/bpf/
> 
> Fixes: d9b9170a2653 ("docs: bpf: Rename README.rst to index.rst")
> Fixes: cb3f0d56e153 ("docs: networking: convert filter.txt to ReST")
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>

That looks better, applied, thanks!
