Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E19F2D89E7
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 21:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407870AbgLLUIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 15:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbgLLUIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 15:08:34 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D415C0613CF
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 12:07:54 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id b73so13007688edf.13
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 12:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=q+g6bIm5jdpq73NjnwqxT8rRKYvF1XDSqPfH32g/g6w=;
        b=siGf8NK3YK7DfdxwGXgsX80AQ6uOcTQyYwbdRBSLnlR+TnvRBKY0gqPKX/bkUViAYU
         K5nIJAIV91wO8mckT7hWoN5gi0CvlyyfH8Favh4GU1z4wrbvV02KGEFTb6u7OucZ0f+c
         nhX6Jh4+k0g/vfIv8KSX5hdvViG9WfdjvjhTds6dlUShfj3P4rE0qzCxK6rUn1ouUNty
         QSxhoRxnzn94KZRQIAq3CH9Ra9m2Qq8CLAS4kvD+cl7tGKMag2UjQg+KeAef1fpiR/lr
         aXbvIdadXkA4cK3G75C7TUa3jjfBRUtvtcMASxqTHrlgQvW40Onhmz1uD4sSfYCzEn6e
         KjIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=q+g6bIm5jdpq73NjnwqxT8rRKYvF1XDSqPfH32g/g6w=;
        b=PQp3OdjIh2Yva1jf5L1K7kXXe1d05Gh35fJVD0S7WyBAgBvg7QBr4XDgUIFWfzonLj
         gJ0G9k4u/EHvVj6O1+udJUY+ees6CXlwfu7x6WB9WmBu3xRboW83O+q09wzpYkvXQ+Bm
         m/1vX2nvpIdRovCzm91cEYxT2iJ/KSzP9DGmJR9RWLhKIYG42CLcj730x5BImM9mv4aO
         ZHeRw5d8bhud0wtv2LtDho5Qji0CWMrhoX6psidaRrFy4hJOKD+lcnWYBIpRm/51th53
         wdb9hlbBc2CzlAOGV96fCEZlwFhGZPLSCSGh/FdogGHdfB6W9BxhLlp2gZZAxbjG5j5/
         N+qw==
X-Gm-Message-State: AOAM532EAdupxvJ012u8dF782+1FTYzEWQH4D3dDm7HGUNYiOJLyKOBg
        x5HmUfXjreVv7hIyL/KCQodk4ULo3eqymvqj4bJQ+WTOZRmSZw==
X-Google-Smtp-Source: ABdhPJxljnRrvHfPVTaUkhn4g7VSK++BWqWKG/FUfBT9gMuvu4iOcgka9ppsUYIA0lOe5OwoIxAUdemcsbEoO07F6nk=
X-Received: by 2002:a50:d8c8:: with SMTP id y8mr17561753edj.82.1607803671837;
 Sat, 12 Dec 2020 12:07:51 -0800 (PST)
MIME-Version: 1.0
From:   Witold Baryluk <witold.baryluk@gmail.com>
Date:   Sat, 12 Dec 2020 20:07:16 +0000
Message-ID: <CAEGMnwozvs0Fn0R-aQBpbN2HY9v7PNmUN=FGL=H8TgDYLAU1ow@mail.gmail.com>
Subject: Incorrect --help / manpage for -color for ip, tc, bridge
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

iproute 5.9.0

Apparently ip -c is a shortcut to ip -color

but in tc, tc -c doesn't work, one needs to say tc -col or tc -color

I understand there is tc -conf, which has tc -c.

But:

Help says:

root@debian:~# tc
Usage:    tc [ OPTIONS ] OBJECT { COMMAND | help }
    tc [-force] -batch filename
where  OBJECT :=3D { qdisc | class | filter | chain |
            action | monitor | exec }
       OPTIONS :=3D { -V[ersion] | -s[tatistics] | -d[etails] | -r[aw] |
            -o[neline] | -j[son] | -p[retty] | -c[olor]
            -b[atch] [filename] | -n[etns] name | -N[umeric] |
             -nm | -nam[es] | { -cf | -conf } path }

this should be:

root@debian:~# tc
Usage:    tc [ OPTIONS ] OBJECT { COMMAND | help }
    tc [-force] -batch filename
where  OBJECT :=3D { qdisc | class | filter | chain |
            action | monitor | exec }
       OPTIONS :=3D { -V[ersion] | -s[tatistics] | -d[etails] | -r[aw] |
            -o[neline] | -j[son] | -p[retty] | -col[or]
            -b[atch] [filename] | -n[etns] name | -N[umeric] |
             -nm | -nam[es] | { -cf | -c[onf] } path }


( -c[olor] -> -col[or] )  # also in --help for ip and bridge

If only -c meaning -conf could be removed, it would be even nicer. -cf
is already short.

Additionally in manpage for tc, ip and bridge:
       -c[color][=3D{always|auto|never}
              Configure color output. If parameter is omitted or
always, color output is enabled regardless of stdout state. If
parameter is auto, stdout is checked to be a terminal be=E2=80=90
              fore  enabling  color output. If parameter is never,
color output is disabled. If specified multiple times, the last one
takes precedence. This flag is ignored if -json is
              also given.



I don't think this is correct either.

Should be -col[or], not -c[color] (sic!).

Similar mistakes are in man pages and --help messages also for ip,
bridge, not just tc.


Regards,
Witold
