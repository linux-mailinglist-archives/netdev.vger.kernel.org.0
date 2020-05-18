Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F711D7331
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 10:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgERIpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 04:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbgERIpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 04:45:39 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606C3C061A0C;
        Mon, 18 May 2020 01:45:39 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id x10so3961446plr.4;
        Mon, 18 May 2020 01:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=lXzzUAU+hsiLT32/l66VdtX5LtrIrzhbLmvU5zagp04=;
        b=iFHlVa+gUW+VW6elb9e4ZX0ruSFDV3RZtDIz+BdIVczPPjDJ8LXCq6Ons6Ljz+65Xn
         LiudbeYmUkhaBw8oJ59/Ftc9qRTi9iKf4fo0Hpmg92aLmbtb6MBClIsywW8r455dR4ms
         B4KvT6pPoYJFrSfDqI214xAbX0UTgKggfWSBGkDotsqlsfzMvZMnDuIfqVEAn7FsVGVO
         Z99CBpJghlKsMbrnqyyr/PFdPiEKVzthAYW8KhcM8VzFfA/KCqKuQSTNoAFkmh2R5IAa
         0la1RBuq9z8XbyE61K34ut2Zr7OneyEBTeSAPlxNatCc3KVp8l6P5hT3wGw7m4zOPVdG
         bTdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=lXzzUAU+hsiLT32/l66VdtX5LtrIrzhbLmvU5zagp04=;
        b=D741G6CyjNDrxi3LURmzKqTLvWCHxn+zaIjXJnLdzXofzQP006MshnDUuK5JjGeq85
         b9bRFYwpgyQa4YKj5o08ONLWafyYHCA1NVNaXzf6phSWxuCzpu0uMlfqSnlJWP9vrEMO
         0m88fPKN71kBj0H1rTcggpiHicbZK0OuSLOMQTGAWwON40FU2P/xa3h+8/g+TU5Tjjrf
         ZcUzvvHHv87fknK+kZb/hZjnkmOK96CLeNtRYnSDvda7sJ/df6gwDohKSqCwH1Gb1Mqr
         ldDa8Eipd730GWrBZ+8RQR/UL9dPIfdQU98QNIP8imPI4ygGeytrrefFYergmCoiQNkx
         TSDQ==
X-Gm-Message-State: AOAM532mnAFdWFJeFl3T0nGW22SmF1xokkjB6IGrKp1QBF5/Kl3n58f8
        1jEYHd38v7A618WbCSRnOV8=
X-Google-Smtp-Source: ABdhPJwDIOAyCFuGFAqrsMCwCKwG714GBSs+iyxlhqtfEIPw+TxTqJjTyHdCdgESX0qZL3v6+AebHw==
X-Received: by 2002:a17:902:930b:: with SMTP id bc11mr15550447plb.2.1589791538903;
        Mon, 18 May 2020 01:45:38 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h4sm7325758pfo.3.2020.05.18.01.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 01:45:38 -0700 (PDT)
Date:   Mon, 18 May 2020 16:45:27 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [RFC PATCHv2 bpf-next 1/2] xdp: add a new helper for dev map
 multicast support
Message-ID: <20200518084527.GF102436@dhcp-12-153.nay.redhat.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
 <20200424085610.10047-1-liuhangbin@gmail.com>
 <20200424085610.10047-2-liuhangbin@gmail.com>
 <87r1wd2bqu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r1wd2bqu.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Toke,

On Fri, Apr 24, 2020 at 04:34:49PM +0200, Toke Høiland-Jørgensen wrote:
> 
> Yeah, the new helper is much cleaner!
> 
> > To achive this I add a new ex_map for struct bpf_redirect_info.
> > in the helper I set tgt_value to NULL to make a difference with
> > bpf_xdp_redirect_map()
> >
> > We also add a flag *BPF_F_EXCLUDE_INGRESS* incase you don't want to
> > create a exclude map for each interface and just want to exclude the
> > ingress interface.
> >
> > The general data path is kept in net/core/filter.c. The native data
> > path is in kernel/bpf/devmap.c so we can use direct calls to
> > get better performace.
> 
> Got any performance numbers? :)

Recently I tried with pktgen to get the performance number. It works
with native mode, although the number looks not high.

I tested it on VM with 1 cpu core. By forwarding to 7 ports, With pktgen
config like:
echo "count 10000000" > /proc/net/pktgen/veth0
echo "clone_skb 0" > /proc/net/pktgen/veth0
echo "pkt_size 64" > /proc/net/pktgen/veth0
echo "dst 224.1.1.10" > /proc/net/pktgen/veth0

I got forwarding number like:
Forwarding     159958 pkt/s
Forwarding     160213 pkt/s
Forwarding     160448 pkt/s

But when testing generic mode, I got system crashed directly. The code
path is:
do_xdp_generic()
  - netif_receive_generic_xdp()
    - pskb_expand_head()    <- skb_is_nonlinear(skb)
      - BUG_ON(skb_shared(skb))

So I want to ask do you have the same issue with pktgen? Any workaround?

> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> > index 2e29a671d67e..1dbe42290223 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> 
> Updates to tools/include should generally go into a separate patch.

Is this a must to? It looks strange to separate the same implementation
into two patches.

Thanks
Hangbin
