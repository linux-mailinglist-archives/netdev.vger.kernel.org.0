Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FD1361874
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 05:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238368AbhDPD6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 23:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234659AbhDPD6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 23:58:01 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9B7C061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 20:57:37 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id w4so21557774wrt.5
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 20:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ffUfz8AQJ+mo9kaf79/VEPlSlKYG2zsaLHcQhznwYSQ=;
        b=vcBo1/+655ALJsMhJWrA1lJDZDFmeQA+gVT2nYzROvcrEBwJIBny6MsSf/KfyNL/3b
         VWsVY+F85pDs7N0j3ofIDV1WX86IAyXQUS6MXaKJqMERhy9YwZKPQYCuIKX/krLMgUdc
         Ka0voQ/nKtT25zFPdP5HeQmNwzFJ5uJZGD3bTlk0L8sBkEENw5OCSqiBrzQEZyn04ouv
         m6i7DLJDhp2ElmndObKrEv5621cWoAQThaD5RydanHJkLApC440GqfPLs/C64+qtWSaA
         XXJWOu8k4AZP+rqHI5kRHbIkiaLiaQHjObosfgFmSMnuQYHd/FbPPKn14MhQ+MzXFTfR
         IWJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ffUfz8AQJ+mo9kaf79/VEPlSlKYG2zsaLHcQhznwYSQ=;
        b=sxNDq+p756tGNfpMcIHQpMybcFMU/Pyw11X/Ag2ti6pTzLc+CQe+bEMnQGGvn6uDgA
         QNl2Bm0KWjAYbwB5JZByrai533o85NWDJmmHrmYXG29FMsp4FBrffrrnJeZDCijMl+kF
         M4PglTCogLVlS/BnJD7nWpiGOH9BHYdstWAZPsM07PJxJ+oo9LGVuv2k1uuDIJpAIsdg
         +HqcMhUZF0yerFohzt53R2BTaSrWTQDInyTMRRZl+gvxDbzVLpnH+bCn3zO+o8ho2cNo
         gpItgN0MCOrEI05bAj2dvk8UNA2VcOvUE9LWkZfGKLJkWzjrQBFbR6K1l/nb3pbpwTqE
         OqMQ==
X-Gm-Message-State: AOAM531n/mleGyc6eWlswrgL7T5Fc4yL7Dp1o4lYNhle4YEG3Lp/a6Yo
        NDzRGw+qxKMKFGj3G7L9gEMK7QwbSuM0SrQhqUhtmaxH972h4w==
X-Google-Smtp-Source: ABdhPJyJWRwD0Bjf4uavNyo8f6XGqvY/r0i77Rnu0LixxgD0vTchduLfz5S1cACbh3X+VmldkAG83HITGWgY43BgEKs=
X-Received: by 2002:a05:6000:249:: with SMTP id m9mr6573992wrz.13.1618545456334;
 Thu, 15 Apr 2021 20:57:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAE_QS3ccJB8GqVrJ_95P7K=NmXC0TP_NyoAiVbTqhk09JRodrA@mail.gmail.com>
 <e73269cc-1530-5749-0b62-f30b742217e1@gmail.com>
In-Reply-To: <e73269cc-1530-5749-0b62-f30b742217e1@gmail.com>
From:   Bala Sajja <bssajja@gmail.com>
Date:   Fri, 16 Apr 2021 09:27:25 +0530
Message-ID: <CAE_QS3fP_CysCvwtTxu=1PPRZevFwBPjFpyq6M+NtZ_CrOkZhw@mail.gmail.com>
Subject: Re: Different behavior wrt VRF and no VRF - packet Tx
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,
       please find the ip link show output(for ifindex) and ping and
its corresponding perf fib events output. OIF seems MGMT(ifindex 5)
always, not enslaved  interfaces ?

ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast
master MGMT state UP mode DEFAULT group default qlen 1000
    link/ether 08:00:27:ee:c2:f8 brd ff:ff:ff:ff:ff:ff
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast
master MGMT state UP mode DEFAULT group default qlen 1000
    link/ether 08:00:27:0e:75:05 brd ff:ff:ff:ff:ff:ff
