Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9198285272
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 19:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389027AbfHGRw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 13:52:59 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34214 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387952AbfHGRw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 13:52:59 -0400
Received: by mail-pl1-f196.google.com with SMTP id i2so41929564plt.1;
        Wed, 07 Aug 2019 10:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U9jURJQ1Uv/DDXBBVFiM0Yx2vC/nTJ5FNJbf0XwSXME=;
        b=JP6n4lR/dA1+ETGt2vNBFvAISfXJKVyuZg3q4R+tYSDmwDIe7yVp/iDibgeINYmWjX
         gF2B2+GNwy+XEcrIC5cBPeQBVJiFsn9BG4vCQ/Kdf31HayvW+y15/tr0dg32mfZj/6Xc
         SLLdDO2oVu9By9/tp3SL+YwWoo2mo5G6v5rcdG3Y+9o2Xr1jvne7E0UA46pccZ13ETOZ
         nr666LA0/Hdyk+cuO6XWiqG5VEf32YgDSlaE61gqJkNsgDX4Qml+JDoAp0Rd9/7Ik2CP
         qXpRI+iqPMTsWrrM/BkZWTEZES2GgqxpZYinA3f354lpfsEV40SopQrjmY8f4/9RuPXL
         V7sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U9jURJQ1Uv/DDXBBVFiM0Yx2vC/nTJ5FNJbf0XwSXME=;
        b=IE2aIclaxRrECUZrxnqlM0QvlmJv6sx4z61940JccTRubtscibbYN/gyCgm6B8KiQf
         ucEnb0Bp1aGSo5RocsQJhYjoTmQ3z0X38nBNRmP94G2YQd1hlpGV7x9csORO7Y5npV/Z
         vhaS6JxFmUgxJzQ/xHKH6FV/XyBBxgdwO3smUCab68s/B1HVa0CWt7W6YtYUZs7aopEv
         o2jvoFE4qYJonJfpKLqTvGJrQBUKGwQN2QUB1+KWjkga67+PYpVTdKO/r2W/HOiVaCPe
         2CYC7zN2lK7/7xaPmOogUtSxrqSko6u6JZSWzal1dFzO0gLKshJ69tzJhRHJlyvzI12W
         8Q7Q==
X-Gm-Message-State: APjAAAXrE93urVma50iHp6UOt7wwh5iPU+X2qE4JacyVeU82yn1wYSGR
        dtMVYcjs2B3HGoaeS+VgAO8=
X-Google-Smtp-Source: APXvYqzHGOJHyi88ZgDd3CqnuW2dE1+GFO/h5SZwZ+XpSaRFkHKmxNboOldlrSNAhD9CACisPs+23Q==
X-Received: by 2002:a17:902:f213:: with SMTP id gn19mr9517558plb.35.1565200378479;
        Wed, 07 Aug 2019 10:52:58 -0700 (PDT)
Received: from [172.27.227.247] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id m6sm91652238pfb.151.2019.08.07.10.52.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 10:52:57 -0700 (PDT)
Subject: Re: [bpf-next PATCH 3/3] samples/bpf: xdp_fwd explain bpf_fib_lookup
 return codes
To:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     xdp-newbies@vger.kernel.org, a.s.protopopov@gmail.com
References: <156518133219.5636.728822418668658886.stgit@firesoul>
 <156518138817.5636.3626699603179533211.stgit@firesoul>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <aae3554f-2d55-d2d1-8cd8-2481ca923469@gmail.com>
Date:   Wed, 7 Aug 2019 11:52:56 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <156518138817.5636.3626699603179533211.stgit@firesoul>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/19 6:36 AM, Jesper Dangaard Brouer wrote:
> Make it clear that this XDP program depend on the network
> stack to do the ARP resolution.  This is connected with the
> BPF_FIB_LKUP_RET_NO_NEIGH return code from bpf_fib_lookup().
> 
> Another common mistake (seen via XDP-tutorial) is that users
> don't realize that sysctl net.ipv{4,6}.conf.all.forwarding
> setting is honored by bpf_fib_lookup.
> 
> Reported-by: Anton Protopopov <a.s.protopopov@gmail.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  samples/bpf/xdp_fwd_kern.c |   19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


