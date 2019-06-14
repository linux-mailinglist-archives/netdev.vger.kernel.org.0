Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 799BD46CDF
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 01:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfFNXXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 19:23:37 -0400
Received: from www62.your-server.de ([213.133.104.62]:41300 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbfFNXXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 19:23:36 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hbvXj-0008Jz-Lc; Sat, 15 Jun 2019 01:23:35 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hbvXj-000EAb-Gd; Sat, 15 Jun 2019 01:23:35 +0200
Subject: Re: [PATCH bpf-next 1/4] bpf: export bpf_sock for
 BPF_PROG_TYPE_CGROUP_SOCK_ADDR prog type
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, Martin Lau <kafai@fb.com>
References: <20190612173040.61944-1-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ad40512b-62dd-abfa-4239-cee8b6606260@iogearbox.net>
Date:   Sat, 15 Jun 2019 01:23:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190612173040.61944-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25480/Fri Jun 14 10:12:45 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/12/2019 07:30 PM, Stanislav Fomichev wrote:
> And let it use bpf_sk_storage_{get,delete} helpers to access socket
> storage. Kernel context (struct bpf_sock_addr_kern) already has sk
> member, so I just expose it to the BPF hooks. Using PTR_TO_SOCKET
> instead of PTR_TO_SOCK_COMMON should be safe because the hook is
> called on bind/connect.
> 
> Cc: Martin Lau <kafai@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Looks good, applied, thanks!
