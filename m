Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71ED234C965
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 10:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbhC2I3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:29:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46393 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234608AbhC2I2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 04:28:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617006527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zk0Gbd3YvZUDEfTpNPL5QSpZw7gTVP3YO60kykKGUEc=;
        b=Pr59ehd5nuIy/kBDHYNcVIKsl9csEYz9Mt58SMakUFOo5yXMesY5wCJJmEWFelHZK1dINT
        w2yj6PGoVblGsJCViVJUH4ahG3rDb64WUo7ma1TELcwLqaUcWTlldmYpby2VjbLOqR0Qyb
        2iEleEnmO5Gw69pEIofi3/7t0O8TA8A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-g7o-8gjtOxCnDdrWtD2WDA-1; Mon, 29 Mar 2021 04:28:42 -0400
X-MC-Unique: g7o-8gjtOxCnDdrWtD2WDA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 822B887A83B;
        Mon, 29 Mar 2021 08:28:40 +0000 (UTC)
Received: from krava (unknown [10.40.195.107])
        by smtp.corp.redhat.com (Postfix) with SMTP id 5401062954;
        Mon, 29 Mar 2021 08:28:37 +0000 (UTC)
Date:   Mon, 29 Mar 2021 10:28:37 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>
Subject: Re: linux-next: manual merge of the net-next tree with the bpf tree
Message-ID: <YGGPtUcstloL8sC2@krava>
References: <20210329122916.5921aad9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329122916.5921aad9@canb.auug.org.au>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 12:29:16PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got a conflict in:
> 
>   include/linux/bpf.h
> 
> between commit:
> 
>   861de02e5f3f ("bpf: Take module reference for trampoline in module")
> 
> from the bpf tree and commit:
> 
>   69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
> 
> from the net-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
> 
> -- 
> Cheers,
> Stephen Rothwell
> 
> diff --cc include/linux/bpf.h
> index fdac0534ce79,39dce9d3c3a5..000000000000
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@@ -40,7 -40,7 +40,8 @@@ struct bpf_local_storage
>   struct bpf_local_storage_map;
>   struct kobject;
>   struct mem_cgroup;
>  +struct module;
> + struct bpf_func_state;
>   
>   extern struct idr btf_idr;
>   extern spinlock_t btf_idr_lock;

ack, thanks
jirka

