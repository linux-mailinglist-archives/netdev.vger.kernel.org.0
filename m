Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8B834E13F
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 08:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhC3G3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 02:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbhC3G3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 02:29:22 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E600CC061762
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 23:29:21 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id bf3so16830769edb.6
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 23:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sQGvvLvGhJryVBI/vkiRB5LM46pTjwaFh+4cVwI4fVI=;
        b=rZf2mAWnBbaEaI7PkCCkZSINB1Q1L5hwIlCHuf5I2KqktkdL3H8PmWleG2kwl1QpP0
         BazHGZ8F24uFOhQeyOD8G6AYV4hEyGJowyuKyLYCOrqh1RMg+YNwNu+X2zdpnp5xvshp
         fFRjrX0+Ub6B2Jxd+DVDtM+TtkgdilntYwJLzd9+p3aUo8zJ64lnPhpMs8pzeXEUerwt
         p0YvHb99LcmPULzLt89yoVCr6LA59R2mtAtEGxGJhFaTd4GkubyHIDKGINWeXmNKUp+y
         FIU0D1UIpPnDMGL/yDbVsXatq4ZRt0kccKMvsFx054gqqPAlhpQB80o1+xXe0yyiljqf
         zqeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sQGvvLvGhJryVBI/vkiRB5LM46pTjwaFh+4cVwI4fVI=;
        b=eAXT7r6tJHeHLBVAigLdovGAaBvbC3Z/HYBBvsrC3RHwZNF6gd4rqUNn3w0pznm21k
         +OxTBE2jeA60qY9mG+hi7s9J7zyH9NLbhY8TLejug5tNbeBITi/7dUD96ttYOyL1JML9
         S3Rp9YmWRk92M4DxnloT3XXEqqjKwQ08y2mQ3p0fy76e4Z5V6CnGShiOk5H5aRa0Ze7v
         I0CmIGma0ZLdO/FNzlwDdt9YpdBQVWycUDLza/vbWTdw5in5+sz+8ZWzcTRIM4T1ua3h
         EDTa52v0KCJDDgKnaT04bITt8GVQnryxgsY/Yrpek4XMG09P1VmxLzMAeUhNka78/Fvu
         Sgqg==
X-Gm-Message-State: AOAM53334UI5w9E7vIuYh7eolRY/ncoX8fWknIAfCJ0jg51HB/HfL8rB
        PUnVmsKAwAiktZUCwB5I2KkcKhrju7HMlPdXoLk=
X-Google-Smtp-Source: ABdhPJxz7BCIcTdstF8dzb0Fl9Ic1lWhJDscHjtp0YGa+uKE3VrJgJKT0e80U21i9MC2/EHKgnEmRSxMjuEI8CO7maA=
X-Received: by 2002:aa7:ce1a:: with SMTP id d26mr31857890edv.206.1617085760755;
 Mon, 29 Mar 2021 23:29:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAOJPZgnLjr6VHvtv9NnemxFagvL-k1wrRsB1f1Pq+9qbtPWw0g@mail.gmail.com>
 <0a6894be727b1bb2124bff19a419972f589b4d7e.camel@kernel.org>
In-Reply-To: <0a6894be727b1bb2124bff19a419972f589b4d7e.camel@kernel.org>
From:   =?UTF-8?B?6auY6ZKn5rWp?= <gaojunhao0504@gmail.com>
Date:   Tue, 30 Mar 2021 14:29:09 +0800
Message-ID: <CAOJPZgk8A7cbRA1KGC7Vm9wDrsHm9q5oRQ4UYWdJr5LFY-hmRg@mail.gmail.com>
Subject: Re: ESP RSS support for NVIDIA Mellanox ConnectX-6 Ethernet Adapter Cards
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     borisp@nvidia.com, netdev@vger.kernel.org, seven.wen@ucloud.cn,
        junhao.gao@ucloud.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Saeed Mahameed <saeed@kernel.org> =E4=BA=8E2021=E5=B9=B43=E6=9C=8830=E6=97=
=A5=E5=91=A8=E4=BA=8C =E4=B8=8A=E5=8D=884:56=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, 2021-03-29 at 12:33 +0800, =E9=AB=98=E9=92=A7=E6=B5=A9 wrote:
> > Hi borisp, saeedm
> >
> >      I have seen mlx5 driver in 5.12.0-rc4 kernel, then find that
> > mlx5e_set_rss_hash_opt only support tcp4/udp4/tcp6/udp6. So mlx5
> > kernel driver doesn't support esp4 rss? Then do you have any plan to
> > support esp4 or other latest mlx5 driver have supported esp4? Then
> > does NVIDIA Mellanox ConnectX-6 Ethernet Adapter Cards support esp4
> > rss in hardware?
> >
>
> Hi Juhano
>
> we do support RSS ESP out of the box on the SPI, src and dst IP fields
>
Hi Saeed

we verified RSS ESP and it is hashed by the SPI, src and dst IP field.
Then in our test, we run ipsec offload in tunnel mode using ESP
protocol, when packets arrive CX-6, the content in packets is
plaintext, and there exist many TCP/UDP flows in one tunnel, so could
we do RSS based on inner src/dst IP field and port etc?
> #define MLX5_HASH_IP_IPSEC_SPI  (MLX5_HASH_FIELD_SEL_SRC_IP   |\
>                                  MLX5_HASH_FIELD_SEL_DST_IP   |\
>                                  MLX5_HASH_FIELD_SEL_IPSEC_SPI)
>
> [MLX5E_TT_IPV4_IPSEC_ESP] =3D { .l3_prot_type =3D MLX5_L3_PROT_TYPE_IPV4,
>                               .l4_prot_type =3D 0,
>                               .rx_hash_fields =3D
> MLX5_HASH_IP_IPSEC_SPI,
> },
>
> [MLX5E_TT_IPV6_IPSEC_ESP] =3D { .l3_prot_type =3D MLX5_L3_PROT_TYPE_IPV6,
>                               .l4_prot_type =3D 0,
>                               .rx_hash_fields =3D
> MLX5_HASH_IP_IPSEC_SPI,
> },
>
> But we don't allow rss_hash_opt at the moment.
>
> what exactly are you looking for ?
>
> > static int mlx5e_set_rss_hash_opt(struct mlx5e_priv *priv,
> >                  struct ethtool_rxnfc *nfc)
> > {
> >     int inlen =3D MLX5_ST_SZ_BYTES(modify_tir_in);
> >     enum mlx5e_traffic_types tt;
> >     u8 rx_hash_field =3D 0;
> >     void *in;
> >     tt =3D flow_type_to_traffic_type(nfc->flow_type);
> >     if (tt =3D=3D MLX5E_NUM_INDIR_TIRS)
> >         return -EINVAL;
> >     /* RSS does not support anything other than hashing to queues
> >      * on src IP, dest IP, TCP/UDP src port and TCP/UDP dest
> >      * port.
> >      */
> >     if (nfc->flow_type !=3D TCP_V4_FLOW &&
> >       nfc->flow_type !=3D TCP_V6_FLOW &&
> >       nfc->flow_type !=3D UDP_V4_FLOW &&
> >       nfc->flow_type !=3D UDP_V6_FLOW)
> >         return -EOPNOTSUPP;
> >
> > Best Regards,
> > Junhao
>
>
