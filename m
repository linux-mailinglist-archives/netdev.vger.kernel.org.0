Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03F720BD06
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 01:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgFZXIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 19:08:02 -0400
Received: from www62.your-server.de ([213.133.104.62]:54272 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgFZXIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 19:08:01 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1joxRv-00018K-9Z; Sat, 27 Jun 2020 01:07:59 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1joxRv-0002GK-2P; Sat, 27 Jun 2020 01:07:59 +0200
Subject: Re: [PATCH bpf-next v2 3/4] bpftool: support
 BPF_CGROUP_INET_SOCK_RELEASE
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org
References: <20200626165231.672001-1-sdf@google.com>
 <20200626165231.672001-3-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <862111f0-b71a-0b7a-1f52-4f2fed28b8ff@iogearbox.net>
Date:   Sat, 27 Jun 2020 01:07:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200626165231.672001-3-sdf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25855/Fri Jun 26 15:19:25 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/26/20 6:52 PM, Stanislav Fomichev wrote:
> Support attaching to sock_release from the bpftool.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>   tools/bpf/bpftool/main.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
> index 5cdf0bc049bd..0a281d3cceb8 100644
> --- a/tools/bpf/bpftool/main.h
> +++ b/tools/bpf/bpftool/main.h
> @@ -92,6 +92,7 @@ static const char * const attach_type_name[__MAX_BPF_ATTACH_TYPE] = {
>   	[BPF_CGROUP_INET_INGRESS] = "ingress",
>   	[BPF_CGROUP_INET_EGRESS] = "egress",
>   	[BPF_CGROUP_INET_SOCK_CREATE] = "sock_create",
> +	[BPF_CGROUP_INET_SOCK_RELEASE] = "sock_release",
>   	[BPF_CGROUP_SOCK_OPS] = "sock_ops",
>   	[BPF_CGROUP_DEVICE] = "device",
>   	[BPF_CGROUP_INET4_BIND] = "bind4",

This one is not on latest bpf-next, needs rebase due to 16d37ee3d2b1 ("tools, bpftool: Define
attach_type_name array only once").

Thanks,
Daniel
