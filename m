Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F1C2A2FD1
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 17:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgKBQaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 11:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgKBQaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 11:30:23 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0B1C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 08:30:22 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id 12so8080780qkl.8
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 08:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S+jPI/Czyy9ztw15K/lYggZBsxfcsA72ng52PmNeu9c=;
        b=IlEneqTUSt0yczoBpuQheoD/obEodZcRPLaqnetDMuiRISgBcDtg+I/Em9gOcpbMhc
         xAugJpeH2K8pK9WbOzv6RIp47j0fJCwcV+t3Gt9gKJEwiWO43kCeYsA5ynf8nTphV0GZ
         2b52BvXnso6/cXRp926pYfhQjnfWbuXLr3b+BgsKWHI0eau3Yn0PF8k/fBWag1/lTk9l
         e2LjMz1XfH/48uJUM7IHCpOF7U2OAx4dwh5y4AwdK2UXiASzGQmzv2EjxSxMjAH/iNpz
         x/dHyH8qAV0cwozhcxtATA/m5RI7be3g3aSW4zP2ey/c4ymqIm6Fyv+Cyqi9gQ7YqHPM
         j9jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S+jPI/Czyy9ztw15K/lYggZBsxfcsA72ng52PmNeu9c=;
        b=ALkwo3xXFti8O2IYgEmETxIgY/yptcgeGid6szuyriKSLvwtmIgR+1fTrtqPbNZuzT
         aVkPffq1CAd+Bm1sIxxauoTDPnjt2TcGofrB5t/siEoTXS1Gl7dQ4aMsolWQw8ZFDQA/
         HIAxq2r48dBfVAwlmKNg3YucbpNyONb15/gNt5EmL7X6CYrdylr4PD/EQ+wyWujQjINs
         fgDZ1tQ1XO37+h+2Dog7SNWa/lKMDyBEIDBTeCnTe12fySr0P5yhtmMf2/SeRRCCEfCY
         1Fl5RyPpv+1IaPd/BdhW9u+MhsdDLXVK5Zu9FqTy37jsPGWXQQvxIaTVazoZAjIA+ql+
         6wyw==
X-Gm-Message-State: AOAM533RhjLmr3h4Yl3r4Ve2rMVqPtF0EzWKa/mlDRIKh4jsl7M7ym/B
        oBATmYfoDgao+7VN0WeEI/SRg/S2LYxO2WAVLhs=
X-Google-Smtp-Source: ABdhPJxFoEV1EkA1UFN6/IURvBP8dbW+tjqSnRUvzbXKeP/Pqmgm+GHScrc/5TH3n7JUo1zlU2xzfJoYj/OPTr5JdQA=
X-Received: by 2002:a37:9cd3:: with SMTP id f202mr15221124qke.479.1604334622108;
 Mon, 02 Nov 2020 08:30:22 -0800 (PST)
MIME-Version: 1.0
References: <CAOKSTBtcsqFZTzvgF-HQGRmvcd=Qanq7r2PREB2qGmnSQZJ_-A@mail.gmail.com>
 <CAOKSTBuRw-H2VbADd6b0dw=cLBz+wwOCc7Bwz_pGve6_XHrqfw@mail.gmail.com>
 <c743770c-93a4-ad72-c883-faa0df4fa372@gmail.com> <CAOKSTBuP0+jjmSYNwi3RB=VYROVY08+DOqnu8=YL5zTgy-RnDw@mail.gmail.com>
 <fb81f07e-911a-729e-337d-e1cfe38b80ff@gmail.com>
In-Reply-To: <fb81f07e-911a-729e-337d-e1cfe38b80ff@gmail.com>
From:   Gilberto Nunes <gilberto.nunes32@gmail.com>
Date:   Mon, 2 Nov 2020 13:29:44 -0300
Message-ID: <CAOKSTBs6F=RWEWOv5OkLd25GsOk1c9Xf8yX6WSy_sKvLmdX86w@mail.gmail.com>
Subject: Re: Fwd: Problem with r8169 module
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From kernel 5.4

ethtool -d enp1s0f1
RealTek RTL8411 registers:
--------------------------------------------------------
0x00: MAC Address                      98:29:a6:e6:e5:6a
0x08: Multicast Address Filter     0xffffffff 0xffffffff
0x10: Dump Tally Counter Command   0xffffe000 0x00000000
0x20: Tx Normal Priority Ring Addr 0xff50b000 0x00000000
0x28: Tx High Priority Ring Addr   0x00000000 0x00000000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x00
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x003f
      LinkChg RxNoBuf TxErr TxOK RxErr RxOK
0x3E: Interrupt Status                            0x0000

