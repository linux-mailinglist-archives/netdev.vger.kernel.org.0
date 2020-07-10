Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D4321AF9B
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 08:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgGJGl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 02:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgGJGl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 02:41:57 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F477C08C5CE;
        Thu,  9 Jul 2020 23:41:57 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id z5so2090477pgb.6;
        Thu, 09 Jul 2020 23:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m06JBY0moWcYj2O83O8dBVgQgKUTL68mbtCuBLL/TiI=;
        b=iwialKqNmdGMpRGEEJcojvSOHa9Y49BQ2pVyuLbcWZmMyKdwXgNdLdHHG/PrITcqNX
         q10D4hxrkmVGiQOmI056klawo87vEnZRA8LlKbS0qtH09XURUxoY3Qycy/4xwoqEoYtA
         U271kFtsgE1n+IG/9EAK+3Vx7nqyhU3etlEwkbsWrO1f+PHZAc/UTHsLW2985n88AAYI
         ZMQQlvGiUJB3EIT9P39gM/JRon+yUixTDnpgvu6Bb93QyfU5dsz5J6SVmVzc03d8Xnme
         gaaE84arlQUgDJjIvnnCog/8qTgP08j2dmMbvMpNdBpPS6pZyYwefNQK856Pk/JkSSbO
         m+CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m06JBY0moWcYj2O83O8dBVgQgKUTL68mbtCuBLL/TiI=;
        b=IxIGXutTp1gjnkQi+cygCf+hcpn9yPh3ai/DPwwo859ZmFXwvzx0hdEopOQ2TMPXVH
         vS9dwVhlNqlOZIkKuNawRkcw2ecN4R2UTLBM/UIHXOveaFS2NfghkkNTmdnj3aufKE06
         59TE/pKxbJOhZdWZvixlYy5JsyZSmZMY5OPCJltlavnZzBLcQCjVWwZOJZ6mXkbqytnS
         kN0auZAV5IX6rXXeoYO+2cPKDfngMSBSynqcilzr9Ns1txmWaFTfCYBuzFrmlsH6o+qB
         JX5979OBZ1VQsIm9m/eCtgJTEJ+l9n2kHoZmWuIlAeLYKZZGHyOVA6RPatQH7H/NEjem
         aq8A==
X-Gm-Message-State: AOAM533N49bCX8IwK71fNfwKkC54rM66T808sO7NjiAZQGKh1BJNJpCJ
        oIYgj/ROcvZNs4b4UsWzSko=
X-Google-Smtp-Source: ABdhPJw4m/pjRpYpC45Jk4M9OywSqbF+WoBq94IM2Ch+KBypWIMgxhcO/nyIiwEuOGKOpOizedqgew==
X-Received: by 2002:a63:531e:: with SMTP id h30mr55201360pgb.165.1594363317006;
        Thu, 09 Jul 2020 23:41:57 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y18sm4949461pff.10.2020.07.09.23.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 23:41:56 -0700 (PDT)
Date:   Fri, 10 Jul 2020 14:41:45 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv6 bpf-next 2/3] sample/bpf: add
 xdp_redirect_map_multicast test
Message-ID: <20200710064145.GA2531@dhcp-12-153.nay.redhat.com>
References: <20200701041938.862200-1-liuhangbin@gmail.com>
 <20200709013008.3900892-1-liuhangbin@gmail.com>
 <20200709013008.3900892-3-liuhangbin@gmail.com>
 <6170ec86-9cce-a5ec-bd14-7aa56cee951e@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6170ec86-9cce-a5ec-bd14-7aa56cee951e@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 12:40:11AM +0200, Daniel Borkmann wrote:
> > +SEC("xdp_redirect_map_multi")
> > +int xdp_redirect_map_multi_prog(struct xdp_md *ctx)
> > +{
> > +	long *value;
> > +	u32 key = 0;
> > +
> > +	/* count packet in global counter */
> > +	value = bpf_map_lookup_elem(&rxcnt, &key);
> > +	if (value)
> > +		*value += 1;
> > +
> > +	return bpf_redirect_map_multi(&forward_map, &null_map,
> > +				      BPF_F_EXCLUDE_INGRESS);
> 
> Why not extending to allow use-case like ...
> 
>   return bpf_redirect_map_multi(&fwd_map, NULL, BPF_F_EXCLUDE_INGRESS);
> 
> ... instead of requiring a dummy/'null' map?
> 

I planed to let user set NULL, but the arg2_type is ARG_CONST_MAP_PTR, which
not allow NULL pointer.

Thanks
Hangbin
