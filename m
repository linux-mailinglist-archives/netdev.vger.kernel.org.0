Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5E7323871
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 09:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbhBXIQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 03:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234341AbhBXIPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 03:15:35 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A848C061786
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 00:14:55 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id o1so976584ila.11
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 00:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4H5MZ6vY+TkIX8F8qNnq0Zlnqq47V/96fYqYtT7E0uc=;
        b=vdkHfkO7c2DueG9nB37esOx+NrtGfd2DEMSV0WYxUe91+C5ufv17KTYPW/xUK+GOD5
         IgEKScvw0Rz7JgVYdOGHahpj5HrtecpXM3CwdXdx+iC/rL5sl61awktUwLH+yohvL5RZ
         5fy0Fk9+QQ8gCzwu4p+pdyR4mXmhoor02T2UNzKpNFE/02FBDluKXqdSu968lYnIuUrp
         tqJhOK8riehV/ZBkWhL+sdqhPFGWM4ma5EnAOOji9eYj7JPRy+aI9HtcXfsBb4Z81yu7
         K/TK0teeoyjvRNS0twsl+FmVZffOYY4cJYgWJHp8rad28nxXuwUAj7+jw/XEXqmvcgPD
         Uo+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4H5MZ6vY+TkIX8F8qNnq0Zlnqq47V/96fYqYtT7E0uc=;
        b=CarFzRXY0rHprcRFtOYI2gLCWGX0QQlItENHm8XhRf1/inxMej7LsoFzlXZPkTNY8y
         xraHZLukYGe8r9tdiE8i2tEViIkGUBcb9m2ZZrQTYmnmFeVXsavfvGb5QDB7cZs90DKh
         V7DH3GWJf7twQHAxZjWgl05jxWFBxwloGqZS9LlivHo/mqZkHv6xqqqvR24lLEnsLrcJ
         MFrE0SIGMNs8P5y9/DbEt5y/cr3jygbOjR/Bqoz/YuSW1vXeJamjN2MLoOn+IQMq3NmB
         reId7Mg3QNNseYZ5SM7YHSbRG91L+ZmO5b5RtEFMiCm8b65thVs7vcW+8c21xH/U5iee
         6ZdQ==
X-Gm-Message-State: AOAM532DtIqFSX2s+c8M5roqNCt3HrogMZXB+qi4Zzvh8iL5RJHGmA7P
        Pw4MeKZuGiLLY7FcT/LQMrV12AUjiyslQ0fglL1SncRkPe+AGA==
X-Google-Smtp-Source: ABdhPJw/LT/ghA0tuCuRVXQeiVAXKBKBA4FewFRP/wW7zG83GgqL1zyUSz5q43AiZfM6Jnlb2ll+YLySvj9PBu1sUXY=
X-Received: by 2002:a05:6e02:d0f:: with SMTP id g15mr16080349ilj.88.1614154494743;
 Wed, 24 Feb 2021 00:14:54 -0800 (PST)
MIME-Version: 1.0
References: <63259d1978cb4a80889ccec40528ee80@skoda.cz>
In-Reply-To: <63259d1978cb4a80889ccec40528ee80@skoda.cz>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Wed, 24 Feb 2021 10:14:43 +0200
Message-ID: <CAHsH6GtF_HwevJ8gMRtkGbo+mtTb7a_1DdSODv5Ek5K=CUftKg@mail.gmail.com>
Subject: Re: High (200+) XFRM interface count performance problem (throughput)
To:     =?UTF-8?Q?Vin=C5=A1_Karel?= <karel.vins@skoda.cz>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vin=C5=A1,

On Tue, Feb 23, 2021 at 9:52 PM Vin=C5=A1 Karel <karel.vins@skoda.cz> wrote=
:
>
> Hello,
>
> I would like to ask you for help or advise.
>
> I'm testing setup with higher number of XFRM interfaces and I'm facing th=
roughput degradation with a growing number of created XFRM interfaces - not=
 concurrent tunnels established but only XFRM interfaces created - even in =
DOWN state.
> Issue is only unidirectional - from "client" to "vpn hub". Throughput for=
 traffic from hub to client is not affected.
>
> XFRM interface created with:
> for i in {1..500}; do link add ipsec$i type xfrm dev ens224 if_id $i  ; d=
one
>
> I'm testing with iperf3 with 1 client connected - from client to hub:
> 2 interfaces - 1.36 Gbps
> 100 interfaces - 1.35 Gbps
> 200 interfaces - 1.19 Gbps
> 300 interfaces - 0.98 Gbps
> 500 interfaces - 0.71 Gbps
>
> Throughput from hub to client is around 1.4 Gbps in all cases.
>
> 1 CPU core is 100%
>
> Linux v-hub 5.4.0-65-generic #73-Ubuntu SMP Mon Jan 18 17:25:17 UTC 2021 =
x86_64 x86_64 x86_64 GNU/Linux

Can you please try with a higher kernel version (>=3D 5.9)?
We've done some work to improve xfrm interface scaling
specifically e98e44562ba2
("xfrm interface: store xfrmi contexts in a hash by if_id").

Thanks,
Eyal.
