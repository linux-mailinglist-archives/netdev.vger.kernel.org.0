Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CAF21A922
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgGIUiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:38:10 -0400
Received: from www62.your-server.de ([213.133.104.62]:53702 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgGIUiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 16:38:09 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jtdIr-0004e3-9w; Thu, 09 Jul 2020 22:37:57 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jtdIr-000GNM-0k; Thu, 09 Jul 2020 22:37:57 +0200
Subject: Re: [PATCH] MAINTAINERS: XDP: restrict N: and K:
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>, ast@kernel.org,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, mchehab+huawei@kernel.org,
        robh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20200709194257.26904-1-grandmaster@al2klimov.de>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d7689340-55fc-5f3f-60ee-b9c952839cab@iogearbox.net>
Date:   Thu, 9 Jul 2020 22:37:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200709194257.26904-1-grandmaster@al2klimov.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25868/Thu Jul  9 15:58:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/9/20 9:42 PM, Alexander A. Klimov wrote:
> Rationale:
> Documentation/arm/ixp4xx.rst contains "xdp" as part of "ixdp465"
> which has nothing to do with XDP.
> 
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
> ---
>   See also: https://lore.kernel.org/lkml/20200709132607.7fb42415@carbon/
> 
>   MAINTAINERS | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1d4aa7f942de..2bb7feb838af 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18708,8 +18708,8 @@ F:	include/trace/events/xdp.h
>   F:	kernel/bpf/cpumap.c
>   F:	kernel/bpf/devmap.c
>   F:	net/core/xdp.c
> -N:	xdp
> -K:	xdp
> +N:	(?:\b|_)xdp(?:\b|_)
> +K:	(?:\b|_)xdp(?:\b|_)

Please also include \W to generally match on non-alphanumeric char given you
explicitly want to avoid [a-z0-9] around the term xdp.

>   XDP SOCKETS (AF_XDP)
>   M:	Björn Töpel <bjorn.topel@intel.com>
> 

