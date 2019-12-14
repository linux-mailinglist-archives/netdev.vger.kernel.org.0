Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B80D111F3AE
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 20:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfLNTZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 14:25:45 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34169 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfLNTZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 14:25:45 -0500
Received: by mail-ed1-f68.google.com with SMTP id l8so1896342edw.1
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 11:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kDLf18D7Y+hYCQsCEctw8t60yTd0uKstHWb2k9BZDvQ=;
        b=po4MTv0/6lFSeGiRTpj9mBv4rIr0zKH7G5v5iuErPFNYFYgf04Feh00r78jQUO5TBK
         HGXnI1amMp47VuK9XkI2PVjO/JMMfF9FWh0AuGyB2uW3KQkrqqV08LAEQyxXWvwv4J7o
         na4cHLNy8IfinFdWDsxmVWqyOKOYjl7yj0gGSo4sb7+IJfSHKtUbjXll3J487Yy7/agI
         begDcxLnULfyxGtXY64lFKlzo1BTZWraice0SV2E+FztEQGBo+ZtscjyP43oUhCb737A
         GVH7lDSebjIzIlw4wOiTrYNKsYJbdWyS6NvJS3iogmmKBXoIsHr+hUooyw2w32pgGWa8
         q66A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kDLf18D7Y+hYCQsCEctw8t60yTd0uKstHWb2k9BZDvQ=;
        b=R1hl5kE9XjB1zCU77R+6uZLausLSpNd4nXk9aGyYTw/+xH9+QwfQ0KCjdqPLfYEqL5
         myvJioRuKZ8AXS2sSE6A1sZAVDiJS5Vw6XuOXU3qjNvYd3Sosg8dmOHHNPeJkQAOms5H
         xNgrmCZ6Kb0ICk89noPXyhg7JJQhMLE0bbNBdlSFmsB1LtQXk4AEIvKSGyYd83O5DUIM
         dwtGvpLrdGW66agGyRtEDA3x4fBwGp6ZxUkZD6gY4DHaTiPHyjmJhyeLKpS4lV4Skiox
         +grDtEj/XUjhZc11m/lTANlETQ25MR2dUCOAr0Xz7mtVol230adpZdA5iD5WwAC/PEGB
         bOMQ==
X-Gm-Message-State: APjAAAWYBzI+s7EYSS9rQViEqRMwKm8edDC7+BrATR181eSk9SmNBz4M
        r9KEOzvB/f+FaJlrNqHRpWcuw34nivydlXA/yT/ksw==
X-Google-Smtp-Source: APXvYqyplSw0oqxW8bHqsnI8l709niEB9lJ0HcYIrSppxtrkQ7V5luEOzkveovLNN9TAnB7r6Embf34SbdFygIzVUFs=
X-Received: by 2002:a17:906:a444:: with SMTP id cb4mr24806941ejb.42.1576351542945;
 Sat, 14 Dec 2019 11:25:42 -0800 (PST)
MIME-Version: 1.0
References: <1570139884-20183-1-git-send-email-tom@herbertland.com>
 <1570139884-20183-7-git-send-email-tom@herbertland.com> <20191007123943.blsqqr3my4jmklqy@netronome.com>
In-Reply-To: <20191007123943.blsqqr3my4jmklqy@netronome.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Sat, 14 Dec 2019 11:25:31 -0800
Message-ID: <CALx6S35OeP4nR+AB2Pujamcork3WVz3KyZi4qSGKfL5CXkMj6w@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 6/7] ip6tlvs: Add netlink interface
To:     Simon Horman <simon.horman@netronome.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Tom Herbert <tom@quantonium.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 7, 2019 at 5:39 AM Simon Horman <simon.horman@netronome.com> wrote:
>
> On Thu, Oct 03, 2019 at 02:58:03PM -0700, Tom Herbert wrote:
> > From: Tom Herbert <tom@quantonium.net>
> >
> > Add a netlink interface to manage the TX TLV parameters. Managed
> > parameters include those for validating and sending TLVs being sent
> > such as alignment, TLV ordering, length limits, etc.
> >
> > Signed-off-by: Tom Herbert <tom@herbertland.com>
>
> Hi Tom,
>
> I am wondering if you considered including extack support in this code.
>
Good point, will look into adding it.

