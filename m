Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B65529671
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 12:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390678AbfEXKzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 06:55:01 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:40265 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390410AbfEXKzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 06:55:01 -0400
Received: by mail-oi1-f195.google.com with SMTP id r136so6696612oie.7
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 03:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sePL6oru9H9JTO0+eo98nVAQmCCZoKDJOF27BKANOwE=;
        b=itgm4ui9Jo3vVjhBpeWGsUbGANhOqIT5lqnNGMkuAoF3Ea8EeWQ/dvcg42tXCAAVnx
         KPLSGOyEi7RDW3PRo6nNKRarAKUKtmQfqitszYl/vGRwq/KKGd0PrCKG67tnYYpYJTX/
         9ijeC1pFGWaYoTutZRnyY0G6t59HrYHPPfyPLZZPPqalmT5WwYxQa/Jd1yVa6sRwC5RD
         gS5Ao2lM3JApBXd7mbM9N+/HrT67x8jlHecIYs3yR/k/ZQyht74s0x0cMPjYNQ76xBbo
         w1Jloz9HoJwndpss20u+ZIy1LPnYqiM6G6INygncb6yFZXn8XEuyA4f+iSojCR7DHbt7
         4vBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sePL6oru9H9JTO0+eo98nVAQmCCZoKDJOF27BKANOwE=;
        b=MmogSodNCSAzHZOir5ylZEfOQyVFO8nmoW2sxdk/ivoId799lUP7nFgOiBl+osQb0+
         YTn9Jcd9Z/Iwc2f7WhUXgHe1HSsBEbDtTW8pQHKHwkzbYgKA1A/UKTYqh1RwNDM5/7bZ
         bTU+ls8YMrFBJ/aFVUWQ2UE2ZGYE1JXKeghzHLi9c0N7FogngsTGLhgQuz4yuU2Ys3Kw
         62sBaob5sLOk54hvzUzxHamedBobOg+8uPwSfqmEkSSyfDXF1RzRRucjjsZfWffTnF8t
         txMsSaBbnCGNKhMFrn8wpWDlmtL9S55Um1gMmm7Oww7E/H+6EJyHW+tTcyghgh/E+4C3
         Z0RA==
X-Gm-Message-State: APjAAAWjPd9tDK5nFA8skZcH/hOPiUcP+aabZLkQTsW9PnukQw2GMoKm
        KV36a7/TyYEXjf0n5Nq7B2BfRAXNV1e0fK+iJsi+sna5
X-Google-Smtp-Source: APXvYqxSiSLETd1PdnX1O5d9xHXVUJFY9F5t6GVCJ1gTx8XcYYbQUJC9N0qphtpsB+uQr9TQHNJ6e/U9i6EPOGZTET8=
X-Received: by 2002:aca:ac43:: with SMTP id v64mr5925253oie.40.1558695299980;
 Fri, 24 May 2019 03:54:59 -0700 (PDT)
MIME-Version: 1.0
References: <1557167317-50202-1-git-send-email-xiangxia.m.yue@gmail.com> <d7bd1535-c56d-5d8c-a44f-611a4fcea9b4@mellanox.com>
In-Reply-To: <d7bd1535-c56d-5d8c-a44f-611a4fcea9b4@mellanox.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Fri, 24 May 2019 18:54:23 +0800
Message-ID: <CAMDZJNVTNBypD8sMG86RqMZ2b=sxqk8NDxGDu2zv3VW8XVaPcQ@mail.gmail.com>
Subject: Re: [PATCH] net/mlx5e: Allow matching only enc_key_id/enc_dst_port
 for decapsulation action