4: enp0s9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast
state UP mode DEFAULT group default qlen 1000
    link/ether 08:00:27:08:6c:37 brd ff:ff:ff:ff:ff:ff
5: MGMT: <NOARP,MASTER,UP,LOWER_UP> mtu 65536 qdisc noqueue state UP
mode DEFAULT group default qlen 1000
    link/ether c2:08:e9:2b:8a:a4 brd ff:ff:ff:ff:ff:ff
6: LOMGMT: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue master
MGMT state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether c2:04:90:b4:2d:9e brd ff:ff:ff:ff:ff:ff


ping 1.1.1.100 -I enp0s3 -c 1

sudo perf report
Samples: 27  of event 'fib:fib_table_lookup', Event count (approx.): 27
Overhead  Trace output

   11.11%  table 1 oif 0 iif 0 proto 0 0.0.0.0/0 -> 2.2.2.100/0 tos 0
scope 0 flags 0 =3D=3D> dev LOMGMT gw 0.0.0.0 src 2.2.2.100 err 0
                =E2=97=86
   7.41%  table 254 oif 0 iif 1 proto 0 0.0.0.0/0 -> 192.168.1.11/0
tos 0 scope 0 flags 0 =3D=3D> dev enp0s9 gw 0.0.0.0 src 192.168.1.2 err 0
                 =E2=96=92
   7.41%  table 255 oif 0 iif 1 proto 0 0.0.0.0/0 -> 192.168.1.11/0
tos 0 scope 0 flags 0 =3D=3D> dev - gw 0.0.0.0 src 0.0.0.0 err -11
                 =E2=96=92
   3.70%  table 1 oif 0 iif 0 proto 0 0.0.0.0/0 -> 1.1.1.100/0 tos 0
scope 0 flags 0 =3D=3D> dev enp0s3 gw 0.0.0.0 src 2.2.2.100 err 0
                =E2=96=92
   3.70%  table 1 oif 5 iif 1 proto 1 0.0.0.0/0 -> 1.1.1.100/0 tos 0
scope 0 flags 4 =3D=3D> dev enp0s3 gw 0.0.0.0 src 2.2.2.100 err 0
                =E2=96=92
   3.70%  table 1 oif 5 iif 1 proto 1 0.0.0.0/0 -> 2.2.2.100/0 tos 0
scope 0 flags 4 =3D=3D> dev LOMGMT gw 0.0.0.0 src 2.2.2.100 err 0
                =E2=96=92
   3.70%  table 1 oif 5 iif 1 proto 1 2.2.2.100/0 -> 2.2.2.100/0 tos 0
scope 0 flags 5 =3D=3D> dev LOMGMT gw 0.0.0.0 src 2.2.2.100 err 0
              =E2=96=92
   3.70%  table 1 oif 5 iif 1 proto 17 0.0.0.0/36297 -> 1.1.1.100/1025
tos 0 scope 0 flags 4 =3D=3D> dev enp0s3 gw 0.0.0.0 src 2.2.2.100 err 0
              =E2=96=92
   3.70%  table 1 oif 5 iif 1 proto 17 2.2.2.100/36297 ->
1.1.1.100/1025 tos 0 scope 0 flags 4 =3D=3D> dev enp0s3 gw 0.0.0.0 src
2.2.2.100 err 0                =E2=96=92
   3.70%  table 254 oif 0 iif 1 proto 0 0.0.0.0/0 -> 1.1.1.100/0 tos 0
scope 0 flags 0 =3D=3D> dev enp0s9 gw 192.168.1.1 src 192.168.1.2 err 0
              =E2=96=92
   3.70%  table 254 oif 0 iif 1 proto 0 192.168.1.2/0 ->
