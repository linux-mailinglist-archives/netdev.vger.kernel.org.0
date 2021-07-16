Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F143CB4B7
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 10:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238414AbhGPIxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 04:53:20 -0400
Received: from mout.gmx.net ([212.227.17.20]:42823 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238379AbhGPIxG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 04:53:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626425394;
        bh=U0bBKpoVK6DUuOVG/9JH3MpVun7q+0cqcYQpS27Sw4M=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Htf+60TH6PiU/yOGYKLg6Gadpnp8eDbwEsFcD2UO3CkFpc4THYNAA+YAVMWMDNot3
         sTqfyoW2riEB/sPnFxMrMl6AIdBp8Wu4/sB6exXNNC6GwwPw3SJDreeUSAbeLzMMwK
         gNrw+rV+SpWf8+VMaOm3H9mSp/2HVq7gIEHpjbPc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [87.130.101.138] ([87.130.101.138]) by web-mail.gmx.net
 (3c-app-gmx-bap63.server.lan [172.19.172.133]) (via HTTP); Fri, 16 Jul 2021
 10:49:54 +0200
MIME-Version: 1.0
Message-ID: <trinity-c43ccfd0-a67d-4622-b202-66460c296c72-1626425394103@3c-app-gmx-bap63>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Aw: Re: [PATCH 0/2] Fixes for KSZ DSA switch
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 16 Jul 2021 10:49:54 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <d205b518-fb47-9065-1e82-de0f9286cb60@gmail.com>
References: <20210714191723.31294-1-LinoSanfilippo@gmx.de>
 <d205b518-fb47-9065-1e82-de0f9286cb60@gmail.com>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:DG6L1b4Bpbnvizv1xoT32Z0SfvWRlAGGgDhiuWkProoZ33CleI7jGC6COmP662CkPU0mk
 /HcqBnaZtzpIr4zmHQmacmYQYYjTJcydCe4wI76d2jHgoLmL/YBy3hwBOXqi0zjszNxz4yaDQYp9
 p+OYdo+D32nG2kE0TQLXW4Ch9UU/sP8et6PlMPRslzugJd4XWXzAu0nk3uYw0CkoMhlkaUJeE+R7
 yyke1TvUfvbQ1UkWCid096JjyxRW856kwSMXo832GTqBe6XiqRhiEChcGLP0yR43BwhohsjNTL+F
 /M=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:XrjL3vnfxPk=:GhaLaiU3q4YoMeRLHCbMtC
 8BdonxI/g3bjYRV3E7oon2ChTm64ffk2mX1g/X0eq4pL25I4/LJYgRqjfkf+fH1PHufvTrqTE
 j5nCBZlEdXOSzhSsRf7xBDeyQDUlgFRrJ8HgpHTTM8+xEDtQGuiJGuxK72ei7eZEhvzD3kmMW
 x8OxgesakZjtawP2AxlkP63PDuSDQQyGuPRlmpUxBlf9hKlIgAsxPCfNFfabPFORp3slvAQiR
 2tnQLu7M7rnnBfQcglM60hWdQ2udSq+gLImQJMNOk21LJ/2LpEo3QieQ/0OwoHXcbhEi1c4SZ
 ufO+yrNrIjKeK91JGU2T9lbXv9YSHZrdQUiaioTrk3lmZvjY73fZO7ZxLMpYPh0dTcBlGn8D0
 hLPmEaKB6t4Xh0LvmSYO9LAq5QMlWoS8UeZB23oDLrZaaJWO7vOQK42mwTf/NwTv65pGqc/NQ
 c8bfZ/7bON8oROKuSJc2OtSXTrdW5QXRWF9XOuCFKlWt3S9Kn+SWufGE8Nc/y4hsVZRTRTOX+
 ltyjpxNzNBuYNmAh3goOzFfJvM4662jQ0MFeJEtSKFg4OnS3ATGGgGPltvRw3Jsl8L/JQuKb0
 iBqHsx7ZRC0c1xFb+IApnlwKZCYAJaHnJ6D5A/Q3mAvx6dkyohjQU53m/BudaSRGU09IrG4pn
 7Ev+Kz/sqToUtUFugp7v7YzLZen5j/oQct52V5Tgl0v4TzvJAfc7fjlsqmq1IspNPZLVAEtp8
 GKSLnJdf5k3uDHJeUq4indRVWDgOPa52sIA8r0qXqgr+PRWYiI/DLNlfl1ROxrHHI6ZHOPxpg
 0DZa8X1ZlIcNCppXE+dzkyEjkVrIE/m1TOKXCALLWU0kHP7fYM=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

> Gesendet: Freitag, 16. Juli 2021 um 01:23 Uhr
> Von: "Florian Fainelli" <f.fainelli@gmail.com>
> An: "Lino Sanfilippo" <LinoSanfilippo@gmx.de>, woojung.huh@microchip.com
> Cc: UNGLinuxDriver@microchip.com, andrew@lunn.ch, vivien.didelot@gmail.c=
om, olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org, netdev@vger.k=
ernel.org, linux-kernel@vger.kernel.org
> Betreff: Re: [PATCH 0/2] Fixes for KSZ DSA switch
>
> On 7/14/21 12:17 PM, Lino Sanfilippo wrote:
> > These patches fix issues I encountered while using a KSZ9897 as a DSA
> > switch with a broadcom GENET network device as the DSA master device.
> >
>
> Is this off the shelf hardware that can be interfaced to a Raspberry Pi
> 4 or is this a custom design that only you have access to?
>

The setup I use is a Raspberry Pi 4 connected to an EVB KSZ9897 from Micro=
chip:

https://www.microchip.com/DevelopmentTools/ProductDetails/PartNO/EVB-KSZ98=
97-1

Best regards,
Lino
