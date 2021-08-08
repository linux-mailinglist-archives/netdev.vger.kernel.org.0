Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C253E3B08
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 17:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbhHHPOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 11:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbhHHPOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 11:14:32 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628C3C061760
        for <netdev@vger.kernel.org>; Sun,  8 Aug 2021 08:14:12 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id z20so1650529ejf.5
        for <netdev@vger.kernel.org>; Sun, 08 Aug 2021 08:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=fv6mYAaW8IXvhD+Bs/2hepBUD6FI+iZ0//02l4LE76o=;
        b=p5K8Zazgwif2qaTUQhwmx2dNJi6OSLzYTDTHEOID4a6cJOg1N2v7LjeZdWODY2t/KV
         yKO11h2uMr4O73c3ZZQtxEsIiKH6Pp4mFZcKBIf9vKM77Hh1dKFGH+hcqTHbdVe8W/fh
         +EsCpHT1xrPGK1cTy8hezLqtrrDI1dCH4UyA34z91aFh0coijOmlkiDRchXM+g/HGDZ4
         nq3VPxtPsLQQHTzgtSKfY0ZP847qt9f4zPaVBcacIIrs7GovHGpLy+jZ65mMhEhuCQIV
         /3LL6hILnG/QLQ5WBxrQIcz74Gez9CmOAeusJzgzMwbLT+Ft5UEU+366VyyTpq/59VE1
         4DKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=fv6mYAaW8IXvhD+Bs/2hepBUD6FI+iZ0//02l4LE76o=;
        b=tZC8NJLbO0LevAZUtT9NDUWYWkXSZJU032t4rsn8ve/0AKb9o9OJ0QTyYnV41vUF9W
         CeF6X+eUCLQUnioRrEhBUhwPlD8cIJueOI9+IzN5Osys5zXf1aLUBHo+2pCsP8JrDixW
         +vfpcgftb5Pu0uOya9mHxyU8/GIcfxTIsK0ILq/p3o/7jOsXPFxfPULeKiBVVNAYodfq
         yVceaL16q6UWf/RnC3+1tETNYz4zMd1Ke9OUeO+c04hyQmGjN/rIpveetm2vhyddt4fu
         ADsIjgHt0f7ODNQQ/97vYoIwCCJmgOZMcdc63xjgtC5zWQORgu1vJ8a0dfUcaM0M9m5w
         RKbQ==
X-Gm-Message-State: AOAM5317vAQX/6ZBL8DeZvTlp0kkVPNENcsby/dchCFCTw+cKNqct4+I
        NaH/6nhueZl+f77n0xdmec4=
X-Google-Smtp-Source: ABdhPJwLQYjI6MeX3Gb5fR1FWhxJkMICXqCpmV2q0sSmpyxLGEoogWfy6m+p4FgxZmNeJAN77gaRrg==
X-Received: by 2002:a17:906:c013:: with SMTP id e19mr18856512ejz.389.1628435651003;
        Sun, 08 Aug 2021 08:14:11 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id a22sm5071833ejk.35.2021.08.08.08.14.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Aug 2021 08:14:10 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Urgent  Bug report: PPPoE ioctl(PPPIOCCONNECT): Transport
 endpoint is not connected
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <YQy9JKgo+BE3G7+a@kroah.com>
Date:   Sun, 8 Aug 2021 18:14:09 +0300
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, pali@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <08EC1CDD-21C4-41AB-B6A8-1CC2D40F5C05@gmail.com>
References: <7EE80F78-6107-4C6E-B61D-01752D44155F@gmail.com>
 <YQy9JKgo+BE3G7+a@kroah.com>
To:     Greg KH <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Pali Roh=C3=A1r,

If have any idea .

Martin

> On 6 Aug 2021, at 7:40, Greg KH <gregkh@linuxfoundation.org> wrote:
>=20
> On Thu, Aug 05, 2021 at 11:53:50PM +0300, Martin Zaharinov wrote:
>> Hi Net dev team
>>=20
>>=20
>> Please check this error :
>> Last time I write for this problem : =
https://www.spinics.net/lists/netdev/msg707513.html
>>=20
>> But not find any solution.
>>=20
>> Config of server is : Bonding port channel (LACP)  > Accel PPP server =
> Huawei switch.
>>=20
>> Server is work fine users is down/up 500+ users .
>> But in one moment server make spike and affect other vlans in same =
server .
>> And in accel I see many row with this error.
>>=20
>> Is there options to find and fix this bug.
>>=20
>> With accel team I discus this problem  and they claim it is kernel =
bug and need to find solution with Kernel dev team.
>>=20
>>=20
>> [2021-08-05 13:52:05.294] vlan912: 24b205903d09718e: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:05.298] vlan912: 24b205903d097162: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:05.626] vlan641: 24b205903d09711b: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:11.000] vlan912: 24b205903d097105: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:17.852] vlan912: 24b205903d0971ae: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:21.113] vlan641: 24b205903d09715b: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:27.963] vlan912: 24b205903d09718d: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:30.249] vlan496: 24b205903d097184: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:30.992] vlan420: 24b205903d09718a: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:33.937] vlan640: 24b205903d0971cd: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:40.032] vlan912: 24b205903d097182: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:40.420] vlan912: 24b205903d0971d5: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:42.799] vlan912: 24b205903d09713a: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:42.799] vlan614: 24b205903d0971e5: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:43.102] vlan912: 24b205903d097190: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:43.850] vlan479: 24b205903d097153: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:43.850] vlan479: 24b205903d097141: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:43.852] vlan912: 24b205903d097198: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:43.977] vlan637: 24b205903d097148: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:44.528] vlan637: 24b205903d0971c3: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>=20
> These are userspace error messages, not kernel messages.
>=20
> What kernel version are you using?
>=20
> thanks,
>=20
> greg k-h

