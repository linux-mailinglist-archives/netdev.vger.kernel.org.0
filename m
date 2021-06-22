Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C673AFB22
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 04:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhFVClw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 22:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbhFVClv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 22:41:51 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4167C061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 19:39:35 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id i4so5954154plt.12
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 19:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=LJbKeg2n4H5jp3xLrBvXI+G7xYyTAk/XOwWWy9MQiQE=;
        b=imNm/r+UdMska8BmRASID1zV/0Iulk6pEY3yydD8qCG90dixkvFXxZBqXjH9yqe8MR
         ouiV3fYEOYCyTKXmyITh/0+DUZoRGHl8RJCbZ2gdQV10jp89o2d2ue139TB+v5wvvXG6
         UVkbJHA8tgjIRghQH6B2g1PjeBt+RbMLf5IwVEjIo9NlAq8nlYVEhe+v0HVLF0pVaO25
         /pNX3PtpsMAy+1mPLWigCe3ZtIEyPeHGH25E0lkO/4vRMbYBVJKZewkQSD4IzagwXQ3R
         Q6zmJnX8spBvh+aJN8WA7l4ZfYG2ts20CT10A3D64fTeYoQc5fxN/Z+Y63C+lrEjQPI5
         18rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=LJbKeg2n4H5jp3xLrBvXI+G7xYyTAk/XOwWWy9MQiQE=;
        b=FLxUML1UDgGJWkWeURoKhO/fsN0btRPtFeqBPVF7K2dPyR9d7/ljooWwDOmsgSFS8H
         7ppOqyqmI207dX9InezEul+YIpipH24/aqXjwUGQ+JViRQ5qQSEyYUWYiq1v4ZPEGTcM
         h4fwH5/IEV5wqRrwW3BP74RvD+Qh+1zjm8iKkF+kKy/xVDeso8u+Zj8FxoAvy0hbPaCc
         ZSRBwSPrr0bpwhs9GGXrs//jWKLwYDae3OuWYafitHK169OjSDEku9t8k/JWmyt8Ckfw
         tezFZuqxIwyr74FnL1z3hUqKgUqIXvKVimIDpMmZHWBMm188fQvuN5Bbj8TKsK5j36fZ
         HVWg==
X-Gm-Message-State: AOAM532TNjMtyLvZkSvFwuVfiESuFOwsoB9/5ap0gbAeBuBeEw5iHKPW
        1//OiALQuBZYEyZ5LENhDAs=
X-Google-Smtp-Source: ABdhPJxv7tUE0d7EEp2CzBisCh5TQk+uFAAf0cfA3q66HrSieWp2WWMQNtkvPNfFLN27bBAiXjMFZQ==
X-Received: by 2002:a17:90a:af85:: with SMTP id w5mr1415019pjq.37.1624329575067;
        Mon, 21 Jun 2021 19:39:35 -0700 (PDT)
Received: from [10.7.3.1] ([133.130.111.179])
        by smtp.gmail.com with ESMTPSA id a25sm16578649pff.54.2021.06.21.19.39.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jun 2021 19:39:34 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.6\))
Subject: Re: [PATCH] net/ipv4: swap flow ports when validating source
From:   Miao Wang <shankerwangmiao@gmail.com>
In-Reply-To: <a08932fe-789d-3b38-3d92-e00225a8cf9f@gmail.com>
Date:   Tue, 22 Jun 2021 10:39:30 +0800
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@cumulusnetworks.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <69C9F0FE-055B-4B1E-8B4B-CE9006A798BE@gmail.com>
References: <1B652E0A-2749-4B75-BC6D-2DAE2A4555A8@gmail.com>
 <a08932fe-789d-3b38-3d92-e00225a8cf9f@gmail.com>
To:     David Ahern <dsahern@gmail.com>
X-Mailer: Apple Mail (2.3608.120.23.2.6)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> 2021=E5=B9=B406=E6=9C=8822=E6=97=A5 09:23=EF=BC=8CDavid Ahern =
<dsahern@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 6/21/21 9:17 AM, Wang Shanker wrote:
>> When doing source address validation, the flowi4 struct used for
>> fib_lookup should be in the reverse direction to the given skb.
>> fl4_dport and fl4_sport returned by fib4_rules_early_flow_dissect
>> should thus be swapped.
>>=20
>> Fixes: 5a847a6 ("net/ipv4: Initialize proto and ports in flow =
struct")
>=20
> I believe the hash should be 12 chars: 5a847a6e1477
>=20
>> Signed-off-by: Miao Wang <shankerwangmiao@gmail.com>
>> ---
>> net/ipv4/fib_frontend.c | 2 ++
>> 1 file changed, 2 insertions(+)
>>=20
>> diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
>> index 84bb707bd88d..647bceab56c2 100644
>> --- a/net/ipv4/fib_frontend.c
>> +++ b/net/ipv4/fib_frontend.c
>> @@ -371,6 +371,8 @@ static int __fib_validate_source(struct sk_buff =
*skb, __be32 src, __be32 dst,
>> 		fl4.flowi4_proto =3D 0;
>> 		fl4.fl4_sport =3D 0;
>> 		fl4.fl4_dport =3D 0;
>> +	} else {
>> +		swap(fl4.fl4_sport, fl4.fl4_dport);
>> 	}
>>=20
>> 	if (fib_lookup(net, &fl4, &res, 0))
>>=20
>=20
> Reviewed-by: David Ahern <dsahern@kernel.org>

Thanks for your suggestion. I wonder if I also CC this to=20
stable?