To:     Roi Dayan <roid@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 12, 2019 at 5:08 PM Roi Dayan <roid@mellanox.com> wrote:
>
>
>
> On 06/05/2019 21:28, xiangxia.m.yue@gmail.com wrote:
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > In some case, we don't care the enc_src_ip and enc_dst_ip, and
> > if we don't match the field enc_src_ip and enc_dst_ip, we can use
> > fewer flows in hardware when revice the tunnel packets. For example,
> > the tunnel packets may be sent from different hosts, we must offload
> > one rule for each host.
> >
> >       $ tc filter add dev vxlan0 protocol ip parent ffff: prio 1 \
> >               flower dst_mac 00:11:22:33:44:00 \
> >               enc_src_ip Host0_IP enc_dst_ip 2.2.2.100 \
> >               enc_dst_port 4789 enc_key_id 100 \
> >               action tunnel_key unset action mirred egress redirect dev eth0_1
> >
> >       $ tc filter add dev vxlan0 protocol ip parent ffff: prio 1 \
> >               flower dst_mac 00:11:22:33:44:00 \
> >               enc_src_ip Host1_IP enc_dst_ip 2.2.2.100 \
> >               enc_dst_port 4789 enc_key_id 100 \
> >               action tunnel_key unset action mirred egress redirect dev eth0_1
> >
> > If we support flows which only match the enc_key_id and enc_dst_port,
> > a flow can process the packets sent to VM which (mac 00:11:22:33:44:00).
> >
> >       $ tc filter add dev vxlan0 protocol ip parent ffff: prio 1 \
> >               flower dst_mac 00:11:22:33:44:00 \
> >               enc_dst_port 4789 enc_key_id 100 \
> >               action tunnel_key unset action mirred egress redirect dev eth0_1
> >
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 27 +++++++------------------
> >  1 file changed, 7 insertions(+), 20 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > index 122f457..91e4db1 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > @@ -1339,7 +1339,6 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
> >       void *headers_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
> >                                      outer_headers);
> >       struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
> > -     struct flow_match_control enc_control;
> >       int err;
> >
> >       err = mlx5e_tc_tun_parse(filter_dev, priv, spec, f,
> > @@ -1350,9 +1349,7 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
> >               return err;
> >       }
> >
> > -     flow_rule_match_enc_control(rule, &enc_control);
> > -
> > -     if (enc_control.key->addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
> > +     if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS)) {
> >               struct flow_match_ipv4_addrs match;
> >
> >               flow_rule_match_enc_ipv4_addrs(rule, &match);
> > @@ -1372,7 +1369,7 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
> >
> >               MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, ethertype);
> >               MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype, ETH_P_IP);
> > -     } else if (enc_control.key->addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
> > +     } else if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS)) {
> >               struct flow_match_ipv6_addrs match;
> >
> >               flow_rule_match_enc_ipv6_addrs(rule, &match);
> > @@ -1504,22 +1501,12 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
> >               return -EOPNOTSUPP;
> >       }
> >
> > -     if ((flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) ||
> > -          flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID) ||
> > -          flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_PORTS)) &&
> > -         flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL)) {
> > -             struct flow_match_control match;
> > -
> > -             flow_rule_match_enc_control(rule, &match);
> > -             switch (match.key->addr_type) {
> > -             case FLOW_DISSECTOR_KEY_IPV4_ADDRS:
> > -             case FLOW_DISSECTOR_KEY_IPV6_ADDRS:
> > -                     if (parse_tunnel_attr(priv, spec, f, filter_dev, tunnel_match_level))
> > -                             return -EOPNOTSUPP;
> > -                     break;
> > -             default:
> > +     if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS) ||
> > +         flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS) ||
> > +         flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID) ||
> > +         flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_PORTS)) {
> > +             if (parse_tunnel_attr(priv, spec, f, filter_dev, tunnel_match_level))
> >                       return -EOPNOTSUPP;
> > -             }
> >
> >               /* In decap flow, header pointers should point to the inner
> >                * headers, outer header were already set by parse_tunnel_attr
> >
>
>
> Reviewed-by: Roi Dayan <roid@mellanox.com>
Hi Saeed,
this patch is ready, will be applied ?
