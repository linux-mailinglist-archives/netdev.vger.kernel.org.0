Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206C63A6F7B
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 21:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbhFNTz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 15:55:57 -0400
Received: from mail-ot1-f42.google.com ([209.85.210.42]:45976 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbhFNTz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 15:55:56 -0400
Received: by mail-ot1-f42.google.com with SMTP id 6-20020a9d07860000b02903e83bf8f8fcso11984284oto.12
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 12:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:date:references
         :to:in-reply-to:message-id;
        bh=kObNrwEKHgce370QXi69vY3tpxbpxLB+T6efSZirxKY=;
        b=AWlt7vahGayJVUV20xAI8VKDBE8HBRgd/BuXPNatHWJABzA1QJP+toVDU0MAXtd7QO
         PVk2pc6MJ0qzBdUjq8vNkjTWzhck0kETJw0Cdyy7EdLneg4WRFLYRnNH1Z4911bhkD/w
         dXcLYZif2/IwXxFZu8fwkkj2IqEHq1XnBifuhDJk/+MeeEGcaecdJWmrT7XRV7ZFXYFu
         ShlthdoQGVhBw1o5Sj0Xzy745B7USk9acUEWdt61yMB7Fll/l5YRfNkbIJ4e7kiH9LDQ
         NQ0JMlXcxGxfCx6+ltHfMrl65APwS58uhZ1AUdTDXHcXH6T5JSYjp6d9D0ivVqYwTJ4z
         z2uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:date:references:to:in-reply-to:message-id;
        bh=kObNrwEKHgce370QXi69vY3tpxbpxLB+T6efSZirxKY=;
        b=Sl5EYF7wHPOMUFNfxg/gy1a4t3rP7ff+1kguiMFxzGPN2X0F9bA5UdXF2FDiuxWpft
         FZwN+9BZnwvCB3n2vKH3KTgwkNLJxfMFnTPMKay+JbUIOwYcLySUKBkyrhGFK9CJ8X3e
         1JW10a987BfHCIgk+UqeJtzrZpOhCa7pdU0hdNyp70TLPv6FnYUx7azwfW31iYUrvZ0z
         8GNy/7duyNyp/9EqiaOpcijYGdl5tNEmdaaBCEKBuhSwYGmGd87nDLGJN5Aq4jGscGDw
         u8wGG4bumixnslodV8Avba6dTPAf/pYYkFlqnl0+ClBJnmdMcKqraUYX7zeXFbqCmxBX
         GMmg==
X-Gm-Message-State: AOAM533erBzCsAcNtZrPoLNL/a5BbuEgkwCq9zX07Izv79XZgkq1armw
        6alB8+w9Q5k/6Xsko6LyyZ07BevXzrY=
X-Google-Smtp-Source: ABdhPJznma/9MlfNA2E9+fAZdLNWDlT/5Gw00ZYtHtVVTlOQKYpSnGRYxVq7v97lD1uCKbsn1Uqa+A==
X-Received: by 2002:a9d:542:: with SMTP id 60mr14763924otw.143.1623700372793;
        Mon, 14 Jun 2021 12:52:52 -0700 (PDT)
Received: from smtpclient.apple ([2600:1700:9b91:a600:2550:68bb:ede4:7f93])
        by smtp.gmail.com with ESMTPSA id k4sm1482294otp.72.2021.06.14.12.52.52
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jun 2021 12:52:52 -0700 (PDT)
From:   Scott Fields <slfields66@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: "ip addr show" returns interface names that won't work with "ip
 addr show dev <ifname>"
Date:   Mon, 14 Jun 2021 14:52:50 -0500
References: <4DC83BAC-29D0-404E-8EA7-74B2BD80446C@gmail.com>
To:     netdev@vger.kernel.org
In-Reply-To: <4DC83BAC-29D0-404E-8EA7-74B2BD80446C@gmail.com>
Message-Id: <B4F46201-5CB4-416A-928C-13F885727CFD@gmail.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Has this been received? I=E2=80=99ve not seen any response.

> On Jun 11, 2021, at 5:27 AM, Scott Fields <slfields66@gmail.com> =
wrote:
>=20
> =E2=80=9Cip addr show=E2=80=9D will return a list of devices that may =
not work with =E2=80=9Cip addr show dev <ifname>=E2=80=9D.
>=20
> If you have list vlan device, it will return it as =E2=80=9C<vlan =
ifname>@<parent ifname>=E2=80=9D.
>=20
> However, =E2=80=9Cip addr show dev <ifname>=E2=80=9D will not work =
with that name.
>=20
> =E2=80=9Cip addr show dev <ifname>=E2=80=9D should work with interface =
names that =E2=80=9Cip addr show=E2=80=9D returns.

