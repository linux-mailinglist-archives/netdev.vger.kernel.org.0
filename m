Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1512E22438
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 19:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfERRS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 13:18:57 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42462 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbfERRS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 13:18:57 -0400
Received: by mail-pl1-f193.google.com with SMTP id x15so4762871pln.9
        for <netdev@vger.kernel.org>; Sat, 18 May 2019 10:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=lInakaH9QIJV2qyTcHK9vy8+So0EobhrfMkTeL58g00=;
        b=qtHSZPLPznbImALkmN2FBZIz4O+T+RKgAdwpltbsjoobbCkfcB1Jl/6+7Tstsc8l+d
         8dxP1VvUIDh45pvv2DeQU+UudRkBSaWmD3IQsH14wPR96NikKq7qdM050+jIbYJyXem9
         F7P/23llmD/DuTFm2v2rz+9ZCdKiB23WQD8AfCIldtIfwR5CoCyKxhOyDQQ+J/enFadU
         KJr7wa2iU8sysixF9jjLSF4I05eZAtCeeJ876hMXIo1In87zvb10xbxm1c4BprhxscR+
         n7LJB6RmeaMqfKX/1F9ahBC1WeItsr/DpOZlDtgGIPk5TFhhJjUU4r8h+t9GF9OFEIw/
         1cag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=lInakaH9QIJV2qyTcHK9vy8+So0EobhrfMkTeL58g00=;
        b=mveu6wYUvn9iWYPMYiNVgNvvwMhZSETkcS75j4yh3C/q42Vf7/0kqtRttu9PVI6bUD
         wMKFt+sAhMBq2wzkDffc2uAkVy5PLnWtW+NAx8HgH/hPvvt1Zp+4a6H2KTNChy3iqYEU
         PxwsGWU0JqbYqZMQHBSE/I/Wjm/7tkmxsWAZQmtrSaBeZ2J2Lw4WSlds7pjo10gELg1o
         D0QttkoFZZDwdxrU0SvdFnduSGOjBTe0bkBxUuO/+PdTmrRamk0acKgxXoRaz7qc9KEg
         CeGnn4Jva16/dXDjHY7XkCPxKgF6QakJerYM/WwPp5+iSbtSQWxFF5ceIVNpTLCY7mFW
         mTjQ==
X-Gm-Message-State: APjAAAUAUGkHdx/1T8k4ZmyGRdRxHg3NQc1XqitwquDW//jyP8pnpBr3
        V3mfhyZZJejPopfbha1GhxjPPg==
X-Google-Smtp-Source: APXvYqwcmysrVwi8eDDoMIdmDMADJBNZKuxiO7AjctFjBc75iOz2YhLkLlg3S/MX0lMnU+XgHh2a7A==
X-Received: by 2002:a17:902:683:: with SMTP id 3mr22168356plh.209.1558199936948;
        Sat, 18 May 2019 10:18:56 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:752c:b986:3395:75e0? ([2601:646:c200:1ef2:752c:b986:3395:75e0])
        by smtp.gmail.com with ESMTPSA id q193sm18551512pfc.52.2019.05.18.10.18.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 May 2019 10:18:55 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2] net: Add UNIX_DIAG_UID to Netlink UNIX socket diagnostics.
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16E227)
In-Reply-To: <20190518034820.16500-1-felipe@felipegasper.com>
Date:   Sat, 18 May 2019 10:18:54 -0700
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-api@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6CDA54A5-56FF-4B42-B6F5-762E72C3FC3B@amacapital.net>
References: <20190518034820.16500-1-felipe@felipegasper.com>
To:     Felipe Gasper <felipe@felipegasper.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 17, 2019, at 8:48 PM, Felipe Gasper <felipe@felipegasper.com> wrote=
:
>=20
> Author: Felipe Gasper <felipe@felipegasper.com>
> Date:   Fri May 17 16:54:40 2019 -0500
>=20
>   net: Add UNIX_DIAG_UID to Netlink UNIX socket diagnostics.
>=20
>   This adds the ability for Netlink to report a socket=E2=80=99s UID along=
 with the