0x40: Tx Configuration                        0x5f800f80
0x44: Rx Configuration                        0x0002cf0f
0x48: Timer count                             0x00000000
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x10
0x51: Config 0                                      0x00
0x52: Config 1                                      0xcf
0x53: Config 2                                      0x3c
0x54: Config 3                                      0x60
0x55: Config 4                                      0x11
0x56: Config 5                                      0x02
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x00000000
0x64: TBI control and status                  0x12011025
0x68: TBI Autonegotiation advertisement (ANAR)    0xf02c
0x6A: TBI Link partner ability (LPAR)             0x8000
0x6C: PHY status                                    0xeb
0x84: PM wakeup frame 0            0x00000000 0x00000000
0x8C: PM wakeup frame 1            0x00000000 0x00000000
0x94: PM wakeup frame 2 (low)      0x00000000 0x00000000
0x9C: PM wakeup frame 2 (high)     0x00000000 0x00000000
0xA4: PM wakeup frame 3 (low)      0x00000000 0x00000000
0xAC: PM wakeup frame 3 (high)     0x00000000 0x00000001
0xB4: PM wakeup frame 4 (low)      0x00000000 0xd205cde1
0xBC: PM wakeup frame 4 (high)     0x00000000 0x00000000
0xC4: Wakeup frame 0 CRC                          0x0000
0xC6: Wakeup frame 1 CRC                          0x0000
0xC8: Wakeup frame 2 CRC                          0x0000
0xCA: Wakeup frame 3 CRC                          0x0000
0xCC: Wakeup frame 4 CRC                          0x0000
0xDA: RX packet maximum size                      0x4000
0xE0: C+ Command                                  0x2060
      VLAN de-tagging
      RX checksumming
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0xff50f000 0x00000000
0xEC: Early Tx threshold                            0x27
0xF0: Func Event                              0x0000003f
0xF4: Func Event Mask                         0x00000000
0xF8: Func Preset State                       0x00000003
0xFC: Func Force Event                        0x00000000

From kernel 5.9.3

ethtool -d enp1s0f1
RealTek RTL8411 registers:
--------------------------------------------------------
0x00: MAC Address                      98:29:a6:e6:e5:6a
0x08: Multicast Address Filter     0xffffffff 0xffffffff
0x10: Dump Tally Counter Command   0xffffe000 0x00000000
0x20: Tx Normal Priority Ring Addr 0xff582000 0x00000000
0x28: Tx High Priority Ring Addr   0x00000000 0x00000000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x00
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x003f
      LinkChg RxNoBuf TxErr TxOK RxErr RxOK
0x3E: Interrupt Status                            0x0000

0x40: Tx Configuration                        0x5f800f80
0x44: Rx Configuration                        0x0002cf0f
0x48: Timer count                             0x00000000
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x10
0x51: Config 0                                      0x00
0x52: Config 1                                      0xcf
0x53: Config 2                                      0x3c
0x54: Config 3                                      0x60
0x55: Config 4                                      0x11
0x56: Config 5                                      0x02
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x00000000
0x64: TBI control and status                  0x12011025
0x68: TBI Autonegotiation advertisement (ANAR)    0xf02c
0x6A: TBI Link partner ability (LPAR)             0x8000
0x6C: PHY status                                    0xeb
0x84: PM wakeup frame 0            0x00000000 0x00000000
0x8C: PM wakeup frame 1            0x00000000 0x00000000
0x94: PM wakeup frame 2 (low)      0x00000000 0x00000000
0x9C: PM wakeup frame 2 (high)     0x00000000 0x00000000
0xA4: PM wakeup frame 3 (low)      0x00000000 0x00000000
0xAC: PM wakeup frame 3 (high)     0x00000000 0x00000001
0xB4: PM wakeup frame 4 (low)      0x00000000 0xd21a30de
0xBC: PM wakeup frame 4 (high)     0x00000000 0x00000000
0xC4: Wakeup frame 0 CRC                          0x0000
0xC6: Wakeup frame 1 CRC                          0x0000
0xC8: Wakeup frame 2 CRC                          0x0000
0xCA: Wakeup frame 3 CRC                          0x0000
0xCC: Wakeup frame 4 CRC                          0x0000
0xDA: RX packet maximum size                      0x4000
0xE0: C+ Command                                  0x2060
      VLAN de-tagging
      RX checksumming
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0xff583000 0x00000000
0xEC: Early Tx threshold                            0x27
0xF0: Func Event                              0x0000003f
0xF4: Func Event Mask                         0x00000000
0xF8: Func Preset State                       0x00000003
0xFC: Func Force Event                        0x00000000


I also noticed this message when ran update-initramfs -k all -u when
installed kernel 5.9.3.
I had made a git clone from linux-firmware and copied this missed
firmware but no change!

W: Possible missing firmware /lib/firmware/rtl_nic/rtl8125b-2.fw for
module r8169



---
Gilberto Nunes Ferreira



Em seg., 2 de nov. de 2020 =C3=A0s 10:40, Heiner Kallweit
<hkallweit1@gmail.com> escreveu:
>
> On 02.11.2020 14:20, Gilberto Nunes wrote:
> > Hi
> >
> > ethtool using 5.4
> >
> ethtool doesn't know about the actual speed, because the downshift
> occurs PHY-internally. Please test actual the speed.
> Alternatively provide the output of ethtool -d <if>, the RTL8169
> chip family has an internal register refkecting the actual link speed.
