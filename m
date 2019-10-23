Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 364AAE16EC
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 11:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391021AbfJWJ5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 05:57:22 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39898 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390545AbfJWJ5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 05:57:22 -0400
Received: by mail-ed1-f68.google.com with SMTP id l25so4029001edt.6
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 02:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/NsmOCl0y6Xsu2o/7hjfK3x4RxKT1/LHqLenfxqsBu4=;
        b=M+iC1Qnn0TshdtMKZlRUc9MwyHpOanqAsn4vIwnb0kzaLjvPhHuuUhiLQrCRWK9P4l
         hqDMurj8khv4+wIgJCCykcJIKG1+3vlczvZ2fOKKLV+GIHdTgiSKjJuLYkf28WsnvV4H
         Pw01NYEroGCPQYXskYPLxVxY+hQgYI17PkbmPD0aU3DRunvINBQMAJPMMCTTNrw6Zsj8
         BIaxRkuNbhA9CZKe6KLs5nA5dhUW1JevILfFZmu6crtPAFEV+GKL4D03im42FJbGY/+m
         RckSW7rYczSX5kAfMfvC1mIqioPokfEcvFqBWC3R1FTn9xvzotr1F9sWPYEWAuKHfwyY
         rPpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/NsmOCl0y6Xsu2o/7hjfK3x4RxKT1/LHqLenfxqsBu4=;
        b=FiOMVdGFeNaPUbAlF0yIFvxxAkq+8/fhAwH2gj1OZhR4+7FUu6k9mPIK8Et2BgDAnb
         8ZZMMJ+kK7XsVFDE79wNi3tBNpUr2w0mIBoGH0qsULkx4It2Ds36g6oHTkVzIcIa1E0W
         Gl0JbCMFg59nTeCCpGDEArnMXzImmNQHNi51hUInlcNPUsYJOOXyAqhXMN4kSmLlBb6i
         n/ToojoK4uvv8qypd+HDIZFiBf+q/x1Qnb+d+oN4/g7d0USxaMMrEN6dOGPSTlyXcV8i
         90CTigutg9UXvIfOddS8JdyFVw2uhAt/qwXys+YrkUiPVLnct88AYAXg6NPSlkrpLS5G
         WrEA==
X-Gm-Message-State: APjAAAVZOVWt9au80+cDIV96aCCsZRUjB4pfc18PBLXahE+rv+wHqC7X
        62kGrHPgUNgssDnguxWTup4IYg==
X-Google-Smtp-Source: APXvYqxOeXB5dcGaik2DpU7A8VO5NugXaB6+Iv+ZKZhAoP9s7OBGYf2kw0dFdZ407h4y+Sap+6cS0Q==
X-Received: by 2002:a17:906:254e:: with SMTP id j14mr6727439ejb.150.1571824640463;
        Wed, 23 Oct 2019 02:57:20 -0700 (PDT)
Received: from netronome.com ([62.119.166.9])
        by smtp.gmail.com with ESMTPSA id b53sm783428ede.96.2019.10.23.02.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 02:57:19 -0700 (PDT)
Date:   Wed, 23 Oct 2019 11:57:15 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller " <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] flow_dissector: add meaningful comments
Message-ID: <20191023095712.GA8732@netronome.com>
References: <20191021200948.23775-1-mcroce@redhat.com>
 <20191021200948.23775-2-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021200948.23775-2-mcroce@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 10:09:45PM +0200, Matteo Croce wrote:
> Documents two piece of code which can't be understood at a glance.
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

> ---
>  include/net/flow_dissector.h | 1 +
>  net/core/flow_dissector.c    | 6 ++++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> index 90bd210be060..7747af3cc500 100644
> --- a/include/net/flow_dissector.h
> +++ b/include/net/flow_dissector.h
> @@ -282,6 +282,7 @@ struct flow_keys {
>  	struct flow_dissector_key_vlan cvlan;
>  	struct flow_dissector_key_keyid keyid;
>  	struct flow_dissector_key_ports ports;
> +	/* 'addrs' must be the last member */
>  	struct flow_dissector_key_addrs addrs;
>  };
>  
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 7c09d87d3269..affde70dad47 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -1374,6 +1374,9 @@ static inline size_t flow_keys_hash_length(const struct flow_keys *flow)
>  {
>  	size_t diff = FLOW_KEYS_HASH_OFFSET + sizeof(flow->addrs);
>  	BUILD_BUG_ON((sizeof(*flow) - FLOW_KEYS_HASH_OFFSET) % sizeof(u32));
> +	/* flow.addrs MUST be the last member in struct flow_keys because
> +	 * different L3 protocols have different address length
> +	 */
>  	BUILD_BUG_ON(offsetof(typeof(*flow), addrs) !=
>  		     sizeof(*flow) - sizeof(flow->addrs));
>  
> @@ -1421,6 +1424,9 @@ __be32 flow_get_u32_dst(const struct flow_keys *flow)
>  }
>  EXPORT_SYMBOL(flow_get_u32_dst);
>  
> +/* Sort the source and destination IP (and the ports if the IP are the same),
> + * to have consistent hash within the two directions
> + */
>  static inline void __flow_hash_consistentify(struct flow_keys *keys)
>  {
>  	int addr_diff, i;
> -- 
> 2.21.0
> 
