Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E346B382598
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 09:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235296AbhEQHp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 03:45:56 -0400
Received: from mout.gmx.net ([212.227.17.21]:53901 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231521AbhEQHpz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 03:45:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1621237461;
        bh=T34V+hn9ZKPr9We0wlSX9kaMJxQbku8lQWce/LDSGRo=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=AdHeHd5eLAHIKaNmyz4IpBjiqZljPH5UcqxqcwDBOvHKu8Xa1nUHcpTZ4kyIp7ef+
         2HfDpubWNyDpVd+NgOz7/cm4eNsmjihSRBIKLikenELocidxZgNBVet8bl7I22wsxK
         HfZ+KsU1kCNm1yzD9nqxyl4RY3OtaAgFBa4BC4A0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.76.108] ([80.245.76.108]) by web-mail.gmx.net
 (3c-app-gmx-bap57.server.lan [172.19.172.127]) (via HTTP); Mon, 17 May 2021
 09:44:21 +0200
MIME-Version: 1.0
Message-ID: <trinity-00d9e9f2-6c60-48b7-ad84-64fd50043001-1621237461808@3c-app-gmx-bap57>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Aw: Re: Crosscompiling iproute2
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 17 May 2021 09:44:21 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20210516141745.009403b7@hermes.local>
References: <trinity-a96735e9-a95a-45be-9386-6e0aa9955a86-1621176719037@3c-app-gmx-bap46>
 <20210516141745.009403b7@hermes.local>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:b2CBtD3XBmMcUGW/2HRFmLEF1vbS/izYpaWU+GwdYL8GqFJOTYhLQbtlpAQgm23snHLii
 vd/NDtiq8BwH1AS5+77TXI9/FLsKqFbwUw/2qyajK9Pj/jAuZ5p8VwyFsYJfOdy0ev2ANRZOUkqi
 fAFyd0aB09//uoLJsO3wd46e86x6XY3znxMaEhEep/fTZSDf26lsCpUQKp+Q4l1I6FLKpx1AUGOq
 20qlCtL7d/CfAxwng1Tqs6dfDGEynfOJ80PFhFtrmQd6L9DFFO6HD+qfbulEfJrQCJbsRI3z3hh4
 JA=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:BNYEmWFu2n0=:5Yx7FlALmq8CE5BBUGK94j
 5CxzlKKCKTWgjlVsW+wbRy6UH2VOBuBLD9+u0k9A2BtZnyjS2vvbUnQOqaEH8sMuTlcMIM/c4
 XSW73UEzcCnwPUzNPwZNLTcTYifIB1wyk3yqzTBpPc3cgT+If79f36G6UxQ1sovIucLiiZPE6
 PY/1ZAuiYLFllw8JF0yCQXacg22KjkzQPqB9EvC8UCcPMCWZ051VgjnJRfmm3n53aKfS2/U9L
 sLq9elPmrVzYSXeujhgslCtRD1gI17pYHvwJ5TxRKrS8yjvTWrkqDbDclLIdEU26ENPuutmv/
 0nDJO5P7sdmLLHeuirB4Ycm88U6qSU2Z6vBH9lXhFNC2m/8/99zD+hqNvthNmp+1DBo2ho+lF
 hDIpxZV2P+flopn8zPj5EiM/oVUZxbKD9xQtapFzXRghvT/SnNwowPlw5q2usueh+/ykz8HkJ
 q3tW2GOPYKlF0NK5FEp8kWOTPQh1MU0Zd+/A61W/KB1BDfQtNNtlWZcfh5t2/Pp2J6vsxCviw
 V3Ul5H/+eYSMu5ubpMimyMtDkjx6dsgIKw7sSJeYxobkAjr5GYOuMP1vTzmvdLgU0ytgY0FkI
 IR8AFntpDxKkzmFmoyk3JUwQWKUMjZvtmpf6X0DzM3ODAT1OtGGsie0Nh8F/7EBSSvQkhnMwY
 5qaYrIjztlaHdUBD2wtQQGpMqOrm6kdDV3cPOvMOOyF+XuJULukybFighIgVIaZD5O5n8N1Gq
 9uEsX/56zsdvN3tkGi6xOu1BY27eR1z3UEHu6rS0EK+xKTn1Nyvx5UwA/QLU5qh0zq4V9Sp0G
 dNoWcXwOw2DrmPtEt2B888J5bqGIE2clognuiEz2DhNlgSRrLEj65o7dIc9X2Hyzqo1muqBTB
 djILKKNNClpj+xxJknXgwvigcd0Abp9uxvJd7BvZ3QGcqnxfJvdbVwCwy972A5YGAAbZLv/x0
 7+yMB/6anSw==
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Sonntag, 16. Mai 2021 um 23:17 Uhr
> Von: "Stephen Hemminger" <stephen@networkplumber.org>

> It is possible to mostly do a cross build if you do:
>
> $ make CC=3D"$CC" LD=3D"$LD"
> There are issues with netem local table generation

Hi,

thank you for your answer, but with this way i got this:

./normal > normal.dist
./normal: error while loading shared libraries: libm.so.6: cannot open sha=
red object file: No such file or directory

i guess it's the netem issue you've mentioned, imho i cannot install armhf=
-libs on ubuntu, so i disabled subdirs in Makefile beginning with netem

-SUBDIRS=3Dlib ip tc bridge misc netem genl tipc devlink rdma dcb man vdpa
+SUBDIRS=3Dlib ip tc bridge misc
+#netem genl tipc devlink rdma dcb man vdpa

it seems to did it now

$ file ip/ip
ip/ip: ELF 32-bit LSB executable, ARM, EABI5 version 1 (GNU/Linux), static=
ally linked, BuildID[sha1]=3Db36e094bc8681713d91ffe3a085ad4d3c6a1c5ea, for=
 GNU/Linux 3.2.0, not stripped

thank you

regards Frank
