Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0EA12D9BA3
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 17:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439133AbgLNQBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 11:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438831AbgLNQA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 11:00:58 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC45C0613D3
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 08:00:18 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id t8so12312649pfg.8
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 08:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CNdJwrcmT+TNuotVrz1sNGJAz9u+VL6dvhVlcCJWSTI=;
        b=DsEvdaEu0N831V6e6dmg/6iBRBirOLbgQljrKYLaDjnIl/6glVyLNUn2GpEpfcW8XZ
         Bs+26oUwayDh4G7ugGHAVCoFGrmPx3TYvjEFjVGvhnT4rBJZrwgSuZxndtS6eFJPHWD+
         FzusnHEgNiWmVIHKpkeipO0M8HV83sKNydkoDZPP+c0i2erd2zcPm4Ex59S4t3aclYo3
         gpCg9jKJvMFEg64PKX/TvWfOK88uTFYLuzzdjc6iQQ3hjl9R5lBlY8KBoVkHJq56zNLp
         N5gpV8Pfj6ffpOdol9CJPlmsc2ny9DRwFyem91ppoXeJTFkBp9crBOH9Vnus/MV8qSkb
         hLcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CNdJwrcmT+TNuotVrz1sNGJAz9u+VL6dvhVlcCJWSTI=;
        b=Sx2zb5GBL1dK9pZJOsbYZSUUq0KI/QrIiDveX11smQCjlT8jYsk8sN9iPO5Kk1SlaS
         pipfS2jZagLdh8GjrCKBvhTqw5l0PIklGW6ZnodixqsQ1zx4YWPTyCW2ORJl+kgKqI5f
         CYiLIfUyTmkCHBW3zq0qwv+ZLMdKIfuEDutAcsY2cmcJEhoG+SQlQnzXNrD3XgxanGN5
         1ksvgC6AeW0qtWfkBcfCwkmikjfWik2hOZP/9KdsMSurFi8XF0RIq5Cd9aVGkboXHVqp
         wMmJFCxawI6sF5xFGJlIy41sPyI5xjUHGkfWQ+2SmMNsWgVSA2DVGUAco7JN8s8ArQlQ
         LjxQ==
X-Gm-Message-State: AOAM532ahYg+TPadOYDxYZR2hTOaLAj7fqRT7gaW8yixBd90/f0HpYam
        6ShGc+vrPP+grAcTOdvquJYkjQ==
X-Google-Smtp-Source: ABdhPJz/yEQ5uZxZxowJc+5h0kVDeKd0nSdivEDlLRkM/QMc8REjn2eAbTw4phwMMBPrCqYg/URBJQ==
X-Received: by 2002:a05:6a00:14cf:b029:18c:959d:929e with SMTP id w15-20020a056a0014cfb029018c959d929emr24605796pfu.53.1607961617688;
        Mon, 14 Dec 2020 08:00:17 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id z6sm20635156pfj.22.2020.12.14.08.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 08:00:17 -0800 (PST)
Date:   Mon, 14 Dec 2020 08:00:13 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Witold Baryluk <witold.baryluk@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Incorrect --help / manpage for -color for ip, tc, bridge
Message-ID: <20201214080013.6ef78cb7@hermes.local>
In-Reply-To: <CAEGMnwozvs0Fn0R-aQBpbN2HY9v7PNmUN=FGL=H8TgDYLAU1ow@mail.gmail.com>
References: <CAEGMnwozvs0Fn0R-aQBpbN2HY9v7PNmUN=FGL=H8TgDYLAU1ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Dec 2020 20:07:16 +0000
Witold Baryluk <witold.baryluk@gmail.com> wrote:

> iproute 5.9.0
>=20
> Apparently ip -c is a shortcut to ip -color
>=20
> but in tc, tc -c doesn't work, one needs to say tc -col or tc -color
>=20
> I understand there is tc -conf, which has tc -c.
>=20
> But:
>=20
> Help says:
>=20
> root@debian:~# tc
> Usage:    tc [ OPTIONS ] OBJECT { COMMAND | help }
>     tc [-force] -batch filename
> where  OBJECT :=3D { qdisc | class | filter | chain |
>             action | monitor | exec }
>        OPTIONS :=3D { -V[ersion] | -s[tatistics] | -d[etails] | -r[aw] |
>             -o[neline] | -j[son] | -p[retty] | -c[olor]
>             -b[atch] [filename] | -n[etns] name | -N[umeric] |
>              -nm | -nam[es] | { -cf | -conf } path }
>=20
> this should be:
>=20
> root@debian:~# tc
> Usage:    tc [ OPTIONS ] OBJECT { COMMAND | help }
>     tc [-force] -batch filename
> where  OBJECT :=3D { qdisc | class | filter | chain |
>             action | monitor | exec }
>        OPTIONS :=3D { -V[ersion] | -s[tatistics] | -d[etails] | -r[aw] |
>             -o[neline] | -j[son] | -p[retty] | -col[or]
>             -b[atch] [filename] | -n[etns] name | -N[umeric] |
>              -nm | -nam[es] | { -cf | -c[onf] } path }
>=20
>=20
> ( -c[olor] -> -col[or] )  # also in --help for ip and bridge
>=20
> If only -c meaning -conf could be removed, it would be even nicer. -cf
> is already short.
>=20
> Additionally in manpage for tc, ip and bridge:
>        -c[color][=3D{always|auto|never}
>               Configure color output. If parameter is omitted or
> always, color output is enabled regardless of stdout state. If
> parameter is auto, stdout is checked to be a terminal be=E2=80=90
>               fore  enabling  color output. If parameter is never,
> color output is disabled. If specified multiple times, the last one
> takes precedence. This flag is ignored if -json is
>               also given.
>=20
>=20
>=20
> I don't think this is correct either.
>=20
> Should be -col[or], not -c[color] (sic!).
>=20
> Similar mistakes are in man pages and --help messages also for ip,
> bridge, not just tc.
>=20
>=20
> Regards,
> Witold

Send a patch to fix it.
