Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2913813BC21
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 10:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgAOJNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 04:13:35 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:44862 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbgAOJNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 04:13:35 -0500
Received: by mail-yb1-f194.google.com with SMTP id f136so2590100ybg.11
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 01:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XcRqeuWoIkNtgyvJChZlQKJy6Bkfi12aLypwjiX603U=;
        b=jfklyf6hOkOkf7hgbJgBZ47uUgFxJHVpkH8v1wteNlftAAOCLFGyS0nNg8V0f8Woj0
         Bc3P6YzKtLULzutBQYUvomYlrU7fXr3rN/PvTJoQbc267CvGDLnFoTjQGs/OTAVVhil6
         sQ+84J696XsNa21fCHKHgxXfDhk63uMnWR8Lo5Lgw82ema4i44IlZiBvbm9J90unAth/
         4CRSE0eCB6GWp2S7NBU2VJ0YrTjKg0HD1EdQAYCI0IRUiCD+bg8NFBnVc56oIkr98hAW
         L3tZCkFEDnZOdh09nRwYfpoSU10DiwI5vtWijEVlBvCPRzXZ21M0lZZ014TTdIqO/8s/
         hduA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XcRqeuWoIkNtgyvJChZlQKJy6Bkfi12aLypwjiX603U=;
        b=s2yRkID9/HrEflvNX1HRnx2QV3LjJ5iM31Cic5RUVxNIML8CglmR+eFv0lNqVyfvY/
         GQFkorwfiHA56eLKvX839vQFZGhlF8f6OozSTd7K7HqmI041IrKAjIa2dTD24PXH1s9e
         Zi7Nmu4S3OvabTLqwDyJDhsx9Jg3+/zSAZWsFPR7TOLTS0Yeyug4lIIUrx8GYG9h3A5i
         Ty6OJJWFloTGok/yjUluegjU0SXHA124h02qsk4/9wqPoDQgpEH7cVJgs8twqYlQD1tN
         Qm0sZ9DJZjZ1BlBPRUrlCa+GKyTls0HUnKgozoIrEQux703AQiJ9CSqJEOE74QpucQPm
         GWNg==
X-Gm-Message-State: APjAAAWdHRkq2gTIRWJ37AU8UyL2B+5h40u410Pne8A9weM8ogcLx8Gx
        l1GWkIt2DmVaB74yQ2oF6n+pv1YHtj4BEXI20Ys=
X-Google-Smtp-Source: APXvYqzxsm88/SicNWFyp7PjVnPdruk+Kvawk5wcVb2J7p+Q6nyC3KFTqTW7VLukpPDaYBFWCG8XE4rnawvGLwFywcY=
X-Received: by 2002:a5b:c0f:: with SMTP id f15mr20481310ybq.129.1579079614454;
 Wed, 15 Jan 2020 01:13:34 -0800 (PST)
MIME-Version: 1.0
References: <1578388566-27310-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1578388566-27310-1-git-send-email-wenxu@ucloud.cn>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Wed, 15 Jan 2020 11:13:23 +0200
Message-ID: <CAJ3xEMjmS=oo6xmep7seVUJ58NPpLQ_UKZH1qVWxf6w=sBBJgQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net/mlx5e: Add mlx5e_flower_parse_meta support
To:     wenxu <wenxu@ucloud.cn>
Cc:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 7, 2020 at 11:17 AM <wenxu@ucloud.cn> wrote:
> In the flowtables offload all the devices in the flowtables
> share the same flow_block. An offload rule will be installed on

"In the flowtables offload all the devices in the flowtables share the"

I am not managing to follow on this sentence. What does "devices in
the flowtables" mean?

> all the devices. This scenario is not correct.

so this is a fix and should go to net, or maybe the code you are fixing
was only introduced in net-next?

> It is no problem if there are only two devices in the flowtable,
> The rule with ingress and egress on the same device can be reject

nit: rejected

> by driver.

> But more than two devices in the flowtable will install the wrong
> rules on hardware.
>
> For example:
> Three devices in a offload flowtables: dev_a, dev_b, dev_c
>
> A rule ingress from dev_a and egress to dev_b:
> The rule will install on device dev_a.
> The rule will try to install on dev_b but failed for ingress
> and egress on the same device.
> The rule will install on dev_c. This is not correct.
>
> The flowtables offload avoid this case through restricting the ingress dev
> with FLOW_DISSECTOR_KEY_META as following patch.
> http://patchwork.ozlabs.org/patch/1218109/
>
> So the mlx5e driver also should support the FLOW_DISSECTOR_KEY_META parse.
>
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
> v2: remap the patch description
>
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 39 +++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 9b32a9c..33d1ce5 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -1805,6 +1805,40 @@ static void *get_match_headers_value(u32 flags,
>                              outer_headers);
>  }
>
> +static int mlx5e_flower_parse_meta(struct net_device *filter_dev,
> +                                  struct flow_cls_offload *f)
> +{
> +       struct flow_rule *rule = flow_cls_offload_flow_rule(f);
> +       struct netlink_ext_ack *extack = f->common.extack;
> +       struct net_device *ingress_dev;
> +       struct flow_match_meta match;
> +
> +       if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_META))
> +               return 0;
> +
> +       flow_rule_match_meta(rule, &match);
> +       if (match.mask->ingress_ifindex != 0xFFFFFFFF) {
> +               NL_SET_ERR_MSG_MOD(extack, "Unsupported ingress ifindex mask");
> +               return -EINVAL;
> +       }
> +
> +       ingress_dev = __dev_get_by_index(dev_net(filter_dev),
> +                                        match.key->ingress_ifindex);
> +       if (!ingress_dev) {
> +               NL_SET_ERR_MSG_MOD(extack,
> +                                  "Can't find the ingress port to match on");
> +               return -EINVAL;
> +       }
> +
> +       if (ingress_dev != filter_dev) {
> +               NL_SET_ERR_MSG_MOD(extack,
> +                                  "Can't match on the ingress filter port");
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
>  static int __parse_cls_flower(struct mlx5e_priv *priv,
>                               struct mlx5_flow_spec *spec,
>                               struct flow_cls_offload *f,
> @@ -1825,6 +1859,7 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
>         u16 addr_type = 0;
>         u8 ip_proto = 0;
>         u8 *match_level;
> +       int err;
>
>         match_level = outer_match_level;
>
> @@ -1868,6 +1903,10 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
>                                                     spec);
>         }
>
> +       err = mlx5e_flower_parse_meta(filter_dev, f);
> +       if (err)
> +               return err;
> +
>         if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
>                 struct flow_match_basic match;
>
> --
> 1.8.3.1
>
