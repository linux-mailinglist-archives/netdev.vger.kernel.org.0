Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0493F1D553B
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgEOPzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:55:35 -0400
Received: from www62.your-server.de ([213.133.104.62]:45572 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbgEOPzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 11:55:35 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZcgE-0007zK-5r; Fri, 15 May 2020 17:55:22 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZcgD-000Fod-R0; Fri, 15 May 2020 17:55:21 +0200
Subject: Re: [PATCH v7 bpf-next 0/3] Introduce CAP_BPF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        linux-security-module@vger.kernel.org, acme@redhat.com,
        jamorris@linux.microsoft.com, jannh@google.com, kpsingh@google.com
References: <20200513230355.7858-1-alexei.starovoitov@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6f56ba3e-144f-29be-c35d-0506fe16830f@iogearbox.net>
Date:   Fri, 15 May 2020 17:55:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200513230355.7858-1-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25813/Fri May 15 14:16:29 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/20 1:03 AM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> v6->v7:
> - permit SK_REUSEPORT program type under CAP_BPF as suggested by Marek Majkowski.
>    It's equivalent to SOCKET_FILTER which is unpriv.

Applied, thanks! I do like the env->{allow_ptr_leaks,bypass_spec_v1,bypass_spec_v4,
bpf_capable} split much better, so there's more clarity which belongs to which.
Potentially this can be even made more fine-grained at some point.