192.168.1.12/0 tos 0 scope 0 flags 0 =3D=3D> dev enp0s9 gw 0.0.0.0 src
192.168.1.2 err 0               =E2=96=92
   3.70%  table 254 oif 0 iif 4 proto 0 1.1.1.100/0 -> 2.2.2.100/0 tos
0 scope 0 flags 0 =3D=3D> dev enp0s9 gw 192.168.1.1 src 192.168.1.2 err 0
              =E2=96=92
   3.70%  table 254 oif 0 iif 4 proto 0 192.168.1.11/0 ->
192.168.1.8/0 tos 0 scope 0 flags 0 =3D=3D> dev enp0s9 gw 0.0.0.0 src
192.168.1.2 err 0               =E2=96=92
   3.70%  table 255 oif 0 iif 1 proto 0 0.0.0.0/0 -> 1.1.1.100/0 tos 0
scope 0 flags 0 =3D=3D> dev - gw 0.0.0.0 src 0.0.0.0 err -11
              =E2=96=92
   3.70%  table 255 oif 0 iif 1 proto 0 192.168.1.2/0 ->
192.168.1.12/0 tos 0 scope 0 flags 0 =3D=3D> dev - gw 0.0.0.0 src 0.0.0.0
err -11                      =E2=96=92
   3.70%  table 255 oif 0 iif 4 proto 0 1.1.1.100/0 -> 2.2.2.100/0 tos
0 scope 0 flags 0 =3D=3D> dev - gw 0.0.0.0 src 0.0.0.0 err -11
              =E2=96=92
   3.70%  table 255 oif 0 iif 4 proto 0 192.168.1.11/0 ->
192.168.1.8/0 tos 0 scope 0 flags 0 =3D=3D> dev - gw 0.0.0.0 src 0.0.0.0
err -11                      =E2=96=92
   3.70%  table 255 oif 0 iif 4 proto 0 192.168.1.12/0 ->
192.168.1.2/0 tos 0 scope 0 flags 0 =3D=3D> dev enp0s9 gw 0.0.0.0 src
192.168.1.2 err 0               =E2=96=92
   3.70%  table 255 oif 5 iif 1 proto 1 0.0.0.0/0 -> 1.1.1.100/0 tos 0
scope 0 flags 4 =3D=3D> dev - gw 0.0.0.0 src 0.0.0.0 err -11
              =E2=96=92
   3.70%  table 255 oif 5 iif 1 proto 1 0.0.0.0/0 -> 2.2.2.100/0 tos 0
scope 0 flags 4 =3D=3D> dev - gw 0.0.0.0 src 0.0.0.0 err -11
              =E2=96=92
   3.70%  table 255 oif 5 iif 1 proto 1 2.2.2.100/0 -> 2.2.2.100/0 tos
0 scope 0 flags 5 =3D=3D> dev - gw 0.0.0.0 src 0.0.0.0 err -11
              =E2=96=92
   3.70%  table 255 oif 5 iif 1 proto 17 0.0.0.0/36297 ->
1.1.1.100/1025 tos 0 scope 0 flags 4 =3D=3D> dev - gw 0.0.0.0 src 0.0.0.0
err -11                     =E2=96=92
   3.70%  table 255 oif 5 iif 1 proto 17 2.2.2.100/36297 ->
1.1.1.100/1025 tos 0 scope 0 flags 4 =3D=3D> dev - gw 0.0.0.0 src 0.0.0.0
err -11                   =E2=96=92

 ping 1.1.1.100 -I enp0s8 -c 1

 sudo perf report
Samples: 27  of event 'fib:fib_table_lookup', Event count (approx.): 27
Overhead  Trace output
  11.11%  table 1 oif 0 iif 0 proto 0 0.0.0.0/0 -> 2.2.2.100/0 tos 0
scope 0 flags 0 =3D=3D> dev LOMGMT gw 0.0.0.0 src 2.2.2.100 err 0
   3.70%  table 1 oif 0 iif 0 proto 0 0.0.0.0/0 -> 1.1.1.100/0 tos 0
