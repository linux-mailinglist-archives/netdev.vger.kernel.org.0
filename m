Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD12B7BD62
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 11:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfGaJig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 05:38:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38542 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726169AbfGaJif (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 05:38:35 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C76BF30C1345;
        Wed, 31 Jul 2019 09:38:35 +0000 (UTC)
Received: from carbon (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CBF95D9C5;
        Wed, 31 Jul 2019 09:38:31 +0000 (UTC)
Date:   Wed, 31 Jul 2019 11:38:29 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     brouer@redhat.com, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] tools: bpftool: add net load command to load XDP on
 interface
Message-ID: <20190731113829.6b0135e3@carbon>
In-Reply-To: <20190730184821.10833-2-danieltimlee@gmail.com>
References: <20190730184821.10833-1-danieltimlee@gmail.com>
        <20190730184821.10833-2-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 31 Jul 2019 09:38:35 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Jul 2019 03:48:20 +0900
"Daniel T. Lee" <danieltimlee@gmail.com> wrote:

> diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> index 67e99c56bc88..d3a4f18b5b95 100644
> --- a/tools/bpf/bpftool/net.c
> +++ b/tools/bpf/bpftool/net.c
> @@ -55,6 +55,35 @@ struct bpf_attach_info {
>  	__u32 flow_dissector_id;
>  };
>  
> +enum net_load_type {
> +	NET_LOAD_TYPE_XDP,
> +	NET_LOAD_TYPE_XDP_GENERIC,
> +	NET_LOAD_TYPE_XDP_DRIVE,

Why "DRIVE" ?
Why not "DRIVER" ?

> +	NET_LOAD_TYPE_XDP_OFFLOAD,
> +	__MAX_NET_LOAD_TYPE
> +};
> +
> +static const char * const load_type_strings[] = {
> +	[NET_LOAD_TYPE_XDP] = "xdp",
> +	[NET_LOAD_TYPE_XDP_GENERIC] = "xdpgeneric",
> +	[NET_LOAD_TYPE_XDP_DRIVE] = "xdpdrv",
> +	[NET_LOAD_TYPE_XDP_OFFLOAD] = "xdpoffload",
> +	[__MAX_NET_LOAD_TYPE] = NULL,
> +};



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
