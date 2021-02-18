Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BABA531ED8D
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhBRRqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:46:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233590AbhBRQiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 11:38:21 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7132C06178A;
        Thu, 18 Feb 2021 08:36:28 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id g20so1551003plo.2;
        Thu, 18 Feb 2021 08:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=9YZ7rIwkTg0cr9K1NBvxWl16zBakNNAe5KH+Me4Ez0g=;
        b=ocXxDQi9CRB9L5lngEyoeBmXLFzDCcvpy+RjN+HSy7/ENmfhYoZEp9DUa+Yc2CCc4t
         BFG3A1G0DyXzhFb+h5JjXRcqME8r5J3YPFAITW2WA46/i+j0T5roVTyLMv6+rRR80Pk6
         n/eNqzFcL1FLC5ruKnx0rUaOu9nABMBOwMqGtC+tSiCDibReTxaPJz809RViZkwG1VQ9
         yAScaSxi4YFA+TsUdxbHYYw49U0YvcRAAukBTTvgYyax6UlD0zT3HXeGOJLLRy6qj1rG
         ZxBuUC8boazXwDk0HKu6ewI9hDzc+C0rTZHEfloHhraXhObPOw5NvmUK823UvwT0cr4F
         o8QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=9YZ7rIwkTg0cr9K1NBvxWl16zBakNNAe5KH+Me4Ez0g=;
        b=NtKjardkPzG+p90+PcY21gRpeTFVxMCbjrhyCGVXHDL5N0nbwxy3IfLR2Azq4rZXvh
         oLCKq/433YEkUnjxaS2x3RqCLCxwFdshu3XDTp3MpQk1pZyaJO7uanH8U4+Ym4cFc74n
         KfoZ+fkrsD8fmpG09BdUQrLlxD6/wZ6G8EcFKMOpFgWTlKRwAKZQ4SXhqd7mz8FsKAuj
         tRAmlCXkQUeDVZTWNOQ1z9z8vERsgN7hX59Xg1LPnw4eLYdedODG9gN9HZ3no864BXN4
         0sstArcuajyzwzGbvZZVpBpV5qj3humo5MhkHjqMGuWh7oxDuRsYlvSsJ4YH8mbCa47K
         Cfqw==
X-Gm-Message-State: AOAM533kDDqZ6o2hLSKiiwhRPMHhMtTntQldiYe55ZSVrWcjCfme95s6
        WXn1lFrwKG3MiLuJTF6pG0w=
X-Google-Smtp-Source: ABdhPJy8m6ISygrI5oodlvagJHQ0wLuOh7fOT75dZQuJUpy4FiSWhDdPY08jJ17G7oH72p25FXrNaA==
X-Received: by 2002:a17:90a:62c1:: with SMTP id k1mr4657174pjs.79.1613666188300;
        Thu, 18 Feb 2021 08:36:28 -0800 (PST)
Received: from [172.20.192.5] ([122.10.101.134])
        by smtp.gmail.com with ESMTPSA id a5sm6442110pgl.41.2021.02.18.08.36.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Feb 2021 08:36:21 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH/v2] bpf: add bpf_skb_adjust_room flag
 BPF_F_ADJ_ROOM_ENCAP_L2_ETH
From:   =?utf-8?B?6buE5a2m5qOu?= <hxseverything@gmail.com>
In-Reply-To: <29b5395f-daff-99f2-4a4b-6d462623a9fe@iogearbox.net>
Date:   Fri, 19 Feb 2021 00:35:44 +0800
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        chengzhiyong <chengzhiyong@kuaishou.com>,
        wangli <wangli09@kuaishou.com>,
        Alan Maguire <alan.maguire@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B016D7B9-A347-4105-AA03-33713FDD2427@gmail.com>
References: <20210210065925.22614-1-hxseverything@gmail.com>
 <CAF=yD-LLzAheej1upLdBOeJc9d0RUXMrL9f9+QVC-4thj1EG5Q@mail.gmail.com>
 <29b5395f-daff-99f2-4a4b-6d462623a9fe@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Daniel and Willem!

So sorry to reply to you late for I just took the Chinese Spring =
Festival vacation.

I will resubmit this patch.

Thanks again!

> 2021=E5=B9=B42=E6=9C=8811=E6=97=A5 =E4=B8=8B=E5=8D=8811:26=EF=BC=8CDanie=
l Borkmann <daniel@iogearbox.net> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 2/10/21 3:50 PM, Willem de Bruijn wrote:
>> On Wed, Feb 10, 2021 at 1:59 AM huangxuesen <hxseverything@gmail.com> =
wrote:
>>>=20
>>> From: huangxuesen <huangxuesen@kuaishou.com>
>>>=20
>>> bpf_skb_adjust_room sets the inner_protocol as skb->protocol for =
packets
>>> encapsulation. But that is not appropriate when pushing Ethernet =
header.
>>>=20
>>> Add an option to further specify encap L2 type and set the =
inner_protocol
>>> as ETH_P_TEB.
>>>=20
>>> Suggested-by: Willem de Bruijn <willemb@google.com>
>>> Signed-off-by: huangxuesen <huangxuesen@kuaishou.com>
>>> Signed-off-by: chengzhiyong <chengzhiyong@kuaishou.com>
>>> Signed-off-by: wangli <wangli09@kuaishou.com>
>> Thanks, this is exactly what I meant.
>> Acked-by: Willem de Bruijn <willemb@google.com>
>> One small point regarding Signed-off-by: It is customary to =
capitalize
>> family and given names.
>=20
> +1, huangxuesen, would be great if you could resubmit with capitalized =
names in
> your SoB as well as =46rom (both seem affected).
>=20
> Thanks,
> Daniel

