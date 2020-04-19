Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716081AF686
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 06:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgDSELo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 00:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725802AbgDSELo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 00:11:44 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E7CC061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 21:11:42 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id e127so7064592iof.6
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 21:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cTefA3QXPjI0SjD9kt+0bAgqvMicSSRijslEDw/BuSo=;
        b=hE6cY02ayD1wZNGovBA++KDiNHwrQiWy8HDFmSW7OrzRTXrH4JGV78y6rI1QbPQ+1e
         dzSy3VDaxHWX/1bEyqKgm7iyu50QMy5h8UkDPaMe05d4IFsfJDOP+wal5nokQlwBx2/d
         Wi18PIZryKZJewRQkamep249dfOAhth8zHdmt4JmljpiO/ibw+cgrBp3zRRvTVe8zpts
         2cM55dTesR4Qwhf2bd7mhq0IOFMtk/SGqZWmixyZv9/pTEruUPszSixqy39oKpLUSUW9
         YIlLsLSmsVC47Oe+nWrTEzOfuK1eVUjm+Gwbs8d17BpMoVKh6olcQBzUZZOrmPnvyrJa
         okFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cTefA3QXPjI0SjD9kt+0bAgqvMicSSRijslEDw/BuSo=;
        b=PhffAfe7rPDIq6lrHbPgjsT76skNV8gdHxgQsGNTUSdWJ/FkjvQjTwXZ3GOt1YHdpd
         gO2IbjgCumFQMmkIerA3ohJHPkjjwSzOh9CB/prdGI45iWU1k2Lc1SGhpIpC2ORGEmMM
         Sz9Kndf0rLaE8QWKFu2yxms/B1/Gz0WA6hv5cKUDIaZA1HXHlWRYPMd43Tp5b+AzJJra
         1rK5lyPezhiKLHr2SMZLVZbkjSkxkJZUYGktHBu4OKBPbCe0EJgIjgsg2b09d1PjvwQB
         qlFhg1bZgP4ZSikpCPeMFWisvcXooJ3ahnqq6KEECIi2sD8JyspJatKPYOuTTpliXnWs
         ttEQ==
X-Gm-Message-State: AGi0PuZM4bQshhHD6lmW/p5Zglom1rzFhlZ+Cqs+C5WkBxdcp5U0uuUg
        BQDoi//dqA+Zc2bbWlI1AKoiIDihD5nqDSfICUE=
X-Google-Smtp-Source: APiQypJgUA6odaTfFXdQFd7OS2qnrd1W4+ogxhQ8FOljApD0p+sp133WnX9ZGMc+icDcDd6+WHPyAZgl6AsRfFTrkv4=
X-Received: by 2002:a5d:8b57:: with SMTP id c23mr10178963iot.161.1587269502065;
 Sat, 18 Apr 2020 21:11:42 -0700 (PDT)
MIME-Version: 1.0
References: <71eb2d7b-6afa-48fd-af96-140dd6ddd1e0.mao-linux@maojianwei.com>
In-Reply-To: <71eb2d7b-6afa-48fd-af96-140dd6ddd1e0.mao-linux@maojianwei.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Sat, 18 Apr 2020 21:11:30 -0700
Message-ID: <CAA93jw5N4Ok259ixYOp09s8_JWObRijEGO+in=Qp_L7cJ+dMsg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ipv6: support Application-aware IPv6
 Network (APN6)
To:     "Jianwei Mao (Mao)" <mao-linux@maojianwei.com>
Cc:     netdev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        kuznet <kuznet@ms2.inr.ac.ru>,
        yoshfuji <yoshfuji@linux-ipv6.org>, kuba <kuba@kernel.org>,
        maojianwei <maojianwei@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 8:39 PM Jianwei Mao (Mao)
