Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856A76E124E
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjDMQbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjDMQbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:31:01 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CD5AD0D
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 09:30:54 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id v10so2302807wmn.5
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 09:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1681403452; x=1683995452;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u0mDNWduF+pD0M3p/ZiM9mGoNceJzLF1dhOFZMxDI6Q=;
        b=Eu76UtDGzq5jN5Gr+fDTg2a0vH+f1Q7/2/hkPjCpJyDGLBgRdWwKLk97WEPjGn0+Wp
         4F9LImild6ICXVLfeHTTM87zMY9eoSqbKkXOugQs30xhI1q/MZeSUzcKCDa/jVVY7wL4
         2jtWDroXSfEYT+mpPXQeEo2uCo6lnHfW+fLOI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681403452; x=1683995452;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u0mDNWduF+pD0M3p/ZiM9mGoNceJzLF1dhOFZMxDI6Q=;
        b=RX36t3EIZtRO2qobfVgTe/DBc+yDdTT2XJ3ClwTvtpBS96LfjACgvCKVpDsj7dgqZq
         WAK0AnGCegn+Le4OKRUWhLhLRpki9ZzFamR70ATzoPFaiIpOjo0AH9h2p2VsnKJ2TYJV
         tzgHEowMA8pcSwK5FlZ0lwC5kuxnHhEdDR1HOEAj8ZdthR1TP5QgOKZPVf3wZcr25y6K
         9yXHNzQWSm+Y+xLF2ZSemptDkP7bISMqGtfqCZfyKSa1mRMxOK3ojnTt2RjLmyiooCzA
         fakMrIrJYE7Vv+fnxCfybsCpSzUoF6QIcy5EFPTvZ+MOFn3VzKvr+4d+Vsm1h2HiyBhI
         bUxg==
X-Gm-Message-State: AAQBX9fVrHji//oBZCwGdrfKHbRXXrIrFb1Jk+AdRpEL58motrxFYCCh
        6ew5LO2iwONbUnqL4l6EjFwl7Q==
X-Google-Smtp-Source: AKy350Yl7Q4Uwkj91CN8S9loLio+5p511yXKikW09QVx8lhRN7MjowqEoSWYsLFUc0oeWgl2cPe/pg==
X-Received: by 2002:a05:600c:2195:b0:3f0:a11f:26f7 with SMTP id e21-20020a05600c219500b003f0a11f26f7mr2299729wme.32.1681403452384;
        Thu, 13 Apr 2023 09:30:52 -0700 (PDT)
Received: from che-box ([85.88.143.70])
        by smtp.gmail.com with ESMTPSA id c8-20020a05600c0a4800b003ee5fa61f45sm5968303wmq.3.2023.04.13.09.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 09:30:51 -0700 (PDT)
Date:   Thu, 13 Apr 2023 18:31:47 +0200
From:   Christian Ehrig <cehrig@cloudflare.com>
To:     broonie@kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Gavin Li <gavinl@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the bpf-next tree with the net-next
 tree
Message-ID: <20230413163147.GA25768@cloudflare.com>
References: <20230413161235.4093777-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413161235.4093777-1-broonie@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 05:12:35PM +0100, broonie@kernel.org wrote:
> Hi all,
> 
> Today's linux-next merge of the bpf-next tree got a conflict in:
> 
>   include/net/ip_tunnels.h
> 
> between commit:
> 
>   bc9d003dc48c3 ("ip_tunnel: Preserve pointer const in ip_tunnel_info_opts")
> 
> from the net-next tree and commit:
> 
>   ac931d4cdec3d ("ipip,ip_tunnel,sit: Add FOU support for externally controlled ipip devices")
> 
> from the bpf-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
> 
> diff --cc include/net/ip_tunnels.h
> index 255b32a90850a,7912f53caae0b..0000000000000
> --- a/include/net/ip_tunnels.h
> +++ b/include/net/ip_tunnels.h
> @@@ -66,15 -73,9 +73,16 @@@ struct ip_tunnel_encap 
>   #define IP_TUNNEL_OPTS_MAX					\
>   	GENMASK((sizeof_field(struct ip_tunnel_info,		\
>   			      options_len) * BITS_PER_BYTE) - 1, 0)
>  +
>  +#define ip_tunnel_info_opts(info)				\
>  +	_Generic(info,						\
>  +		 const struct ip_tunnel_info * : ((const void *)((info) + 1)),\
>  +		 struct ip_tunnel_info * : ((void *)((info) + 1))\
>  +	)
>  +
>   struct ip_tunnel_info {
>   	struct ip_tunnel_key	key;
> + 	struct ip_tunnel_encap	encap;
>   #ifdef CONFIG_DST_CACHE
>   	struct dst_cache	dst_cache;
>   #endif

This looks good to me. Thanks much.