>   other UNIX diagnostic information that is already available. This will
>   allow diagnostic tools greater insight into which users control which so=
cket.
>=20
>   Signed-off-by: Felipe Gasper <felipe@felipegasper.com>
>=20
> diff --git a/include/uapi/linux/unix_diag.h b/include/uapi/linux/unix_diag=
.h
> index 5c502fd..a198857 100644
> --- a/include/uapi/linux/unix_diag.h
> +++ b/include/uapi/linux/unix_diag.h
> @@ -20,6 +20,7 @@ struct unix_diag_req {
> #define UDIAG_SHOW_ICONS    0x00000008    /* show pending connections */
> #define UDIAG_SHOW_RQLEN    0x00000010    /* show skb receive queue len */=

> #define UDIAG_SHOW_MEMINFO    0x00000020    /* show memory info of a socke=
t */
> +#define UDIAG_SHOW_UID        0x00000040    /* show socket's UID */
>=20
> struct unix_diag_msg {
>    __u8    udiag_family;
> @@ -40,6 +41,7 @@ enum {
>    UNIX_DIAG_RQLEN,
>    UNIX_DIAG_MEMINFO,
>    UNIX_DIAG_SHUTDOWN,
> +    UNIX_DIAG_UID,
>=20
>    __UNIX_DIAG_MAX,
> };
> diff --git a/net/unix/diag.c b/net/unix/diag.c
> index 3183d9b..e40f348 100644
> --- a/net/unix/diag.c
> +++ b/net/unix/diag.c
> @@ -4,9 +4,11 @@
> #include <linux/unix_diag.h>
> #include <linux/skbuff.h>
> #include <linux/module.h>
> +#include <linux/uidgid.h>
> #include <net/netlink.h>
> #include <net/af_unix.h>
> #include <net/tcp_states.h>
> +#include <net/sock.h>
>=20
> static int sk_diag_dump_name(struct sock *sk, struct sk_buff *nlskb)
> {
> @@ -110,6 +112,12 @@ static int sk_diag_show_rqlen(struct sock *sk, struct=
 sk_buff *nlskb)
>    return nla_put(nlskb, UNIX_DIAG_RQLEN, sizeof(rql), &rql);
> }
>=20
> +static int sk_diag_dump_uid(struct sock *sk, struct sk_buff *nlskb)
> +{
> +    uid_t uid =3D from_kuid_munged(sk_user_ns(sk), sock_i_uid(sk));
> +    return nla_put(nlskb, UNIX_DIAG_UID, sizeof(uid_t), &uid);

This still looks wrong. You=E2=80=99re reporting the uid of the socket as se=
en by that socket.  Presumably you actually want the uid of the socket as se=
en by the *diagnostic* socket. This might be sk_user_ns(nlskb->sk).

You can test this with a command like unshare -U -r nc -l 12345 run as no -r=
oot. Then run you user diagnostic tool to find the uid of the socket. It sho=
uld not be zero. Similarly, if you run unshare -U -r bash and then open a so=
cket and run your diagnostic tool, both from that same session, you should s=
ee 0 as the uid since bash and all its children think they=E2=80=99re uid 0.=


> +}

> +
> static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_=
diag_req *req,
>        u32 portid, u32 seq, u32 flags, int sk_ino)
> {
> @@ -156,6 +164,10 @@ static int sk_diag_fill(struct sock *sk, struct sk_bu=
ff *skb, struct unix_diag_r
>    if (nla_put_u8(skb, UNIX_DIAG_SHUTDOWN, sk->sk_shutdown))
>        goto out_nlmsg_trim;
>=20
> +    if ((req->udiag_show & UDIAG_SHOW_UID) &&
> +        sk_diag_dump_uid(sk, skb))
> +        goto out_nlmsg_trim;
> +
>    nlmsg_end(skb, nlh);
>    return 0;
>=20