<mao-linux@maojianwei.com> wrote:
>
> Hi friends,
>
> I would like to propose this new feature for you and linux networking:
> support Application-aware IPv6 Network (APN6)
> Content of my patch file is as follow. Appreciate your reviews and commen=
ts, thanks :)
>
>
> Feature: support Application-aware IPv6 Network (APN6)
>
> This feature allows application client/server set APN6 infos to sockets
> they are using to communicate to each other, by setsockopt().
>
> APN6 infos include three fields now: SLA, AppID and UserID. This APN6
> infos will be encapsulated in IPv6 Hop-by-Hop(HBH) extension header,
> as an APN6 option TLV.
>
> After that, network can provide specific performance for Apps, such as,
> low-latency for online Games, low-jitter for industrial control,
> enough-bandwidth for video conference/remote medical system, etc.

Well, it can declare that intent. As to delivering it....

> This feature is to support APN6 IETF Standard draft:
> https://datatracker.ietf.org/doc/draft-li-6man-app-aware-ipv6-network

That appears to be an expired draft. is there a replacement?

https://www.ietf.org/id/draft-li-apn6-framework-00.txt still seems current.

Where is the discussion of this taking in the ietf? 6man appears to
have nothing...

>
> We made two changes:
> 1. add IPV6_APN6 as an 'optname' for IPPROTO_IPV6 'level'.
> 2. add a function to generate IPv6 APN6 HBH header, and re-use
>     IPV6_HOPOPTS procedure to set this header to socket opt.
>
> Signed-off-by: Jianwei Mao <mao-linux@maojianwei.com>
> ---
>  include/uapi/linux/in6.h |  4 ++
>  net/ipv6/ipv6_sockglue.c | 97 +++++++++++++++++++++++++++++++++-------
>  2 files changed, 86 insertions(+), 15 deletions(-)
>
> diff --git a/include/uapi/linux/in6.h b/include/uapi/linux/in6.h
> index 9f2273a08356..6601cad58415 100644
> --- a/include/uapi/linux/in6.h
> +++ b/include/uapi/linux/in6.h
> @@ -297,4 +297,8 @@ struct in6_flowlabel_req {
>   * ...
>   * MRT6_MAX
>   */
> +
> +/* APN6: Application-aware IPv6 Network */
> +#define IPV6_APN6              81
> +
>  #endif /* _UAPI_LINUX_IN6_H */
> diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
> index debdaeba5d8c..929cbaf27c27 100644
> --- a/net/ipv6/ipv6_sockglue.c
> +++ b/net/ipv6/ipv6_sockglue.c
> @@ -136,6 +136,59 @@ static bool setsockopt_needs_rtnl(int optname)
>         return false;
>  }
>
> +#define APN6_HBH_LEN 16
> +#define APN6_HBH_HDR_LEN 4
> +#define APN6_OPTION_TYPE 0x03
> +#define APN6_OPTION_LEN (APN6_HBH_LEN - APN6_HBH_HDR_LEN)
> +#define APN6_SLA_SIZE 4
> +#define APN6_APPID_SIZE 4
> +#define APN6_USERID_SIZE 4
> +/* Return APN6 Hop-by-Hop(HBH) extension header */
> +static void *generate_apn6_hopopts(char __user *optval, unsigned int opt=
len)
> +{
> +       unsigned char *hbh;
> +       unsigned int sla, app_id, user_id;
> +
> +       if (optlen < (sizeof(unsigned int) * 3))
> +               return NULL;
> +       else if (!optval)
> +               return NULL;
> +
> +       if (get_user(sla, ((unsigned int __user *)optval)) ||
> +           get_user(app_id, ((unsigned int __user *)optval) + 1) ||
> +           get_user(user_id, ((unsigned int __user *)optval) + 2))
> +               return ERR_PTR(-EFAULT);
> +
> +       pr_info("APN6: Get info: SLA:%08X AppID:%08X UserID:%08X",
> +                   sla, app_id, user_id);
> +
> +       hbh =3D kzalloc(APN6_HBH_LEN, GFP_KERNEL);
> +       // hbh[0] is 0x0 now, and will be set natively when sending packe=
ts.
> +       hbh[1] =3D (APN6_HBH_LEN >> 3) - 1;
> +       hbh[2] =3D APN6_OPTION_TYPE;
> +       hbh[3] =3D APN6_OPTION_LEN;
> +
> +       sla =3D htonl(sla);
> +       app_id =3D htonl(app_id);
> +       user_id =3D htonl(user_id);
> +       memcpy(hbh + APN6_HBH_HDR_LEN, &sla, APN6_SLA_SIZE);
> +       memcpy(hbh + APN6_HBH_HDR_LEN + APN6_SLA_SIZE, &app_id, APN6_APPI=
D_SIZE);
> +       memcpy(hbh + APN6_HBH_HDR_LEN + APN6_SLA_SIZE + APN6_APPID_SIZE,
> +              &user_id, APN6_USERID_SIZE);
> +
> +       pr_info("APN6: Generate APN6 Hop-by-Hop extension header:\n"
> +                       "%02X %02X %02X %02X\n"
> +                       "%02X %02X %02X %02X\n"
> +                       "%02X %02X %02X %02X\n"
> +                       "%02X %02X %02X %02X",
> +                       hbh[0], hbh[1], hbh[2], hbh[3],
> +                       hbh[4], hbh[5], hbh[6], hbh[7],
> +                       hbh[8], hbh[9], hbh[10], hbh[11],
> +                       hbh[12], hbh[13], hbh[14], hbh[15]);
> +
> +       return hbh;
> +}
> +
>  static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
>                     char __user *optval, unsigned int optlen)
>  {
> @@ -400,34 +453,48 @@ static int do_ipv6_setsockopt(struct sock *sk, int =
level, int optname,
>         case IPV6_RTHDRDSTOPTS:
>         case IPV6_RTHDR:
>         case IPV6_DSTOPTS:
> +       case IPV6_APN6:
>         {
>                 struct ipv6_txoptions *opt;
>                 struct ipv6_opt_hdr *new =3D NULL;
>
>                 /* hop-by-hop / destination options are privileged option=
 */
>                 retv =3D -EPERM;
> -               if (optname !=3D IPV6_RTHDR && !ns_capable(net->user_ns, =
CAP_NET_RAW))
> +               if (optname !=3D IPV6_APN6 && optname !=3D IPV6_RTHDR &&
> +                   !ns_capable(net->user_ns, CAP_NET_RAW))
>                         break;
>
> -               /* remove any sticky options header with a zero option
> -                * length, per RFC3542.
> -                */
> -               if (optlen =3D=3D 0)
> -                       optval =3D NULL;
> -               else if (!optval)
> -                       goto e_inval;
> -               else if (optlen < sizeof(struct ipv6_opt_hdr) ||
> -                        optlen & 0x7 || optlen > 8 * 255)
> -                       goto e_inval;
> -               else {
> -                       new =3D memdup_user(optval, optlen);
> +               if (optname =3D=3D IPV6_APN6) {
> +                       new =3D generate_apn6_hopopts(optval, optlen);
>                         if (IS_ERR(new)) {
>                                 retv =3D PTR_ERR(new);
> +                               pr_warn("APN6: Fail when generate HBH, %d=
", retv);
>                                 break;
>                         }
> -                       if (unlikely(ipv6_optlen(new) > optlen)) {
> -                               kfree(new);
> +                       // next steps are same as IPV6_HOPOPTS procedure,
> +                       // so we can reuse it.
> +                       optname =3D IPV6_HOPOPTS;
> +               } else {
> +                       /* remove any sticky options header with a zero o=
ption
> +                        * length, per RFC3542.
> +                        */
> +                       if (optlen =3D=3D 0)
> +                               optval =3D NULL;
> +                       else if (!optval)
> +                               goto e_inval;
> +                       else if (optlen < sizeof(struct ipv6_opt_hdr) ||
> +                                    optlen & 0x7 || optlen > 8 * 255)
>                                 goto e_inval;
> +                       else {
> +                               new =3D memdup_user(optval, optlen);
> +                               if (IS_ERR(new)) {
> +                                       retv =3D PTR_ERR(new);
> +                                       break;
> +                               }
> +                               if (unlikely(ipv6_optlen(new) > optlen)) =
{
> +                                       kfree(new);
> +                                       goto e_inval;
> +                               }
>                         }
>                 }
>
> --
> 2.17.1



--=20
Make Music, Not War

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-435-0729