scope 0 flags 0 =3D=3D> dev enp0s3 gw 0.0.0.0 src 2.2.2.100 err 0
   3.70%  table 1 oif 5 iif 1 proto 1 0.0.0.0/0 -> 1.1.1.100/0 tos 0
scope 0 flags 4 =3D=3D> dev enp0s3 gw 0.0.0.0 src 2.2.2.100 err 0
   3.70%  table 1 oif 5 iif 1 proto 1 0.0.0.0/0 -> 2.2.2.100/0 tos 0
scope 0 flags 4 =3D=3D> dev LOMGMT gw 0.0.0.0 src 2.2.2.100 err 0
   3.70%  table 1 oif 5 iif 1 proto 1 2.2.2.100/0 -> 2.2.2.100/0 tos 0
scope 0 flags 5 =3D=3D> dev LOMGMT gw 0.0.0.0 src 2.2.2.100 err 0
   3.70%  table 1 oif 5 iif 1 proto 17 0.0.0.0/51188 -> 1.1.1.100/1025
tos 0 scope 0 flags 4 =3D=3D> dev enp0s3 gw 0.0.0.0 src 2.2.2.100 err 0
   3.70%  table 1 oif 5 iif 1 proto 17 2.2.2.100/51188 ->
1.1.1.100/1025 tos 0 scope 0 flags 4 =3D=3D> dev enp0s3 gw 0.0.0.0 src
2.2.2.100 err 0
   3.70%  table 254 oif 0 iif 1 proto 0 0.0.0.0/0 -> 1.1.1.100/0 tos 0
scope 0 flags 0 =3D=3D> dev enp0s9 gw 192.168.1.1 src 192.168.1.2 err 0
   3.70%  table 254 oif 0 iif 1 proto 0 192.168.1.2/0 ->
192.168.1.12/0 tos 0 scope 0 flags 0 =3D=3D> dev enp0s9 gw 0.0.0.0 src
192.168.1.2 err 0
   3.70%  table 254 oif 0 iif 4 proto 0 1.1.1.100/0 -> 2.2.2.100/0 tos
0 scope 0 flags 0 =3D=3D> dev enp0s9 gw 192.168.1.1 src 192.168.1.2 err 0
   3.70%  table 254 oif 0 iif 4 proto 0 192.168.1.1/0 ->
192.168.1.12/0 tos 0 scope 0 flags 0 =3D=3D> dev enp0s9 gw 0.0.0.0 src
192.168.1.2 err 0
   3.70%  table 254 oif 0 iif 4 proto 0 192.168.1.11/0 ->
192.168.1.8/0 tos 0 scope 0 flags 0 =3D=3D> dev enp0s9 gw 0.0.0.0 src
192.168.1.2 err 0
   3.70%  table 254 oif 0 iif 4 proto 0 192.168.1.8/0 ->
192.168.1.12/0 tos 0 scope 0 flags 0 =3D=3D> dev enp0s9 gw 0.0.0.0 src
192.168.1.2 err 0
   3.70%  table 255 oif 0 iif 1 proto 0 0.0.0.0/0 -> 1.1.1.100/0 tos 0
scope 0 flags 0 =3D=3D> dev - gw 0.0.0.0 src 0.0.0.0 err -11
   3.70%  table 255 oif 0 iif 1 proto 0 192.168.1.2/0 ->
192.168.1.12/0 tos 0 scope 0 flags 0 =3D=3D> dev - gw 0.0.0.0 src 0.0.0.0
err -11
   3.70%  table 255 oif 0 iif 4 proto 0 1.1.1.100/0 -> 2.2.2.100/0 tos
0 scope 0 flags 0 =3D=3D> dev - gw 0.0.0.0 src 0.0.0.0 err -11
   3.70%  table 255 oif 0 iif 4 proto 0 192.168.1.1/0 ->