> ...
>
> > diff --git a/include/uapi/linux/ipeh.h b/include/uapi/linux/ipeh.h
> > index dbf0728..bac36a7 100644
> > --- a/include/uapi/linux/ipeh.h
> > +++ b/include/uapi/linux/ipeh.h
> > @@ -21,4 +21,33 @@ enum {
> >       IPEH_TLV_PERM_MAX = IPEH_TLV_PERM_NO_CHECK
> >  };
> >
> > +/* NETLINK_GENERIC related info for IP TLVs */
> > +
> > +enum {
> > +     IPEH_TLV_ATTR_UNSPEC,
> > +     IPEH_TLV_ATTR_TYPE,                     /* u8, > 1 */
> > +     IPEH_TLV_ATTR_ORDER,                    /* u16 */
> > +     IPEH_TLV_ATTR_ADMIN_PERM,               /* u8, perm value */
> > +     IPEH_TLV_ATTR_USER_PERM,                /* u8, perm value */
>
> My reading of struct tlv_tx_params is that admin_perm and user_perm are
> 2-bit entities whose valid values are currently 0, 1 and 2. Perhaps that
> would be worth noting here in keeping with restrictions noted for other
> attributes.
>
Okay.

> > +     IPEH_TLV_ATTR_CLASS,                    /* u8, 3 bit flags */
> > +     IPEH_TLV_ATTR_ALIGN_MULT,               /* u8, 1 to 16 */
> > +     IPEH_TLV_ATTR_ALIGN_OFF,                /* u8, 0 to 15 */
> > +     IPEH_TLV_ATTR_MIN_DATA_LEN,             /* u8 (option data length) */
> > +     IPEH_TLV_ATTR_MAX_DATA_LEN,             /* u8 (option data length) */
> > +     IPEH_TLV_ATTR_DATA_LEN_MULT,            /* u8, 1 to 16 */
> > +     IPEH_TLV_ATTR_DATA_LEN_OFF,             /* u8, 0 to 15 */
> > +
> > +     __IPEH_TLV_ATTR_MAX,
> > +};
> > +
> > +#define IPEH_TLV_ATTR_MAX              (__IPEH_TLV_ATTR_MAX - 1)
>
> ...
>
> > diff --git a/net/ipv6/exthdrs_common.c b/net/ipv6/exthdrs_common.c
> > index feaa4a6..e3c1f33 100644
> > --- a/net/ipv6/exthdrs_common.c
> > +++ b/net/ipv6/exthdrs_common.c
> > @@ -454,6 +454,244 @@ int __ipeh_tlv_unset(struct tlv_param_table *tlv_param_table,
>
> ...
>
> > +int ipeh_tlv_nl_cmd_set(struct tlv_param_table *tlv_param_table,
> > +                     struct genl_family *tlv_nl_family,
> > +                     struct sk_buff *skb, struct genl_info *info)
> > +{
> > +     struct tlv_params new_params;
> > +     struct tlv_proc *tproc;
> > +     unsigned char type;
> > +     unsigned int v;
> > +     int retv = -EINVAL;
> > +
> > +     if (!info->attrs[IPEH_TLV_ATTR_TYPE])
> > +             return -EINVAL;
> > +
> > +     type = nla_get_u8(info->attrs[IPEH_TLV_ATTR_TYPE]);
> > +     if (type < 2)
> > +             return -EINVAL;
> > +
> > +     rcu_read_lock();
> > +
> > +     /* Base new parameters on existing ones */
> > +     tproc = ipeh_tlv_get_proc_by_type(tlv_param_table, type);
> > +     new_params = tproc->params;
> > +
> > +     if (info->attrs[IPEH_TLV_ATTR_ORDER]) {
> > +             v = nla_get_u16(info->attrs[IPEH_TLV_ATTR_ORDER]);
> > +             new_params.t.preferred_order = v;
> > +     }
> > +
> > +     if (info->attrs[IPEH_TLV_ATTR_ADMIN_PERM]) {
> > +             v = nla_get_u8(info->attrs[IPEH_TLV_ATTR_ADMIN_PERM]);
> > +             if (v > IPEH_TLV_PERM_MAX)
> > +                     goto out;
> > +             new_params.t.admin_perm = v;
> > +     }
> > +
> > +     if (info->attrs[IPEH_TLV_ATTR_USER_PERM]) {
> > +             v = nla_get_u8(info->attrs[IPEH_TLV_ATTR_USER_PERM]);
> > +             if (v > IPEH_TLV_PERM_MAX)
> > +                     goto out;
> > +             new_params.t.user_perm = v;
> > +     }
> > +
> > +     if (info->attrs[IPEH_TLV_ATTR_CLASS]) {
> > +             v = nla_get_u8(info->attrs[IPEH_TLV_ATTR_CLASS]);
> > +             if (!v || (v & ~IPEH_TLV_CLASS_FLAG_MASK))
> > +                     goto out;
> > +             new_params.t.class = v;
> > +     }
> > +
> > +     if (info->attrs[IPEH_TLV_ATTR_ALIGN_MULT]) {
> > +             v = nla_get_u8(info->attrs[IPEH_TLV_ATTR_ALIGN_MULT]);
> > +             if (v > 16 || v < 1)
> > +                     goto out;
> > +             new_params.t.align_mult = v - 1;
> > +     }
> > +
> > +     if (info->attrs[IPEH_TLV_ATTR_ALIGN_OFF]) {
> > +             v = nla_get_u8(info->attrs[IPEH_TLV_ATTR_ALIGN_OFF]);
> > +             if (v > 15)
> > +                     goto out;
> > +             new_params.t.align_off = v;
> > +     }
> > +
> > +     if (info->attrs[IPEH_TLV_ATTR_MAX_DATA_LEN])
> > +             new_params.t.max_data_len =
> > +                 nla_get_u8(info->attrs[IPEH_TLV_ATTR_MAX_DATA_LEN]);
> > +
> > +     if (info->attrs[IPEH_TLV_ATTR_MIN_DATA_LEN])
> > +             new_params.t.min_data_len =
> > +                 nla_get_u8(info->attrs[IPEH_TLV_ATTR_MIN_DATA_LEN]);
> > +
> > +     if (info->attrs[IPEH_TLV_ATTR_DATA_LEN_MULT]) {
> > +             v = nla_get_u8(info->attrs[IPEH_TLV_ATTR_DATA_LEN_MULT]);
> > +             if (v > 16 || v < 1)
> > +                     goto out;
> > +             new_params.t.data_len_mult = v - 1;
> > +     }
>
> Is some sanity checking warranted for the min/max data len values.
> f.e. that min <= max ?

Okay, will add.

>
> > +
> > +     if (info->attrs[IPEH_TLV_ATTR_DATA_LEN_OFF]) {
> > +             v = nla_get_u8(info->attrs[IPEH_TLV_ATTR_DATA_LEN_OFF]);
> > +             if (v > 15)
> > +                     goto out;
> > +             new_params.t.data_len_off = v;
> > +     }
> > +
> > +     retv = ipeh_tlv_set_params(tlv_param_table, type, &new_params);
> > +
> > +out:
> > +     rcu_read_unlock();
> > +     return retv;
> > +}
> > +EXPORT_SYMBOL(ipeh_tlv_nl_cmd_set);
>
> ...