192.168.1.12/0 tos 0 scope 0 flags 0 =3D=3D> dev - gw 0.0.0.0 src 0.0.0.0
err -11
   3.70%  table 255 oif 0 iif 4 proto 0 192.168.1.11/0 ->
192.168.1.8/0 tos 0 scope 0 flags 0 =3D=3D> dev - gw 0.0.0.0 src 0.0.0.0
err -11
   3.70%  table 255 oif 0 iif 4 proto 0 192.168.1.12/0 ->
192.168.1.2/0 tos 0 scope 0 flags 0 =3D=3D> dev enp0s9 gw 0.0.0.0 src
192.168.1.2 err 0
   3.70%  table 255 oif 0 iif 4 proto 0 192.168.1.8/0 ->
192.168.1.12/0 tos 0 scope 0 flags 0 =3D=3D> dev - gw 0.0.0.0 src 0.0.0.0
err -11
   3.70%  table 255 oif 5 iif 1 proto 1 0.0.0.0/0 -> 1.1.1.100/0 tos 0
scope 0 flags 4 =3D=3D> dev - gw 0.0.0.0 src 0.0.0.0 err -11
   3.70%  table 255 oif 5 iif 1 proto 1 0.0.0.0/0 -> 2.2.2.100/0 tos 0
scope 0 flags 4 =3D=3D> dev - gw 0.0.0.0 src 0.0.0.0 err -11
   3.70%  table 255 oif 5 iif 1 proto 1 2.2.2.100/0 -> 2.2.2.100/0 tos
0 scope 0 flags 5 =3D=3D> dev - gw 0.0.0.0 src 0.0.0.0 err -11
   3.70%  table 255 oif 5 iif 1 proto 17 0.0.0.0/51188 ->
1.1.1.100/1025 tos 0 scope 0 flags 4 =3D=3D> dev - gw 0.0.0.0 src 0.0.0.0
err -11
   3.70%  table 255 oif 5 iif 1 proto 17 2.2.2.100/51188 ->
1.1.1.100/1025 tos 0 scope 0 flags 4 =3D=3D> dev - gw 0.0.0.0 src 0.0.0.0
err -11


Regards,
Bala.


On Fri, Apr 16, 2021 at 1:11 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 4/15/21 12:15 AM, Bala Sajja wrote:
> > When interfaces are not part of VRF  and below ip address config is
> > done on these interfaces, ping with -I (interface) option, we see
> > packets transmitting out of the right interfaces.
> >
> >  ip addr add 2.2.2.100 peer 1.1.1.100/32 dev enp0s3
> >  ip addr add 2.2.2.100 peer 1.1.1.100/32  dev enp0s8
> >
> >  ping 1.1.1.100    -I  enp0s3 , packet always goes out of  enp0s3
> >  ping 1.1.1.100    -I   enp0s8, packet always goes out of  enp0s8
> >
> > When interfaces are enslaved  to VRF  as below and ip are configured
> > on these interfaces, packets go out of one  interface only.
> >
> >  ip link add MGMT type vrf table 1
> >  ip link set dev MGMT up
> >  ip link set dev enp0s3 up
> >  ip link set dev enp0s3 master MGMT
> >  ip link set dev enp0s8 up
> >  ip link set dev enp0s8 master MGMT
> >  ip link set dev enp0s9 up
> >
> >  ip addr add 2.2.2.100 peer 1.1.1.100/32 dev enp0s3
> >  ip addr add 2.2.2.100 peer 1.1.1.100/32  dev enp0s8
> >
> >  ping 1.1.1.100    -I  enp0s3 , packet always goes out of  enp0s3
> >  ping 1.1.1.100    -I   enp0s8, packet always goes out of  enp0s3
> >
> >
>
> I believe this use case will not work since the FIB lookup loses the
> original device binding (the -I argument). take a look at the FIB lookup
> argument and result:
>
> perf record -e fib:*
> perf script
