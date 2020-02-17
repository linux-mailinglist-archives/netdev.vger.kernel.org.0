Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBCBC16196E
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 19:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729837AbgBQSIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 13:08:31 -0500
Received: from mail-lj1-f180.google.com ([209.85.208.180]:40628 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbgBQSIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 13:08:30 -0500
Received: by mail-lj1-f180.google.com with SMTP id n18so19874120ljo.7
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 10:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=25FtdJY4SvmtH5zcJSSGK6KzDfkA5FELvZRgdubDVgM=;
        b=myl7UhG+2wdxaZk9rtycluaSlBPT3LMMLhlS5qxs+Altll4PVqO2AUy9Tpo7RmFgAX
         Z53CrkBdYPghyK+IS5oLDT8bHV+sYwP3HPtwgYe50vBl/9JoYW/g2U/V16wlVMyCNuuy
         iJmJ/PgGi1cSgOv7/mRFP/B88B3ccPAcDoaXQdc0CkdYIkfaLWIVidLWS8v48Lvpf+6o
         a4tOaRS6+NJBB95AEPMZ1EjAfmkjKzp6CPhuHFQ1zhBGqohZ3LnxQ+X4cX5zV2mWfB1K
         h3mRC7PPSbA3e4zY/caimQR+kqHUo/D7xKE+d9JwdaNg3VvUAsSgfDhtZdd8TI5maf0V
         W9Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=25FtdJY4SvmtH5zcJSSGK6KzDfkA5FELvZRgdubDVgM=;
        b=N1TujAqbxmnUw7vPdiTwz2k/I3Y+NvmDuf2ZMZMpPXlWNEqCiG+E9JY8BWXGYeLVQ9
         BQ+85r2S+PUXuF2xscCR1y84VYiAM2T5hq9yZ+uP0McXJRwWfTutU8IEcCsK2kj/h7q4
         2gV60yX/9E+OHh0+U/dg6PlGpgegHoin+qpH6VsnGwXQ/eYcK4KXS2i46sxZDmAwb9yw
         3grYEwHwHzfBgb2BrvTSOaEtzc3YGayJTYBMgVqEflKZdk8r2nbEhiA47qtbSe/8lwgy
         m1xLtv1XTClrGw2BQof5DdynWPZTXvxRxdfbe4OvpwRoUAQP84AJuILEx0ZrlbVgxAhD
         8PQg==
X-Gm-Message-State: APjAAAVKjLWfrm/k9QF1l94OQiOPnPy+ZDdnh6i7680wMkry1Zq+pwLN
        xiG4QtbUvsOWNAWiuJzzibggaklW
X-Google-Smtp-Source: APXvYqyTFGwQjVtGG72tXXJ4TU11uhseygPCfZTTW9W/SqikZlS8fXoPc/gZfrvXBglXEsRaSBPy/g==
X-Received: by 2002:a2e:b5a5:: with SMTP id f5mr10536364ljn.162.1581962892718;
        Mon, 17 Feb 2020 10:08:12 -0800 (PST)
Received: from [192.168.1.10] (hst-227-49.splius.lt. [62.80.227.49])
        by smtp.gmail.com with ESMTPSA id h24sm837865ljc.84.2020.02.17.10.08.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 10:08:11 -0800 (PST)
Subject: Re: About r8169 regression 5.4
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Cc:     netdev@vger.kernel.org
References: <b46d29d8-faf6-351e-0d9f-a4d4c043a54c@gmail.com>
 <9e865e39-0406-d5e0-5022-9978ef4ec6ac@gmail.com>
 <97b0eb30-7ae2-80e2-6961-f52a8bb26b81@gmail.com>
 <20200215161247.GA179065@eldamar.local>
 <269f588f-78f2-4acf-06d3-eeefaa5d8e0f@gmail.com>
 <3ad8a76d-5da1-eb62-689e-44ea0534907f@gmail.com>
 <74c2d5db-3396-96c4-cbb3-744046c55c46@gmail.com>
From:   Vincas Dargis <vindrg@gmail.com>
Message-ID: <81548409-2fd3-9645-eeaf-ab8f7789b676@gmail.com>
Date:   Mon, 17 Feb 2020 20:08:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <74c2d5db-3396-96c4-cbb3-744046c55c46@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------6B4E476C6BC68787477D6DB6"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------6B4E476C6BC68787477D6DB6
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

2020-02-16 01:27, Heiner Kallweit rašė:
> One more idea:
> Commit "r8169: enable HW csum and TSO" enables certain hardware offloading by default.
> Maybe your chip version has a hw issue with offloading. You could try:
> 
> 1. Disable TSO
> ethtool -K <if> tso off
> 
> 2. If this didn't help, disable all offloading.
> ethtool -K <if> tx off sg off tso off
> 

Unmodified 5.4 was running successfully for whole Sunday with `tx off sg off tso off`! Disabling only tso did not help, while disabling all actually avoided the timeout.

I've attached kern.log from boot 'til 5.4 got that timeout (when I did not use these off's).

About bisecting - I need to figure out how to build linux-image and linux-headers package only, to reduce that almost hour build...

--------------6B4E476C6BC68787477D6DB6
Content-Type: text/x-log; charset=UTF-8;
 name="kern.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="kern.log"

Feb 17 19:00:29 vinco kernel: [    0.000000] microcode: microcode updated=
 early to revision 0x27, date =3D 2019-02-26
Feb 17 19:00:29 vinco kernel: [    0.000000] Linux version 5.4.0-4-amd64 =
(debian-kernel@lists.debian.org) (gcc version 9.2.1 20200203 (Debian 9.2.=
1-28)) #1 SMP Debian 5.4.19-1 (2020-02-13)
Feb 17 19:00:29 vinco kernel: [    0.000000] Command line: BOOT_IMAGE=3D/=
vmlinuz-5.4.0-4-amd64 root=3DUUID=3D795ee075-978f-4245-9dad-ecccd37080d8 =
ro quiet apparmor=3D1 security=3Dapparmor
Feb 17 19:00:29 vinco kernel: [    0.000000] x86/fpu: Supporting XSAVE fe=
ature 0x001: 'x87 floating point registers'
Feb 17 19:00:29 vinco kernel: [    0.000000] x86/fpu: Supporting XSAVE fe=
ature 0x002: 'SSE registers'
Feb 17 19:00:29 vinco kernel: [    0.000000] x86/fpu: Supporting XSAVE fe=
ature 0x004: 'AVX registers'
Feb 17 19:00:29 vinco kernel: [    0.000000] x86/fpu: xstate_offset[2]:  =
576, xstate_sizes[2]:  256
Feb 17 19:00:29 vinco kernel: [    0.000000] x86/fpu: Enabled xstate feat=
ures 0x7, context size is 832 bytes, using 'standard' format.
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-provided physical RAM m=
ap:
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x0000000000=
000000-0x0000000000057fff] usable
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x0000000000=
058000-0x0000000000058fff] reserved
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x0000000000=
059000-0x000000000009efff] usable
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x0000000000=
09f000-0x000000000009ffff] reserved
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x0000000000=
100000-0x00000000b9754fff] usable
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000b9=
755000-0x00000000b975bfff] ACPI NVS
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000b9=
75c000-0x00000000b9fd4fff] usable
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000b9=
fd5000-0x00000000ba275fff] reserved
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000ba=
276000-0x00000000c98c5fff] usable
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000c9=
8c6000-0x00000000c9acefff] reserved
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000c9=
acf000-0x00000000c9e00fff] usable
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000c9=
e01000-0x00000000cab05fff] ACPI NVS
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000ca=
b06000-0x00000000caf59fff] reserved
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000ca=
f5a000-0x00000000caffefff] type 20
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000ca=
fff000-0x00000000caffffff] usable
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000cb=
c00000-0x00000000cfdfffff] reserved
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000f8=
000000-0x00000000fbffffff] reserved
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000fe=
c00000-0x00000000fec00fff] reserved
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000fe=
d00000-0x00000000fed03fff] reserved
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000fe=
d1c000-0x00000000fed1ffff] reserved
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000fe=
e00000-0x00000000fee00fff] reserved
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000ff=
000000-0x00000000ffffffff] reserved
Feb 17 19:00:29 vinco kernel: [    0.000000] BIOS-e820: [mem 0x0000000100=
000000-0x000000042f1fffff] usable
Feb 17 19:00:29 vinco kernel: [    0.000000] NX (Execute Disable) protect=
ion: active
Feb 17 19:00:29 vinco kernel: [    0.000000] efi: EFI v2.31 by American M=
egatrends
Feb 17 19:00:29 vinco kernel: [    0.000000] efi:  ACPI 2.0=3D0xc9e89000 =
 ACPI=3D0xc9e89000  SMBIOS=3D0xf04c0  MPS=3D0xfd5a0=20
Feb 17 19:00:29 vinco kernel: [    0.000000] secureboot: Secure boot coul=
d not be determined (mode 0)
Feb 17 19:00:29 vinco kernel: [    0.000000] SMBIOS 2.7 present.
Feb 17 19:00:29 vinco kernel: [    0.000000] DMI: ASUSTeK COMPUTER INC. N=
551JM/N551JM, BIOS N551JM.205 02/13/2015
Feb 17 19:00:29 vinco kernel: [    0.000000] tsc: Fast TSC calibration us=
ing PIT
Feb 17 19:00:29 vinco kernel: [    0.000000] tsc: Detected 2494.164 MHz p=
rocessor
Feb 17 19:00:29 vinco kernel: [    0.001378] e820: update [mem 0x00000000=
-0x00000fff] usable =3D=3D> reserved
Feb 17 19:00:29 vinco kernel: [    0.001379] e820: remove [mem 0x000a0000=
-0x000fffff] usable
Feb 17 19:00:29 vinco kernel: [    0.001384] last_pfn =3D 0x42f200 max_ar=
ch_pfn =3D 0x400000000
Feb 17 19:00:29 vinco kernel: [    0.001388] MTRR default type: uncachabl=
e
Feb 17 19:00:29 vinco kernel: [    0.001388] MTRR fixed ranges enabled:
Feb 17 19:00:29 vinco kernel: [    0.001389]   00000-9FFFF write-back
Feb 17 19:00:29 vinco kernel: [    0.001390]   A0000-BFFFF uncachable
Feb 17 19:00:29 vinco kernel: [    0.001390]   C0000-CFFFF write-protect
Feb 17 19:00:29 vinco kernel: [    0.001391]   D0000-DFFFF uncachable
Feb 17 19:00:29 vinco kernel: [    0.001391]   E0000-FFFFF write-protect
Feb 17 19:00:29 vinco kernel: [    0.001392] MTRR variable ranges enabled=
:
Feb 17 19:00:29 vinco kernel: [    0.001393]   0 base 0000000000 mask 7C0=
0000000 write-back
Feb 17 19:00:29 vinco kernel: [    0.001393]   1 base 0400000000 mask 7FE=
0000000 write-back
Feb 17 19:00:29 vinco kernel: [    0.001394]   2 base 0420000000 mask 7FF=
0000000 write-back
Feb 17 19:00:29 vinco kernel: [    0.001394]   3 base 00E0000000 mask 7FE=
0000000 uncachable
Feb 17 19:00:29 vinco kernel: [    0.001395]   4 base 00D0000000 mask 7FF=
0000000 uncachable
Feb 17 19:00:29 vinco kernel: [    0.001395]   5 base 00CC000000 mask 7FF=
C000000 uncachable
Feb 17 19:00:29 vinco kernel: [    0.001396]   6 base 00CBC00000 mask 7FF=
FC00000 uncachable
Feb 17 19:00:29 vinco kernel: [    0.001396]   7 base 042F800000 mask 7FF=
F800000 uncachable
Feb 17 19:00:29 vinco kernel: [    0.001397]   8 base 042F400000 mask 7FF=
FC00000 uncachable
Feb 17 19:00:29 vinco kernel: [    0.001397]   9 base 042F200000 mask 7FF=
FE00000 uncachable
Feb 17 19:00:29 vinco kernel: [    0.001660] x86/PAT: Configuration [0-7]=
: WB  WC  UC- UC  WB  WP  UC- WT =20
Feb 17 19:00:29 vinco kernel: [    0.001766] e820: update [mem 0xcbc00000=
-0xffffffff] usable =3D=3D> reserved
Feb 17 19:00:29 vinco kernel: [    0.001768] last_pfn =3D 0xcb000 max_arc=
h_pfn =3D 0x400000000
Feb 17 19:00:29 vinco kernel: [    0.007745] found SMP MP-table at [mem 0=
x000fd8a0-0x000fd8af]
Feb 17 19:00:29 vinco kernel: [    0.007759] Using GB pages for direct ma=
pping
Feb 17 19:00:29 vinco kernel: [    0.007760] BRK [0x1eae01000, 0x1eae01ff=
f] PGTABLE
Feb 17 19:00:29 vinco kernel: [    0.007762] BRK [0x1eae02000, 0x1eae02ff=
f] PGTABLE
Feb 17 19:00:29 vinco kernel: [    0.007762] BRK [0x1eae03000, 0x1eae03ff=
f] PGTABLE
Feb 17 19:00:29 vinco kernel: [    0.007803] BRK [0x1eae04000, 0x1eae04ff=
f] PGTABLE
Feb 17 19:00:29 vinco kernel: [    0.007804] BRK [0x1eae05000, 0x1eae05ff=
f] PGTABLE
Feb 17 19:00:29 vinco kernel: [    0.008013] BRK [0x1eae06000, 0x1eae06ff=
f] PGTABLE
Feb 17 19:00:29 vinco kernel: [    0.008048] BRK [0x1eae07000, 0x1eae07ff=
f] PGTABLE
Feb 17 19:00:29 vinco kernel: [    0.008140] BRK [0x1eae08000, 0x1eae08ff=
f] PGTABLE
Feb 17 19:00:29 vinco kernel: [    0.008175] BRK [0x1eae09000, 0x1eae09ff=
f] PGTABLE
Feb 17 19:00:29 vinco kernel: [    0.008207] BRK [0x1eae0a000, 0x1eae0aff=
f] PGTABLE
Feb 17 19:00:29 vinco kernel: [    0.008258] BRK [0x1eae0b000, 0x1eae0bff=
f] PGTABLE
Feb 17 19:00:29 vinco kernel: [    0.008327] BRK [0x1eae0c000, 0x1eae0cff=
f] PGTABLE
Feb 17 19:00:29 vinco kernel: [    0.008585] RAMDISK: [mem 0x30ed7000-0x3=
4762fff]
Feb 17 19:00:29 vinco kernel: [    0.008590] ACPI: Early table checksum v=
erification disabled
Feb 17 19:00:29 vinco kernel: [    0.008592] ACPI: RSDP 0x00000000C9E8900=
0 000024 (v02 _ASUS_)
Feb 17 19:00:29 vinco kernel: [    0.008595] ACPI: XSDT 0x00000000C9E8908=
8 00009C (v01 _ASUS_ Notebook 01072009 AMI  00010013)
Feb 17 19:00:29 vinco kernel: [    0.008598] ACPI: FACP 0x00000000C9E9CF3=
8 00010C (v05 _ASUS_ Notebook 01072009 AMI  00010013)
Feb 17 19:00:29 vinco kernel: [    0.008602] ACPI: DSDT 0x00000000C9E8924=
0 013CF2 (v02 _ASUS_ Notebook 00000012 INTL 20120711)
Feb 17 19:00:29 vinco kernel: [    0.008604] ACPI: FACS 0x00000000CAB03F8=
0 000040
Feb 17 19:00:29 vinco kernel: [    0.008606] ACPI: APIC 0x00000000C9E9D04=
8 000092 (v03 _ASUS_ Notebook 01072009 AMI  00010013)
Feb 17 19:00:29 vinco kernel: [    0.008607] ACPI: FPDT 0x00000000C9E9D0E=
0 000044 (v01 _ASUS_ Notebook 01072009 AMI  00010013)
Feb 17 19:00:29 vinco kernel: [    0.008609] ACPI: ECDT 0x00000000C9E9D12=
8 0000C1 (v01 _ASUS_ Notebook 01072009 AMI. 00000005)
Feb 17 19:00:29 vinco kernel: [    0.008611] ACPI: SSDT 0x00000000C9E9D1F=
0 00019D (v01 Intel  zpodd    00001000 INTL 20120711)
Feb 17 19:00:29 vinco kernel: [    0.008613] ACPI: SSDT 0x00000000C9E9D39=
0 000539 (v01 PmRef  Cpu0Ist  00003000 INTL 20120711)
Feb 17 19:00:29 vinco kernel: [    0.008615] ACPI: SSDT 0x00000000C9E9D8D=
0 000AD8 (v01 PmRef  CpuPm    00003000 INTL 20120711)
Feb 17 19:00:29 vinco kernel: [    0.008616] ACPI: MCFG 0x00000000C9E9E3A=
8 00003C (v01 _ASUS_ Notebook 01072009 MSFT 00000097)
Feb 17 19:00:29 vinco kernel: [    0.008618] ACPI: HPET 0x00000000C9E9E3E=
8 000038 (v01 _ASUS_ Notebook 01072009 AMI. 00000005)
Feb 17 19:00:29 vinco kernel: [    0.008620] ACPI: SSDT 0x00000000C9E9E42=
0 000298 (v01 SataRe SataTabl 00001000 INTL 20120711)
Feb 17 19:00:29 vinco kernel: [    0.008622] ACPI: SSDT 0x00000000C9E9E6B=
8 004541 (v01 SaSsdt SaSsdt   00003000 INTL 20091112)
Feb 17 19:00:29 vinco kernel: [    0.008623] ACPI: SSDT 0x00000000C9EA2C0=
0 001983 (v01 SgRef  SgPeg    00001000 INTL 20120711)
Feb 17 19:00:29 vinco kernel: [    0.008625] ACPI: DMAR 0x00000000C9EA458=
8 0000B8 (v01 INTEL  HSW      00000001 INTL 00000001)
Feb 17 19:00:29 vinco kernel: [    0.008627] ACPI: SSDT 0x00000000C9EA464=
0 0019CA (v01 OptRef OptTabl  00001000 INTL 20120711)
Feb 17 19:00:29 vinco kernel: [    0.008629] ACPI: MSDM 0x00000000C9ACDE1=
8 000055 (v03 _ASUS_ Notebook 00000000 ASUS 00000001)
Feb 17 19:00:29 vinco kernel: [    0.008635] ACPI: Local APIC address 0xf=
ee00000
Feb 17 19:00:29 vinco kernel: [    0.008699] No NUMA configuration found
Feb 17 19:00:29 vinco kernel: [    0.008699] Faking a node at [mem 0x0000=
000000000000-0x000000042f1fffff]
Feb 17 19:00:29 vinco kernel: [    0.008702] NODE_DATA(0) allocated [mem =
0x42f1f9000-0x42f1fdfff]
Feb 17 19:00:29 vinco kernel: [    0.008726] Zone ranges:
Feb 17 19:00:29 vinco kernel: [    0.008727]   DMA      [mem 0x0000000000=
001000-0x0000000000ffffff]
Feb 17 19:00:29 vinco kernel: [    0.008727]   DMA32    [mem 0x0000000001=
000000-0x00000000ffffffff]
Feb 17 19:00:29 vinco kernel: [    0.008728]   Normal   [mem 0x0000000100=
000000-0x000000042f1fffff]
Feb 17 19:00:29 vinco kernel: [    0.008729]   Device   empty
Feb 17 19:00:29 vinco kernel: [    0.008729] Movable zone start for each =
node
Feb 17 19:00:29 vinco kernel: [    0.008730] Early memory node ranges
Feb 17 19:00:29 vinco kernel: [    0.008730]   node   0: [mem 0x000000000=
0001000-0x0000000000057fff]
Feb 17 19:00:29 vinco kernel: [    0.008731]   node   0: [mem 0x000000000=
0059000-0x000000000009efff]
Feb 17 19:00:29 vinco kernel: [    0.008731]   node   0: [mem 0x000000000=
0100000-0x00000000b9754fff]
Feb 17 19:00:29 vinco kernel: [    0.008732]   node   0: [mem 0x00000000b=
975c000-0x00000000b9fd4fff]
Feb 17 19:00:29 vinco kernel: [    0.008733]   node   0: [mem 0x00000000b=
a276000-0x00000000c98c5fff]
Feb 17 19:00:29 vinco kernel: [    0.008733]   node   0: [mem 0x00000000c=
9acf000-0x00000000c9e00fff]
Feb 17 19:00:29 vinco kernel: [    0.008733]   node   0: [mem 0x00000000c=
afff000-0x00000000caffffff]
Feb 17 19:00:29 vinco kernel: [    0.008734]   node   0: [mem 0x000000010=
0000000-0x000000042f1fffff]
Feb 17 19:00:29 vinco kernel: [    0.008954] Zeroed struct page in unavai=
lable ranges: 29970 pages
Feb 17 19:00:29 vinco kernel: [    0.008955] Initmem setup node 0 [mem 0x=
0000000000001000-0x000000042f1fffff]
Feb 17 19:00:29 vinco kernel: [    0.008956] On node 0 totalpages: 416433=
4
Feb 17 19:00:29 vinco kernel: [    0.008957]   DMA zone: 64 pages used fo=
r memmap
Feb 17 19:00:29 vinco kernel: [    0.008957]   DMA zone: 26 pages reserve=
d
Feb 17 19:00:29 vinco kernel: [    0.008958]   DMA zone: 3997 pages, LIFO=
 batch:0
Feb 17 19:00:29 vinco kernel: [    0.008995]   DMA32 zone: 12838 pages us=
ed for memmap
Feb 17 19:00:29 vinco kernel: [    0.008996]   DMA32 zone: 821585 pages, =
LIFO batch:63
Feb 17 19:00:29 vinco kernel: [    0.016841]   Normal zone: 52168 pages u=
sed for memmap
Feb 17 19:00:29 vinco kernel: [    0.016842]   Normal zone: 3338752 pages=
, LIFO batch:63
Feb 17 19:00:29 vinco kernel: [    0.045337] Reserving Intel graphics mem=
ory at [mem 0xcbe00000-0xcfdfffff]
Feb 17 19:00:29 vinco kernel: [    0.045505] ACPI: PM-Timer IO Port: 0x18=
08
Feb 17 19:00:29 vinco kernel: [    0.045507] ACPI: Local APIC address 0xf=
ee00000
Feb 17 19:00:29 vinco kernel: [    0.045511] ACPI: LAPIC_NMI (acpi_id[0xf=
f] high edge lint[0x1])
Feb 17 19:00:29 vinco kernel: [    0.045521] IOAPIC[0]: apic_id 8, versio=
n 32, address 0xfec00000, GSI 0-23
Feb 17 19:00:29 vinco kernel: [    0.045522] ACPI: INT_SRC_OVR (bus 0 bus=
_irq 0 global_irq 2 dfl dfl)
Feb 17 19:00:29 vinco kernel: [    0.045523] ACPI: INT_SRC_OVR (bus 0 bus=
_irq 9 global_irq 9 high level)
Feb 17 19:00:29 vinco kernel: [    0.045524] ACPI: IRQ0 used by override.=

Feb 17 19:00:29 vinco kernel: [    0.045524] ACPI: IRQ9 used by override.=

Feb 17 19:00:29 vinco kernel: [    0.045526] Using ACPI (MADT) for SMP co=
nfiguration information
Feb 17 19:00:29 vinco kernel: [    0.045527] ACPI: HPET id: 0x8086a701 ba=
se: 0xfed00000
Feb 17 19:00:29 vinco kernel: [    0.045530] smpboot: Allowing 8 CPUs, 0 =
hotplug CPUs
Feb 17 19:00:29 vinco kernel: [    0.045546] PM: Registered nosave memory=
: [mem 0x00000000-0x00000fff]
Feb 17 19:00:29 vinco kernel: [    0.045547] PM: Registered nosave memory=
: [mem 0x00058000-0x00058fff]
Feb 17 19:00:29 vinco kernel: [    0.045549] PM: Registered nosave memory=
: [mem 0x0009f000-0x0009ffff]
Feb 17 19:00:29 vinco kernel: [    0.045549] PM: Registered nosave memory=
: [mem 0x000a0000-0x000fffff]
Feb 17 19:00:29 vinco kernel: [    0.045550] PM: Registered nosave memory=
: [mem 0xb9755000-0xb975bfff]
Feb 17 19:00:29 vinco kernel: [    0.045551] PM: Registered nosave memory=
: [mem 0xb9fd5000-0xba275fff]
Feb 17 19:00:29 vinco kernel: [    0.045552] PM: Registered nosave memory=
: [mem 0xc98c6000-0xc9acefff]
Feb 17 19:00:29 vinco kernel: [    0.045554] PM: Registered nosave memory=
: [mem 0xc9e01000-0xcab05fff]
Feb 17 19:00:29 vinco kernel: [    0.045554] PM: Registered nosave memory=
: [mem 0xcab06000-0xcaf59fff]
Feb 17 19:00:29 vinco kernel: [    0.045554] PM: Registered nosave memory=
: [mem 0xcaf5a000-0xcaffefff]
Feb 17 19:00:29 vinco kernel: [    0.045556] PM: Registered nosave memory=
: [mem 0xcb000000-0xcbbfffff]
Feb 17 19:00:29 vinco kernel: [    0.045556] PM: Registered nosave memory=
: [mem 0xcbc00000-0xcfdfffff]
Feb 17 19:00:29 vinco kernel: [    0.045556] PM: Registered nosave memory=
: [mem 0xcfe00000-0xf7ffffff]
Feb 17 19:00:29 vinco kernel: [    0.045557] PM: Registered nosave memory=
: [mem 0xf8000000-0xfbffffff]
Feb 17 19:00:29 vinco kernel: [    0.045557] PM: Registered nosave memory=
: [mem 0xfc000000-0xfebfffff]
Feb 17 19:00:29 vinco kernel: [    0.045558] PM: Registered nosave memory=
: [mem 0xfec00000-0xfec00fff]
Feb 17 19:00:29 vinco kernel: [    0.045558] PM: Registered nosave memory=
: [mem 0xfec01000-0xfecfffff]
Feb 17 19:00:29 vinco kernel: [    0.045558] PM: Registered nosave memory=
: [mem 0xfed00000-0xfed03fff]
Feb 17 19:00:29 vinco kernel: [    0.045559] PM: Registered nosave memory=
: [mem 0xfed04000-0xfed1bfff]
Feb 17 19:00:29 vinco kernel: [    0.045559] PM: Registered nosave memory=
: [mem 0xfed1c000-0xfed1ffff]
Feb 17 19:00:29 vinco kernel: [    0.045559] PM: Registered nosave memory=
: [mem 0xfed20000-0xfedfffff]
Feb 17 19:00:29 vinco kernel: [    0.045560] PM: Registered nosave memory=
: [mem 0xfee00000-0xfee00fff]
Feb 17 19:00:29 vinco kernel: [    0.045560] PM: Registered nosave memory=
: [mem 0xfee01000-0xfeffffff]
Feb 17 19:00:29 vinco kernel: [    0.045561] PM: Registered nosave memory=
: [mem 0xff000000-0xffffffff]
Feb 17 19:00:29 vinco kernel: [    0.045562] [mem 0xcfe00000-0xf7ffffff] =
available for PCI devices
Feb 17 19:00:29 vinco kernel: [    0.045563] Booting paravirtualized kern=
el on bare hardware
Feb 17 19:00:29 vinco kernel: [    0.045565] clocksource: refined-jiffies=
: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 =
ns
Feb 17 19:00:29 vinco kernel: [    0.112638] setup_percpu: NR_CPUS:512 nr=
_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:1
Feb 17 19:00:29 vinco kernel: [    0.112803] percpu: Embedded 53 pages/cp=
u s178584 r8192 d30312 u262144
Feb 17 19:00:29 vinco kernel: [    0.112809] pcpu-alloc: s178584 r8192 d3=
0312 u262144 alloc=3D1*2097152
Feb 17 19:00:29 vinco kernel: [    0.112809] pcpu-alloc: [0] 0 1 2 3 4 5 =
6 7=20
Feb 17 19:00:29 vinco kernel: [    0.112828] Built 1 zonelists, mobility =
grouping on.  Total pages: 4099238
Feb 17 19:00:29 vinco kernel: [    0.112829] Policy zone: Normal
Feb 17 19:00:29 vinco kernel: [    0.112830] Kernel command line: BOOT_IM=
AGE=3D/vmlinuz-5.4.0-4-amd64 root=3DUUID=3D795ee075-978f-4245-9dad-ecccd3=
7080d8 ro quiet apparmor=3D1 security=3Dapparmor
Feb 17 19:00:29 vinco kernel: [    0.113574] Dentry cache hash table entr=
ies: 2097152 (order: 12, 16777216 bytes, linear)
Feb 17 19:00:29 vinco kernel: [    0.113917] Inode-cache hash table entri=
es: 1048576 (order: 11, 8388608 bytes, linear)
Feb 17 19:00:29 vinco kernel: [    0.113972] mem auto-init: stack:off, he=
ap alloc:off, heap free:off
Feb 17 19:00:29 vinco kernel: [    0.116740] Calgary: detecting Calgary v=
ia BIOS EBDA area
Feb 17 19:00:29 vinco kernel: [    0.116741] Calgary: Unable to locate Ri=
o Grande table in EBDA - bailing!
Feb 17 19:00:29 vinco kernel: [    0.152158] Memory: 16022980K/16657336K =
available (10243K kernel code, 1197K rwdata, 3736K rodata, 1672K init, 20=
48K bss, 634356K reserved, 0K cma-reserved)
Feb 17 19:00:29 vinco kernel: [    0.152256] SLUB: HWalign=3D64, Order=3D=
0-3, MinObjects=3D0, CPUs=3D8, Nodes=3D1
Feb 17 19:00:29 vinco kernel: [    0.152264] Kernel/User page tables isol=
ation: enabled
Feb 17 19:00:29 vinco kernel: [    0.152274] ftrace: allocating 33946 ent=
ries in 133 pages
Feb 17 19:00:29 vinco kernel: [    0.161826] rcu: Hierarchical RCU implem=
entation.
Feb 17 19:00:29 vinco kernel: [    0.161827] rcu: 	RCU restricting CPUs f=
rom NR_CPUS=3D512 to nr_cpu_ids=3D8.
Feb 17 19:00:29 vinco kernel: [    0.161828] rcu: RCU calculated value of=
 scheduler-enlistment delay is 25 jiffies.
Feb 17 19:00:29 vinco kernel: [    0.161828] rcu: Adjusting geometry for =
rcu_fanout_leaf=3D16, nr_cpu_ids=3D8
Feb 17 19:00:29 vinco kernel: [    0.163925] NR_IRQS: 33024, nr_irqs: 488=
, preallocated irqs: 16
Feb 17 19:00:29 vinco kernel: [    0.164101] random: crng done (trusting =
CPU's manufacturer)
Feb 17 19:00:29 vinco kernel: [    0.164116] Console: colour dummy device=
 80x25
Feb 17 19:00:29 vinco kernel: [    0.164121] printk: console [tty0] enabl=
ed
Feb 17 19:00:29 vinco kernel: [    0.164133] ACPI: Core revision 20190816=

Feb 17 19:00:29 vinco kernel: [    0.164254] clocksource: hpet: mask: 0xf=
fffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
Feb 17 19:00:29 vinco kernel: [    0.164265] APIC: Switch to symmetric I/=
O mode setup
Feb 17 19:00:29 vinco kernel: [    0.164266] DMAR: Host address width 39
Feb 17 19:00:29 vinco kernel: [    0.164267] DMAR: DRHD base: 0x000000fed=
90000 flags: 0x0
Feb 17 19:00:29 vinco kernel: [    0.164270] DMAR: dmar0: reg_base_addr f=
ed90000 ver 1:0 cap c0000020660462 ecap f0101a
Feb 17 19:00:29 vinco kernel: [    0.164271] DMAR: DRHD base: 0x000000fed=
91000 flags: 0x1
Feb 17 19:00:29 vinco kernel: [    0.164273] DMAR: dmar1: reg_base_addr f=
ed91000 ver 1:0 cap d2008020660462 ecap f010da
Feb 17 19:00:29 vinco kernel: [    0.164274] DMAR: RMRR base: 0x000000c9a=
56000 end: 0x000000c9a62fff
Feb 17 19:00:29 vinco kernel: [    0.164274] DMAR: RMRR base: 0x000000cbc=
00000 end: 0x000000cfdfffff
Feb 17 19:00:29 vinco kernel: [    0.164275] DMAR-IR: IOAPIC id 8 under D=
RHD base  0xfed91000 IOMMU 1
Feb 17 19:00:29 vinco kernel: [    0.164276] DMAR-IR: HPET id 0 under DRH=
D base 0xfed91000
Feb 17 19:00:29 vinco kernel: [    0.164276] DMAR-IR: Queued invalidation=
 will be enabled to support x2apic and Intr-remapping.
Feb 17 19:00:29 vinco kernel: [    0.164635] DMAR-IR: Enabled IRQ remappi=
ng in x2apic mode
Feb 17 19:00:29 vinco kernel: [    0.164636] x2apic enabled
Feb 17 19:00:29 vinco kernel: [    0.164641] Switched APIC routing to clu=
ster x2apic.
Feb 17 19:00:29 vinco kernel: [    0.165013] ..TIMER: vector=3D0x30 apic1=
=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
Feb 17 19:00:29 vinco kernel: [    0.184267] clocksource: tsc-early: mask=
: 0xffffffffffffffff max_cycles: 0x23f3b0d5e5b, max_idle_ns: 440795306932=
 ns
Feb 17 19:00:29 vinco kernel: [    0.184270] Calibrating delay loop (skip=
ped), value calculated using timer frequency.. 4988.32 BogoMIPS (lpj=3D99=
76656)
Feb 17 19:00:29 vinco kernel: [    0.184272] pid_max: default: 32768 mini=
mum: 301
Feb 17 19:00:29 vinco kernel: [    0.188875] LSM: Security Framework init=
ializing
Feb 17 19:00:29 vinco kernel: [    0.188880] Yama: disabled by default; e=
nable with sysctl kernel.yama.*
Feb 17 19:00:29 vinco kernel: [    0.188898] AppArmor: AppArmor initializ=
ed
Feb 17 19:00:29 vinco kernel: [    0.188934] Mount-cache hash table entri=
es: 32768 (order: 6, 262144 bytes, linear)
Feb 17 19:00:29 vinco kernel: [    0.188962] Mountpoint-cache hash table =
entries: 32768 (order: 6, 262144 bytes, linear)
Feb 17 19:00:29 vinco kernel: [    0.189149] mce: CPU0: Thermal monitorin=
g enabled (TM1)
Feb 17 19:00:29 vinco kernel: [    0.189161] process: using mwait in idle=
 threads
Feb 17 19:00:29 vinco kernel: [    0.189163] Last level iTLB entries: 4KB=
 1024, 2MB 1024, 4MB 1024
Feb 17 19:00:29 vinco kernel: [    0.189163] Last level dTLB entries: 4KB=
 1024, 2MB 1024, 4MB 1024, 1GB 4
Feb 17 19:00:29 vinco kernel: [    0.189165] Spectre V1 : Mitigation: use=
rcopy/swapgs barriers and __user pointer sanitization
Feb 17 19:00:29 vinco kernel: [    0.189166] Spectre V2 : Mitigation: Ful=
l generic retpoline
Feb 17 19:00:29 vinco kernel: [    0.189167] Spectre V2 : Spectre v2 / Sp=
ectreRSB mitigation: Filling RSB on context switch
Feb 17 19:00:29 vinco kernel: [    0.189167] Spectre V2 : Enabling Restri=
cted Speculation for firmware calls
Feb 17 19:00:29 vinco kernel: [    0.189168] Spectre V2 : mitigation: Ena=
bling conditional Indirect Branch Prediction Barrier
Feb 17 19:00:29 vinco kernel: [    0.189169] Spectre V2 : User space: Mit=
igation: STIBP via seccomp and prctl
Feb 17 19:00:29 vinco kernel: [    0.189169] Speculative Store Bypass: Mi=
tigation: Speculative Store Bypass disabled via prctl and seccomp
Feb 17 19:00:29 vinco kernel: [    0.189172] MDS: Mitigation: Clear CPU b=
uffers
Feb 17 19:00:29 vinco kernel: [    0.189302] Freeing SMP alternatives mem=
ory: 24K
Feb 17 19:00:29 vinco kernel: [    0.191432] TSC deadline timer enabled
Feb 17 19:00:29 vinco kernel: [    0.191434] smpboot: CPU0: Intel(R) Core=
(TM) i7-4710HQ CPU @ 2.50GHz (family: 0x6, model: 0x3c, stepping: 0x3)
Feb 17 19:00:29 vinco kernel: [    0.191506] Performance Events: PEBS fmt=
2+, Haswell events, 16-deep LBR, full-width counters, Intel PMU driver.
Feb 17 19:00:29 vinco kernel: [    0.191519] ... version:                =
3
Feb 17 19:00:29 vinco kernel: [    0.191519] ... bit width:              =
48
Feb 17 19:00:29 vinco kernel: [    0.191520] ... generic registers:      =
4
Feb 17 19:00:29 vinco kernel: [    0.191520] ... value mask:             =
0000ffffffffffff
Feb 17 19:00:29 vinco kernel: [    0.191520] ... max period:             =
00007fffffffffff
Feb 17 19:00:29 vinco kernel: [    0.191521] ... fixed-purpose events:   =
3
Feb 17 19:00:29 vinco kernel: [    0.191521] ... event mask:             =
000000070000000f
Feb 17 19:00:29 vinco kernel: [    0.191545] rcu: Hierarchical SRCU imple=
mentation.
Feb 17 19:00:29 vinco kernel: [    0.192141] NMI watchdog: Enabled. Perma=
nently consumes one hw-PMU counter.
Feb 17 19:00:29 vinco kernel: [    0.192190] smp: Bringing up secondary C=
PUs ...
Feb 17 19:00:29 vinco kernel: [    0.192240] x86: Booting SMP configurati=
on:
Feb 17 19:00:29 vinco kernel: [    0.192241] .... node  #0, CPUs:      #1=
 #2 #3 #4
Feb 17 19:00:29 vinco kernel: [    0.193733] MDS CPU bug present and SMT =
on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-=
guide/hw-vuln/mds.html for more details.
Feb 17 19:00:29 vinco kernel: [    0.193733]  #5 #6 #7
Feb 17 19:00:29 vinco kernel: [    0.193733] smp: Brought up 1 node, 8 CP=
Us
Feb 17 19:00:29 vinco kernel: [    0.193733] smpboot: Max logical package=
s: 1
Feb 17 19:00:29 vinco kernel: [    0.193733] smpboot: Total of 8 processo=
rs activated (39906.62 BogoMIPS)
Feb 17 19:00:29 vinco kernel: [    0.196584] devtmpfs: initialized
Feb 17 19:00:29 vinco kernel: [    0.196584] x86/mm: Memory block size: 1=
28MB
Feb 17 19:00:29 vinco kernel: [    0.197433] PM: Registering ACPI NVS reg=
ion [mem 0xb9755000-0xb975bfff] (28672 bytes)
Feb 17 19:00:29 vinco kernel: [    0.197433] PM: Registering ACPI NVS reg=
ion [mem 0xc9e01000-0xcab05fff] (13651968 bytes)
Feb 17 19:00:29 vinco kernel: [    0.197433] clocksource: jiffies: mask: =
0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
Feb 17 19:00:29 vinco kernel: [    0.197433] futex hash table entries: 20=
48 (order: 5, 131072 bytes, linear)
Feb 17 19:00:29 vinco kernel: [    0.197433] pinctrl core: initialized pi=
nctrl subsystem
Feb 17 19:00:29 vinco kernel: [    0.197433] NET: Registered protocol fam=
ily 16
Feb 17 19:00:29 vinco kernel: [    0.197433] audit: initializing netlink =
subsys (disabled)
Feb 17 19:00:29 vinco kernel: [    0.197433] audit: type=3D2000 audit(158=
1958823.032:1): state=3Dinitialized audit_enabled=3D0 res=3D1
Feb 17 19:00:29 vinco kernel: [    0.197433] cpuidle: using governor ladd=
er
Feb 17 19:00:29 vinco kernel: [    0.197433] cpuidle: using governor menu=

Feb 17 19:00:29 vinco kernel: [    0.197433] ACPI FADT declares the syste=
m doesn't support PCIe ASPM, so disable it
Feb 17 19:00:29 vinco kernel: [    0.197433] ACPI: bus type PCI registere=
d
Feb 17 19:00:29 vinco kernel: [    0.197433] acpiphp: ACPI Hot Plug PCI C=
ontroller Driver version: 0.5
Feb 17 19:00:29 vinco kernel: [    0.197433] PCI: MMCONFIG for domain 000=
0 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
Feb 17 19:00:29 vinco kernel: [    0.197433] PCI: MMCONFIG at [mem 0xf800=
0000-0xfbffffff] reserved in E820
Feb 17 19:00:29 vinco kernel: [    0.197433] pmd_set_huge: Cannot satisfy=
 [mem 0xf8000000-0xf8200000] with a huge-page mapping due to MTRR overrid=
e.
Feb 17 19:00:29 vinco kernel: [    0.197433] PCI: Using configuration typ=
e 1 for base access
Feb 17 19:00:29 vinco kernel: [    0.197433] core: PMU erratum BJ122, BV9=
8, HSD29 worked around, HT is on
Feb 17 19:00:29 vinco kernel: [    0.197433] ENERGY_PERF_BIAS: Set to 'no=
rmal', was 'performance'
Feb 17 19:00:29 vinco kernel: [    0.197433] HugeTLB registered 1.00 GiB =
page size, pre-allocated 0 pages
Feb 17 19:00:29 vinco kernel: [    0.197433] HugeTLB registered 2.00 MiB =
page size, pre-allocated 0 pages
Feb 17 19:00:29 vinco kernel: [    0.316471] ACPI: Added _OSI(Module Devi=
ce)
Feb 17 19:00:29 vinco kernel: [    0.316471] ACPI: Added _OSI(Processor D=
evice)
Feb 17 19:00:29 vinco kernel: [    0.316471] ACPI: Added _OSI(3.0 _SCP Ex=
tensions)
Feb 17 19:00:29 vinco kernel: [    0.316471] ACPI: Added _OSI(Processor A=
ggregator Device)
Feb 17 19:00:29 vinco kernel: [    0.316471] ACPI: Added _OSI(Linux-Dell-=
Video)
Feb 17 19:00:29 vinco kernel: [    0.316471] ACPI: Added _OSI(Linux-Lenov=
o-NV-HDMI-Audio)
Feb 17 19:00:29 vinco kernel: [    0.316471] ACPI: Added _OSI(Linux-HPI-H=
ybrid-Graphics)
Feb 17 19:00:29 vinco kernel: [    0.330316] ACPI: 8 ACPI AML tables succ=
essfully acquired and loaded
Feb 17 19:00:29 vinco kernel: [    0.330821] ACPI: EC: EC started
Feb 17 19:00:29 vinco kernel: [    0.330821] ACPI: EC: interrupt blocked
Feb 17 19:00:29 vinco kernel: [    0.331621] ACPI: \: Used as first EC
Feb 17 19:00:29 vinco kernel: [    0.331622] ACPI: \: GPE=3D0x19, EC_CMD/=
EC_SC=3D0x66, EC_DATA=3D0x62
Feb 17 19:00:29 vinco kernel: [    0.331622] ACPI: EC: Boot ECDT EC used =
to handle transactions
Feb 17 19:00:29 vinco kernel: [    0.332251] ACPI: [Firmware Bug]: BIOS _=
OSI(Linux) query ignored
Feb 17 19:00:29 vinco kernel: [    0.334580] ACPI: Dynamic OEM Table Load=
:
Feb 17 19:00:29 vinco kernel: [    0.334584] ACPI: SSDT 0xFFFF95065C7F600=
0 0003D3 (v01 PmRef  Cpu0Cst  00003001 INTL 20120711)
Feb 17 19:00:29 vinco kernel: [    0.335303] ACPI: Dynamic OEM Table Load=
:
Feb 17 19:00:29 vinco kernel: [    0.335306] ACPI: SSDT 0xFFFF95065C2F680=
0 0005AA (v01 PmRef  ApIst    00003000 INTL 20120711)
Feb 17 19:00:29 vinco kernel: [    0.336046] ACPI: Dynamic OEM Table Load=
:
Feb 17 19:00:29 vinco kernel: [    0.336049] ACPI: SSDT 0xFFFF95065C7EB00=
0 000119 (v01 PmRef  ApCst    00003000 INTL 20120711)
Feb 17 19:00:29 vinco kernel: [    0.337593] ACPI: Interpreter enabled
Feb 17 19:00:29 vinco kernel: [    0.337618] ACPI: (supports S0 S3 S4 S5)=

Feb 17 19:00:29 vinco kernel: [    0.337619] ACPI: Using IOAPIC for inter=
rupt routing
Feb 17 19:00:29 vinco kernel: [    0.337638] PCI: Using host bridge windo=
ws from ACPI; if necessary, use "pci=3Dnocrs" and report a bug
Feb 17 19:00:29 vinco kernel: [    0.337839] ACPI: Enabled 7 GPEs in bloc=
k 00 to 3F
Feb 17 19:00:29 vinco kernel: [    0.341494] ACPI: Power Resource [PG00] =
(on)
Feb 17 19:00:29 vinco kernel: [    0.345154] ACPI: PCI Root Bridge [PCI0]=
 (domain 0000 [bus 00-3e])
Feb 17 19:00:29 vinco kernel: [    0.345157] acpi PNP0A08:00: _OSC: OS su=
pports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
Feb 17 19:00:29 vinco kernel: [    0.345614] acpi PNP0A08:00: _OSC: OS no=
w controls [PCIeHotplug SHPCHotplug PME AER PCIeCapability LTR]
Feb 17 19:00:29 vinco kernel: [    0.345615] acpi PNP0A08:00: FADT indica=
tes ASPM is unsupported, using BIOS configuration
Feb 17 19:00:29 vinco kernel: [    0.345895] PCI host bridge to bus 0000:=
00
Feb 17 19:00:29 vinco kernel: [    0.345896] pci_bus 0000:00: root bus re=
source [io  0x0000-0x0cf7 window]
Feb 17 19:00:29 vinco kernel: [    0.345897] pci_bus 0000:00: root bus re=
source [io  0x0d00-0xffff window]
Feb 17 19:00:29 vinco kernel: [    0.345898] pci_bus 0000:00: root bus re=
source [mem 0x000a0000-0x000bffff window]
Feb 17 19:00:29 vinco kernel: [    0.345899] pci_bus 0000:00: root bus re=
source [mem 0x000d0000-0x000d3fff window]
Feb 17 19:00:29 vinco kernel: [    0.345899] pci_bus 0000:00: root bus re=
source [mem 0x000d4000-0x000d7fff window]
Feb 17 19:00:29 vinco kernel: [    0.345900] pci_bus 0000:00: root bus re=
source [mem 0x000d8000-0x000dbfff window]
Feb 17 19:00:29 vinco kernel: [    0.345901] pci_bus 0000:00: root bus re=
source [mem 0x000dc000-0x000dffff window]
Feb 17 19:00:29 vinco kernel: [    0.345901] pci_bus 0000:00: root bus re=
source [mem 0xcfe00000-0xfeafffff window]
Feb 17 19:00:29 vinco kernel: [    0.345902] pci_bus 0000:00: root bus re=
source [bus 00-3e]
Feb 17 19:00:29 vinco kernel: [    0.345909] pci 0000:00:00.0: [8086:0c04=
] type 00 class 0x060000
Feb 17 19:00:29 vinco kernel: [    0.345971] pci 0000:00:01.0: [8086:0c01=
] type 01 class 0x060400
Feb 17 19:00:29 vinco kernel: [    0.346003] pci 0000:00:01.0: PME# suppo=
rted from D0 D3hot D3cold
Feb 17 19:00:29 vinco kernel: [    0.346097] pci 0000:00:02.0: [8086:0416=
] type 00 class 0x030000
Feb 17 19:00:29 vinco kernel: [    0.346105] pci 0000:00:02.0: reg 0x10: =
[mem 0xf7400000-0xf77fffff 64bit]
Feb 17 19:00:29 vinco kernel: [    0.346109] pci 0000:00:02.0: reg 0x18: =
[mem 0xd0000000-0xdfffffff 64bit pref]
Feb 17 19:00:29 vinco kernel: [    0.346112] pci 0000:00:02.0: reg 0x20: =
[io  0xf000-0xf03f]
Feb 17 19:00:29 vinco kernel: [    0.346121] pci 0000:00:02.0: BAR 2: ass=
igned to efifb
Feb 17 19:00:29 vinco kernel: [    0.346176] pci 0000:00:03.0: [8086:0c0c=
] type 00 class 0x040300
Feb 17 19:00:29 vinco kernel: [    0.346183] pci 0000:00:03.0: reg 0x10: =
[mem 0xf7a14000-0xf7a17fff 64bit]
Feb 17 19:00:29 vinco kernel: [    0.346263] pci 0000:00:14.0: [8086:8c31=
] type 00 class 0x0c0330
Feb 17 19:00:29 vinco kernel: [    0.346281] pci 0000:00:14.0: reg 0x10: =
[mem 0xf7a00000-0xf7a0ffff 64bit]
Feb 17 19:00:29 vinco kernel: [    0.346332] pci 0000:00:14.0: PME# suppo=
rted from D3hot D3cold
Feb 17 19:00:29 vinco kernel: [    0.346389] pci 0000:00:16.0: [8086:8c3a=
] type 00 class 0x078000
Feb 17 19:00:29 vinco kernel: [    0.346407] pci 0000:00:16.0: reg 0x10: =
[mem 0xf7a1e000-0xf7a1e00f 64bit]
Feb 17 19:00:29 vinco kernel: [    0.346461] pci 0000:00:16.0: PME# suppo=
rted from D0 D3hot D3cold
Feb 17 19:00:29 vinco kernel: [    0.346518] pci 0000:00:1a.0: [8086:8c2d=
] type 00 class 0x0c0320
Feb 17 19:00:29 vinco kernel: [    0.346536] pci 0000:00:1a.0: reg 0x10: =
[mem 0xf7a1c000-0xf7a1c3ff]
Feb 17 19:00:29 vinco kernel: [    0.346608] pci 0000:00:1a.0: PME# suppo=
rted from D0 D3hot D3cold
Feb 17 19:00:29 vinco kernel: [    0.346670] pci 0000:00:1b.0: [8086:8c20=
] type 00 class 0x040300
Feb 17 19:00:29 vinco kernel: [    0.346688] pci 0000:00:1b.0: reg 0x10: =
[mem 0xf7a10000-0xf7a13fff 64bit]
Feb 17 19:00:29 vinco kernel: [    0.346748] pci 0000:00:1b.0: PME# suppo=
rted from D0 D3hot D3cold
Feb 17 19:00:29 vinco kernel: [    0.346806] pci 0000:00:1c.0: [8086:8c10=
] type 01 class 0x060400
Feb 17 19:00:29 vinco kernel: [    0.346874] pci 0000:00:1c.0: PME# suppo=
rted from D0 D3hot D3cold
Feb 17 19:00:29 vinco kernel: [    0.346890] pci 0000:00:1c.0: Enabling M=
PC IRBNCE
Feb 17 19:00:29 vinco kernel: [    0.346893] pci 0000:00:1c.0: Intel PCH =
root port ACS workaround enabled
Feb 17 19:00:29 vinco kernel: [    0.346977] pci 0000:00:1c.1: [8086:8c12=
] type 01 class 0x060400
Feb 17 19:00:29 vinco kernel: [    0.347065] pci 0000:00:1c.1: PME# suppo=
rted from D0 D3hot D3cold
Feb 17 19:00:29 vinco kernel: [    0.347080] pci 0000:00:1c.1: Enabling M=
PC IRBNCE
Feb 17 19:00:29 vinco kernel: [    0.347082] pci 0000:00:1c.1: Intel PCH =
root port ACS workaround enabled
Feb 17 19:00:29 vinco kernel: [    0.347161] pci 0000:00:1c.2: [8086:8c14=
] type 01 class 0x060400
Feb 17 19:00:29 vinco kernel: [    0.347231] pci 0000:00:1c.2: PME# suppo=
rted from D0 D3hot D3cold
Feb 17 19:00:29 vinco kernel: [    0.347245] pci 0000:00:1c.2: Enabling M=
PC IRBNCE
Feb 17 19:00:29 vinco kernel: [    0.347247] pci 0000:00:1c.2: Intel PCH =
root port ACS workaround enabled
Feb 17 19:00:29 vinco kernel: [    0.347329] pci 0000:00:1c.3: [8086:8c16=
] type 01 class 0x060400
Feb 17 19:00:29 vinco kernel: [    0.347399] pci 0000:00:1c.3: PME# suppo=
rted from D0 D3hot D3cold
Feb 17 19:00:29 vinco kernel: [    0.347413] pci 0000:00:1c.3: Enabling M=
PC IRBNCE
Feb 17 19:00:29 vinco kernel: [    0.347415] pci 0000:00:1c.3: Intel PCH =
root port ACS workaround enabled
Feb 17 19:00:29 vinco kernel: [    0.347502] pci 0000:00:1d.0: [8086:8c26=
] type 00 class 0x0c0320
Feb 17 19:00:29 vinco kernel: [    0.347521] pci 0000:00:1d.0: reg 0x10: =
[mem 0xf7a1b000-0xf7a1b3ff]
Feb 17 19:00:29 vinco kernel: [    0.347595] pci 0000:00:1d.0: PME# suppo=
rted from D0 D3hot D3cold
Feb 17 19:00:29 vinco kernel: [    0.347658] pci 0000:00:1f.0: [8086:8c49=
] type 00 class 0x060100
Feb 17 19:00:29 vinco kernel: [    0.347804] pci 0000:00:1f.2: [8086:8c03=
] type 00 class 0x010601
Feb 17 19:00:29 vinco kernel: [    0.347818] pci 0000:00:1f.2: reg 0x10: =
[io  0xf0b0-0xf0b7]
Feb 17 19:00:29 vinco kernel: [    0.347824] pci 0000:00:1f.2: reg 0x14: =
[io  0xf0a0-0xf0a3]
Feb 17 19:00:29 vinco kernel: [    0.347830] pci 0000:00:1f.2: reg 0x18: =
[io  0xf090-0xf097]
Feb 17 19:00:29 vinco kernel: [    0.347836] pci 0000:00:1f.2: reg 0x1c: =
[io  0xf080-0xf083]
Feb 17 19:00:29 vinco kernel: [    0.347842] pci 0000:00:1f.2: reg 0x20: =
[io  0xf060-0xf07f]
Feb 17 19:00:29 vinco kernel: [    0.347848] pci 0000:00:1f.2: reg 0x24: =
[mem 0xf7a1a000-0xf7a1a7ff]
Feb 17 19:00:29 vinco kernel: [    0.347878] pci 0000:00:1f.2: PME# suppo=
rted from D3hot
Feb 17 19:00:29 vinco kernel: [    0.347931] pci 0000:00:1f.3: [8086:8c22=
] type 00 class 0x0c0500
Feb 17 19:00:29 vinco kernel: [    0.347947] pci 0000:00:1f.3: reg 0x10: =
[mem 0xf7a19000-0xf7a190ff 64bit]
Feb 17 19:00:29 vinco kernel: [    0.347964] pci 0000:00:1f.3: reg 0x20: =
[io  0xf040-0xf05f]
Feb 17 19:00:29 vinco kernel: [    0.348067] pci 0000:01:00.0: [10de:1392=
] type 00 class 0x030200
Feb 17 19:00:29 vinco kernel: [    0.348091] pci 0000:01:00.0: reg 0x10: =
[mem 0xf6000000-0xf6ffffff]
Feb 17 19:00:29 vinco kernel: [    0.348107] pci 0000:01:00.0: reg 0x14: =
[mem 0xe0000000-0xefffffff 64bit pref]
Feb 17 19:00:29 vinco kernel: [    0.348122] pci 0000:01:00.0: reg 0x1c: =
[mem 0xf0000000-0xf1ffffff 64bit pref]
Feb 17 19:00:29 vinco kernel: [    0.348132] pci 0000:01:00.0: reg 0x24: =
[io  0xe000-0xe07f]
Feb 17 19:00:29 vinco kernel: [    0.348143] pci 0000:01:00.0: reg 0x30: =
[mem 0xf7000000-0xf707ffff pref]
Feb 17 19:00:29 vinco kernel: [    0.348160] pci 0000:01:00.0: Enabling H=
DA controller
Feb 17 19:00:29 vinco kernel: [    0.348312] pci 0000:00:01.0: PCI bridge=
 to [bus 01]
Feb 17 19:00:29 vinco kernel: [    0.348313] pci 0000:00:01.0:   bridge w=
indow [io  0xe000-0xefff]
Feb 17 19:00:29 vinco kernel: [    0.348315] pci 0000:00:01.0:   bridge w=
indow [mem 0xf6000000-0xf70fffff]
Feb 17 19:00:29 vinco kernel: [    0.348317] pci 0000:00:01.0:   bridge w=
indow [mem 0xe0000000-0xf1ffffff 64bit pref]
Feb 17 19:00:29 vinco kernel: [    0.348362] acpiphp: Slot [1] registered=

Feb 17 19:00:29 vinco kernel: [    0.348367] pci 0000:00:1c.0: PCI bridge=
 to [bus 02]
Feb 17 19:00:29 vinco kernel: [    0.348421] pci 0000:00:1c.1: PCI bridge=
 to [bus 03]
Feb 17 19:00:29 vinco kernel: [    0.348517] pci 0000:04:00.0: [8086:08b1=
] type 00 class 0x028000
Feb 17 19:00:29 vinco kernel: [    0.348593] pci 0000:04:00.0: reg 0x10: =
[mem 0xf7900000-0xf7901fff 64bit]
Feb 17 19:00:29 vinco kernel: [    0.348857] pci 0000:04:00.0: PME# suppo=
rted from D0 D3hot D3cold
Feb 17 19:00:29 vinco kernel: [    0.349058] pci 0000:00:1c.2: PCI bridge=
 to [bus 04]
Feb 17 19:00:29 vinco kernel: [    0.349063] pci 0000:00:1c.2:   bridge w=
indow [mem 0xf7900000-0xf79fffff]
Feb 17 19:00:29 vinco kernel: [    0.349127] pci 0000:05:00.0: [10ec:5287=
] type 00 class 0xff0000
Feb 17 19:00:29 vinco kernel: [    0.349157] pci 0000:05:00.0: reg 0x10: =
[mem 0xf7815000-0xf7815fff]
Feb 17 19:00:29 vinco kernel: [    0.349217] pci 0000:05:00.0: reg 0x30: =
[mem 0xf7800000-0xf780ffff pref]
Feb 17 19:00:29 vinco kernel: [    0.349311] pci 0000:05:00.0: supports D=
1 D2
Feb 17 19:00:29 vinco kernel: [    0.349312] pci 0000:05:00.0: PME# suppo=
rted from D1 D2 D3hot D3cold
Feb 17 19:00:29 vinco kernel: [    0.349419] pci 0000:05:00.1: [10ec:8168=
] type 00 class 0x020000
Feb 17 19:00:29 vinco kernel: [    0.349448] pci 0000:05:00.1: reg 0x10: =
[io  0xd000-0xd0ff]
Feb 17 19:00:29 vinco kernel: [    0.349475] pci 0000:05:00.1: reg 0x18: =
[mem 0xf7814000-0xf7814fff 64bit]
Feb 17 19:00:29 vinco kernel: [    0.349492] pci 0000:05:00.1: reg 0x20: =
[mem 0xf7810000-0xf7813fff 64bit]
Feb 17 19:00:29 vinco kernel: [    0.349590] pci 0000:05:00.1: supports D=
1 D2
Feb 17 19:00:29 vinco kernel: [    0.349591] pci 0000:05:00.1: PME# suppo=
rted from D0 D1 D2 D3hot D3cold
Feb 17 19:00:29 vinco kernel: [    0.349720] pci 0000:00:1c.3: PCI bridge=
 to [bus 05]
Feb 17 19:00:29 vinco kernel: [    0.349722] pci 0000:00:1c.3:   bridge w=
indow [io  0xd000-0xdfff]
Feb 17 19:00:29 vinco kernel: [    0.349725] pci 0000:00:1c.3:   bridge w=
indow [mem 0xf7800000-0xf78fffff]
Feb 17 19:00:29 vinco kernel: [    0.350286] ACPI: PCI Interrupt Link [LN=
KA] (IRQs 3 4 5 6 7 10 *11 12)
Feb 17 19:00:29 vinco kernel: [    0.350320] ACPI: PCI Interrupt Link [LN=
KB] (IRQs *3 4 5 6 7 10 12)
Feb 17 19:00:29 vinco kernel: [    0.350352] ACPI: PCI Interrupt Link [LN=
KC] (IRQs 3 *4 5 6 7 10 12)
Feb 17 19:00:29 vinco kernel: [    0.350383] ACPI: PCI Interrupt Link [LN=
KD] (IRQs 3 4 5 6 7 *10 12)
Feb 17 19:00:29 vinco kernel: [    0.350414] ACPI: PCI Interrupt Link [LN=
KE] (IRQs 3 4 5 6 7 10 12) *0, disabled.
Feb 17 19:00:29 vinco kernel: [    0.350445] ACPI: PCI Interrupt Link [LN=
KF] (IRQs 3 4 5 6 7 10 12) *0, disabled.
Feb 17 19:00:29 vinco kernel: [    0.350475] ACPI: PCI Interrupt Link [LN=
KG] (IRQs 3 4 *5 6 7 10 12)
Feb 17 19:00:29 vinco kernel: [    0.350506] ACPI: PCI Interrupt Link [LN=
KH] (IRQs 3 4 5 6 7 *10 12)
Feb 17 19:00:29 vinco kernel: [    0.350768] ACPI: EC: interrupt unblocke=
d
Feb 17 19:00:29 vinco kernel: [    0.350774] ACPI: EC: event unblocked
Feb 17 19:00:29 vinco kernel: [    0.350791] ACPI: \_SB_.PCI0.LPCB.EC0_: =
GPE=3D0x19, EC_CMD/EC_SC=3D0x66, EC_DATA=3D0x62
Feb 17 19:00:29 vinco kernel: [    0.350792] ACPI: \_SB_.PCI0.LPCB.EC0_: =
Boot DSDT EC used to handle transactions and events
Feb 17 19:00:29 vinco kernel: [    0.350836] iommu: Default domain type: =
Translated=20
Feb 17 19:00:29 vinco kernel: [    0.350844] pci 0000:00:02.0: vgaarb: se=
tting as boot VGA device
Feb 17 19:00:29 vinco kernel: [    0.350844] pci 0000:00:02.0: vgaarb: VG=
A device added: decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
Feb 17 19:00:29 vinco kernel: [    0.350844] pci 0000:00:02.0: vgaarb: br=
idge control possible
Feb 17 19:00:29 vinco kernel: [    0.350844] vgaarb: loaded
Feb 17 19:00:29 vinco kernel: [    0.350844] EDAC MC: Ver: 3.0.0
Feb 17 19:00:29 vinco kernel: [    0.350844] Registered efivars operation=
s
Feb 17 19:00:29 vinco kernel: [    0.350844] PCI: Using ACPI for IRQ rout=
ing
Feb 17 19:00:29 vinco kernel: [    0.350844] PCI: pci_cache_line_size set=
 to 64 bytes
Feb 17 19:00:29 vinco kernel: [    0.352293] e820: reserve RAM buffer [me=
m 0x00058000-0x0005ffff]
Feb 17 19:00:29 vinco kernel: [    0.352294] e820: reserve RAM buffer [me=
m 0x0009f000-0x0009ffff]
Feb 17 19:00:29 vinco kernel: [    0.352295] e820: reserve RAM buffer [me=
m 0xb9755000-0xbbffffff]
Feb 17 19:00:29 vinco kernel: [    0.352295] e820: reserve RAM buffer [me=
m 0xb9fd5000-0xbbffffff]
Feb 17 19:00:29 vinco kernel: [    0.352296] e820: reserve RAM buffer [me=
m 0xc98c6000-0xcbffffff]
Feb 17 19:00:29 vinco kernel: [    0.352297] e820: reserve RAM buffer [me=
m 0xc9e01000-0xcbffffff]
Feb 17 19:00:29 vinco kernel: [    0.352298] e820: reserve RAM buffer [me=
m 0xcb000000-0xcbffffff]
Feb 17 19:00:29 vinco kernel: [    0.352298] e820: reserve RAM buffer [me=
m 0x42f200000-0x42fffffff]
Feb 17 19:00:29 vinco kernel: [    0.352733] hpet0: at MMIO 0xfed00000, I=
RQs 2, 8, 0, 0, 0, 0, 0, 0
Feb 17 19:00:29 vinco kernel: [    0.352736] hpet0: 8 comparators, 64-bit=
 14.318180 MHz counter
Feb 17 19:00:29 vinco kernel: [    0.354758] clocksource: Switched to clo=
cksource tsc-early
Feb 17 19:00:29 vinco kernel: [    0.357784] VFS: Disk quotas dquot_6.6.0=

Feb 17 19:00:29 vinco kernel: [    0.357784] VFS: Dquot-cache hash table =
entries: 512 (order 0, 4096 bytes)
Feb 17 19:00:29 vinco kernel: [    0.357784] AppArmor: AppArmor Filesyste=
m Enabled
Feb 17 19:00:29 vinco kernel: [    0.357784] pnp: PnP ACPI init
Feb 17 19:00:29 vinco kernel: [    0.357784] system 00:00: [mem 0xfed4000=
0-0xfed44fff] has been reserved
Feb 17 19:00:29 vinco kernel: [    0.357784] system 00:00: Plug and Play =
ACPI device, IDs PNP0c01 (active)
Feb 17 19:00:29 vinco kernel: [    0.357784] system 00:01: [io  0x0680-0x=
069f] has been reserved
Feb 17 19:00:29 vinco kernel: [    0.357784] system 00:01: [io  0xffff] h=
as been reserved
Feb 17 19:00:29 vinco kernel: [    0.357784] system 00:01: [io  0xffff] h=
as been reserved
Feb 17 19:00:29 vinco kernel: [    0.357784] system 00:01: [io  0xffff] h=
as been reserved
Feb 17 19:00:29 vinco kernel: [    0.357784] system 00:01: [io  0x1c00-0x=
1cfe] has been reserved
Feb 17 19:00:29 vinco kernel: [    0.357784] system 00:01: [io  0x1d00-0x=
1dfe] has been reserved
Feb 17 19:00:29 vinco kernel: [    0.357784] system 00:01: [io  0x1e00-0x=
1efe] has been reserved
Feb 17 19:00:29 vinco kernel: [    0.357784] system 00:01: [io  0x1f00-0x=
1ffe] has been reserved
Feb 17 19:00:29 vinco kernel: [    0.357784] system 00:01: [io  0x1800-0x=
18fe] has been reserved
Feb 17 19:00:29 vinco kernel: [    0.357784] system 00:01: [io  0x164e-0x=
164f] has been reserved
Feb 17 19:00:29 vinco kernel: [    0.357784] system 00:01: Plug and Play =
ACPI device, IDs PNP0c02 (active)
Feb 17 19:00:29 vinco kernel: [    0.357784] pnp 00:02: Plug and Play ACP=
I device, IDs PNP0b00 (active)
Feb 17 19:00:29 vinco kernel: [    0.357784] system 00:03: [io  0x1854-0x=
1857] has been reserved
Feb 17 19:00:29 vinco kernel: [    0.357784] system 00:03: Plug and Play =
ACPI device, IDs INT3f0d PNP0c02 (active)
Feb 17 19:00:29 vinco kernel: [    0.357784] system 00:04: [io  0x04d0-0x=
04d1] has been reserved
Feb 17 19:00:29 vinco kernel: [    0.357784] system 00:04: Plug and Play =
ACPI device, IDs PNP0c02 (active)
Feb 17 19:00:29 vinco kernel: [    0.357784] system 00:05: [io  0x0240-0x=
0259] has been reserved
Feb 17 19:00:29 vinco kernel: [    0.357784] system 00:05: Plug and Play =
ACPI device, IDs PNP0c02 (active)
Feb 17 19:00:29 vinco kernel: [    0.357784] pnp 00:06: Plug and Play ACP=
I device, IDs ETD0108 SYN0a00 SYN0002 PNP0f03 PNP0f13 PNP0f12 (active)
Feb 17 19:00:29 vinco kernel: [    0.357784] pnp 00:07: Plug and Play ACP=
I device, IDs ATK3001 PNP030b (active)
Feb 17 19:00:29 vinco kernel: [    0.360326] system 00:08: [mem 0xfed1c00=
0-0xfed1ffff] has been reserved
Feb 17 19:00:29 vinco kernel: [    0.360327] system 00:08: [mem 0xfed1000=
0-0xfed17fff] has been reserved
Feb 17 19:00:29 vinco kernel: [    0.360328] system 00:08: [mem 0xfed1800=
0-0xfed18fff] has been reserved
Feb 17 19:00:29 vinco kernel: [    0.360329] system 00:08: [mem 0xfed1900=
0-0xfed19fff] has been reserved
Feb 17 19:00:29 vinco kernel: [    0.360330] system 00:08: [mem 0xf800000=
0-0xfbffffff] has been reserved
Feb 17 19:00:29 vinco kernel: [    0.360331] system 00:08: [mem 0xfed2000=
0-0xfed3ffff] has been reserved
Feb 17 19:00:29 vinco kernel: [    0.360332] system 00:08: [mem 0xfed9000=
0-0xfed93fff] could not be reserved
Feb 17 19:00:29 vinco kernel: [    0.360332] system 00:08: [mem 0xfed4500=
0-0xfed8ffff] has been reserved
Feb 17 19:00:29 vinco kernel: [    0.360333] system 00:08: [mem 0xff00000=
0-0xffffffff] has been reserved
Feb 17 19:00:29 vinco kernel: [    0.360334] system 00:08: [mem 0xfee0000=
0-0xfeefffff] could not be reserved
Feb 17 19:00:29 vinco kernel: [    0.360335] system 00:08: [mem 0xf7fdf00=
0-0xf7fdffff] has been reserved
Feb 17 19:00:29 vinco kernel: [    0.360336] system 00:08: [mem 0xf7fe000=
0-0xf7feffff] has been reserved
Feb 17 19:00:29 vinco kernel: [    0.360338] system 00:08: Plug and Play =
ACPI device, IDs PNP0c02 (active)
Feb 17 19:00:29 vinco kernel: [    0.360394] system 00:09: Plug and Play =
ACPI device, IDs PNP0c02 (active)
Feb 17 19:00:29 vinco kernel: [    0.360605] pnp: PnP ACPI: found 10 devi=
ces
Feb 17 19:00:29 vinco kernel: [    0.361384] thermal_sys: Registered ther=
mal governor 'fair_share'
Feb 17 19:00:29 vinco kernel: [    0.361385] thermal_sys: Registered ther=
mal governor 'bang_bang'
Feb 17 19:00:29 vinco kernel: [    0.361385] thermal_sys: Registered ther=
mal governor 'step_wise'
Feb 17 19:00:29 vinco kernel: [    0.361385] thermal_sys: Registered ther=
mal governor 'user_space'
Feb 17 19:00:29 vinco kernel: [    0.365875] clocksource: acpi_pm: mask: =
0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
Feb 17 19:00:29 vinco kernel: [    0.365897] pci 0000:00:1c.1: bridge win=
dow [io  0x1000-0x0fff] to [bus 03] add_size 1000
Feb 17 19:00:29 vinco kernel: [    0.365899] pci 0000:00:1c.1: bridge win=
dow [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000 ad=
d_align 100000
Feb 17 19:00:29 vinco kernel: [    0.365900] pci 0000:00:1c.1: bridge win=
dow [mem 0x00100000-0x000fffff] to [bus 03] add_size 200000 add_align 100=
000
Feb 17 19:00:29 vinco kernel: [    0.365905] pci 0000:00:1c.1: BAR 14: as=
signed [mem 0xcfe00000-0xcfffffff]
Feb 17 19:00:29 vinco kernel: [    0.365909] pci 0000:00:1c.1: BAR 15: as=
signed [mem 0xf2000000-0xf21fffff 64bit pref]
Feb 17 19:00:29 vinco kernel: [    0.365911] pci 0000:00:1c.1: BAR 13: as=
signed [io  0x2000-0x2fff]
Feb 17 19:00:29 vinco kernel: [    0.365913] pci 0000:00:01.0: PCI bridge=
 to [bus 01]
Feb 17 19:00:29 vinco kernel: [    0.365914] pci 0000:00:01.0:   bridge w=
indow [io  0xe000-0xefff]
Feb 17 19:00:29 vinco kernel: [    0.365916] pci 0000:00:01.0:   bridge w=
indow [mem 0xf6000000-0xf70fffff]
Feb 17 19:00:29 vinco kernel: [    0.365917] pci 0000:00:01.0:   bridge w=
indow [mem 0xe0000000-0xf1ffffff 64bit pref]
Feb 17 19:00:29 vinco kernel: [    0.365920] pci 0000:00:1c.0: PCI bridge=
 to [bus 02]
Feb 17 19:00:29 vinco kernel: [    0.365928] pci 0000:00:1c.1: PCI bridge=
 to [bus 03]
Feb 17 19:00:29 vinco kernel: [    0.365930] pci 0000:00:1c.1:   bridge w=
indow [io  0x2000-0x2fff]
Feb 17 19:00:29 vinco kernel: [    0.365934] pci 0000:00:1c.1:   bridge w=
indow [mem 0xcfe00000-0xcfffffff]
Feb 17 19:00:29 vinco kernel: [    0.365937] pci 0000:00:1c.1:   bridge w=
indow [mem 0xf2000000-0xf21fffff 64bit pref]
Feb 17 19:00:29 vinco kernel: [    0.365941] pci 0000:00:1c.2: PCI bridge=
 to [bus 04]
Feb 17 19:00:29 vinco kernel: [    0.365945] pci 0000:00:1c.2:   bridge w=
indow [mem 0xf7900000-0xf79fffff]
Feb 17 19:00:29 vinco kernel: [    0.365951] pci 0000:00:1c.3: PCI bridge=
 to [bus 05]
Feb 17 19:00:29 vinco kernel: [    0.365953] pci 0000:00:1c.3:   bridge w=
indow [io  0xd000-0xdfff]
Feb 17 19:00:29 vinco kernel: [    0.365956] pci 0000:00:1c.3:   bridge w=
indow [mem 0xf7800000-0xf78fffff]
Feb 17 19:00:29 vinco kernel: [    0.365963] pci_bus 0000:00: resource 4 =
[io  0x0000-0x0cf7 window]
Feb 17 19:00:29 vinco kernel: [    0.365964] pci_bus 0000:00: resource 5 =
[io  0x0d00-0xffff window]
Feb 17 19:00:29 vinco kernel: [    0.365965] pci_bus 0000:00: resource 6 =
[mem 0x000a0000-0x000bffff window]
Feb 17 19:00:29 vinco kernel: [    0.365965] pci_bus 0000:00: resource 7 =
[mem 0x000d0000-0x000d3fff window]
Feb 17 19:00:29 vinco kernel: [    0.365966] pci_bus 0000:00: resource 8 =
[mem 0x000d4000-0x000d7fff window]
Feb 17 19:00:29 vinco kernel: [    0.365967] pci_bus 0000:00: resource 9 =
[mem 0x000d8000-0x000dbfff window]
Feb 17 19:00:29 vinco kernel: [    0.365967] pci_bus 0000:00: resource 10=
 [mem 0x000dc000-0x000dffff window]
Feb 17 19:00:29 vinco kernel: [    0.365968] pci_bus 0000:00: resource 11=
 [mem 0xcfe00000-0xfeafffff window]
Feb 17 19:00:29 vinco kernel: [    0.365969] pci_bus 0000:01: resource 0 =
[io  0xe000-0xefff]
Feb 17 19:00:29 vinco kernel: [    0.365969] pci_bus 0000:01: resource 1 =
[mem 0xf6000000-0xf70fffff]
Feb 17 19:00:29 vinco kernel: [    0.365970] pci_bus 0000:01: resource 2 =
[mem 0xe0000000-0xf1ffffff 64bit pref]
Feb 17 19:00:29 vinco kernel: [    0.365971] pci_bus 0000:03: resource 0 =
[io  0x2000-0x2fff]
Feb 17 19:00:29 vinco kernel: [    0.365972] pci_bus 0000:03: resource 1 =
[mem 0xcfe00000-0xcfffffff]
Feb 17 19:00:29 vinco kernel: [    0.365972] pci_bus 0000:03: resource 2 =
[mem 0xf2000000-0xf21fffff 64bit pref]
Feb 17 19:00:29 vinco kernel: [    0.365973] pci_bus 0000:04: resource 1 =
[mem 0xf7900000-0xf79fffff]
Feb 17 19:00:29 vinco kernel: [    0.365974] pci_bus 0000:05: resource 0 =
[io  0xd000-0xdfff]
Feb 17 19:00:29 vinco kernel: [    0.365975] pci_bus 0000:05: resource 1 =
[mem 0xf7800000-0xf78fffff]
Feb 17 19:00:29 vinco kernel: [    0.366055] NET: Registered protocol fam=
ily 2
Feb 17 19:00:29 vinco kernel: [    0.366140] tcp_listen_portaddr_hash has=
h table entries: 8192 (order: 5, 131072 bytes, linear)
Feb 17 19:00:29 vinco kernel: [    0.366156] TCP established hash table e=
ntries: 131072 (order: 8, 1048576 bytes, linear)
Feb 17 19:00:29 vinco kernel: [    0.366250] TCP bind hash table entries:=
 65536 (order: 8, 1048576 bytes, linear)
Feb 17 19:00:29 vinco kernel: [    0.366345] TCP: Hash tables configured =
(established 131072 bind 65536)
Feb 17 19:00:29 vinco kernel: [    0.366364] UDP hash table entries: 8192=
 (order: 6, 262144 bytes, linear)
Feb 17 19:00:29 vinco kernel: [    0.366390] UDP-Lite hash table entries:=
 8192 (order: 6, 262144 bytes, linear)
Feb 17 19:00:29 vinco kernel: [    0.366440] NET: Registered protocol fam=
ily 1
Feb 17 19:00:29 vinco kernel: [    0.366442] NET: Registered protocol fam=
ily 44
Feb 17 19:00:29 vinco kernel: [    0.366450] pci 0000:00:02.0: Video devi=
ce with shadowed ROM at [mem 0x000c0000-0x000dffff]
Feb 17 19:00:29 vinco kernel: [    0.366822] PCI: CLS 64 bytes, default 6=
4
Feb 17 19:00:29 vinco kernel: [    0.366847] Trying to unpack rootfs imag=
e as initramfs...
Feb 17 19:00:29 vinco kernel: [    0.977767] Freeing initrd memory: 57904=
K
Feb 17 19:00:29 vinco kernel: [    0.977805] DMAR: No ATSR found
Feb 17 19:00:29 vinco kernel: [    0.977853] DMAR: dmar0: Using Queued in=
validation
Feb 17 19:00:29 vinco kernel: [    0.977858] DMAR: dmar1: Using Queued in=
validation
Feb 17 19:00:29 vinco kernel: [    1.050212] pci 0000:00:00.0: Adding to =
iommu group 0
Feb 17 19:00:29 vinco kernel: [    1.050257] pci 0000:00:01.0: Adding to =
iommu group 1
Feb 17 19:00:29 vinco kernel: [    1.054849] pci 0000:00:02.0: Adding to =
iommu group 2
Feb 17 19:00:29 vinco kernel: [    1.054898] pci 0000:00:02.0: Using iomm=
u direct mapping
Feb 17 19:00:29 vinco kernel: [    1.054930] pci 0000:00:03.0: Adding to =
iommu group 3
Feb 17 19:00:29 vinco kernel: [    1.054986] pci 0000:00:14.0: Adding to =
iommu group 4
Feb 17 19:00:29 vinco kernel: [    1.055032] pci 0000:00:16.0: Adding to =
iommu group 5
Feb 17 19:00:29 vinco kernel: [    1.055087] pci 0000:00:1a.0: Adding to =
iommu group 6
Feb 17 19:00:29 vinco kernel: [    1.055132] pci 0000:00:1b.0: Adding to =
iommu group 7
Feb 17 19:00:29 vinco kernel: [    1.055171] pci 0000:00:1c.0: Adding to =
iommu group 8
Feb 17 19:00:29 vinco kernel: [    1.055217] pci 0000:00:1c.1: Adding to =
iommu group 9
Feb 17 19:00:29 vinco kernel: [    1.055258] pci 0000:00:1c.2: Adding to =
iommu group 10
Feb 17 19:00:29 vinco kernel: [    1.055295] pci 0000:00:1c.3: Adding to =
iommu group 11
Feb 17 19:00:29 vinco kernel: [    1.055356] pci 0000:00:1d.0: Adding to =
iommu group 12
Feb 17 19:00:29 vinco kernel: [    1.056513] pci 0000:00:1f.0: Adding to =
iommu group 13
Feb 17 19:00:29 vinco kernel: [    1.056522] pci 0000:00:1f.2: Adding to =
iommu group 13
Feb 17 19:00:29 vinco kernel: [    1.056529] pci 0000:00:1f.3: Adding to =
iommu group 13
Feb 17 19:00:29 vinco kernel: [    1.056538] pci 0000:01:00.0: Adding to =
iommu group 1
Feb 17 19:00:29 vinco kernel: [    1.056586] pci 0000:04:00.0: Adding to =
iommu group 14
Feb 17 19:00:29 vinco kernel: [    1.056645] pci 0000:05:00.0: Adding to =
iommu group 15
Feb 17 19:00:29 vinco kernel: [    1.056664] pci 0000:05:00.1: Adding to =
iommu group 15
Feb 17 19:00:29 vinco kernel: [    1.056701] DMAR: Intel(R) Virtualizatio=
n Technology for Directed I/O
Feb 17 19:00:29 vinco kernel: [    1.058211] Initialise system trusted ke=
yrings
Feb 17 19:00:29 vinco kernel: [    1.058219] Key type blacklist registere=
d
Feb 17 19:00:29 vinco kernel: [    1.058239] workingset: timestamp_bits=3D=
40 max_order=3D22 bucket_order=3D0
Feb 17 19:00:29 vinco kernel: [    1.059074] zbud: loaded
Feb 17 19:00:29 vinco kernel: [    1.059239] Platform Keyring initialized=

Feb 17 19:00:29 vinco kernel: [    1.059241] Key type asymmetric register=
ed
Feb 17 19:00:29 vinco kernel: [    1.059242] Asymmetric key parser 'x509'=
 registered
Feb 17 19:00:29 vinco kernel: [    1.059247] Block layer SCSI generic (bs=
g) driver version 0.4 loaded (major 250)
Feb 17 19:00:29 vinco kernel: [    1.059276] io scheduler mq-deadline reg=
istered
Feb 17 19:00:29 vinco kernel: [    1.059502] pcieport 0000:00:01.0: PME: =
Signaling with IRQ 26
Feb 17 19:00:29 vinco kernel: [    1.059626] pcieport 0000:00:1c.0: PME: =
Signaling with IRQ 27
Feb 17 19:00:29 vinco kernel: [    1.059764] pcieport 0000:00:1c.1: PME: =
Signaling with IRQ 28
Feb 17 19:00:29 vinco kernel: [    1.059781] pcieport 0000:00:1c.1: pcieh=
p: Slot #1 AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+ Int=
erlock- NoCompl+ LLActRep+
Feb 17 19:00:29 vinco kernel: [    1.059935] pcieport 0000:00:1c.2: PME: =
Signaling with IRQ 29
Feb 17 19:00:29 vinco kernel: [    1.060062] pcieport 0000:00:1c.3: PME: =
Signaling with IRQ 30
Feb 17 19:00:29 vinco kernel: [    1.060113] shpchp: Standard Hot Plug PC=
I Controller Driver version: 0.4
Feb 17 19:00:29 vinco kernel: [    1.060123] efifb: probing for efifb
Feb 17 19:00:29 vinco kernel: [    1.060138] efifb: framebuffer at 0xd000=
0000, using 3072k, total 3072k
Feb 17 19:00:29 vinco kernel: [    1.060139] efifb: mode is 1024x768x32, =
linelength=3D4096, pages=3D1
Feb 17 19:00:29 vinco kernel: [    1.060139] efifb: scrolling: redraw
Feb 17 19:00:29 vinco kernel: [    1.060140] efifb: Truecolor: size=3D8:8=
:8:8, shift=3D24:16:8:0
Feb 17 19:00:29 vinco kernel: [    1.060196] Console: switching to colour=
 frame buffer device 128x48
Feb 17 19:00:29 vinco kernel: [    1.061474] fb0: EFI VGA frame buffer de=
vice
Feb 17 19:00:29 vinco kernel: [    1.061479] intel_idle: MWAIT substates:=
 0x42120
Feb 17 19:00:29 vinco kernel: [    1.061480] intel_idle: v0.4.1 model 0x3=
C
Feb 17 19:00:29 vinco kernel: [    1.061727] intel_idle: lapic_timer_reli=
able_states 0xffffffff
Feb 17 19:00:29 vinco kernel: [    1.062565] thermal LNXTHERM:00: registe=
red as thermal_zone0
Feb 17 19:00:29 vinco kernel: [    1.062566] ACPI: Thermal Zone [THRM] (5=
0 C)
Feb 17 19:00:29 vinco kernel: [    1.062714] Serial: 8250/16550 driver, 4=
 ports, IRQ sharing enabled
Feb 17 19:00:29 vinco kernel: [    1.063218] Linux agpgart interface v0.1=
03
Feb 17 19:00:29 vinco kernel: [    1.063255] AMD-Vi: AMD IOMMUv2 driver b=
y Joerg Roedel <jroedel@suse.de>
Feb 17 19:00:29 vinco kernel: [    1.063255] AMD-Vi: AMD IOMMUv2 function=
ality not available on this system
Feb 17 19:00:29 vinco kernel: [    1.063588] i8042: PNP: PS/2 Controller =
[PNP030b:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
Feb 17 19:00:29 vinco kernel: [    1.065927] i8042: Detected active multi=
plexing controller, rev 1.1
Feb 17 19:00:29 vinco kernel: [    1.068432] serio: i8042 KBD port at 0x6=
0,0x64 irq 1
Feb 17 19:00:29 vinco kernel: [    1.068434] serio: i8042 AUX0 port at 0x=
60,0x64 irq 12
Feb 17 19:00:29 vinco kernel: [    1.068451] serio: i8042 AUX1 port at 0x=
60,0x64 irq 12
Feb 17 19:00:29 vinco kernel: [    1.068461] serio: i8042 AUX2 port at 0x=
60,0x64 irq 12
Feb 17 19:00:29 vinco kernel: [    1.068471] serio: i8042 AUX3 port at 0x=
60,0x64 irq 12
Feb 17 19:00:29 vinco kernel: [    1.068548] mousedev: PS/2 mouse device =
common for all mice
Feb 17 19:00:29 vinco kernel: [    1.068585] rtc_cmos 00:02: RTC can wake=
 from S4
Feb 17 19:00:29 vinco kernel: [    1.068736] rtc_cmos 00:02: registered a=
s rtc0
Feb 17 19:00:29 vinco kernel: [    1.068754] rtc_cmos 00:02: alarms up to=
 one month, y3k, 242 bytes nvram, hpet irqs
Feb 17 19:00:29 vinco kernel: [    1.068761] intel_pstate: Intel P-state =
driver initializing
Feb 17 19:00:29 vinco kernel: [    1.069369] ledtrig-cpu: registered to i=
ndicate activity on CPUs
Feb 17 19:00:29 vinco kernel: [    1.069693] drop_monitor: Initializing n=
etwork drop monitor service
Feb 17 19:00:29 vinco kernel: [    1.070100] NET: Registered protocol fam=
ily 10
Feb 17 19:00:29 vinco kernel: [    1.085750] Segment Routing with IPv6
Feb 17 19:00:29 vinco kernel: [    1.085772] mip6: Mobile IPv6
Feb 17 19:00:29 vinco kernel: [    1.085774] NET: Registered protocol fam=
ily 17
Feb 17 19:00:29 vinco kernel: [    1.085843] mpls_gso: MPLS GSO support
Feb 17 19:00:29 vinco kernel: [    1.086291] microcode: sig=3D0x306c3, pf=
=3D0x20, revision=3D0x27
Feb 17 19:00:29 vinco kernel: [    1.086466] microcode: Microcode Update =
Driver: v2.2.
Feb 17 19:00:29 vinco kernel: [    1.086477] IPI shorthand broadcast: ena=
bled
Feb 17 19:00:29 vinco kernel: [    1.086482] sched_clock: Marking stable =
(1086035090, 195746)->(1093236631, -7005795)
Feb 17 19:00:29 vinco kernel: [    1.086622] registered taskstats version=
 1
Feb 17 19:00:29 vinco kernel: [    1.086623] Loading compiled-in X.509 ce=
rtificates
Feb 17 19:00:29 vinco kernel: [    1.109359] input: AT Translated Set 2 k=
eyboard as /devices/platform/i8042/serio0/input/input0
Feb 17 19:00:29 vinco kernel: [    1.117180] Loaded X.509 cert 'Debian Se=
cure Boot CA: 6ccece7e4c6c0d1f6149f3dd27dfcc5cbb419ea1'
Feb 17 19:00:29 vinco kernel: [    1.117192] Loaded X.509 cert 'Debian Se=
cure Boot Signer: 00a7468def'
Feb 17 19:00:29 vinco kernel: [    1.117209] zswap: loaded using pool lzo=
/zbud
Feb 17 19:00:29 vinco kernel: [    1.117358] Key type ._fscrypt registere=
d
Feb 17 19:00:29 vinco kernel: [    1.117358] Key type .fscrypt registered=

Feb 17 19:00:29 vinco kernel: [    1.117369] AppArmor: AppArmor sha1 poli=
cy hashing enabled
Feb 17 19:00:29 vinco kernel: [    1.117687] integrity: Loading X.509 cer=
tificate: UEFI:db
Feb 17 19:00:29 vinco kernel: [    1.117857] integrity: Loaded X.509 cert=
 'ASUSTeK Notebook SW Key Certificate: b8e581e4df77a5bb4282d5ccfc00c071'
Feb 17 19:00:29 vinco kernel: [    1.117857] integrity: Loading X.509 cer=
tificate: UEFI:db
Feb 17 19:00:29 vinco kernel: [    1.118011] integrity: Loaded X.509 cert=
 'ASUSTeK MotherBoard SW Key Certificate: da83b990422ebc8c441f8d8b039a65a=
2'
Feb 17 19:00:29 vinco kernel: [    1.118012] integrity: Loading X.509 cer=
tificate: UEFI:db
Feb 17 19:00:29 vinco kernel: [    1.118026] integrity: Loaded X.509 cert=
 'Microsoft Corporation UEFI CA 2011: 13adbf4309bd82709c8cd54f316ed522988=
a1bd4'
Feb 17 19:00:29 vinco kernel: [    1.118026] integrity: Loading X.509 cer=
tificate: UEFI:db
Feb 17 19:00:29 vinco kernel: [    1.118038] integrity: Loaded X.509 cert=
 'Microsoft Windows Production PCA 2011: a92902398e16c49778cd90f99e4f9ae1=
7c55af53'
Feb 17 19:00:29 vinco kernel: [    1.118039] integrity: Loading X.509 cer=
tificate: UEFI:db
Feb 17 19:00:29 vinco kernel: [    1.118225] integrity: Loaded X.509 cert=
 'Canonical Ltd. Master Certificate Authority: ad91990bc22ab1f517048c23b6=
655a268e345a63'
Feb 17 19:00:29 vinco kernel: [    1.118895] rtc_cmos 00:02: setting syst=
em clock to 2020-02-17T17:00:24 UTC (1581958824)
Feb 17 19:00:29 vinco kernel: [    1.119586] Freeing unused kernel image =
memory: 1672K
Feb 17 19:00:29 vinco kernel: [    1.160409] Write protecting the kernel =
read-only data: 16384k
Feb 17 19:00:29 vinco kernel: [    1.161279] Freeing unused kernel image =
memory: 2036K
Feb 17 19:00:29 vinco kernel: [    1.161548] Freeing unused kernel image =
memory: 360K
Feb 17 19:00:29 vinco kernel: [    1.176443] x86/mm: Checked W+X mappings=
: passed, no W+X pages found.
Feb 17 19:00:29 vinco kernel: [    1.176444] x86/mm: Checking user space =
page tables
Feb 17 19:00:29 vinco kernel: [    1.182537] x86/mm: Checked W+X mappings=
: passed, no W+X pages found.
Feb 17 19:00:29 vinco kernel: [    1.182538] Run /init as init process
Feb 17 19:00:29 vinco kernel: [    1.234863] input: Lid Switch as /device=
s/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input4
Feb 17 19:00:29 vinco kernel: [    1.234887] ACPI: Lid Switch [LID]
Feb 17 19:00:29 vinco kernel: [    1.234940] input: Sleep Button as /devi=
ces/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input5
Feb 17 19:00:29 vinco kernel: [    1.234977] ACPI: Sleep Button [SLPB]
Feb 17 19:00:29 vinco kernel: [    1.235018] input: Power Button as /devi=
ces/LNXSYSTM:00/LNXPWRBN:00/input/input6
Feb 17 19:00:29 vinco kernel: [    1.235048] ACPI: Power Button [PWRF]
Feb 17 19:00:29 vinco kernel: [    1.245767] ACPI Warning: SystemIO range=
 0x0000000000001828-0x000000000000182F conflicts with OpRegion 0x00000000=
00001800-0x000000000000184F (\GPIS) (20190816/utaddress-204)
Feb 17 19:00:29 vinco kernel: [    1.245772] ACPI Warning: SystemIO range=
 0x0000000000001828-0x000000000000182F conflicts with OpRegion 0x00000000=
00001800-0x000000000000187F (\PMIO) (20190816/utaddress-204)
Feb 17 19:00:29 vinco kernel: [    1.245776] ACPI: If an ACPI driver is a=
vailable for this device, you should use it instead of the native driver
Feb 17 19:00:29 vinco kernel: [    1.245780] ACPI Warning: SystemIO range=
 0x0000000000001C40-0x0000000000001C4F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C5F (\_SB.PCI0.PEG0.PEGP.GPR) (20190816/utaddress=
-204)
Feb 17 19:00:29 vinco kernel: [    1.245783] ACPI Warning: SystemIO range=
 0x0000000000001C40-0x0000000000001C4F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C7F (\GPIO) (20190816/utaddress-204)
Feb 17 19:00:29 vinco kernel: [    1.245786] ACPI Warning: SystemIO range=
 0x0000000000001C40-0x0000000000001C4F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C63 (\GP01) (20190816/utaddress-204)
Feb 17 19:00:29 vinco kernel: [    1.245788] ACPI: If an ACPI driver is a=
vailable for this device, you should use it instead of the native driver
Feb 17 19:00:29 vinco kernel: [    1.245789] ACPI Warning: SystemIO range=
 0x0000000000001C30-0x0000000000001C3F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C5F (\_SB.PCI0.PEG0.PEGP.GPR) (20190816/utaddress=
-204)
Feb 17 19:00:29 vinco kernel: [    1.245792] ACPI Warning: SystemIO range=
 0x0000000000001C30-0x0000000000001C3F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C7F (\GPIO) (20190816/utaddress-204)
Feb 17 19:00:29 vinco kernel: [    1.245795] ACPI Warning: SystemIO range=
 0x0000000000001C30-0x0000000000001C3F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C63 (\GP01) (20190816/utaddress-204)
Feb 17 19:00:29 vinco kernel: [    1.245797] ACPI Warning: SystemIO range=
 0x0000000000001C30-0x0000000000001C3F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C3F (\GPRL) (20190816/utaddress-204)
Feb 17 19:00:29 vinco kernel: [    1.245800] ACPI: If an ACPI driver is a=
vailable for this device, you should use it instead of the native driver
Feb 17 19:00:29 vinco kernel: [    1.245801] ACPI Warning: SystemIO range=
 0x0000000000001C00-0x0000000000001C2F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C5F (\_SB.PCI0.PEG0.PEGP.GPR) (20190816/utaddress=
-204)
Feb 17 19:00:29 vinco kernel: [    1.245803] ACPI Warning: SystemIO range=
 0x0000000000001C00-0x0000000000001C2F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C7F (\GPIO) (20190816/utaddress-204)
Feb 17 19:00:29 vinco kernel: [    1.245806] ACPI Warning: SystemIO range=
 0x0000000000001C00-0x0000000000001C2F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C63 (\GP01) (20190816/utaddress-204)
Feb 17 19:00:29 vinco kernel: [    1.245809] ACPI Warning: SystemIO range=
 0x0000000000001C00-0x0000000000001C2F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C3F (\GPRL) (20190816/utaddress-204)
Feb 17 19:00:29 vinco kernel: [    1.245811] ACPI: If an ACPI driver is a=
vailable for this device, you should use it instead of the native driver
Feb 17 19:00:29 vinco kernel: [    1.245812] lpc_ich: Resource conflict(s=
) found affecting gpio_ich
Feb 17 19:00:29 vinco kernel: [    1.252456] r8169 0000:05:00.1: can't di=
sable ASPM; OS doesn't have ASPM control
Feb 17 19:00:29 vinco kernel: [    1.255989] SCSI subsystem initialized
Feb 17 19:00:29 vinco kernel: [    1.259015] ACPI: bus type USB registere=
d
Feb 17 19:00:29 vinco kernel: [    1.259030] usbcore: registered new inte=
rface driver usbfs
Feb 17 19:00:29 vinco kernel: [    1.259038] usbcore: registered new inte=
rface driver hub
Feb 17 19:00:29 vinco kernel: [    1.259069] usbcore: registered new devi=
ce driver usb
Feb 17 19:00:29 vinco kernel: [    1.259083] i801_smbus 0000:00:1f.3: SPD=
 Write Disable is set
Feb 17 19:00:29 vinco kernel: [    1.259115] i801_smbus 0000:00:1f.3: SMB=
us using PCI interrupt
Feb 17 19:00:29 vinco kernel: [    1.263588] ehci_hcd: USB 2.0 'Enhanced'=
 Host Controller (EHCI) Driver
Feb 17 19:00:29 vinco kernel: [    1.268640] ehci-pci: EHCI PCI platform =
driver
Feb 17 19:00:29 vinco kernel: [    1.268835] ehci-pci 0000:00:1a.0: EHCI =
Host Controller
Feb 17 19:00:29 vinco kernel: [    1.268842] ehci-pci 0000:00:1a.0: new U=
SB bus registered, assigned bus number 1
Feb 17 19:00:29 vinco kernel: [    1.268853] ehci-pci 0000:00:1a.0: debug=
 port 2
Feb 17 19:00:29 vinco kernel: [    1.270454] libphy: r8169: probed
Feb 17 19:00:29 vinco kernel: [    1.270627] r8169 0000:05:00.1 eth0: RTL=
8411b, 08:62:66:b3:2e:1c, XID 5c8, IRQ 32
Feb 17 19:00:29 vinco kernel: [    1.270629] r8169 0000:05:00.1 eth0: jum=
bo features [frames: 9200 bytes, tx checksumming: ko]
Feb 17 19:00:29 vinco kernel: [    1.271522] libata version 3.00 loaded.
Feb 17 19:00:29 vinco kernel: [    1.272772] ehci-pci 0000:00:1a.0: cache=
 line size of 64 is not supported
Feb 17 19:00:29 vinco kernel: [    1.272801] ehci-pci 0000:00:1a.0: irq 1=
6, io mem 0xf7a1c000
Feb 17 19:00:29 vinco kernel: [    1.277060] r8169 0000:05:00.1 enp5s0f1:=
 renamed from eth0
Feb 17 19:00:29 vinco kernel: [    1.277424] ahci 0000:00:1f.2: version 3=
=2E0
Feb 17 19:00:29 vinco kernel: [    1.277572] ahci 0000:00:1f.2: AHCI 0001=
=2E0300 32 slots 4 ports 6 Gbps 0x14 impl SATA mode
Feb 17 19:00:29 vinco kernel: [    1.277573] ahci 0000:00:1f.2: flags: 64=
bit ncq pm led clo pio slum part ems apst=20
Feb 17 19:00:29 vinco kernel: [    1.288704] scsi host0: ahci
Feb 17 19:00:29 vinco kernel: [    1.288898] scsi host1: ahci
Feb 17 19:00:29 vinco kernel: [    1.289018] scsi host2: ahci
Feb 17 19:00:29 vinco kernel: [    1.289110] scsi host3: ahci
Feb 17 19:00:29 vinco kernel: [    1.289190] scsi host4: ahci
Feb 17 19:00:29 vinco kernel: [    1.289217] ata1: DUMMY
Feb 17 19:00:29 vinco kernel: [    1.289218] ata2: DUMMY
Feb 17 19:00:29 vinco kernel: [    1.289220] ata3: SATA max UDMA/133 abar=
 m2048@0xf7a1a000 port 0xf7a1a200 irq 33
Feb 17 19:00:29 vinco kernel: [    1.289220] ata4: DUMMY
Feb 17 19:00:29 vinco kernel: [    1.289222] ata5: SATA max UDMA/133 abar=
 m2048@0xf7a1a000 port 0xf7a1a300 irq 33
Feb 17 19:00:29 vinco kernel: [    1.292283] ehci-pci 0000:00:1a.0: USB 2=
=2E0 started, EHCI 1.00
Feb 17 19:00:29 vinco kernel: [    1.292326] usb usb1: New USB device fou=
nd, idVendor=3D1d6b, idProduct=3D0002, bcdDevice=3D 5.04
Feb 17 19:00:29 vinco kernel: [    1.292327] usb usb1: New USB device str=
ings: Mfr=3D3, Product=3D2, SerialNumber=3D1
Feb 17 19:00:29 vinco kernel: [    1.292328] usb usb1: Product: EHCI Host=
 Controller
Feb 17 19:00:29 vinco kernel: [    1.292330] usb usb1: Manufacturer: Linu=
x 5.4.0-4-amd64 ehci_hcd
Feb 17 19:00:29 vinco kernel: [    1.292331] usb usb1: SerialNumber: 0000=
:00:1a.0
Feb 17 19:00:29 vinco kernel: [    1.292438] hub 1-0:1.0: USB hub found
Feb 17 19:00:29 vinco kernel: [    1.292443] hub 1-0:1.0: 2 ports detecte=
d
Feb 17 19:00:29 vinco kernel: [    1.292583] xhci_hcd 0000:00:14.0: xHCI =
Host Controller
Feb 17 19:00:29 vinco kernel: [    1.292588] xhci_hcd 0000:00:14.0: new U=
SB bus registered, assigned bus number 2
Feb 17 19:00:29 vinco kernel: [    1.293655] xhci_hcd 0000:00:14.0: hcc p=
arams 0x200077c1 hci version 0x100 quirks 0x0000000000009810
Feb 17 19:00:29 vinco kernel: [    1.293659] xhci_hcd 0000:00:14.0: cache=
 line size of 64 is not supported
Feb 17 19:00:29 vinco kernel: [    1.293800] usb usb2: New USB device fou=
nd, idVendor=3D1d6b, idProduct=3D0002, bcdDevice=3D 5.04
Feb 17 19:00:29 vinco kernel: [    1.293801] usb usb2: New USB device str=
ings: Mfr=3D3, Product=3D2, SerialNumber=3D1
Feb 17 19:00:29 vinco kernel: [    1.293802] usb usb2: Product: xHCI Host=
 Controller
Feb 17 19:00:29 vinco kernel: [    1.293803] usb usb2: Manufacturer: Linu=
x 5.4.0-4-amd64 xhci-hcd
Feb 17 19:00:29 vinco kernel: [    1.293803] usb usb2: SerialNumber: 0000=
:00:14.0
Feb 17 19:00:29 vinco kernel: [    1.293883] hub 2-0:1.0: USB hub found
Feb 17 19:00:29 vinco kernel: [    1.293905] hub 2-0:1.0: 14 ports detect=
ed
Feb 17 19:00:29 vinco kernel: [    1.296045] ehci-pci 0000:00:1d.0: EHCI =
Host Controller
Feb 17 19:00:29 vinco kernel: [    1.296050] ehci-pci 0000:00:1d.0: new U=
SB bus registered, assigned bus number 3
Feb 17 19:00:29 vinco kernel: [    1.296065] ehci-pci 0000:00:1d.0: debug=
 port 2
Feb 17 19:00:29 vinco kernel: [    1.296077] xhci_hcd 0000:00:14.0: xHCI =
Host Controller
Feb 17 19:00:29 vinco kernel: [    1.296080] xhci_hcd 0000:00:14.0: new U=
SB bus registered, assigned bus number 4
Feb 17 19:00:29 vinco kernel: [    1.296083] xhci_hcd 0000:00:14.0: Host =
supports USB 3.0 SuperSpeed
Feb 17 19:00:29 vinco kernel: [    1.296141] usb usb4: New USB device fou=
nd, idVendor=3D1d6b, idProduct=3D0003, bcdDevice=3D 5.04
Feb 17 19:00:29 vinco kernel: [    1.296141] usb usb4: New USB device str=
ings: Mfr=3D3, Product=3D2, SerialNumber=3D1
Feb 17 19:00:29 vinco kernel: [    1.296142] usb usb4: Product: xHCI Host=
 Controller
Feb 17 19:00:29 vinco kernel: [    1.296143] usb usb4: Manufacturer: Linu=
x 5.4.0-4-amd64 xhci-hcd
Feb 17 19:00:29 vinco kernel: [    1.296143] usb usb4: SerialNumber: 0000=
:00:14.0
Feb 17 19:00:29 vinco kernel: [    1.296230] hub 4-0:1.0: USB hub found
Feb 17 19:00:29 vinco kernel: [    1.296244] hub 4-0:1.0: 4 ports detecte=
d
Feb 17 19:00:29 vinco kernel: [    1.299992] ehci-pci 0000:00:1d.0: cache=
 line size of 64 is not supported
Feb 17 19:00:29 vinco kernel: [    1.300004] ehci-pci 0000:00:1d.0: irq 2=
3, io mem 0xf7a1b000
Feb 17 19:00:29 vinco kernel: [    1.316289] ehci-pci 0000:00:1d.0: USB 2=
=2E0 started, EHCI 1.00
Feb 17 19:00:29 vinco kernel: [    1.316336] usb usb3: New USB device fou=
nd, idVendor=3D1d6b, idProduct=3D0002, bcdDevice=3D 5.04
Feb 17 19:00:29 vinco kernel: [    1.316337] usb usb3: New USB device str=
ings: Mfr=3D3, Product=3D2, SerialNumber=3D1
Feb 17 19:00:29 vinco kernel: [    1.316338] usb usb3: Product: EHCI Host=
 Controller
Feb 17 19:00:29 vinco kernel: [    1.316339] usb usb3: Manufacturer: Linu=
x 5.4.0-4-amd64 ehci_hcd
Feb 17 19:00:29 vinco kernel: [    1.316340] usb usb3: SerialNumber: 0000=
:00:1d.0
Feb 17 19:00:29 vinco kernel: [    1.316472] hub 3-0:1.0: USB hub found
Feb 17 19:00:29 vinco kernel: [    1.316477] hub 3-0:1.0: 2 ports detecte=
d
Feb 17 19:00:29 vinco kernel: [    1.341185] i915 0000:00:02.0: VT-d acti=
ve for gfx access
Feb 17 19:00:29 vinco kernel: [    1.341187] checking generic (d0000000 3=
00000) vs hw (d0000000 10000000)
Feb 17 19:00:29 vinco kernel: [    1.341188] fb0: switching to inteldrmfb=
 from EFI VGA
Feb 17 19:00:29 vinco kernel: [    1.341237] Console: switching to colour=
 dummy device 80x25
Feb 17 19:00:29 vinco kernel: [    1.341266] i915 0000:00:02.0: vgaarb: d=
eactivate vga console
Feb 17 19:00:29 vinco kernel: [    1.341478] i915 0000:00:02.0: DMAR acti=
ve, disabling use of stolen memory
Feb 17 19:00:29 vinco kernel: [    1.341944] [drm] Supports vblank timest=
amp caching Rev 2 (21.10.2013).
Feb 17 19:00:29 vinco kernel: [    1.341944] [drm] Driver supports precis=
e vblank timestamp query.
Feb 17 19:00:29 vinco kernel: [    1.342107] i915 0000:00:02.0: vgaarb: c=
hanged VGA decodes: olddecodes=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
Feb 17 19:00:29 vinco kernel: [    1.362230] [drm] Initialized i915 1.6.0=
 20190822 for 0000:00:02.0 on minor 0
Feb 17 19:00:29 vinco kernel: [    1.362656] [Firmware Bug]: ACPI(PEGP) d=
efines _DOD but not _DOS
Feb 17 19:00:29 vinco kernel: [    1.364079] ACPI: Video Device [PEGP] (m=
ulti-head: yes  rom: yes  post: no)
Feb 17 19:00:29 vinco kernel: [    1.366816] input: Video Bus as /devices=
/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:4f/LNXVIDEO:00/input/input9
Feb 17 19:00:29 vinco kernel: [    1.368144] ACPI: Video Device [GFX0] (m=
ulti-head: yes  rom: no  post: no)
Feb 17 19:00:29 vinco kernel: [    1.370548] input: Video Bus as /devices=
/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/input/input10
Feb 17 19:00:29 vinco kernel: [    1.381006] fbcon: i915drmfb (fb0) is pr=
imary device
Feb 17 19:00:29 vinco kernel: [    1.534265] battery: ACPI: Battery Slot =
[BAT0] (battery present)
Feb 17 19:00:29 vinco kernel: [    1.602369] ata5: SATA link up 6.0 Gbps =
(SStatus 133 SControl 300)
Feb 17 19:00:29 vinco kernel: [    1.602390] ata3: SATA link up 1.5 Gbps =
(SStatus 113 SControl 300)
Feb 17 19:00:29 vinco kernel: [    1.604441] ata5.00: ACPI cmd ef/10:06:0=
0:00:00:00 (SET FEATURES) succeeded
Feb 17 19:00:29 vinco kernel: [    1.604444] ata5.00: ACPI cmd f5/00:00:0=
0:00:00:00 (SECURITY FREEZE LOCK) filtered out
Feb 17 19:00:29 vinco kernel: [    1.604445] ata5.00: ACPI cmd b1/c1:00:0=
0:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
Feb 17 19:00:29 vinco kernel: [    1.604729] ata5.00: supports DRM functi=
ons and may not be fully accessible
Feb 17 19:00:29 vinco kernel: [    1.605584] ata5.00: disabling queued TR=
IM support
Feb 17 19:00:29 vinco kernel: [    1.605585] ata5.00: ATA-9: Samsung SSD =
850 EVO 1TB, EMT02B6Q, max UDMA/133
Feb 17 19:00:29 vinco kernel: [    1.605586] ata5.00: 1953525168 sectors,=
 multi 1: LBA48 NCQ (depth 32), AA
Feb 17 19:00:29 vinco kernel: [    1.605834] ata3.00: ATAPI: TSSTcorp CDD=
VDW SU-228FB, AS00, max UDMA/100
Feb 17 19:00:29 vinco kernel: [    1.608488] ata5.00: ACPI cmd ef/10:06:0=
0:00:00:00 (SET FEATURES) succeeded
Feb 17 19:00:29 vinco kernel: [    1.608490] ata5.00: ACPI cmd f5/00:00:0=
0:00:00:00 (SECURITY FREEZE LOCK) filtered out
Feb 17 19:00:29 vinco kernel: [    1.608491] ata5.00: ACPI cmd b1/c1:00:0=
0:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
Feb 17 19:00:29 vinco kernel: [    1.608830] ata5.00: supports DRM functi=
ons and may not be fully accessible
Feb 17 19:00:29 vinco kernel: [    1.609741] ata5.00: disabling queued TR=
IM support
Feb 17 19:00:29 vinco kernel: [    1.611023] ata3.00: configured for UDMA=
/100
Feb 17 19:00:29 vinco kernel: [    1.611538] ata5.00: configured for UDMA=
/133
Feb 17 19:00:29 vinco kernel: [    1.615925] scsi 2:0:0:0: CD-ROM        =
    TSSTcorp CDDVDW SU-228FB  AS00 PQ: 0 ANSI: 5
Feb 17 19:00:29 vinco kernel: [    1.648719] scsi 4:0:0:0: Direct-Access =
    ATA      Samsung SSD 850  2B6Q PQ: 0 ANSI: 5
Feb 17 19:00:29 vinco kernel: [    1.656361] usb 1-1: new high-speed USB =
device number 2 using ehci-pci
Feb 17 19:00:29 vinco kernel: [    1.656365] usb 2-3: new full-speed USB =
device number 2 using xhci_hcd
Feb 17 19:00:29 vinco kernel: [    1.660358] usb 3-1: new high-speed USB =
device number 2 using ehci-pci
Feb 17 19:00:29 vinco kernel: [    1.689350] usb 1-1: New USB device foun=
d, idVendor=3D8087, idProduct=3D8008, bcdDevice=3D 0.05
Feb 17 19:00:29 vinco kernel: [    1.689353] usb 1-1: New USB device stri=
ngs: Mfr=3D0, Product=3D0, SerialNumber=3D0
Feb 17 19:00:29 vinco kernel: [    1.689425] usb 3-1: New USB device foun=
d, idVendor=3D8087, idProduct=3D8000, bcdDevice=3D 0.05
Feb 17 19:00:29 vinco kernel: [    1.689426] usb 3-1: New USB device stri=
ngs: Mfr=3D0, Product=3D0, SerialNumber=3D0
Feb 17 19:00:29 vinco kernel: [    1.689688] hub 1-1:1.0: USB hub found
Feb 17 19:00:29 vinco kernel: [    1.689739] hub 3-1:1.0: USB hub found
Feb 17 19:00:29 vinco kernel: [    1.689879] hub 1-1:1.0: 6 ports detecte=
d
Feb 17 19:00:29 vinco kernel: [    1.689893] hub 3-1:1.0: 8 ports detecte=
d
Feb 17 19:00:29 vinco kernel: [    1.808027] usb 2-3: New USB device foun=
d, idVendor=3D046d, idProduct=3Dc52b, bcdDevice=3D12.03
Feb 17 19:00:29 vinco kernel: [    1.808030] usb 2-3: New USB device stri=
ngs: Mfr=3D1, Product=3D2, SerialNumber=3D0
Feb 17 19:00:29 vinco kernel: [    1.808032] usb 2-3: Product: USB Receiv=
er
Feb 17 19:00:29 vinco kernel: [    1.808034] usb 2-3: Manufacturer: Logit=
ech
Feb 17 19:00:29 vinco kernel: [    1.820801] hidraw: raw HID events drive=
r (C) Jiri Kosina
Feb 17 19:00:29 vinco kernel: [    1.826652] usbcore: registered new inte=
rface driver usbhid
Feb 17 19:00:29 vinco kernel: [    1.826652] usbhid: USB HID core driver
Feb 17 19:00:29 vinco kernel: [    1.828657] input: Logitech USB Receiver=
 as /devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.0/0003:046D:C52B.0001=
/input/input14
Feb 17 19:00:29 vinco kernel: [    1.888651] hid-generic 0003:046D:C52B.0=
001: input,hidraw0: USB HID v1.11 Keyboard [Logitech USB Receiver] on usb=
-0000:00:14.0-3/input0
Feb 17 19:00:29 vinco kernel: [    1.889065] input: Logitech USB Receiver=
 Mouse as /devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.1/0003:046D:C52=
B.0002/input/input15
Feb 17 19:00:29 vinco kernel: [    1.889204] input: Logitech USB Receiver=
 Consumer Control as /devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.1/00=
03:046D:C52B.0002/input/input16
Feb 17 19:00:29 vinco kernel: [    1.936374] usb 2-5: new full-speed USB =
device number 3 using xhci_hcd
Feb 17 19:00:29 vinco kernel: [    1.948451] input: Logitech USB Receiver=
 System Control as /devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.1/0003=
:046D:C52B.0002/input/input17
Feb 17 19:00:29 vinco kernel: [    1.948706] hid-generic 0003:046D:C52B.0=
002: input,hiddev0,hidraw1: USB HID v1.11 Mouse [Logitech USB Receiver] o=
n usb-0000:00:14.0-3/input1
Feb 17 19:00:29 vinco kernel: [    1.949096] hid-generic 0003:046D:C52B.0=
003: hiddev1,hidraw2: USB HID v1.11 Device [Logitech USB Receiver] on usb=
-0000:00:14.0-3/input2
Feb 17 19:00:29 vinco kernel: [    2.049423] logitech-djreceiver 0003:046=
D:C52B.0003: hiddev0,hidraw0: USB HID v1.11 Device [Logitech USB Receiver=
] on usb-0000:00:14.0-3/input2
Feb 17 19:00:29 vinco kernel: [    2.059085] psmouse serio4: elantech: as=
suming hardware version 4 (with firmware version 0x381fa2)
Feb 17 19:00:29 vinco kernel: [    2.074687] psmouse serio4: elantech: Sy=
naptics capabilities query result 0x10, 0x14, 0x0e.
Feb 17 19:00:29 vinco kernel: [    2.080380] tsc: Refined TSC clocksource=
 calibration: 2494.228 MHz
Feb 17 19:00:29 vinco kernel: [    2.080393] clocksource: tsc: mask: 0xff=
ffffffffffffff max_cycles: 0x23f3ed6cc7b, max_idle_ns: 440795302954 ns
Feb 17 19:00:29 vinco kernel: [    2.080445] clocksource: Switched to clo=
cksource tsc
Feb 17 19:00:29 vinco kernel: [    2.086156] usb 2-5: New USB device foun=
d, idVendor=3D8087, idProduct=3D07dc, bcdDevice=3D 0.01
Feb 17 19:00:29 vinco kernel: [    2.086160] usb 2-5: New USB device stri=
ngs: Mfr=3D0, Product=3D0, SerialNumber=3D0
Feb 17 19:00:29 vinco kernel: [    2.089186] psmouse serio4: elantech: El=
an sample query result 05, 1b, 64
Feb 17 19:00:29 vinco kernel: [    2.163622] input: ETPS/2 Elantech Touch=
pad as /devices/platform/i8042/serio4/input/input13
Feb 17 19:00:29 vinco kernel: [    2.171659] input: Logitech Unifying Dev=
ice. Wireless PID:101b Mouse as /devices/pci0000:00/0000:00:14.0/usb2/2-3=
/2-3:1.2/0003:046D:C52B.0003/0003:046D:101B.0004/input/input19
Feb 17 19:00:29 vinco kernel: [    2.171871] hid-generic 0003:046D:101B.0=
004: input,hidraw1: USB HID v1.11 Mouse [Logitech Unifying Device. Wirele=
ss PID:101b] on usb-0000:00:14.0-3/input2:1
Feb 17 19:00:29 vinco kernel: [    2.212366] usb 2-7: new high-speed USB =
device number 4 using xhci_hcd
Feb 17 19:00:29 vinco kernel: [    2.219056] input: Logitech M705 as /dev=
ices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.2/0003:046D:C52B.0003/0003:04=
6D:101B.0004/input/input23
Feb 17 19:00:29 vinco kernel: [    2.219223] logitech-hidpp-device 0003:0=
46D:101B.0004: input,hidraw1: USB HID v1.11 Mouse [Logitech M705] on usb-=
0000:00:14.0-3/input2:1
Feb 17 19:00:29 vinco kernel: [    2.334409] usb 2-7: New USB device foun=
d, idVendor=3D13d3, idProduct=3D5188, bcdDevice=3D 8.14
Feb 17 19:00:29 vinco kernel: [    2.334412] usb 2-7: New USB device stri=
ngs: Mfr=3D3, Product=3D1, SerialNumber=3D2
Feb 17 19:00:29 vinco kernel: [    2.334414] usb 2-7: Product: USB2.0 UVC=
 HD Webcam
Feb 17 19:00:29 vinco kernel: [    2.334415] usb 2-7: Manufacturer: Azure=
wave
Feb 17 19:00:29 vinco kernel: [    2.334416] usb 2-7: SerialNumber: NULL
Feb 17 19:00:29 vinco kernel: [    2.639249] Console: switching to colour=
 frame buffer device 240x67
Feb 17 19:00:29 vinco kernel: [    2.662663] i915 0000:00:02.0: fb0: i915=
drmfb frame buffer device
Feb 17 19:00:29 vinco kernel: [    2.693240] sd 4:0:0:0: [sda] 1953525168=
 512-byte logical blocks: (1.00 TB/932 GiB)
Feb 17 19:00:29 vinco kernel: [    2.693254] sd 4:0:0:0: [sda] Write Prot=
ect is off
Feb 17 19:00:29 vinco kernel: [    2.693256] sd 4:0:0:0: [sda] Mode Sense=
: 00 3a 00 00
Feb 17 19:00:29 vinco kernel: [    2.693279] sd 4:0:0:0: [sda] Write cach=
e: enabled, read cache: enabled, doesn't support DPO or FUA
Feb 17 19:00:29 vinco kernel: [    2.742901] sr 2:0:0:0: [sr0] scsi3-mmc =
drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Feb 17 19:00:29 vinco kernel: [    2.742904] cdrom: Uniform CD-ROM driver=
 Revision: 3.20
Feb 17 19:00:29 vinco kernel: [    2.745150]  sda: sda1 sda2 sda3 sda4 sd=
a6
Feb 17 19:00:29 vinco kernel: [    2.746620] sd 4:0:0:0: [sda] supports T=
CG Opal
Feb 17 19:00:29 vinco kernel: [    2.746623] sd 4:0:0:0: [sda] Attached S=
CSI disk
Feb 17 19:00:29 vinco kernel: [    2.760728] sr 2:0:0:0: Attached scsi CD=
-ROM sr0
Feb 17 19:00:29 vinco kernel: [    3.160292] raid6: avx2x4   gen() 31358 =
MB/s
Feb 17 19:00:29 vinco kernel: [    3.228293] raid6: avx2x4   xor() 20364 =
MB/s
Feb 17 19:00:29 vinco kernel: [    3.296291] raid6: avx2x2   gen() 27548 =
MB/s
Feb 17 19:00:29 vinco kernel: [    3.364290] raid6: avx2x2   xor() 17699 =
MB/s
Feb 17 19:00:29 vinco kernel: [    3.432292] raid6: avx2x1   gen() 24359 =
MB/s
Feb 17 19:00:29 vinco kernel: [    3.500291] raid6: avx2x1   xor() 16245 =
MB/s
Feb 17 19:00:29 vinco kernel: [    3.568292] raid6: sse2x4   gen() 17446 =
MB/s
Feb 17 19:00:29 vinco kernel: [    3.636293] raid6: sse2x4   xor() 10912 =
MB/s
Feb 17 19:00:29 vinco kernel: [    3.704294] raid6: sse2x2   gen() 14330 =
MB/s
Feb 17 19:00:29 vinco kernel: [    3.772294] raid6: sse2x2   xor()  9929 =
MB/s
Feb 17 19:00:29 vinco kernel: [    3.840295] raid6: sse2x1   gen() 12222 =
MB/s
Feb 17 19:00:29 vinco kernel: [    3.908294] raid6: sse2x1   xor()  8448 =
MB/s
Feb 17 19:00:29 vinco kernel: [    3.908294] raid6: using algorithm avx2x=
4 gen() 31358 MB/s
Feb 17 19:00:29 vinco kernel: [    3.908295] raid6: .... xor() 20364 MB/s=
, rmw enabled
Feb 17 19:00:29 vinco kernel: [    3.908295] raid6: using avx2x2 recovery=
 algorithm
Feb 17 19:00:29 vinco kernel: [    3.914101] xor: automatically using bes=
t checksumming function   avx      =20
Feb 17 19:00:29 vinco kernel: [    3.955633] Btrfs loaded, crc32c=3Dcrc32=
c-intel
Feb 17 19:00:29 vinco kernel: [    4.132087] PM: Image not found (code -2=
2)
Feb 17 19:00:29 vinco kernel: [    4.216079] EXT4-fs (sda4): mounted file=
system with ordered data mode. Opts: (null)
Feb 17 19:00:29 vinco kernel: [    4.591728] EXT4-fs (sda4): re-mounted. =
Opts: errors=3Dremount-ro
Feb 17 19:00:29 vinco kernel: [    4.605090] lp: driver loaded but no dev=
ices found
Feb 17 19:00:29 vinco kernel: [    4.609694] ppdev: user-space parallel p=
ort driver
Feb 17 19:00:29 vinco kernel: [    4.746810] ACPI: AC Adapter [AC0] (on-l=
ine)
Feb 17 19:00:29 vinco kernel: [    4.752998] input: Asus Wireless Radio C=
ontrol as /devices/LNXSYSTM:00/LNXSYBUS:00/ATK4002:00/input/input24
Feb 17 19:00:29 vinco kernel: [    4.801187] EDAC ie31200: No ECC support=

Feb 17 19:00:29 vinco kernel: [    4.802975] iTCO_vendor_support: vendor-=
support=3D0
Feb 17 19:00:29 vinco kernel: [    4.808055] iTCO_wdt: Intel TCO WatchDog=
 Timer Driver v1.11
Feb 17 19:00:29 vinco kernel: [    4.808094] iTCO_wdt: Found a Lynx Point=
 TCO device (Version=3D2, TCOBASE=3D0x1860)
Feb 17 19:00:29 vinco kernel: [    4.809160] iTCO_wdt: initialized. heart=
beat=3D30 sec (nowayout=3D0)
Feb 17 19:00:29 vinco kernel: [    4.810637] input: PC Speaker as /device=
s/platform/pcspkr/input/input25
Feb 17 19:00:29 vinco kernel: [    4.814059] sr 2:0:0:0: Attached scsi ge=
neric sg0 type 5
Feb 17 19:00:29 vinco kernel: [    4.814088] sd 4:0:0:0: Attached scsi ge=
neric sg1 type 0
Feb 17 19:00:29 vinco kernel: [    4.822466] EFI Variables Facility v0.08=
 2004-May-17
Feb 17 19:00:29 vinco kernel: [    4.840473] RAPL PMU: API unit is 2^-32 =
Joules, 4 fixed counters, 655360 ms ovfl timer
Feb 17 19:00:29 vinco kernel: [    4.840475] RAPL PMU: hw unit of domain =
pp0-core 2^-14 Joules
Feb 17 19:00:29 vinco kernel: [    4.840476] RAPL PMU: hw unit of domain =
package 2^-14 Joules
Feb 17 19:00:29 vinco kernel: [    4.840476] RAPL PMU: hw unit of domain =
dram 2^-14 Joules
Feb 17 19:00:29 vinco kernel: [    4.840477] RAPL PMU: hw unit of domain =
pp1-gpu 2^-14 Joules
Feb 17 19:00:29 vinco kernel: [    4.890467] pstore: Using crash dump com=
pression: deflate
Feb 17 19:00:29 vinco kernel: [    4.916875] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.917612] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.917708] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.917802] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.918582] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.918676] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.918762] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.918849] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.919113] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.919203] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.919970] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.920060] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.920819] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.921183] mc: Linux media interface: v=
0.10
Feb 17 19:00:29 vinco kernel: [    4.921597] asus_wmi: ASUS WMI generic d=
river loaded
Feb 17 19:00:29 vinco kernel: [    4.923725] snd_hda_intel 0000:00:03.0: =
bound 0000:00:02.0 (ops i915_audio_component_bind_ops [i915])
Feb 17 19:00:29 vinco kernel: [    4.923906] asus_wmi: Initialization: 0x=
1
Feb 17 19:00:29 vinco kernel: [    4.923942] asus_wmi: BIOS WMI version: =
7.9
Feb 17 19:00:29 vinco kernel: [    4.923990] asus_wmi: SFUN value: 0x6a08=
77
Feb 17 19:00:29 vinco kernel: [    4.923992] asus-nb-wmi asus-nb-wmi: Det=
ected ATK, not ASUSWMI, use DSTS
Feb 17 19:00:29 vinco kernel: [    4.923994] asus-nb-wmi asus-nb-wmi: Det=
ected ATK, enable event queue
Feb 17 19:00:29 vinco kernel: [    4.925498] input: Asus WMI hotkeys as /=
devices/platform/asus-nb-wmi/input/input26
Feb 17 19:00:29 vinco kernel: [    4.927290] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.927497] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.927672] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.928594] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.929430] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.929696] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.933323] alg: No test for fips(ansi_c=
prng) (fips_ansi_cprng)
Feb 17 19:00:29 vinco kernel: [    4.938849] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.939088] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.939303] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.939380] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.939454] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.939530] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.939607] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.939681] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.939757] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.939831] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.939922] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.940000] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.940071] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.940152] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.940223] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.940304] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.940379] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.940450] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.940521] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.940592] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.941161] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.941232] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.941303] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.941383] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.941452] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.941525] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.941602] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.941691] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.941772] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.942677] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.942761] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.942842] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.942923] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.943002] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.943085] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.943163] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.943243] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.943315] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.943383] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.943450] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:00:29 vinco kernel: [    4.943490] pstore: Registered efi as pe=
rsistent store backend
Feb 17 19:00:29 vinco kernel: [    4.956658] cryptd: max_cpu_qlen set to =
1000
Feb 17 19:00:29 vinco kernel: [    4.956895] videodev: Linux video captur=
e interface: v2.00
Feb 17 19:00:29 vinco kernel: [    4.960604] input: HDA Intel HDMI HDMI/D=
P,pcm=3D3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input27
Feb 17 19:00:29 vinco kernel: [    4.960654] input: HDA Intel HDMI HDMI/D=
P,pcm=3D7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input28
Feb 17 19:00:29 vinco kernel: [    4.960721] input: HDA Intel HDMI HDMI/D=
P,pcm=3D8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input29
Feb 17 19:00:29 vinco kernel: [    4.960768] input: HDA Intel HDMI HDMI/D=
P,pcm=3D9 as /devices/pci0000:00/0000:00:03.0/sound/card0/input30
Feb 17 19:00:29 vinco kernel: [    4.960813] input: HDA Intel HDMI HDMI/D=
P,pcm=3D10 as /devices/pci0000:00/0000:00:03.0/sound/card0/input31
Feb 17 19:00:29 vinco kernel: [    4.961155] Intel(R) Wireless WiFi drive=
r for Linux
Feb 17 19:00:29 vinco kernel: [    4.961156] Copyright(c) 2003- 2015 Inte=
l Corporation
Feb 17 19:00:29 vinco kernel: [    4.964289] Adding 15625212k swap on /de=
v/sda3.  Priority:-2 extents:1 across:15625212k SSFS
Feb 17 19:00:29 vinco kernel: [    4.966056] iwlwifi 0000:04:00.0: firmwa=
re: direct-loading firmware iwlwifi-7260-17.ucode
Feb 17 19:00:29 vinco kernel: [    4.966271] iwlwifi 0000:04:00.0: loaded=
 firmware version 17.3216344376.0 op_mode iwlmvm
Feb 17 19:00:29 vinco kernel: [    4.966379] AVX2 version of gcm_enc/dec =
engaged.
Feb 17 19:00:29 vinco kernel: [    4.966380] AES CTR mode by8 optimizatio=
n enabled
Feb 17 19:00:29 vinco kernel: [    4.984820] EXT4-fs (sda2): mounting ext=
2 file system using the ext4 subsystem
Feb 17 19:00:29 vinco kernel: [    4.989922] EXT4-fs (sda2): mounted file=
system without journal. Opts: (null)
Feb 17 19:00:29 vinco kernel: [    5.037220] EXT4-fs (sda6): mounted file=
system with ordered data mode. Opts: (null)
Feb 17 19:00:29 vinco kernel: [    5.055549] snd_hda_codec_realtek hdaudi=
oC1D0: autoconfig for ALC668: line_outs=3D2 (0x14/0x1a/0x0/0x0/0x0) type:=
speaker
Feb 17 19:00:29 vinco kernel: [    5.055552] snd_hda_codec_realtek hdaudi=
oC1D0:    speaker_outs=3D0 (0x0/0x0/0x0/0x0/0x0)
Feb 17 19:00:29 vinco kernel: [    5.055553] snd_hda_codec_realtek hdaudi=
oC1D0:    hp_outs=3D1 (0x15/0x0/0x0/0x0/0x0)
Feb 17 19:00:29 vinco kernel: [    5.055554] snd_hda_codec_realtek hdaudi=
oC1D0:    mono: mono_out=3D0x0
Feb 17 19:00:29 vinco kernel: [    5.055555] snd_hda_codec_realtek hdaudi=
oC1D0:    inputs:
Feb 17 19:00:29 vinco kernel: [    5.055557] snd_hda_codec_realtek hdaudi=
oC1D0:      Headphone Mic=3D0x19
Feb 17 19:00:29 vinco kernel: [    5.055558] snd_hda_codec_realtek hdaudi=
oC1D0:      Headset Mic=3D0x1b
Feb 17 19:00:29 vinco kernel: [    5.055559] snd_hda_codec_realtek hdaudi=
oC1D0:      Internal Mic=3D0x12
Feb 17 19:00:29 vinco kernel: [    5.055652] uvcvideo: Found UVC 1.00 dev=
ice USB2.0 UVC HD Webcam (13d3:5188)
Feb 17 19:00:29 vinco kernel: [    5.073219] uvcvideo 2-7:1.0: Entity typ=
e for entity Extension 4 was not initialized!
Feb 17 19:00:29 vinco kernel: [    5.073222] uvcvideo 2-7:1.0: Entity typ=
e for entity Processing 2 was not initialized!
Feb 17 19:00:29 vinco kernel: [    5.073223] uvcvideo 2-7:1.0: Entity typ=
e for entity Camera 1 was not initialized!
Feb 17 19:00:29 vinco kernel: [    5.073313] input: USB2.0 UVC HD Webcam:=
 USB2.0 UV as /devices/pci0000:00/0000:00:14.0/usb2/2-7/2-7:1.0/input/inp=
ut33
Feb 17 19:00:29 vinco kernel: [    5.073372] usbcore: registered new inte=
rface driver uvcvideo
Feb 17 19:00:29 vinco kernel: [    5.073373] USB Video Class driver (1.1.=
1)
Feb 17 19:00:29 vinco kernel: [    5.106164] input: HDA Intel PCH Headpho=
ne Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input32
Feb 17 19:00:29 vinco kernel: [    5.142366] Bluetooth: Core ver 2.22
Feb 17 19:00:29 vinco kernel: [    5.142377] NET: Registered protocol fam=
ily 31
Feb 17 19:00:29 vinco kernel: [    5.142378] Bluetooth: HCI device and co=
nnection manager initialized
Feb 17 19:00:29 vinco kernel: [    5.142381] Bluetooth: HCI socket layer =
initialized
Feb 17 19:00:29 vinco kernel: [    5.142383] Bluetooth: L2CAP socket laye=
r initialized
Feb 17 19:00:29 vinco kernel: [    5.142386] Bluetooth: SCO socket layer =
initialized
Feb 17 19:00:29 vinco kernel: [    5.208636] iwlwifi 0000:04:00.0: Detect=
ed Intel(R) Dual Band Wireless N 7260, REV=3D0x144
Feb 17 19:00:29 vinco kernel: [    5.248722] iwlwifi 0000:04:00.0: base H=
W address: 48:51:b7:6b:7d:3a
Feb 17 19:00:29 vinco kernel: [    5.298214] audit: type=3D1400 audit(158=
1958828.673:2): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"aatest-nvidia_modprobe" pid=3D684 comm=3D"apparmor_p=
arser"
Feb 17 19:00:29 vinco kernel: [    5.298695] audit: type=3D1400 audit(158=
1958828.673:3): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"openbazaard2" pid=3D683 comm=3D"apparmor_parser"
Feb 17 19:00:29 vinco kernel: [    5.298699] audit: type=3D1400 audit(158=
1958828.673:4): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"openbazaard2//ip" pid=3D683 comm=3D"apparmor_parser"=

Feb 17 19:00:29 vinco kernel: [    5.298730] audit: type=3D1400 audit(158=
1958828.673:5): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"nvidia_modprobe" pid=3D687 comm=3D"apparmor_parser"
Feb 17 19:00:29 vinco kernel: [    5.298732] audit: type=3D1400 audit(158=
1958828.673:6): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"nvidia_modprobe//kmod" pid=3D687 comm=3D"apparmor_pa=
rser"
Feb 17 19:00:29 vinco kernel: [    5.303771] audit: type=3D1400 audit(158=
1958828.677:7): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"klogd" pid=3D691 comm=3D"apparmor_parser"
Feb 17 19:00:29 vinco kernel: [    5.303849] audit: type=3D1400 audit(158=
1958828.677:8): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"mdnsd" pid=3D685 comm=3D"apparmor_parser"
Feb 17 19:00:29 vinco kernel: [    5.306380] audit: type=3D1400 audit(158=
1958828.681:9): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/lib/ipsec/charon" pid=3D681 comm=3D"apparmor_pa=
rser"
Feb 17 19:00:29 vinco kernel: [    5.308114] audit: type=3D1400 audit(158=
1958828.681:10): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/sbin/haveged" pid=3D692 comm=3D"apparmor_parser=
"
Feb 17 19:00:29 vinco kernel: [    5.308462] audit: type=3D1400 audit(158=
1958828.685:11): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/bin/skype" pid=3D689 comm=3D"apparmor_parser"
Feb 17 19:00:29 vinco kernel: [    5.360608] usbcore: registered new inte=
rface driver btusb
Feb 17 19:00:29 vinco kernel: [    5.372891] Bluetooth: hci0: read Intel =
version: 3707100180012d0d00
Feb 17 19:00:29 vinco kernel: [    5.374295] bluetooth hci0: firmware: di=
rect-loading firmware intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
Feb 17 19:00:29 vinco kernel: [    5.374297] Bluetooth: hci0: Intel Bluet=
ooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
Feb 17 19:00:29 vinco kernel: [    5.434666] ieee80211 phy0: Selected rat=
e control algorithm 'iwl-mvm-rs'
Feb 17 19:00:29 vinco kernel: [    5.439586] iwlwifi 0000:04:00.0 wlp4s0:=
 renamed from wlan0
Feb 17 19:00:29 vinco kernel: [    5.479892] intel_rapl_common: Found RAP=
L domain package
Feb 17 19:00:29 vinco kernel: [    5.479893] intel_rapl_common: Found RAP=
L domain core
Feb 17 19:00:29 vinco kernel: [    5.479894] intel_rapl_common: Found RAP=
L domain uncore
Feb 17 19:00:29 vinco kernel: [    5.479895] intel_rapl_common: Found RAP=
L domain dram
Feb 17 19:00:29 vinco kernel: [    5.479898] intel_rapl_common: RAPL pack=
age-0 domain package locked by BIOS
Feb 17 19:00:29 vinco kernel: [    5.479901] intel_rapl_common: RAPL pack=
age-0 domain dram locked by BIOS
Feb 17 19:00:29 vinco kernel: [    5.528859] Bluetooth: hci0: unexpected =
event for opcode 0xfc2f
Feb 17 19:00:29 vinco kernel: [    5.543867] Bluetooth: hci0: Intel firmw=
are patch completed and activated
Feb 17 19:00:29 vinco kernel: [    5.804066] bbswitch: loading out-of-tre=
e module taints kernel.
Feb 17 19:00:29 vinco kernel: [    5.833248] bbswitch: module verificatio=
n failed: signature and/or required key missing - tainting kernel
Feb 17 19:00:29 vinco kernel: [    5.833528] bbswitch: version 0.8
Feb 17 19:00:29 vinco kernel: [    5.833532] bbswitch: Found integrated V=
GA device 0000:00:02.0: \_SB_.PCI0.GFX0
Feb 17 19:00:29 vinco kernel: [    5.833538] bbswitch: Found discrete VGA=
 device 0000:01:00.0: \_SB_.PCI0.PEG0.PEGP
Feb 17 19:00:29 vinco kernel: [    5.833549] ACPI Warning: \_SB.PCI0.PEG0=
=2EPEGP._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [=
Package] (20190816/nsarguments-59)
Feb 17 19:00:29 vinco kernel: [    5.833625] bbswitch: detected an Optimu=
s _DSM function
Feb 17 19:00:29 vinco kernel: [    5.833687] bbswitch: Succesfully loaded=
=2E Discrete card 0000:01:00.0 is on
Feb 17 19:00:29 vinco kernel: [    5.834507] bbswitch: disabling discrete=
 graphics
Feb 17 19:00:29 vinco kernel: [    5.847235] IPMI message handler: versio=
n 39.2
Feb 17 19:00:29 vinco kernel: [    5.849661] ipmi device interface
Feb 17 19:00:29 vinco kernel: [    5.900291] nvidia: module license 'NVID=
IA' taints kernel.
Feb 17 19:00:29 vinco kernel: [    5.900293] Disabling lock debugging due=
 to kernel taint
Feb 17 19:00:29 vinco kernel: [    5.911166] nvidia-nvlink: Nvlink Core i=
s being initialized, major device number 244
Feb 17 19:00:29 vinco kernel: [    5.911381] nvidia 0000:01:00.0: Refused=
 to change power state, currently in D3
Feb 17 19:00:29 vinco kernel: [    5.911469] NVRM: This is a 64-bit BAR m=
apped above 4GB by the system
Feb 17 19:00:29 vinco kernel: [    5.911469] NVRM: BIOS or the Linux kern=
el, but the PCI bridge
Feb 17 19:00:29 vinco kernel: [    5.911469] NVRM: immediately upstream o=
f this GPU does not define
Feb 17 19:00:29 vinco kernel: [    5.911469] NVRM: a matching prefetchabl=
e memory window.
Feb 17 19:00:29 vinco kernel: [    5.911469] NVRM: This may be due to a k=
nown Linux kernel bug.  Please
Feb 17 19:00:29 vinco kernel: [    5.911469] NVRM: see the README section=
 on 64-bit BARs for additional
Feb 17 19:00:29 vinco kernel: [    5.911469] NVRM: information.
Feb 17 19:00:29 vinco kernel: [    5.911475] nvidia: probe of 0000:01:00.=
0 failed with error -1
Feb 17 19:00:29 vinco kernel: [    5.911494] NVRM: The NVIDIA probe routi=
ne failed for 1 device(s).
Feb 17 19:00:29 vinco kernel: [    5.911494] NVRM: None of the NVIDIA gra=
phics adapters were initialized!
Feb 17 19:00:29 vinco kernel: [    5.942010] Bluetooth: BNEP (Ethernet Em=
ulation) ver 1.3
Feb 17 19:00:29 vinco kernel: [    5.942011] Bluetooth: BNEP filters: pro=
tocol multicast
Feb 17 19:00:29 vinco kernel: [    5.942016] Bluetooth: BNEP socket layer=
 initialized
Feb 17 19:00:29 vinco kernel: [    5.960974] nvidia-nvlink: Unregistered =
the Nvlink Core, major device number 244
Feb 17 19:00:29 vinco kernel: [    6.313548] r8169 0000:05:00.1: firmware=
: direct-loading firmware rtl_nic/rtl8411-2.fw
Feb 17 19:00:29 vinco kernel: [    6.313616] Generic FE-GE Realtek PHY r8=
169-501:00: attached PHY driver [Generic FE-GE Realtek PHY] (mii_bus:phy_=
addr=3Dr8169-501:00, irq=3DIGNORE)
Feb 17 19:00:29 vinco kernel: [    6.436521] r8169 0000:05:00.1 enp5s0f1:=
 Link is Down
Feb 17 19:00:30 vinco kernel: [    7.196705] broken atomic modeset usersp=
ace detected, disabling atomic
Feb 17 19:00:32 vinco kernel: [    9.009730] r8169 0000:05:00.1 enp5s0f1:=
 Link is Up - 1Gbps/Full - flow control rx/tx
Feb 17 19:00:32 vinco kernel: [    9.009740] IPv6: ADDRCONF(NETDEV_CHANGE=
): enp5s0f1: link becomes ready
Feb 17 19:00:32 vinco kernel: [    9.046195] PPP generic driver version 2=
=2E4.2
Feb 17 19:00:32 vinco kernel: [    9.047417] NET: Registered protocol fam=
ily 24
Feb 17 19:00:32 vinco kernel: [    9.055544] l2tp_core: L2TP core driver,=
 V2.0
Feb 17 19:00:32 vinco kernel: [    9.057888] l2tp_netlink: L2TP netlink i=
nterface
Feb 17 19:00:32 vinco kernel: [    9.060261] l2tp_ppp: PPPoL2TP kernel dr=
iver, V2.0
Feb 17 19:00:32 vinco kernel: [    9.070125] vboxdrv: Found 8 processor c=
ores
Feb 17 19:00:32 vinco kernel: [    9.088760] vboxdrv: TSC mode is Invaria=
nt, tentative frequency 2494215834 Hz
Feb 17 19:00:32 vinco kernel: [    9.088761] vboxdrv: Successfully loaded=
 version 6.1.2_Debian (interface 0x002d0001)
Feb 17 19:00:32 vinco kernel: [    9.097275] Initializing XFRM netlink so=
cket
Feb 17 19:00:32 vinco kernel: [    9.100146] VBoxNetFlt: Successfully sta=
rted.
Feb 17 19:00:32 vinco kernel: [    9.108909] VBoxNetAdp: Successfully sta=
rted.
Feb 17 19:06:08 vinco kernel: [  345.659069] Bluetooth: RFCOMM TTY layer =
initialized
Feb 17 19:06:08 vinco kernel: [  345.659078] Bluetooth: RFCOMM socket lay=
er initialized
Feb 17 19:06:08 vinco kernel: [  345.659083] Bluetooth: RFCOMM ver 1.11
Feb 17 19:06:11 vinco kernel: [  348.556640] logitech-hidpp-device 0003:0=
46D:101B.0004: HID++ 1.0 device connected.
Feb 17 19:06:11 vinco kernel: [  348.666639] logitech-hidpp-device 0003:0=
46D:101B.0004: multiplier =3D 8
Feb 17 19:11:19 vinco kernel: [  656.852221] bbswitch: enabling discrete =
graphics
Feb 17 19:11:37 vinco kernel: [    0.000000] microcode: microcode updated=
 early to revision 0x27, date =3D 2019-02-26
Feb 17 19:11:37 vinco kernel: [    0.000000] Linux version 5.4.0-4-amd64 =
(debian-kernel@lists.debian.org) (gcc version 9.2.1 20200203 (Debian 9.2.=
1-28)) #1 SMP Debian 5.4.19-1 (2020-02-13)
Feb 17 19:11:37 vinco kernel: [    0.000000] Command line: BOOT_IMAGE=3D/=
vmlinuz-5.4.0-4-amd64 root=3DUUID=3D795ee075-978f-4245-9dad-ecccd37080d8 =
ro quiet apparmor=3D1 security=3Dapparmor
Feb 17 19:11:37 vinco kernel: [    0.000000] x86/fpu: Supporting XSAVE fe=
ature 0x001: 'x87 floating point registers'
Feb 17 19:11:37 vinco kernel: [    0.000000] x86/fpu: Supporting XSAVE fe=
ature 0x002: 'SSE registers'
Feb 17 19:11:37 vinco kernel: [    0.000000] x86/fpu: Supporting XSAVE fe=
ature 0x004: 'AVX registers'
Feb 17 19:11:37 vinco kernel: [    0.000000] x86/fpu: xstate_offset[2]:  =
576, xstate_sizes[2]:  256
Feb 17 19:11:37 vinco kernel: [    0.000000] x86/fpu: Enabled xstate feat=
ures 0x7, context size is 832 bytes, using 'standard' format.
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-provided physical RAM m=
ap:
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x0000000000=
000000-0x0000000000057fff] usable
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x0000000000=
058000-0x0000000000058fff] reserved
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x0000000000=
059000-0x000000000009efff] usable
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x0000000000=
09f000-0x000000000009ffff] reserved
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x0000000000=
100000-0x00000000b9754fff] usable
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000b9=
755000-0x00000000b975bfff] ACPI NVS
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000b9=
75c000-0x00000000b9fd4fff] usable
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000b9=
fd5000-0x00000000ba275fff] reserved
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000ba=
276000-0x00000000c98c5fff] usable
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000c9=
8c6000-0x00000000c9acefff] reserved
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000c9=
acf000-0x00000000c9e00fff] usable
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000c9=
e01000-0x00000000cab05fff] ACPI NVS
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000ca=
b06000-0x00000000caf59fff] reserved
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000ca=
f5a000-0x00000000caffefff] type 20
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000ca=
fff000-0x00000000caffffff] usable
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000cb=
c00000-0x00000000cfdfffff] reserved
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000f8=
000000-0x00000000fbffffff] reserved
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000fe=
c00000-0x00000000fec00fff] reserved
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000fe=
d00000-0x00000000fed03fff] reserved
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000fe=
d1c000-0x00000000fed1ffff] reserved
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000fe=
e00000-0x00000000fee00fff] reserved
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x00000000ff=
000000-0x00000000ffffffff] reserved
Feb 17 19:11:37 vinco kernel: [    0.000000] BIOS-e820: [mem 0x0000000100=
000000-0x000000042f1fffff] usable
Feb 17 19:11:37 vinco kernel: [    0.000000] NX (Execute Disable) protect=
ion: active
Feb 17 19:11:37 vinco kernel: [    0.000000] efi: EFI v2.31 by American M=
egatrends
Feb 17 19:11:37 vinco kernel: [    0.000000] efi:  ACPI 2.0=3D0xc9e89000 =
 ACPI=3D0xc9e89000  SMBIOS=3D0xf04c0  MPS=3D0xfd5a0=20
Feb 17 19:11:37 vinco kernel: [    0.000000] secureboot: Secure boot coul=
d not be determined (mode 0)
Feb 17 19:11:37 vinco kernel: [    0.000000] SMBIOS 2.7 present.
Feb 17 19:11:37 vinco kernel: [    0.000000] DMI: ASUSTeK COMPUTER INC. N=
551JM/N551JM, BIOS N551JM.205 02/13/2015
Feb 17 19:11:37 vinco kernel: [    0.000000] tsc: Fast TSC calibration us=
ing PIT
Feb 17 19:11:37 vinco kernel: [    0.000000] tsc: Detected 2494.220 MHz p=
rocessor
Feb 17 19:11:37 vinco kernel: [    0.001377] e820: update [mem 0x00000000=
-0x00000fff] usable =3D=3D> reserved
Feb 17 19:11:37 vinco kernel: [    0.001379] e820: remove [mem 0x000a0000=
-0x000fffff] usable
Feb 17 19:11:37 vinco kernel: [    0.001384] last_pfn =3D 0x42f200 max_ar=
ch_pfn =3D 0x400000000
Feb 17 19:11:37 vinco kernel: [    0.001387] MTRR default type: uncachabl=
e
Feb 17 19:11:37 vinco kernel: [    0.001387] MTRR fixed ranges enabled:
Feb 17 19:11:37 vinco kernel: [    0.001388]   00000-9FFFF write-back
Feb 17 19:11:37 vinco kernel: [    0.001389]   A0000-BFFFF uncachable
Feb 17 19:11:37 vinco kernel: [    0.001389]   C0000-CFFFF write-protect
Feb 17 19:11:37 vinco kernel: [    0.001390]   D0000-DFFFF uncachable
Feb 17 19:11:37 vinco kernel: [    0.001390]   E0000-FFFFF write-protect
Feb 17 19:11:37 vinco kernel: [    0.001391] MTRR variable ranges enabled=
:
Feb 17 19:11:37 vinco kernel: [    0.001392]   0 base 0000000000 mask 7C0=
0000000 write-back
Feb 17 19:11:37 vinco kernel: [    0.001392]   1 base 0400000000 mask 7FE=
0000000 write-back
Feb 17 19:11:37 vinco kernel: [    0.001393]   2 base 0420000000 mask 7FF=
0000000 write-back
Feb 17 19:11:37 vinco kernel: [    0.001394]   3 base 00E0000000 mask 7FE=
0000000 uncachable
Feb 17 19:11:37 vinco kernel: [    0.001394]   4 base 00D0000000 mask 7FF=
0000000 uncachable
Feb 17 19:11:37 vinco kernel: [    0.001395]   5 base 00CC000000 mask 7FF=
C000000 uncachable
Feb 17 19:11:37 vinco kernel: [    0.001395]   6 base 00CBC00000 mask 7FF=
FC00000 uncachable
Feb 17 19:11:37 vinco kernel: [    0.001396]   7 base 042F800000 mask 7FF=
F800000 uncachable
Feb 17 19:11:37 vinco kernel: [    0.001396]   8 base 042F400000 mask 7FF=
FC00000 uncachable
Feb 17 19:11:37 vinco kernel: [    0.001397]   9 base 042F200000 mask 7FF=
FE00000 uncachable
Feb 17 19:11:37 vinco kernel: [    0.001660] x86/PAT: Configuration [0-7]=
: WB  WC  UC- UC  WB  WP  UC- WT =20
Feb 17 19:11:37 vinco kernel: [    0.001764] e820: update [mem 0xcbc00000=
-0xffffffff] usable =3D=3D> reserved
Feb 17 19:11:37 vinco kernel: [    0.001767] last_pfn =3D 0xcb000 max_arc=
h_pfn =3D 0x400000000
Feb 17 19:11:37 vinco kernel: [    0.007744] found SMP MP-table at [mem 0=
x000fd8a0-0x000fd8af]
Feb 17 19:11:37 vinco kernel: [    0.007758] Using GB pages for direct ma=
pping
Feb 17 19:11:37 vinco kernel: [    0.007759] BRK [0x404c01000, 0x404c01ff=
f] PGTABLE
Feb 17 19:11:37 vinco kernel: [    0.007760] BRK [0x404c02000, 0x404c02ff=
f] PGTABLE
Feb 17 19:11:37 vinco kernel: [    0.007761] BRK [0x404c03000, 0x404c03ff=
f] PGTABLE
Feb 17 19:11:37 vinco kernel: [    0.007780] BRK [0x404c04000, 0x404c04ff=
f] PGTABLE
Feb 17 19:11:37 vinco kernel: [    0.007781] BRK [0x404c05000, 0x404c05ff=
f] PGTABLE
Feb 17 19:11:37 vinco kernel: [    0.007859] BRK [0x404c06000, 0x404c06ff=
f] PGTABLE
Feb 17 19:11:37 vinco kernel: [    0.007873] BRK [0x404c07000, 0x404c07ff=
f] PGTABLE
Feb 17 19:11:37 vinco kernel: [    0.007899] BRK [0x404c08000, 0x404c08ff=
f] PGTABLE
Feb 17 19:11:37 vinco kernel: [    0.007913] BRK [0x404c09000, 0x404c09ff=
f] PGTABLE
Feb 17 19:11:37 vinco kernel: [    0.007923] BRK [0x404c0a000, 0x404c0aff=
f] PGTABLE
Feb 17 19:11:37 vinco kernel: [    0.007952] BRK [0x404c0b000, 0x404c0bff=
f] PGTABLE
Feb 17 19:11:37 vinco kernel: [    0.008000] BRK [0x404c0c000, 0x404c0cff=
f] PGTABLE
Feb 17 19:11:37 vinco kernel: [    0.008148] RAMDISK: [mem 0x30ed7000-0x3=
4762fff]
Feb 17 19:11:37 vinco kernel: [    0.008154] ACPI: Early table checksum v=
erification disabled
Feb 17 19:11:37 vinco kernel: [    0.008156] ACPI: RSDP 0x00000000C9E8900=
0 000024 (v02 _ASUS_)
Feb 17 19:11:37 vinco kernel: [    0.008159] ACPI: XSDT 0x00000000C9E8908=
8 00009C (v01 _ASUS_ Notebook 01072009 AMI  00010013)
Feb 17 19:11:37 vinco kernel: [    0.008162] ACPI: FACP 0x00000000C9E9CF3=
8 00010C (v05 _ASUS_ Notebook 01072009 AMI  00010013)
Feb 17 19:11:37 vinco kernel: [    0.008166] ACPI: DSDT 0x00000000C9E8924=
0 013CF2 (v02 _ASUS_ Notebook 00000012 INTL 20120711)
Feb 17 19:11:37 vinco kernel: [    0.008168] ACPI: FACS 0x00000000CAB03F8=
0 000040
Feb 17 19:11:37 vinco kernel: [    0.008170] ACPI: APIC 0x00000000C9E9D04=
8 000092 (v03 _ASUS_ Notebook 01072009 AMI  00010013)
Feb 17 19:11:37 vinco kernel: [    0.008171] ACPI: FPDT 0x00000000C9E9D0E=
0 000044 (v01 _ASUS_ Notebook 01072009 AMI  00010013)
Feb 17 19:11:37 vinco kernel: [    0.008173] ACPI: ECDT 0x00000000C9E9D12=
8 0000C1 (v01 _ASUS_ Notebook 01072009 AMI. 00000005)
Feb 17 19:11:37 vinco kernel: [    0.008175] ACPI: SSDT 0x00000000C9E9D1F=
0 00019D (v01 Intel  zpodd    00001000 INTL 20120711)
Feb 17 19:11:37 vinco kernel: [    0.008177] ACPI: SSDT 0x00000000C9E9D39=
0 000539 (v01 PmRef  Cpu0Ist  00003000 INTL 20120711)
Feb 17 19:11:37 vinco kernel: [    0.008179] ACPI: SSDT 0x00000000C9E9D8D=
0 000AD8 (v01 PmRef  CpuPm    00003000 INTL 20120711)
Feb 17 19:11:37 vinco kernel: [    0.008180] ACPI: MCFG 0x00000000C9E9E3A=
8 00003C (v01 _ASUS_ Notebook 01072009 MSFT 00000097)
Feb 17 19:11:37 vinco kernel: [    0.008182] ACPI: HPET 0x00000000C9E9E3E=
8 000038 (v01 _ASUS_ Notebook 01072009 AMI. 00000005)
Feb 17 19:11:37 vinco kernel: [    0.008184] ACPI: SSDT 0x00000000C9E9E42=
0 000298 (v01 SataRe SataTabl 00001000 INTL 20120711)
Feb 17 19:11:37 vinco kernel: [    0.008186] ACPI: SSDT 0x00000000C9E9E6B=
8 004541 (v01 SaSsdt SaSsdt   00003000 INTL 20091112)
Feb 17 19:11:37 vinco kernel: [    0.008188] ACPI: SSDT 0x00000000C9EA2C0=
0 001983 (v01 SgRef  SgPeg    00001000 INTL 20120711)
Feb 17 19:11:37 vinco kernel: [    0.008189] ACPI: DMAR 0x00000000C9EA458=
8 0000B8 (v01 INTEL  HSW      00000001 INTL 00000001)
Feb 17 19:11:37 vinco kernel: [    0.008191] ACPI: SSDT 0x00000000C9EA464=
0 0019CA (v01 OptRef OptTabl  00001000 INTL 20120711)
Feb 17 19:11:37 vinco kernel: [    0.008193] ACPI: MSDM 0x00000000C9ACDE1=
8 000055 (v03 _ASUS_ Notebook 00000000 ASUS 00000001)
Feb 17 19:11:37 vinco kernel: [    0.008199] ACPI: Local APIC address 0xf=
ee00000
Feb 17 19:11:37 vinco kernel: [    0.008263] No NUMA configuration found
Feb 17 19:11:37 vinco kernel: [    0.008264] Faking a node at [mem 0x0000=
000000000000-0x000000042f1fffff]
Feb 17 19:11:37 vinco kernel: [    0.008267] NODE_DATA(0) allocated [mem =
0x42f1f9000-0x42f1fdfff]
Feb 17 19:11:37 vinco kernel: [    0.008291] Zone ranges:
Feb 17 19:11:37 vinco kernel: [    0.008291]   DMA      [mem 0x0000000000=
001000-0x0000000000ffffff]
Feb 17 19:11:37 vinco kernel: [    0.008292]   DMA32    [mem 0x0000000001=
000000-0x00000000ffffffff]
Feb 17 19:11:37 vinco kernel: [    0.008293]   Normal   [mem 0x0000000100=
000000-0x000000042f1fffff]
Feb 17 19:11:37 vinco kernel: [    0.008294]   Device   empty
Feb 17 19:11:37 vinco kernel: [    0.008294] Movable zone start for each =
node
Feb 17 19:11:37 vinco kernel: [    0.008295] Early memory node ranges
Feb 17 19:11:37 vinco kernel: [    0.008295]   node   0: [mem 0x000000000=
0001000-0x0000000000057fff]
Feb 17 19:11:37 vinco kernel: [    0.008296]   node   0: [mem 0x000000000=
0059000-0x000000000009efff]
Feb 17 19:11:37 vinco kernel: [    0.008296]   node   0: [mem 0x000000000=
0100000-0x00000000b9754fff]
Feb 17 19:11:37 vinco kernel: [    0.008297]   node   0: [mem 0x00000000b=
975c000-0x00000000b9fd4fff]
Feb 17 19:11:37 vinco kernel: [    0.008297]   node   0: [mem 0x00000000b=
a276000-0x00000000c98c5fff]
Feb 17 19:11:37 vinco kernel: [    0.008298]   node   0: [mem 0x00000000c=
9acf000-0x00000000c9e00fff]
Feb 17 19:11:37 vinco kernel: [    0.008298]   node   0: [mem 0x00000000c=
afff000-0x00000000caffffff]
Feb 17 19:11:37 vinco kernel: [    0.008299]   node   0: [mem 0x000000010=
0000000-0x000000042f1fffff]
Feb 17 19:11:37 vinco kernel: [    0.008517] Zeroed struct page in unavai=
lable ranges: 29970 pages
Feb 17 19:11:37 vinco kernel: [    0.008518] Initmem setup node 0 [mem 0x=
0000000000001000-0x000000042f1fffff]
Feb 17 19:11:37 vinco kernel: [    0.008519] On node 0 totalpages: 416433=
4
Feb 17 19:11:37 vinco kernel: [    0.008520]   DMA zone: 64 pages used fo=
r memmap
Feb 17 19:11:37 vinco kernel: [    0.008520]   DMA zone: 26 pages reserve=
d
Feb 17 19:11:37 vinco kernel: [    0.008521]   DMA zone: 3997 pages, LIFO=
 batch:0
Feb 17 19:11:37 vinco kernel: [    0.008558]   DMA32 zone: 12838 pages us=
ed for memmap
Feb 17 19:11:37 vinco kernel: [    0.008559]   DMA32 zone: 821585 pages, =
LIFO batch:63
Feb 17 19:11:37 vinco kernel: [    0.016403]   Normal zone: 52168 pages u=
sed for memmap
Feb 17 19:11:37 vinco kernel: [    0.016404]   Normal zone: 3338752 pages=
, LIFO batch:63
Feb 17 19:11:37 vinco kernel: [    0.044897] Reserving Intel graphics mem=
ory at [mem 0xcbe00000-0xcfdfffff]
Feb 17 19:11:37 vinco kernel: [    0.045065] ACPI: PM-Timer IO Port: 0x18=
08
Feb 17 19:11:37 vinco kernel: [    0.045067] ACPI: Local APIC address 0xf=
ee00000
Feb 17 19:11:37 vinco kernel: [    0.045071] ACPI: LAPIC_NMI (acpi_id[0xf=
f] high edge lint[0x1])
Feb 17 19:11:37 vinco kernel: [    0.045081] IOAPIC[0]: apic_id 8, versio=
n 32, address 0xfec00000, GSI 0-23
Feb 17 19:11:37 vinco kernel: [    0.045082] ACPI: INT_SRC_OVR (bus 0 bus=
_irq 0 global_irq 2 dfl dfl)
Feb 17 19:11:37 vinco kernel: [    0.045083] ACPI: INT_SRC_OVR (bus 0 bus=
_irq 9 global_irq 9 high level)
Feb 17 19:11:37 vinco kernel: [    0.045084] ACPI: IRQ0 used by override.=

Feb 17 19:11:37 vinco kernel: [    0.045084] ACPI: IRQ9 used by override.=

Feb 17 19:11:37 vinco kernel: [    0.045086] Using ACPI (MADT) for SMP co=
nfiguration information
Feb 17 19:11:37 vinco kernel: [    0.045087] ACPI: HPET id: 0x8086a701 ba=
se: 0xfed00000
Feb 17 19:11:37 vinco kernel: [    0.045090] smpboot: Allowing 8 CPUs, 0 =
hotplug CPUs
Feb 17 19:11:37 vinco kernel: [    0.045106] PM: Registered nosave memory=
: [mem 0x00000000-0x00000fff]
Feb 17 19:11:37 vinco kernel: [    0.045107] PM: Registered nosave memory=
: [mem 0x00058000-0x00058fff]
Feb 17 19:11:37 vinco kernel: [    0.045108] PM: Registered nosave memory=
: [mem 0x0009f000-0x0009ffff]
Feb 17 19:11:37 vinco kernel: [    0.045109] PM: Registered nosave memory=
: [mem 0x000a0000-0x000fffff]
Feb 17 19:11:37 vinco kernel: [    0.045110] PM: Registered nosave memory=
: [mem 0xb9755000-0xb975bfff]
Feb 17 19:11:37 vinco kernel: [    0.045111] PM: Registered nosave memory=
: [mem 0xb9fd5000-0xba275fff]
Feb 17 19:11:37 vinco kernel: [    0.045112] PM: Registered nosave memory=
: [mem 0xc98c6000-0xc9acefff]
Feb 17 19:11:37 vinco kernel: [    0.045113] PM: Registered nosave memory=
: [mem 0xc9e01000-0xcab05fff]
Feb 17 19:11:37 vinco kernel: [    0.045114] PM: Registered nosave memory=
: [mem 0xcab06000-0xcaf59fff]
Feb 17 19:11:37 vinco kernel: [    0.045114] PM: Registered nosave memory=
: [mem 0xcaf5a000-0xcaffefff]
Feb 17 19:11:37 vinco kernel: [    0.045115] PM: Registered nosave memory=
: [mem 0xcb000000-0xcbbfffff]
Feb 17 19:11:37 vinco kernel: [    0.045115] PM: Registered nosave memory=
: [mem 0xcbc00000-0xcfdfffff]
Feb 17 19:11:37 vinco kernel: [    0.045116] PM: Registered nosave memory=
: [mem 0xcfe00000-0xf7ffffff]
Feb 17 19:11:37 vinco kernel: [    0.045116] PM: Registered nosave memory=
: [mem 0xf8000000-0xfbffffff]
Feb 17 19:11:37 vinco kernel: [    0.045117] PM: Registered nosave memory=
: [mem 0xfc000000-0xfebfffff]
Feb 17 19:11:37 vinco kernel: [    0.045117] PM: Registered nosave memory=
: [mem 0xfec00000-0xfec00fff]
Feb 17 19:11:37 vinco kernel: [    0.045117] PM: Registered nosave memory=
: [mem 0xfec01000-0xfecfffff]
Feb 17 19:11:37 vinco kernel: [    0.045118] PM: Registered nosave memory=
: [mem 0xfed00000-0xfed03fff]
Feb 17 19:11:37 vinco kernel: [    0.045118] PM: Registered nosave memory=
: [mem 0xfed04000-0xfed1bfff]
Feb 17 19:11:37 vinco kernel: [    0.045118] PM: Registered nosave memory=
: [mem 0xfed1c000-0xfed1ffff]
Feb 17 19:11:37 vinco kernel: [    0.045119] PM: Registered nosave memory=
: [mem 0xfed20000-0xfedfffff]
Feb 17 19:11:37 vinco kernel: [    0.045119] PM: Registered nosave memory=
: [mem 0xfee00000-0xfee00fff]
Feb 17 19:11:37 vinco kernel: [    0.045119] PM: Registered nosave memory=
: [mem 0xfee01000-0xfeffffff]
Feb 17 19:11:37 vinco kernel: [    0.045120] PM: Registered nosave memory=
: [mem 0xff000000-0xffffffff]
Feb 17 19:11:37 vinco kernel: [    0.045121] [mem 0xcfe00000-0xf7ffffff] =
available for PCI devices
Feb 17 19:11:37 vinco kernel: [    0.045122] Booting paravirtualized kern=
el on bare hardware
Feb 17 19:11:37 vinco kernel: [    0.045125] clocksource: refined-jiffies=
: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 =
ns
Feb 17 19:11:37 vinco kernel: [    0.112648] setup_percpu: NR_CPUS:512 nr=
_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:1
Feb 17 19:11:37 vinco kernel: [    0.112812] percpu: Embedded 53 pages/cp=
u s178584 r8192 d30312 u262144
Feb 17 19:11:37 vinco kernel: [    0.112818] pcpu-alloc: s178584 r8192 d3=
0312 u262144 alloc=3D1*2097152
Feb 17 19:11:37 vinco kernel: [    0.112818] pcpu-alloc: [0] 0 1 2 3 4 5 =
6 7=20
Feb 17 19:11:37 vinco kernel: [    0.112838] Built 1 zonelists, mobility =
grouping on.  Total pages: 4099238
Feb 17 19:11:37 vinco kernel: [    0.112838] Policy zone: Normal
Feb 17 19:11:37 vinco kernel: [    0.112839] Kernel command line: BOOT_IM=
AGE=3D/vmlinuz-5.4.0-4-amd64 root=3DUUID=3D795ee075-978f-4245-9dad-ecccd3=
7080d8 ro quiet apparmor=3D1 security=3Dapparmor
Feb 17 19:11:37 vinco kernel: [    0.113584] Dentry cache hash table entr=
ies: 2097152 (order: 12, 16777216 bytes, linear)
Feb 17 19:11:37 vinco kernel: [    0.113926] Inode-cache hash table entri=
es: 1048576 (order: 11, 8388608 bytes, linear)
Feb 17 19:11:37 vinco kernel: [    0.113982] mem auto-init: stack:off, he=
ap alloc:off, heap free:off
Feb 17 19:11:37 vinco kernel: [    0.116754] Calgary: detecting Calgary v=
ia BIOS EBDA area
Feb 17 19:11:37 vinco kernel: [    0.116755] Calgary: Unable to locate Ri=
o Grande table in EBDA - bailing!
Feb 17 19:11:37 vinco kernel: [    0.152182] Memory: 16022984K/16657336K =
available (10243K kernel code, 1197K rwdata, 3736K rodata, 1672K init, 20=
48K bss, 634352K reserved, 0K cma-reserved)
Feb 17 19:11:37 vinco kernel: [    0.152280] SLUB: HWalign=3D64, Order=3D=
0-3, MinObjects=3D0, CPUs=3D8, Nodes=3D1
Feb 17 19:11:37 vinco kernel: [    0.152288] Kernel/User page tables isol=
ation: enabled
Feb 17 19:11:37 vinco kernel: [    0.152298] ftrace: allocating 33946 ent=
ries in 133 pages
Feb 17 19:11:37 vinco kernel: [    0.161858] rcu: Hierarchical RCU implem=
entation.
Feb 17 19:11:37 vinco kernel: [    0.161859] rcu: 	RCU restricting CPUs f=
rom NR_CPUS=3D512 to nr_cpu_ids=3D8.
Feb 17 19:11:37 vinco kernel: [    0.161860] rcu: RCU calculated value of=
 scheduler-enlistment delay is 25 jiffies.
Feb 17 19:11:37 vinco kernel: [    0.161860] rcu: Adjusting geometry for =
rcu_fanout_leaf=3D16, nr_cpu_ids=3D8
Feb 17 19:11:37 vinco kernel: [    0.163957] NR_IRQS: 33024, nr_irqs: 488=
, preallocated irqs: 16
Feb 17 19:11:37 vinco kernel: [    0.164133] random: crng done (trusting =
CPU's manufacturer)
Feb 17 19:11:37 vinco kernel: [    0.164149] Console: colour dummy device=
 80x25
Feb 17 19:11:37 vinco kernel: [    0.164152] printk: console [tty0] enabl=
ed
Feb 17 19:11:37 vinco kernel: [    0.164164] ACPI: Core revision 20190816=

Feb 17 19:11:37 vinco kernel: [    0.164286] clocksource: hpet: mask: 0xf=
fffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
Feb 17 19:11:37 vinco kernel: [    0.164297] APIC: Switch to symmetric I/=
O mode setup
Feb 17 19:11:37 vinco kernel: [    0.164298] DMAR: Host address width 39
Feb 17 19:11:37 vinco kernel: [    0.164299] DMAR: DRHD base: 0x000000fed=
90000 flags: 0x0
Feb 17 19:11:37 vinco kernel: [    0.164302] DMAR: dmar0: reg_base_addr f=
ed90000 ver 1:0 cap c0000020660462 ecap f0101a
Feb 17 19:11:37 vinco kernel: [    0.164303] DMAR: DRHD base: 0x000000fed=
91000 flags: 0x1
Feb 17 19:11:37 vinco kernel: [    0.164305] DMAR: dmar1: reg_base_addr f=
ed91000 ver 1:0 cap d2008020660462 ecap f010da
Feb 17 19:11:37 vinco kernel: [    0.164306] DMAR: RMRR base: 0x000000c9a=
56000 end: 0x000000c9a62fff
Feb 17 19:11:37 vinco kernel: [    0.164306] DMAR: RMRR base: 0x000000cbc=
00000 end: 0x000000cfdfffff
Feb 17 19:11:37 vinco kernel: [    0.164308] DMAR-IR: IOAPIC id 8 under D=
RHD base  0xfed91000 IOMMU 1
Feb 17 19:11:37 vinco kernel: [    0.164308] DMAR-IR: HPET id 0 under DRH=
D base 0xfed91000
Feb 17 19:11:37 vinco kernel: [    0.164309] DMAR-IR: Queued invalidation=
 will be enabled to support x2apic and Intr-remapping.
Feb 17 19:11:37 vinco kernel: [    0.164665] DMAR-IR: Enabled IRQ remappi=
ng in x2apic mode
Feb 17 19:11:37 vinco kernel: [    0.164666] x2apic enabled
Feb 17 19:11:37 vinco kernel: [    0.164671] Switched APIC routing to clu=
ster x2apic.
Feb 17 19:11:37 vinco kernel: [    0.165047] ..TIMER: vector=3D0x30 apic1=
=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
Feb 17 19:11:37 vinco kernel: [    0.184298] clocksource: tsc-early: mask=
: 0xffffffffffffffff max_cycles: 0x23f3e58916c, max_idle_ns: 440795226006=
 ns
Feb 17 19:11:37 vinco kernel: [    0.184301] Calibrating delay loop (skip=
ped), value calculated using timer frequency.. 4988.44 BogoMIPS (lpj=3D99=
76880)
Feb 17 19:11:37 vinco kernel: [    0.184303] pid_max: default: 32768 mini=
mum: 301
Feb 17 19:11:37 vinco kernel: [    0.188912] LSM: Security Framework init=
ializing
Feb 17 19:11:37 vinco kernel: [    0.188918] Yama: disabled by default; e=
nable with sysctl kernel.yama.*
Feb 17 19:11:37 vinco kernel: [    0.188934] AppArmor: AppArmor initializ=
ed
Feb 17 19:11:37 vinco kernel: [    0.188971] Mount-cache hash table entri=
es: 32768 (order: 6, 262144 bytes, linear)
Feb 17 19:11:37 vinco kernel: [    0.188999] Mountpoint-cache hash table =
entries: 32768 (order: 6, 262144 bytes, linear)
Feb 17 19:11:37 vinco kernel: [    0.189183] mce: CPU0: Thermal monitorin=
g enabled (TM1)
Feb 17 19:11:37 vinco kernel: [    0.189195] process: using mwait in idle=
 threads
Feb 17 19:11:37 vinco kernel: [    0.189197] Last level iTLB entries: 4KB=
 1024, 2MB 1024, 4MB 1024
Feb 17 19:11:37 vinco kernel: [    0.189198] Last level dTLB entries: 4KB=
 1024, 2MB 1024, 4MB 1024, 1GB 4
Feb 17 19:11:37 vinco kernel: [    0.189200] Spectre V1 : Mitigation: use=
rcopy/swapgs barriers and __user pointer sanitization
Feb 17 19:11:37 vinco kernel: [    0.189201] Spectre V2 : Mitigation: Ful=
l generic retpoline
Feb 17 19:11:37 vinco kernel: [    0.189201] Spectre V2 : Spectre v2 / Sp=
ectreRSB mitigation: Filling RSB on context switch
Feb 17 19:11:37 vinco kernel: [    0.189201] Spectre V2 : Enabling Restri=
cted Speculation for firmware calls
Feb 17 19:11:37 vinco kernel: [    0.189202] Spectre V2 : mitigation: Ena=
bling conditional Indirect Branch Prediction Barrier
Feb 17 19:11:37 vinco kernel: [    0.189203] Spectre V2 : User space: Mit=
igation: STIBP via seccomp and prctl
Feb 17 19:11:37 vinco kernel: [    0.189203] Speculative Store Bypass: Mi=
tigation: Speculative Store Bypass disabled via prctl and seccomp
Feb 17 19:11:37 vinco kernel: [    0.189206] MDS: Mitigation: Clear CPU b=
uffers
Feb 17 19:11:37 vinco kernel: [    0.189334] Freeing SMP alternatives mem=
ory: 24K
Feb 17 19:11:37 vinco kernel: [    0.191469] TSC deadline timer enabled
Feb 17 19:11:37 vinco kernel: [    0.191471] smpboot: CPU0: Intel(R) Core=
(TM) i7-4710HQ CPU @ 2.50GHz (family: 0x6, model: 0x3c, stepping: 0x3)
Feb 17 19:11:37 vinco kernel: [    0.191543] Performance Events: PEBS fmt=
2+, Haswell events, 16-deep LBR, full-width counters, Intel PMU driver.
Feb 17 19:11:37 vinco kernel: [    0.191556] ... version:                =
3
Feb 17 19:11:37 vinco kernel: [    0.191556] ... bit width:              =
48
Feb 17 19:11:37 vinco kernel: [    0.191556] ... generic registers:      =
4
Feb 17 19:11:37 vinco kernel: [    0.191557] ... value mask:             =
0000ffffffffffff
Feb 17 19:11:37 vinco kernel: [    0.191557] ... max period:             =
00007fffffffffff
Feb 17 19:11:37 vinco kernel: [    0.191557] ... fixed-purpose events:   =
3
Feb 17 19:11:37 vinco kernel: [    0.191558] ... event mask:             =
000000070000000f
Feb 17 19:11:37 vinco kernel: [    0.191582] rcu: Hierarchical SRCU imple=
mentation.
Feb 17 19:11:37 vinco kernel: [    0.192178] NMI watchdog: Enabled. Perma=
nently consumes one hw-PMU counter.
Feb 17 19:11:37 vinco kernel: [    0.192227] smp: Bringing up secondary C=
PUs ...
Feb 17 19:11:37 vinco kernel: [    0.192277] x86: Booting SMP configurati=
on:
Feb 17 19:11:37 vinco kernel: [    0.192278] .... node  #0, CPUs:      #1=
 #2 #3 #4
Feb 17 19:11:37 vinco kernel: [    0.193762] MDS CPU bug present and SMT =
on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-=
guide/hw-vuln/mds.html for more details.
Feb 17 19:11:37 vinco kernel: [    0.193762]  #5 #6 #7
Feb 17 19:11:37 vinco kernel: [    0.193762] smp: Brought up 1 node, 8 CP=
Us
Feb 17 19:11:37 vinco kernel: [    0.193762] smpboot: Max logical package=
s: 1
Feb 17 19:11:37 vinco kernel: [    0.193762] smpboot: Total of 8 processo=
rs activated (39907.52 BogoMIPS)
Feb 17 19:11:37 vinco kernel: [    0.196614] devtmpfs: initialized
Feb 17 19:11:37 vinco kernel: [    0.196614] x86/mm: Memory block size: 1=
28MB
Feb 17 19:11:37 vinco kernel: [    0.197468] PM: Registering ACPI NVS reg=
ion [mem 0xb9755000-0xb975bfff] (28672 bytes)
Feb 17 19:11:37 vinco kernel: [    0.197468] PM: Registering ACPI NVS reg=
ion [mem 0xc9e01000-0xcab05fff] (13651968 bytes)
Feb 17 19:11:37 vinco kernel: [    0.197468] clocksource: jiffies: mask: =
0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
Feb 17 19:11:37 vinco kernel: [    0.197468] futex hash table entries: 20=
48 (order: 5, 131072 bytes, linear)
Feb 17 19:11:37 vinco kernel: [    0.197468] pinctrl core: initialized pi=
nctrl subsystem
Feb 17 19:11:37 vinco kernel: [    0.197468] NET: Registered protocol fam=
ily 16
Feb 17 19:11:37 vinco kernel: [    0.197468] audit: initializing netlink =
subsys (disabled)
Feb 17 19:11:37 vinco kernel: [    0.197468] audit: type=3D2000 audit(158=
1959491.032:1): state=3Dinitialized audit_enabled=3D0 res=3D1
Feb 17 19:11:37 vinco kernel: [    0.197468] cpuidle: using governor ladd=
er
Feb 17 19:11:37 vinco kernel: [    0.197468] cpuidle: using governor menu=

Feb 17 19:11:37 vinco kernel: [    0.197468] ACPI FADT declares the syste=
m doesn't support PCIe ASPM, so disable it
Feb 17 19:11:37 vinco kernel: [    0.197468] ACPI: bus type PCI registere=
d
Feb 17 19:11:37 vinco kernel: [    0.197468] acpiphp: ACPI Hot Plug PCI C=
ontroller Driver version: 0.5
Feb 17 19:11:37 vinco kernel: [    0.197468] PCI: MMCONFIG for domain 000=
0 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
Feb 17 19:11:37 vinco kernel: [    0.197468] PCI: MMCONFIG at [mem 0xf800=
0000-0xfbffffff] reserved in E820
Feb 17 19:11:37 vinco kernel: [    0.197468] pmd_set_huge: Cannot satisfy=
 [mem 0xf8000000-0xf8200000] with a huge-page mapping due to MTRR overrid=
e.
Feb 17 19:11:37 vinco kernel: [    0.197468] PCI: Using configuration typ=
e 1 for base access
Feb 17 19:11:37 vinco kernel: [    0.197468] core: PMU erratum BJ122, BV9=
8, HSD29 worked around, HT is on
Feb 17 19:11:37 vinco kernel: [    0.197468] ENERGY_PERF_BIAS: Set to 'no=
rmal', was 'performance'
Feb 17 19:11:37 vinco kernel: [    0.197468] HugeTLB registered 1.00 GiB =
page size, pre-allocated 0 pages
Feb 17 19:11:37 vinco kernel: [    0.197468] HugeTLB registered 2.00 MiB =
page size, pre-allocated 0 pages
Feb 17 19:11:37 vinco kernel: [    0.316456] ACPI: Added _OSI(Module Devi=
ce)
Feb 17 19:11:37 vinco kernel: [    0.316456] ACPI: Added _OSI(Processor D=
evice)
Feb 17 19:11:37 vinco kernel: [    0.316456] ACPI: Added _OSI(3.0 _SCP Ex=
tensions)
Feb 17 19:11:37 vinco kernel: [    0.316456] ACPI: Added _OSI(Processor A=
ggregator Device)
Feb 17 19:11:37 vinco kernel: [    0.316456] ACPI: Added _OSI(Linux-Dell-=
Video)
Feb 17 19:11:37 vinco kernel: [    0.316456] ACPI: Added _OSI(Linux-Lenov=
o-NV-HDMI-Audio)
Feb 17 19:11:37 vinco kernel: [    0.316456] ACPI: Added _OSI(Linux-HPI-H=
ybrid-Graphics)
Feb 17 19:11:37 vinco kernel: [    0.328813] ACPI: 8 ACPI AML tables succ=
essfully acquired and loaded
Feb 17 19:11:37 vinco kernel: [    0.329320] ACPI: EC: EC started
Feb 17 19:11:37 vinco kernel: [    0.329320] ACPI: EC: interrupt blocked
Feb 17 19:11:37 vinco kernel: [    0.330118] ACPI: \: Used as first EC
Feb 17 19:11:37 vinco kernel: [    0.330119] ACPI: \: GPE=3D0x19, EC_CMD/=
EC_SC=3D0x66, EC_DATA=3D0x62
Feb 17 19:11:37 vinco kernel: [    0.330119] ACPI: EC: Boot ECDT EC used =
to handle transactions
Feb 17 19:11:37 vinco kernel: [    0.330749] ACPI: [Firmware Bug]: BIOS _=
OSI(Linux) query ignored
Feb 17 19:11:37 vinco kernel: [    0.333078] ACPI: Dynamic OEM Table Load=
:
Feb 17 19:11:37 vinco kernel: [    0.333082] ACPI: SSDT 0xFFFF93EBDC7F080=
0 0003D3 (v01 PmRef  Cpu0Cst  00003001 INTL 20120711)
Feb 17 19:11:37 vinco kernel: [    0.333801] ACPI: Dynamic OEM Table Load=
:
Feb 17 19:11:37 vinco kernel: [    0.333805] ACPI: SSDT 0xFFFF93EBDC2F500=
0 0005AA (v01 PmRef  ApIst    00003000 INTL 20120711)
Feb 17 19:11:37 vinco kernel: [    0.334545] ACPI: Dynamic OEM Table Load=
:
Feb 17 19:11:37 vinco kernel: [    0.334547] ACPI: SSDT 0xFFFF93EBDC7E9A0=
0 000119 (v01 PmRef  ApCst    00003000 INTL 20120711)
Feb 17 19:11:37 vinco kernel: [    0.336079] ACPI: Interpreter enabled
Feb 17 19:11:37 vinco kernel: [    0.336104] ACPI: (supports S0 S3 S4 S5)=

Feb 17 19:11:37 vinco kernel: [    0.336104] ACPI: Using IOAPIC for inter=
rupt routing
Feb 17 19:11:37 vinco kernel: [    0.336124] PCI: Using host bridge windo=
ws from ACPI; if necessary, use "pci=3Dnocrs" and report a bug
Feb 17 19:11:37 vinco kernel: [    0.336328] ACPI: Enabled 7 GPEs in bloc=
k 00 to 3F
Feb 17 19:11:37 vinco kernel: [    0.339988] ACPI: Power Resource [PG00] =
(on)
Feb 17 19:11:37 vinco kernel: [    0.343638] ACPI: PCI Root Bridge [PCI0]=
 (domain 0000 [bus 00-3e])
Feb 17 19:11:37 vinco kernel: [    0.343641] acpi PNP0A08:00: _OSC: OS su=
pports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
Feb 17 19:11:37 vinco kernel: [    0.344101] acpi PNP0A08:00: _OSC: OS no=
w controls [PCIeHotplug SHPCHotplug PME AER PCIeCapability LTR]
Feb 17 19:11:37 vinco kernel: [    0.344102] acpi PNP0A08:00: FADT indica=
tes ASPM is unsupported, using BIOS configuration
Feb 17 19:11:37 vinco kernel: [    0.344385] PCI host bridge to bus 0000:=
00
Feb 17 19:11:37 vinco kernel: [    0.344387] pci_bus 0000:00: root bus re=
source [io  0x0000-0x0cf7 window]
Feb 17 19:11:37 vinco kernel: [    0.344388] pci_bus 0000:00: root bus re=
source [io  0x0d00-0xffff window]
Feb 17 19:11:37 vinco kernel: [    0.344388] pci_bus 0000:00: root bus re=
source [mem 0x000a0000-0x000bffff window]
Feb 17 19:11:37 vinco kernel: [    0.344389] pci_bus 0000:00: root bus re=
source [mem 0x000d0000-0x000d3fff window]
Feb 17 19:11:37 vinco kernel: [    0.344390] pci_bus 0000:00: root bus re=
source [mem 0x000d4000-0x000d7fff window]
Feb 17 19:11:37 vinco kernel: [    0.344390] pci_bus 0000:00: root bus re=
source [mem 0x000d8000-0x000dbfff window]
Feb 17 19:11:37 vinco kernel: [    0.344391] pci_bus 0000:00: root bus re=
source [mem 0x000dc000-0x000dffff window]
Feb 17 19:11:37 vinco kernel: [    0.344392] pci_bus 0000:00: root bus re=
source [mem 0xcfe00000-0xfeafffff window]
Feb 17 19:11:37 vinco kernel: [    0.344393] pci_bus 0000:00: root bus re=
source [bus 00-3e]
Feb 17 19:11:37 vinco kernel: [    0.344399] pci 0000:00:00.0: [8086:0c04=
] type 00 class 0x060000
Feb 17 19:11:37 vinco kernel: [    0.344463] pci 0000:00:01.0: [8086:0c01=
] type 01 class 0x060400
Feb 17 19:11:37 vinco kernel: [    0.344495] pci 0000:00:01.0: PME# suppo=
rted from D0 D3hot D3cold
Feb 17 19:11:37 vinco kernel: [    0.344587] pci 0000:00:02.0: [8086:0416=
] type 00 class 0x030000
Feb 17 19:11:37 vinco kernel: [    0.344596] pci 0000:00:02.0: reg 0x10: =
[mem 0xf7400000-0xf77fffff 64bit]
Feb 17 19:11:37 vinco kernel: [    0.344600] pci 0000:00:02.0: reg 0x18: =
[mem 0xd0000000-0xdfffffff 64bit pref]
Feb 17 19:11:37 vinco kernel: [    0.344602] pci 0000:00:02.0: reg 0x20: =
[io  0xf000-0xf03f]
Feb 17 19:11:37 vinco kernel: [    0.344611] pci 0000:00:02.0: BAR 2: ass=
igned to efifb
Feb 17 19:11:37 vinco kernel: [    0.344666] pci 0000:00:03.0: [8086:0c0c=
] type 00 class 0x040300
Feb 17 19:11:37 vinco kernel: [    0.344673] pci 0000:00:03.0: reg 0x10: =
[mem 0xf7a14000-0xf7a17fff 64bit]
Feb 17 19:11:37 vinco kernel: [    0.344756] pci 0000:00:14.0: [8086:8c31=
] type 00 class 0x0c0330
Feb 17 19:11:37 vinco kernel: [    0.344774] pci 0000:00:14.0: reg 0x10: =
[mem 0xf7a00000-0xf7a0ffff 64bit]
Feb 17 19:11:37 vinco kernel: [    0.344826] pci 0000:00:14.0: PME# suppo=
rted from D3hot D3cold
Feb 17 19:11:37 vinco kernel: [    0.344883] pci 0000:00:16.0: [8086:8c3a=
] type 00 class 0x078000
Feb 17 19:11:37 vinco kernel: [    0.344901] pci 0000:00:16.0: reg 0x10: =
[mem 0xf7a1e000-0xf7a1e00f 64bit]
Feb 17 19:11:37 vinco kernel: [    0.344955] pci 0000:00:16.0: PME# suppo=
rted from D0 D3hot D3cold
Feb 17 19:11:37 vinco kernel: [    0.345012] pci 0000:00:1a.0: [8086:8c2d=
] type 00 class 0x0c0320
Feb 17 19:11:37 vinco kernel: [    0.345031] pci 0000:00:1a.0: reg 0x10: =
[mem 0xf7a1c000-0xf7a1c3ff]
Feb 17 19:11:37 vinco kernel: [    0.345103] pci 0000:00:1a.0: PME# suppo=
rted from D0 D3hot D3cold
Feb 17 19:11:37 vinco kernel: [    0.345165] pci 0000:00:1b.0: [8086:8c20=
] type 00 class 0x040300
Feb 17 19:11:37 vinco kernel: [    0.345182] pci 0000:00:1b.0: reg 0x10: =
[mem 0xf7a10000-0xf7a13fff 64bit]
Feb 17 19:11:37 vinco kernel: [    0.345242] pci 0000:00:1b.0: PME# suppo=
rted from D0 D3hot D3cold
Feb 17 19:11:37 vinco kernel: [    0.345299] pci 0000:00:1c.0: [8086:8c10=
] type 01 class 0x060400
Feb 17 19:11:37 vinco kernel: [    0.345368] pci 0000:00:1c.0: PME# suppo=
rted from D0 D3hot D3cold
Feb 17 19:11:37 vinco kernel: [    0.345384] pci 0000:00:1c.0: Enabling M=
PC IRBNCE
Feb 17 19:11:37 vinco kernel: [    0.345386] pci 0000:00:1c.0: Intel PCH =
root port ACS workaround enabled
Feb 17 19:11:37 vinco kernel: [    0.345470] pci 0000:00:1c.1: [8086:8c12=
] type 01 class 0x060400
Feb 17 19:11:37 vinco kernel: [    0.345558] pci 0000:00:1c.1: PME# suppo=
rted from D0 D3hot D3cold
Feb 17 19:11:37 vinco kernel: [    0.345573] pci 0000:00:1c.1: Enabling M=
PC IRBNCE
Feb 17 19:11:37 vinco kernel: [    0.345575] pci 0000:00:1c.1: Intel PCH =
root port ACS workaround enabled
Feb 17 19:11:37 vinco kernel: [    0.345654] pci 0000:00:1c.2: [8086:8c14=
] type 01 class 0x060400
Feb 17 19:11:37 vinco kernel: [    0.345724] pci 0000:00:1c.2: PME# suppo=
rted from D0 D3hot D3cold
Feb 17 19:11:37 vinco kernel: [    0.345739] pci 0000:00:1c.2: Enabling M=
PC IRBNCE
Feb 17 19:11:37 vinco kernel: [    0.345740] pci 0000:00:1c.2: Intel PCH =
root port ACS workaround enabled
Feb 17 19:11:37 vinco kernel: [    0.345822] pci 0000:00:1c.3: [8086:8c16=
] type 01 class 0x060400
Feb 17 19:11:37 vinco kernel: [    0.345892] pci 0000:00:1c.3: PME# suppo=
rted from D0 D3hot D3cold
Feb 17 19:11:37 vinco kernel: [    0.345907] pci 0000:00:1c.3: Enabling M=
PC IRBNCE
Feb 17 19:11:37 vinco kernel: [    0.345909] pci 0000:00:1c.3: Intel PCH =
root port ACS workaround enabled
Feb 17 19:11:37 vinco kernel: [    0.345995] pci 0000:00:1d.0: [8086:8c26=
] type 00 class 0x0c0320
Feb 17 19:11:37 vinco kernel: [    0.346015] pci 0000:00:1d.0: reg 0x10: =
[mem 0xf7a1b000-0xf7a1b3ff]
Feb 17 19:11:37 vinco kernel: [    0.346088] pci 0000:00:1d.0: PME# suppo=
rted from D0 D3hot D3cold
Feb 17 19:11:37 vinco kernel: [    0.346151] pci 0000:00:1f.0: [8086:8c49=
] type 00 class 0x060100
Feb 17 19:11:37 vinco kernel: [    0.346298] pci 0000:00:1f.2: [8086:8c03=
] type 00 class 0x010601
Feb 17 19:11:37 vinco kernel: [    0.346312] pci 0000:00:1f.2: reg 0x10: =
[io  0xf0b0-0xf0b7]
Feb 17 19:11:37 vinco kernel: [    0.346318] pci 0000:00:1f.2: reg 0x14: =
[io  0xf0a0-0xf0a3]
Feb 17 19:11:37 vinco kernel: [    0.346324] pci 0000:00:1f.2: reg 0x18: =
[io  0xf090-0xf097]
Feb 17 19:11:37 vinco kernel: [    0.346330] pci 0000:00:1f.2: reg 0x1c: =
[io  0xf080-0xf083]
Feb 17 19:11:37 vinco kernel: [    0.346336] pci 0000:00:1f.2: reg 0x20: =
[io  0xf060-0xf07f]
Feb 17 19:11:37 vinco kernel: [    0.346342] pci 0000:00:1f.2: reg 0x24: =
[mem 0xf7a1a000-0xf7a1a7ff]
Feb 17 19:11:37 vinco kernel: [    0.346372] pci 0000:00:1f.2: PME# suppo=
rted from D3hot
Feb 17 19:11:37 vinco kernel: [    0.346425] pci 0000:00:1f.3: [8086:8c22=
] type 00 class 0x0c0500
Feb 17 19:11:37 vinco kernel: [    0.346440] pci 0000:00:1f.3: reg 0x10: =
[mem 0xf7a19000-0xf7a190ff 64bit]
Feb 17 19:11:37 vinco kernel: [    0.346457] pci 0000:00:1f.3: reg 0x20: =
[io  0xf040-0xf05f]
Feb 17 19:11:37 vinco kernel: [    0.346560] pci 0000:01:00.0: [10de:1392=
] type 00 class 0x030200
Feb 17 19:11:37 vinco kernel: [    0.346583] pci 0000:01:00.0: reg 0x10: =
[mem 0xf6000000-0xf6ffffff]
Feb 17 19:11:37 vinco kernel: [    0.346599] pci 0000:01:00.0: reg 0x14: =
[mem 0xe0000000-0xefffffff 64bit pref]
Feb 17 19:11:37 vinco kernel: [    0.346614] pci 0000:01:00.0: reg 0x1c: =
[mem 0xf0000000-0xf1ffffff 64bit pref]
Feb 17 19:11:37 vinco kernel: [    0.346624] pci 0000:01:00.0: reg 0x24: =
[io  0xe000-0xe07f]
Feb 17 19:11:37 vinco kernel: [    0.346634] pci 0000:01:00.0: reg 0x30: =
[mem 0xf7000000-0xf707ffff pref]
Feb 17 19:11:37 vinco kernel: [    0.346651] pci 0000:01:00.0: Enabling H=
DA controller
Feb 17 19:11:37 vinco kernel: [    0.346803] pci 0000:00:01.0: PCI bridge=
 to [bus 01]
Feb 17 19:11:37 vinco kernel: [    0.346804] pci 0000:00:01.0:   bridge w=
indow [io  0xe000-0xefff]
Feb 17 19:11:37 vinco kernel: [    0.346806] pci 0000:00:01.0:   bridge w=
indow [mem 0xf6000000-0xf70fffff]
Feb 17 19:11:37 vinco kernel: [    0.346808] pci 0000:00:01.0:   bridge w=
indow [mem 0xe0000000-0xf1ffffff 64bit pref]
Feb 17 19:11:37 vinco kernel: [    0.346853] acpiphp: Slot [1] registered=

Feb 17 19:11:37 vinco kernel: [    0.346857] pci 0000:00:1c.0: PCI bridge=
 to [bus 02]
Feb 17 19:11:37 vinco kernel: [    0.346912] pci 0000:00:1c.1: PCI bridge=
 to [bus 03]
Feb 17 19:11:37 vinco kernel: [    0.347007] pci 0000:04:00.0: [8086:08b1=
] type 00 class 0x028000
Feb 17 19:11:37 vinco kernel: [    0.347083] pci 0000:04:00.0: reg 0x10: =
[mem 0xf7900000-0xf7901fff 64bit]
Feb 17 19:11:37 vinco kernel: [    0.347347] pci 0000:04:00.0: PME# suppo=
rted from D0 D3hot D3cold
Feb 17 19:11:37 vinco kernel: [    0.347546] pci 0000:00:1c.2: PCI bridge=
 to [bus 04]
Feb 17 19:11:37 vinco kernel: [    0.347550] pci 0000:00:1c.2:   bridge w=
indow [mem 0xf7900000-0xf79fffff]
Feb 17 19:11:37 vinco kernel: [    0.347614] pci 0000:05:00.0: [10ec:5287=
] type 00 class 0xff0000
Feb 17 19:11:37 vinco kernel: [    0.347644] pci 0000:05:00.0: reg 0x10: =
[mem 0xf7815000-0xf7815fff]
Feb 17 19:11:37 vinco kernel: [    0.347704] pci 0000:05:00.0: reg 0x30: =
[mem 0xf7800000-0xf780ffff pref]
Feb 17 19:11:37 vinco kernel: [    0.347797] pci 0000:05:00.0: supports D=
1 D2
Feb 17 19:11:37 vinco kernel: [    0.347798] pci 0000:05:00.0: PME# suppo=
rted from D1 D2 D3hot D3cold
Feb 17 19:11:37 vinco kernel: [    0.347904] pci 0000:05:00.1: [10ec:8168=
] type 00 class 0x020000
Feb 17 19:11:37 vinco kernel: [    0.347933] pci 0000:05:00.1: reg 0x10: =
[io  0xd000-0xd0ff]
Feb 17 19:11:37 vinco kernel: [    0.347959] pci 0000:05:00.1: reg 0x18: =
[mem 0xf7814000-0xf7814fff 64bit]
Feb 17 19:11:37 vinco kernel: [    0.347976] pci 0000:05:00.1: reg 0x20: =
[mem 0xf7810000-0xf7813fff 64bit]
Feb 17 19:11:37 vinco kernel: [    0.348073] pci 0000:05:00.1: supports D=
1 D2
Feb 17 19:11:37 vinco kernel: [    0.348074] pci 0000:05:00.1: PME# suppo=
rted from D0 D1 D2 D3hot D3cold
Feb 17 19:11:37 vinco kernel: [    0.348205] pci 0000:00:1c.3: PCI bridge=
 to [bus 05]
Feb 17 19:11:37 vinco kernel: [    0.348208] pci 0000:00:1c.3:   bridge w=
indow [io  0xd000-0xdfff]
Feb 17 19:11:37 vinco kernel: [    0.348211] pci 0000:00:1c.3:   bridge w=
indow [mem 0xf7800000-0xf78fffff]
Feb 17 19:11:37 vinco kernel: [    0.348776] ACPI: PCI Interrupt Link [LN=
KA] (IRQs 3 4 5 6 7 10 *11 12)
Feb 17 19:11:37 vinco kernel: [    0.348810] ACPI: PCI Interrupt Link [LN=
KB] (IRQs *3 4 5 6 7 10 12)
Feb 17 19:11:37 vinco kernel: [    0.348841] ACPI: PCI Interrupt Link [LN=
KC] (IRQs 3 *4 5 6 7 10 12)
Feb 17 19:11:37 vinco kernel: [    0.348872] ACPI: PCI Interrupt Link [LN=
KD] (IRQs 3 4 5 6 7 *10 12)
Feb 17 19:11:37 vinco kernel: [    0.348903] ACPI: PCI Interrupt Link [LN=
KE] (IRQs 3 4 5 6 7 10 12) *0, disabled.
Feb 17 19:11:37 vinco kernel: [    0.348934] ACPI: PCI Interrupt Link [LN=
KF] (IRQs 3 4 5 6 7 10 12) *0, disabled.
Feb 17 19:11:37 vinco kernel: [    0.348966] ACPI: PCI Interrupt Link [LN=
KG] (IRQs 3 4 *5 6 7 10 12)
Feb 17 19:11:37 vinco kernel: [    0.348997] ACPI: PCI Interrupt Link [LN=
KH] (IRQs 3 4 5 6 7 *10 12)
Feb 17 19:11:37 vinco kernel: [    0.349261] ACPI: EC: interrupt unblocke=
d
Feb 17 19:11:37 vinco kernel: [    0.349267] ACPI: EC: event unblocked
Feb 17 19:11:37 vinco kernel: [    0.349272] ACPI: \_SB_.PCI0.LPCB.EC0_: =
GPE=3D0x19, EC_CMD/EC_SC=3D0x66, EC_DATA=3D0x62
Feb 17 19:11:37 vinco kernel: [    0.349273] ACPI: \_SB_.PCI0.LPCB.EC0_: =
Boot DSDT EC used to handle transactions and events
Feb 17 19:11:37 vinco kernel: [    0.349316] iommu: Default domain type: =
Translated=20
Feb 17 19:11:37 vinco kernel: [    0.349324] pci 0000:00:02.0: vgaarb: se=
tting as boot VGA device
Feb 17 19:11:37 vinco kernel: [    0.349324] pci 0000:00:02.0: vgaarb: VG=
A device added: decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
Feb 17 19:11:37 vinco kernel: [    0.349324] pci 0000:00:02.0: vgaarb: br=
idge control possible
Feb 17 19:11:37 vinco kernel: [    0.349324] vgaarb: loaded
Feb 17 19:11:37 vinco kernel: [    0.349324] EDAC MC: Ver: 3.0.0
Feb 17 19:11:37 vinco kernel: [    0.349324] Registered efivars operation=
s
Feb 17 19:11:37 vinco kernel: [    0.349324] PCI: Using ACPI for IRQ rout=
ing
Feb 17 19:11:37 vinco kernel: [    0.349502] PCI: pci_cache_line_size set=
 to 64 bytes
Feb 17 19:11:37 vinco kernel: [    0.349569] e820: reserve RAM buffer [me=
m 0x00058000-0x0005ffff]
Feb 17 19:11:37 vinco kernel: [    0.349570] e820: reserve RAM buffer [me=
m 0x0009f000-0x0009ffff]
Feb 17 19:11:37 vinco kernel: [    0.349571] e820: reserve RAM buffer [me=
m 0xb9755000-0xbbffffff]
Feb 17 19:11:37 vinco kernel: [    0.349571] e820: reserve RAM buffer [me=
m 0xb9fd5000-0xbbffffff]
Feb 17 19:11:37 vinco kernel: [    0.349572] e820: reserve RAM buffer [me=
m 0xc98c6000-0xcbffffff]
Feb 17 19:11:37 vinco kernel: [    0.349573] e820: reserve RAM buffer [me=
m 0xc9e01000-0xcbffffff]
Feb 17 19:11:37 vinco kernel: [    0.349574] e820: reserve RAM buffer [me=
m 0xcb000000-0xcbffffff]
Feb 17 19:11:37 vinco kernel: [    0.349574] e820: reserve RAM buffer [me=
m 0x42f200000-0x42fffffff]
Feb 17 19:11:37 vinco kernel: [    0.350010] hpet0: at MMIO 0xfed00000, I=
RQs 2, 8, 0, 0, 0, 0, 0, 0
Feb 17 19:11:37 vinco kernel: [    0.350013] hpet0: 8 comparators, 64-bit=
 14.318180 MHz counter
Feb 17 19:11:37 vinco kernel: [    0.352320] clocksource: Switched to clo=
cksource tsc-early
Feb 17 19:11:37 vinco kernel: [    0.359610] VFS: Disk quotas dquot_6.6.0=

Feb 17 19:11:37 vinco kernel: [    0.359621] VFS: Dquot-cache hash table =
entries: 512 (order 0, 4096 bytes)
Feb 17 19:11:37 vinco kernel: [    0.359699] AppArmor: AppArmor Filesyste=
m Enabled
Feb 17 19:11:37 vinco kernel: [    0.359711] pnp: PnP ACPI init
Feb 17 19:11:37 vinco kernel: [    0.359812] system 00:00: [mem 0xfed4000=
0-0xfed44fff] has been reserved
Feb 17 19:11:37 vinco kernel: [    0.359815] system 00:00: Plug and Play =
ACPI device, IDs PNP0c01 (active)
Feb 17 19:11:37 vinco kernel: [    0.359969] system 00:01: [io  0x0680-0x=
069f] has been reserved
Feb 17 19:11:37 vinco kernel: [    0.359970] system 00:01: [io  0xffff] h=
as been reserved
Feb 17 19:11:37 vinco kernel: [    0.359971] system 00:01: [io  0xffff] h=
as been reserved
Feb 17 19:11:37 vinco kernel: [    0.359972] system 00:01: [io  0xffff] h=
as been reserved
Feb 17 19:11:37 vinco kernel: [    0.359973] system 00:01: [io  0x1c00-0x=
1cfe] has been reserved
Feb 17 19:11:37 vinco kernel: [    0.359973] system 00:01: [io  0x1d00-0x=
1dfe] has been reserved
Feb 17 19:11:37 vinco kernel: [    0.359974] system 00:01: [io  0x1e00-0x=
1efe] has been reserved
Feb 17 19:11:37 vinco kernel: [    0.359975] system 00:01: [io  0x1f00-0x=
1ffe] has been reserved
Feb 17 19:11:37 vinco kernel: [    0.359976] system 00:01: [io  0x1800-0x=
18fe] has been reserved
Feb 17 19:11:37 vinco kernel: [    0.359976] system 00:01: [io  0x164e-0x=
164f] has been reserved
Feb 17 19:11:37 vinco kernel: [    0.359979] system 00:01: Plug and Play =
ACPI device, IDs PNP0c02 (active)
Feb 17 19:11:37 vinco kernel: [    0.359995] pnp 00:02: Plug and Play ACP=
I device, IDs PNP0b00 (active)
Feb 17 19:11:37 vinco kernel: [    0.360032] system 00:03: [io  0x1854-0x=
1857] has been reserved
Feb 17 19:11:37 vinco kernel: [    0.360035] system 00:03: Plug and Play =
ACPI device, IDs INT3f0d PNP0c02 (active)
Feb 17 19:11:37 vinco kernel: [    0.360071] system 00:04: [io  0x04d0-0x=
04d1] has been reserved
Feb 17 19:11:37 vinco kernel: [    0.360073] system 00:04: Plug and Play =
ACPI device, IDs PNP0c02 (active)
Feb 17 19:11:37 vinco kernel: [    0.360096] system 00:05: [io  0x0240-0x=
0259] has been reserved
Feb 17 19:11:37 vinco kernel: [    0.360098] system 00:05: Plug and Play =
ACPI device, IDs PNP0c02 (active)
Feb 17 19:11:37 vinco kernel: [    0.360135] pnp 00:06: Plug and Play ACP=
I device, IDs ETD0108 SYN0a00 SYN0002 PNP0f03 PNP0f13 PNP0f12 (active)
Feb 17 19:11:37 vinco kernel: [    0.360157] pnp 00:07: Plug and Play ACP=
I device, IDs ATK3001 PNP030b (active)
Feb 17 19:11:37 vinco kernel: [    0.360400] system 00:08: [mem 0xfed1c00=
0-0xfed1ffff] has been reserved
Feb 17 19:11:37 vinco kernel: [    0.360401] system 00:08: [mem 0xfed1000=
0-0xfed17fff] has been reserved
Feb 17 19:11:37 vinco kernel: [    0.360401] system 00:08: [mem 0xfed1800=
0-0xfed18fff] has been reserved
Feb 17 19:11:37 vinco kernel: [    0.360402] system 00:08: [mem 0xfed1900=
0-0xfed19fff] has been reserved
Feb 17 19:11:37 vinco kernel: [    0.360403] system 00:08: [mem 0xf800000=
0-0xfbffffff] has been reserved
Feb 17 19:11:37 vinco kernel: [    0.360404] system 00:08: [mem 0xfed2000=
0-0xfed3ffff] has been reserved
Feb 17 19:11:37 vinco kernel: [    0.360405] system 00:08: [mem 0xfed9000=
0-0xfed93fff] could not be reserved
Feb 17 19:11:37 vinco kernel: [    0.360406] system 00:08: [mem 0xfed4500=
0-0xfed8ffff] has been reserved
Feb 17 19:11:37 vinco kernel: [    0.360407] system 00:08: [mem 0xff00000=
0-0xffffffff] has been reserved
Feb 17 19:11:37 vinco kernel: [    0.360408] system 00:08: [mem 0xfee0000=
0-0xfeefffff] could not be reserved
Feb 17 19:11:37 vinco kernel: [    0.360408] system 00:08: [mem 0xf7fdf00=
0-0xf7fdffff] has been reserved
Feb 17 19:11:37 vinco kernel: [    0.360409] system 00:08: [mem 0xf7fe000=
0-0xf7feffff] has been reserved
Feb 17 19:11:37 vinco kernel: [    0.360411] system 00:08: Plug and Play =
ACPI device, IDs PNP0c02 (active)
Feb 17 19:11:37 vinco kernel: [    0.360469] system 00:09: Plug and Play =
ACPI device, IDs PNP0c02 (active)
Feb 17 19:11:37 vinco kernel: [    0.360682] pnp: PnP ACPI: found 10 devi=
ces
Feb 17 19:11:37 vinco kernel: [    0.361467] thermal_sys: Registered ther=
mal governor 'fair_share'
Feb 17 19:11:37 vinco kernel: [    0.361467] thermal_sys: Registered ther=
mal governor 'bang_bang'
Feb 17 19:11:37 vinco kernel: [    0.361468] thermal_sys: Registered ther=
mal governor 'step_wise'
Feb 17 19:11:37 vinco kernel: [    0.361468] thermal_sys: Registered ther=
mal governor 'user_space'
Feb 17 19:11:37 vinco kernel: [    0.365958] clocksource: acpi_pm: mask: =
0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
Feb 17 19:11:37 vinco kernel: [    0.365980] pci 0000:00:1c.1: bridge win=
dow [io  0x1000-0x0fff] to [bus 03] add_size 1000
Feb 17 19:11:37 vinco kernel: [    0.365982] pci 0000:00:1c.1: bridge win=
dow [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000 ad=
d_align 100000
Feb 17 19:11:37 vinco kernel: [    0.365983] pci 0000:00:1c.1: bridge win=
dow [mem 0x00100000-0x000fffff] to [bus 03] add_size 200000 add_align 100=
000
Feb 17 19:11:37 vinco kernel: [    0.365988] pci 0000:00:1c.1: BAR 14: as=
signed [mem 0xcfe00000-0xcfffffff]
Feb 17 19:11:37 vinco kernel: [    0.365992] pci 0000:00:1c.1: BAR 15: as=
signed [mem 0xf2000000-0xf21fffff 64bit pref]
Feb 17 19:11:37 vinco kernel: [    0.365994] pci 0000:00:1c.1: BAR 13: as=
signed [io  0x2000-0x2fff]
Feb 17 19:11:37 vinco kernel: [    0.365995] pci 0000:00:01.0: PCI bridge=
 to [bus 01]
Feb 17 19:11:37 vinco kernel: [    0.365997] pci 0000:00:01.0:   bridge w=
indow [io  0xe000-0xefff]
Feb 17 19:11:37 vinco kernel: [    0.365999] pci 0000:00:01.0:   bridge w=
indow [mem 0xf6000000-0xf70fffff]
Feb 17 19:11:37 vinco kernel: [    0.366000] pci 0000:00:01.0:   bridge w=
indow [mem 0xe0000000-0xf1ffffff 64bit pref]
Feb 17 19:11:37 vinco kernel: [    0.366003] pci 0000:00:1c.0: PCI bridge=
 to [bus 02]
Feb 17 19:11:37 vinco kernel: [    0.366011] pci 0000:00:1c.1: PCI bridge=
 to [bus 03]
Feb 17 19:11:37 vinco kernel: [    0.366013] pci 0000:00:1c.1:   bridge w=
indow [io  0x2000-0x2fff]
Feb 17 19:11:37 vinco kernel: [    0.366017] pci 0000:00:1c.1:   bridge w=
indow [mem 0xcfe00000-0xcfffffff]
Feb 17 19:11:37 vinco kernel: [    0.366019] pci 0000:00:1c.1:   bridge w=
indow [mem 0xf2000000-0xf21fffff 64bit pref]
Feb 17 19:11:37 vinco kernel: [    0.366024] pci 0000:00:1c.2: PCI bridge=
 to [bus 04]
Feb 17 19:11:37 vinco kernel: [    0.366028] pci 0000:00:1c.2:   bridge w=
indow [mem 0xf7900000-0xf79fffff]
Feb 17 19:11:37 vinco kernel: [    0.366034] pci 0000:00:1c.3: PCI bridge=
 to [bus 05]
Feb 17 19:11:37 vinco kernel: [    0.366036] pci 0000:00:1c.3:   bridge w=
indow [io  0xd000-0xdfff]
Feb 17 19:11:37 vinco kernel: [    0.366040] pci 0000:00:1c.3:   bridge w=
indow [mem 0xf7800000-0xf78fffff]
Feb 17 19:11:37 vinco kernel: [    0.366046] pci_bus 0000:00: resource 4 =
[io  0x0000-0x0cf7 window]
Feb 17 19:11:37 vinco kernel: [    0.366047] pci_bus 0000:00: resource 5 =
[io  0x0d00-0xffff window]
Feb 17 19:11:37 vinco kernel: [    0.366048] pci_bus 0000:00: resource 6 =
[mem 0x000a0000-0x000bffff window]
Feb 17 19:11:37 vinco kernel: [    0.366048] pci_bus 0000:00: resource 7 =
[mem 0x000d0000-0x000d3fff window]
Feb 17 19:11:37 vinco kernel: [    0.366049] pci_bus 0000:00: resource 8 =
[mem 0x000d4000-0x000d7fff window]
Feb 17 19:11:37 vinco kernel: [    0.366050] pci_bus 0000:00: resource 9 =
[mem 0x000d8000-0x000dbfff window]
Feb 17 19:11:37 vinco kernel: [    0.366050] pci_bus 0000:00: resource 10=
 [mem 0x000dc000-0x000dffff window]
Feb 17 19:11:37 vinco kernel: [    0.366051] pci_bus 0000:00: resource 11=
 [mem 0xcfe00000-0xfeafffff window]
Feb 17 19:11:37 vinco kernel: [    0.366052] pci_bus 0000:01: resource 0 =
[io  0xe000-0xefff]
Feb 17 19:11:37 vinco kernel: [    0.366053] pci_bus 0000:01: resource 1 =
[mem 0xf6000000-0xf70fffff]
Feb 17 19:11:37 vinco kernel: [    0.366053] pci_bus 0000:01: resource 2 =
[mem 0xe0000000-0xf1ffffff 64bit pref]
Feb 17 19:11:37 vinco kernel: [    0.366054] pci_bus 0000:03: resource 0 =
[io  0x2000-0x2fff]
Feb 17 19:11:37 vinco kernel: [    0.366055] pci_bus 0000:03: resource 1 =
[mem 0xcfe00000-0xcfffffff]
Feb 17 19:11:37 vinco kernel: [    0.366056] pci_bus 0000:03: resource 2 =
[mem 0xf2000000-0xf21fffff 64bit pref]
Feb 17 19:11:37 vinco kernel: [    0.366056] pci_bus 0000:04: resource 1 =
[mem 0xf7900000-0xf79fffff]
Feb 17 19:11:37 vinco kernel: [    0.366057] pci_bus 0000:05: resource 0 =
[io  0xd000-0xdfff]
Feb 17 19:11:37 vinco kernel: [    0.366058] pci_bus 0000:05: resource 1 =
[mem 0xf7800000-0xf78fffff]
Feb 17 19:11:37 vinco kernel: [    0.366144] NET: Registered protocol fam=
ily 2
Feb 17 19:11:37 vinco kernel: [    0.366232] tcp_listen_portaddr_hash has=
h table entries: 8192 (order: 5, 131072 bytes, linear)
Feb 17 19:11:37 vinco kernel: [    0.366248] TCP established hash table e=
ntries: 131072 (order: 8, 1048576 bytes, linear)
Feb 17 19:11:37 vinco kernel: [    0.366347] TCP bind hash table entries:=
 65536 (order: 8, 1048576 bytes, linear)
Feb 17 19:11:37 vinco kernel: [    0.366445] TCP: Hash tables configured =
(established 131072 bind 65536)
Feb 17 19:11:37 vinco kernel: [    0.366466] UDP hash table entries: 8192=
 (order: 6, 262144 bytes, linear)
Feb 17 19:11:37 vinco kernel: [    0.366492] UDP-Lite hash table entries:=
 8192 (order: 6, 262144 bytes, linear)
Feb 17 19:11:37 vinco kernel: [    0.366545] NET: Registered protocol fam=
ily 1
Feb 17 19:11:37 vinco kernel: [    0.366548] NET: Registered protocol fam=
ily 44
Feb 17 19:11:37 vinco kernel: [    0.366556] pci 0000:00:02.0: Video devi=
ce with shadowed ROM at [mem 0x000c0000-0x000dffff]
Feb 17 19:11:37 vinco kernel: [    0.366959] PCI: CLS 64 bytes, default 6=
4
Feb 17 19:11:37 vinco kernel: [    0.366984] Trying to unpack rootfs imag=
e as initramfs...
Feb 17 19:11:37 vinco kernel: [    0.976711] Freeing initrd memory: 57904=
K
Feb 17 19:11:37 vinco kernel: [    0.976753] DMAR: No ATSR found
Feb 17 19:11:37 vinco kernel: [    0.976800] DMAR: dmar0: Using Queued in=
validation
Feb 17 19:11:37 vinco kernel: [    0.976804] DMAR: dmar1: Using Queued in=
validation
Feb 17 19:11:37 vinco kernel: [    1.050833] pci 0000:00:00.0: Adding to =
iommu group 0
Feb 17 19:11:37 vinco kernel: [    1.050879] pci 0000:00:01.0: Adding to =
iommu group 1
Feb 17 19:11:37 vinco kernel: [    1.055500] pci 0000:00:02.0: Adding to =
iommu group 2
Feb 17 19:11:37 vinco kernel: [    1.055549] pci 0000:00:02.0: Using iomm=
u direct mapping
Feb 17 19:11:37 vinco kernel: [    1.055581] pci 0000:00:03.0: Adding to =
iommu group 3
Feb 17 19:11:37 vinco kernel: [    1.055638] pci 0000:00:14.0: Adding to =
iommu group 4
Feb 17 19:11:37 vinco kernel: [    1.055685] pci 0000:00:16.0: Adding to =
iommu group 5
Feb 17 19:11:37 vinco kernel: [    1.055741] pci 0000:00:1a.0: Adding to =
iommu group 6
Feb 17 19:11:37 vinco kernel: [    1.055786] pci 0000:00:1b.0: Adding to =
iommu group 7
Feb 17 19:11:37 vinco kernel: [    1.055828] pci 0000:00:1c.0: Adding to =
iommu group 8
Feb 17 19:11:37 vinco kernel: [    1.055873] pci 0000:00:1c.1: Adding to =
iommu group 9
Feb 17 19:11:37 vinco kernel: [    1.055915] pci 0000:00:1c.2: Adding to =
iommu group 10
Feb 17 19:11:37 vinco kernel: [    1.055954] pci 0000:00:1c.3: Adding to =
iommu group 11
Feb 17 19:11:37 vinco kernel: [    1.056014] pci 0000:00:1d.0: Adding to =
iommu group 12
Feb 17 19:11:37 vinco kernel: [    1.057182] pci 0000:00:1f.0: Adding to =
iommu group 13
Feb 17 19:11:37 vinco kernel: [    1.057190] pci 0000:00:1f.2: Adding to =
iommu group 13
Feb 17 19:11:37 vinco kernel: [    1.057198] pci 0000:00:1f.3: Adding to =
iommu group 13
Feb 17 19:11:37 vinco kernel: [    1.057207] pci 0000:01:00.0: Adding to =
iommu group 1
Feb 17 19:11:37 vinco kernel: [    1.057253] pci 0000:04:00.0: Adding to =
iommu group 14
Feb 17 19:11:37 vinco kernel: [    1.057314] pci 0000:05:00.0: Adding to =
iommu group 15
Feb 17 19:11:37 vinco kernel: [    1.057334] pci 0000:05:00.1: Adding to =
iommu group 15
Feb 17 19:11:37 vinco kernel: [    1.057371] DMAR: Intel(R) Virtualizatio=
n Technology for Directed I/O
Feb 17 19:11:37 vinco kernel: [    1.058887] Initialise system trusted ke=
yrings
Feb 17 19:11:37 vinco kernel: [    1.058895] Key type blacklist registere=
d
Feb 17 19:11:37 vinco kernel: [    1.058917] workingset: timestamp_bits=3D=
40 max_order=3D22 bucket_order=3D0
Feb 17 19:11:37 vinco kernel: [    1.059755] zbud: loaded
Feb 17 19:11:37 vinco kernel: [    1.059925] Platform Keyring initialized=

Feb 17 19:11:37 vinco kernel: [    1.059926] Key type asymmetric register=
ed
Feb 17 19:11:37 vinco kernel: [    1.059927] Asymmetric key parser 'x509'=
 registered
Feb 17 19:11:37 vinco kernel: [    1.059932] Block layer SCSI generic (bs=
g) driver version 0.4 loaded (major 250)
Feb 17 19:11:37 vinco kernel: [    1.059964] io scheduler mq-deadline reg=
istered
Feb 17 19:11:37 vinco kernel: [    1.060189] pcieport 0000:00:01.0: PME: =
Signaling with IRQ 26
Feb 17 19:11:37 vinco kernel: [    1.060319] pcieport 0000:00:1c.0: PME: =
Signaling with IRQ 27
Feb 17 19:11:37 vinco kernel: [    1.060458] pcieport 0000:00:1c.1: PME: =
Signaling with IRQ 28
Feb 17 19:11:37 vinco kernel: [    1.060475] pcieport 0000:00:1c.1: pcieh=
p: Slot #1 AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+ Int=
erlock- NoCompl+ LLActRep+
Feb 17 19:11:37 vinco kernel: [    1.060637] pcieport 0000:00:1c.2: PME: =
Signaling with IRQ 29
Feb 17 19:11:37 vinco kernel: [    1.060764] pcieport 0000:00:1c.3: PME: =
Signaling with IRQ 30
Feb 17 19:11:37 vinco kernel: [    1.060814] shpchp: Standard Hot Plug PC=
I Controller Driver version: 0.4
Feb 17 19:11:37 vinco kernel: [    1.060824] efifb: probing for efifb
Feb 17 19:11:37 vinco kernel: [    1.060839] efifb: framebuffer at 0xd000=
0000, using 3072k, total 3072k
Feb 17 19:11:37 vinco kernel: [    1.060839] efifb: mode is 1024x768x32, =
linelength=3D4096, pages=3D1
Feb 17 19:11:37 vinco kernel: [    1.060840] efifb: scrolling: redraw
Feb 17 19:11:37 vinco kernel: [    1.060840] efifb: Truecolor: size=3D8:8=
:8:8, shift=3D24:16:8:0
Feb 17 19:11:37 vinco kernel: [    1.060897] Console: switching to colour=
 frame buffer device 128x48
Feb 17 19:11:37 vinco kernel: [    1.062174] fb0: EFI VGA frame buffer de=
vice
Feb 17 19:11:37 vinco kernel: [    1.062179] intel_idle: MWAIT substates:=
 0x42120
Feb 17 19:11:37 vinco kernel: [    1.062180] intel_idle: v0.4.1 model 0x3=
C
Feb 17 19:11:37 vinco kernel: [    1.062407] intel_idle: lapic_timer_reli=
able_states 0xffffffff
Feb 17 19:11:37 vinco kernel: [    1.063113] thermal LNXTHERM:00: registe=
red as thermal_zone0
Feb 17 19:11:37 vinco kernel: [    1.063114] ACPI: Thermal Zone [THRM] (5=
0 C)
Feb 17 19:11:37 vinco kernel: [    1.063260] Serial: 8250/16550 driver, 4=
 ports, IRQ sharing enabled
Feb 17 19:11:37 vinco kernel: [    1.063681] Linux agpgart interface v0.1=
03
Feb 17 19:11:37 vinco kernel: [    1.063714] AMD-Vi: AMD IOMMUv2 driver b=
y Joerg Roedel <jroedel@suse.de>
Feb 17 19:11:37 vinco kernel: [    1.063715] AMD-Vi: AMD IOMMUv2 function=
ality not available on this system
Feb 17 19:11:37 vinco kernel: [    1.064133] i8042: PNP: PS/2 Controller =
[PNP030b:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
Feb 17 19:11:37 vinco kernel: [    1.067063] i8042: Detected active multi=
plexing controller, rev 1.1
Feb 17 19:11:37 vinco kernel: [    1.069580] serio: i8042 KBD port at 0x6=
0,0x64 irq 1
Feb 17 19:11:37 vinco kernel: [    1.069582] serio: i8042 AUX0 port at 0x=
60,0x64 irq 12
Feb 17 19:11:37 vinco kernel: [    1.069598] serio: i8042 AUX1 port at 0x=
60,0x64 irq 12
Feb 17 19:11:37 vinco kernel: [    1.069609] serio: i8042 AUX2 port at 0x=
60,0x64 irq 12
Feb 17 19:11:37 vinco kernel: [    1.069619] serio: i8042 AUX3 port at 0x=
60,0x64 irq 12
Feb 17 19:11:37 vinco kernel: [    1.069695] mousedev: PS/2 mouse device =
common for all mice
Feb 17 19:11:37 vinco kernel: [    1.069732] rtc_cmos 00:02: RTC can wake=
 from S4
Feb 17 19:11:37 vinco kernel: [    1.069883] rtc_cmos 00:02: registered a=
s rtc0
Feb 17 19:11:37 vinco kernel: [    1.069902] rtc_cmos 00:02: alarms up to=
 one month, y3k, 242 bytes nvram, hpet irqs
Feb 17 19:11:37 vinco kernel: [    1.069909] intel_pstate: Intel P-state =
driver initializing
Feb 17 19:11:37 vinco kernel: [    1.070524] ledtrig-cpu: registered to i=
ndicate activity on CPUs
Feb 17 19:11:37 vinco kernel: [    1.070849] drop_monitor: Initializing n=
etwork drop monitor service
Feb 17 19:11:37 vinco kernel: [    1.071259] NET: Registered protocol fam=
ily 10
Feb 17 19:11:37 vinco kernel: [    1.091091] Segment Routing with IPv6
Feb 17 19:11:37 vinco kernel: [    1.091115] mip6: Mobile IPv6
Feb 17 19:11:37 vinco kernel: [    1.091117] NET: Registered protocol fam=
ily 17
Feb 17 19:11:37 vinco kernel: [    1.091251] mpls_gso: MPLS GSO support
Feb 17 19:11:37 vinco kernel: [    1.092008] microcode: sig=3D0x306c3, pf=
=3D0x20, revision=3D0x27
Feb 17 19:11:37 vinco kernel: [    1.092097] microcode: Microcode Update =
Driver: v2.2.
Feb 17 19:11:37 vinco kernel: [    1.092101] IPI shorthand broadcast: ena=
bled
Feb 17 19:11:37 vinco kernel: [    1.092108] sched_clock: Marking stable =
(1091745039, 195300)->(1097419075, -5478736)
Feb 17 19:11:37 vinco kernel: [    1.092214] registered taskstats version=
 1
Feb 17 19:11:37 vinco kernel: [    1.092214] Loading compiled-in X.509 ce=
rtificates
Feb 17 19:11:37 vinco kernel: [    1.110158] input: AT Translated Set 2 k=
eyboard as /devices/platform/i8042/serio0/input/input0
Feb 17 19:11:37 vinco kernel: [    1.125172] Loaded X.509 cert 'Debian Se=
cure Boot CA: 6ccece7e4c6c0d1f6149f3dd27dfcc5cbb419ea1'
Feb 17 19:11:37 vinco kernel: [    1.125183] Loaded X.509 cert 'Debian Se=
cure Boot Signer: 00a7468def'
Feb 17 19:11:37 vinco kernel: [    1.125197] zswap: loaded using pool lzo=
/zbud
Feb 17 19:11:37 vinco kernel: [    1.125321] Key type ._fscrypt registere=
d
Feb 17 19:11:37 vinco kernel: [    1.125321] Key type .fscrypt registered=

Feb 17 19:11:37 vinco kernel: [    1.125331] AppArmor: AppArmor sha1 poli=
cy hashing enabled
Feb 17 19:11:37 vinco kernel: [    1.125470] integrity: Loading X.509 cer=
tificate: UEFI:db
Feb 17 19:11:37 vinco kernel: [    1.125642] integrity: Loaded X.509 cert=
 'ASUSTeK Notebook SW Key Certificate: b8e581e4df77a5bb4282d5ccfc00c071'
Feb 17 19:11:37 vinco kernel: [    1.125642] integrity: Loading X.509 cer=
tificate: UEFI:db
Feb 17 19:11:37 vinco kernel: [    1.125797] integrity: Loaded X.509 cert=
 'ASUSTeK MotherBoard SW Key Certificate: da83b990422ebc8c441f8d8b039a65a=
2'
Feb 17 19:11:37 vinco kernel: [    1.125797] integrity: Loading X.509 cer=
tificate: UEFI:db
Feb 17 19:11:37 vinco kernel: [    1.125812] integrity: Loaded X.509 cert=
 'Microsoft Corporation UEFI CA 2011: 13adbf4309bd82709c8cd54f316ed522988=
a1bd4'
Feb 17 19:11:37 vinco kernel: [    1.125812] integrity: Loading X.509 cer=
tificate: UEFI:db
Feb 17 19:11:37 vinco kernel: [    1.125824] integrity: Loaded X.509 cert=
 'Microsoft Windows Production PCA 2011: a92902398e16c49778cd90f99e4f9ae1=
7c55af53'
Feb 17 19:11:37 vinco kernel: [    1.125824] integrity: Loading X.509 cer=
tificate: UEFI:db
Feb 17 19:11:37 vinco kernel: [    1.125980] integrity: Loaded X.509 cert=
 'Canonical Ltd. Master Certificate Authority: ad91990bc22ab1f517048c23b6=
655a268e345a63'
Feb 17 19:11:37 vinco kernel: [    1.126552] rtc_cmos 00:02: setting syst=
em clock to 2020-02-17T17:11:32 UTC (1581959492)
Feb 17 19:11:37 vinco kernel: [    1.127193] Freeing unused kernel image =
memory: 1672K
Feb 17 19:11:37 vinco kernel: [    1.164411] Write protecting the kernel =
read-only data: 16384k
Feb 17 19:11:37 vinco kernel: [    1.165148] Freeing unused kernel image =
memory: 2036K
Feb 17 19:11:37 vinco kernel: [    1.165340] Freeing unused kernel image =
memory: 360K
Feb 17 19:11:37 vinco kernel: [    1.178912] x86/mm: Checked W+X mappings=
: passed, no W+X pages found.
Feb 17 19:11:37 vinco kernel: [    1.178913] x86/mm: Checking user space =
page tables
Feb 17 19:11:37 vinco kernel: [    1.184492] x86/mm: Checked W+X mappings=
: passed, no W+X pages found.
Feb 17 19:11:37 vinco kernel: [    1.184493] Run /init as init process
Feb 17 19:11:37 vinco kernel: [    1.236757] input: Lid Switch as /device=
s/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input4
Feb 17 19:11:37 vinco kernel: [    1.236781] ACPI: Lid Switch [LID]
Feb 17 19:11:37 vinco kernel: [    1.236840] input: Sleep Button as /devi=
ces/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input5
Feb 17 19:11:37 vinco kernel: [    1.236884] ACPI: Sleep Button [SLPB]
Feb 17 19:11:37 vinco kernel: [    1.236931] input: Power Button as /devi=
ces/LNXSYSTM:00/LNXPWRBN:00/input/input6
Feb 17 19:11:37 vinco kernel: [    1.236969] ACPI: Power Button [PWRF]
Feb 17 19:11:37 vinco kernel: [    1.247790] ACPI Warning: SystemIO range=
 0x0000000000001828-0x000000000000182F conflicts with OpRegion 0x00000000=
00001800-0x000000000000184F (\GPIS) (20190816/utaddress-204)
Feb 17 19:11:37 vinco kernel: [    1.247795] ACPI Warning: SystemIO range=
 0x0000000000001828-0x000000000000182F conflicts with OpRegion 0x00000000=
00001800-0x000000000000187F (\PMIO) (20190816/utaddress-204)
Feb 17 19:11:37 vinco kernel: [    1.247799] ACPI: If an ACPI driver is a=
vailable for this device, you should use it instead of the native driver
Feb 17 19:11:37 vinco kernel: [    1.247802] ACPI Warning: SystemIO range=
 0x0000000000001C40-0x0000000000001C4F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C5F (\_SB.PCI0.PEG0.PEGP.GPR) (20190816/utaddress=
-204)
Feb 17 19:11:37 vinco kernel: [    1.247805] ACPI Warning: SystemIO range=
 0x0000000000001C40-0x0000000000001C4F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C7F (\GPIO) (20190816/utaddress-204)
Feb 17 19:11:37 vinco kernel: [    1.247808] ACPI Warning: SystemIO range=
 0x0000000000001C40-0x0000000000001C4F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C63 (\GP01) (20190816/utaddress-204)
Feb 17 19:11:37 vinco kernel: [    1.247811] ACPI: If an ACPI driver is a=
vailable for this device, you should use it instead of the native driver
Feb 17 19:11:37 vinco kernel: [    1.247812] ACPI Warning: SystemIO range=
 0x0000000000001C30-0x0000000000001C3F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C5F (\_SB.PCI0.PEG0.PEGP.GPR) (20190816/utaddress=
-204)
Feb 17 19:11:37 vinco kernel: [    1.247815] ACPI Warning: SystemIO range=
 0x0000000000001C30-0x0000000000001C3F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C7F (\GPIO) (20190816/utaddress-204)
Feb 17 19:11:37 vinco kernel: [    1.247818] ACPI Warning: SystemIO range=
 0x0000000000001C30-0x0000000000001C3F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C63 (\GP01) (20190816/utaddress-204)
Feb 17 19:11:37 vinco kernel: [    1.247821] ACPI Warning: SystemIO range=
 0x0000000000001C30-0x0000000000001C3F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C3F (\GPRL) (20190816/utaddress-204)
Feb 17 19:11:37 vinco kernel: [    1.247824] ACPI: If an ACPI driver is a=
vailable for this device, you should use it instead of the native driver
Feb 17 19:11:37 vinco kernel: [    1.247825] ACPI Warning: SystemIO range=
 0x0000000000001C00-0x0000000000001C2F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C5F (\_SB.PCI0.PEG0.PEGP.GPR) (20190816/utaddress=
-204)
Feb 17 19:11:37 vinco kernel: [    1.247827] ACPI Warning: SystemIO range=
 0x0000000000001C00-0x0000000000001C2F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C7F (\GPIO) (20190816/utaddress-204)
Feb 17 19:11:37 vinco kernel: [    1.247830] ACPI Warning: SystemIO range=
 0x0000000000001C00-0x0000000000001C2F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C63 (\GP01) (20190816/utaddress-204)
Feb 17 19:11:37 vinco kernel: [    1.247833] ACPI Warning: SystemIO range=
 0x0000000000001C00-0x0000000000001C2F conflicts with OpRegion 0x00000000=
00001C00-0x0000000000001C3F (\GPRL) (20190816/utaddress-204)
Feb 17 19:11:37 vinco kernel: [    1.247835] ACPI: If an ACPI driver is a=
vailable for this device, you should use it instead of the native driver
Feb 17 19:11:37 vinco kernel: [    1.247836] lpc_ich: Resource conflict(s=
) found affecting gpio_ich
Feb 17 19:11:37 vinco kernel: [    1.251534] i801_smbus 0000:00:1f.3: SPD=
 Write Disable is set
Feb 17 19:11:37 vinco kernel: [    1.251566] i801_smbus 0000:00:1f.3: SMB=
us using PCI interrupt
Feb 17 19:11:37 vinco kernel: [    1.259246] SCSI subsystem initialized
Feb 17 19:11:37 vinco kernel: [    1.262796] ACPI: bus type USB registere=
d
Feb 17 19:11:37 vinco kernel: [    1.262816] usbcore: registered new inte=
rface driver usbfs
Feb 17 19:11:37 vinco kernel: [    1.262824] usbcore: registered new inte=
rface driver hub
Feb 17 19:11:37 vinco kernel: [    1.264320] usbcore: registered new devi=
ce driver usb
Feb 17 19:11:37 vinco kernel: [    1.268950] r8169 0000:05:00.1: can't di=
sable ASPM; OS doesn't have ASPM control
Feb 17 19:11:37 vinco kernel: [    1.269125] ehci_hcd: USB 2.0 'Enhanced'=
 Host Controller (EHCI) Driver
Feb 17 19:11:37 vinco kernel: [    1.272804] ehci-pci: EHCI PCI platform =
driver
Feb 17 19:11:37 vinco kernel: [    1.272901] ehci-pci 0000:00:1a.0: EHCI =
Host Controller
Feb 17 19:11:37 vinco kernel: [    1.272906] ehci-pci 0000:00:1a.0: new U=
SB bus registered, assigned bus number 1
Feb 17 19:11:37 vinco kernel: [    1.272916] ehci-pci 0000:00:1a.0: debug=
 port 2
Feb 17 19:11:37 vinco kernel: [    1.275366] libata version 3.00 loaded.
Feb 17 19:11:37 vinco kernel: [    1.276818] ehci-pci 0000:00:1a.0: cache=
 line size of 64 is not supported
Feb 17 19:11:37 vinco kernel: [    1.276837] ehci-pci 0000:00:1a.0: irq 1=
6, io mem 0xf7a1c000
Feb 17 19:11:37 vinco kernel: [    1.279500] ahci 0000:00:1f.2: version 3=
=2E0
Feb 17 19:11:37 vinco kernel: [    1.279628] ahci 0000:00:1f.2: AHCI 0001=
=2E0300 32 slots 4 ports 6 Gbps 0x14 impl SATA mode
Feb 17 19:11:37 vinco kernel: [    1.279630] ahci 0000:00:1f.2: flags: 64=
bit ncq pm led clo pio slum part ems apst=20
Feb 17 19:11:37 vinco kernel: [    1.282117] libphy: r8169: probed
Feb 17 19:11:37 vinco kernel: [    1.282236] r8169 0000:05:00.1 eth0: RTL=
8411b, 08:62:66:b3:2e:1c, XID 5c8, IRQ 33
Feb 17 19:11:37 vinco kernel: [    1.282238] r8169 0000:05:00.1 eth0: jum=
bo features [frames: 9200 bytes, tx checksumming: ko]
Feb 17 19:11:37 vinco kernel: [    1.282778] r8169 0000:05:00.1 enp5s0f1:=
 renamed from eth0
Feb 17 19:11:37 vinco kernel: [    1.288665] scsi host0: ahci
Feb 17 19:11:37 vinco kernel: [    1.288773] scsi host1: ahci
Feb 17 19:11:37 vinco kernel: [    1.288841] scsi host2: ahci
Feb 17 19:11:37 vinco kernel: [    1.288907] scsi host3: ahci
Feb 17 19:11:37 vinco kernel: [    1.288968] scsi host4: ahci
Feb 17 19:11:37 vinco kernel: [    1.289008] ata1: DUMMY
Feb 17 19:11:37 vinco kernel: [    1.289009] ata2: DUMMY
Feb 17 19:11:37 vinco kernel: [    1.289011] ata3: SATA max UDMA/133 abar=
 m2048@0xf7a1a000 port 0xf7a1a200 irq 32
Feb 17 19:11:37 vinco kernel: [    1.289012] ata4: DUMMY
Feb 17 19:11:37 vinco kernel: [    1.289014] ata5: SATA max UDMA/133 abar=
 m2048@0xf7a1a000 port 0xf7a1a300 irq 32
Feb 17 19:11:37 vinco kernel: [    1.292314] ehci-pci 0000:00:1a.0: USB 2=
=2E0 started, EHCI 1.00
Feb 17 19:11:37 vinco kernel: [    1.292396] usb usb1: New USB device fou=
nd, idVendor=3D1d6b, idProduct=3D0002, bcdDevice=3D 5.04
Feb 17 19:11:37 vinco kernel: [    1.292397] usb usb1: New USB device str=
ings: Mfr=3D3, Product=3D2, SerialNumber=3D1
Feb 17 19:11:37 vinco kernel: [    1.292398] usb usb1: Product: EHCI Host=
 Controller
Feb 17 19:11:37 vinco kernel: [    1.292399] usb usb1: Manufacturer: Linu=
x 5.4.0-4-amd64 ehci_hcd
Feb 17 19:11:37 vinco kernel: [    1.292399] usb usb1: SerialNumber: 0000=
:00:1a.0
Feb 17 19:11:37 vinco kernel: [    1.292491] hub 1-0:1.0: USB hub found
Feb 17 19:11:37 vinco kernel: [    1.292497] hub 1-0:1.0: 2 ports detecte=
d
Feb 17 19:11:37 vinco kernel: [    1.292608] xhci_hcd 0000:00:14.0: xHCI =
Host Controller
Feb 17 19:11:37 vinco kernel: [    1.292614] xhci_hcd 0000:00:14.0: new U=
SB bus registered, assigned bus number 2
Feb 17 19:11:37 vinco kernel: [    1.293686] xhci_hcd 0000:00:14.0: hcc p=
arams 0x200077c1 hci version 0x100 quirks 0x0000000000009810
Feb 17 19:11:37 vinco kernel: [    1.293691] xhci_hcd 0000:00:14.0: cache=
 line size of 64 is not supported
Feb 17 19:11:37 vinco kernel: [    1.293827] usb usb2: New USB device fou=
nd, idVendor=3D1d6b, idProduct=3D0002, bcdDevice=3D 5.04
Feb 17 19:11:37 vinco kernel: [    1.293828] usb usb2: New USB device str=
ings: Mfr=3D3, Product=3D2, SerialNumber=3D1
Feb 17 19:11:37 vinco kernel: [    1.293829] usb usb2: Product: xHCI Host=
 Controller
Feb 17 19:11:37 vinco kernel: [    1.293830] usb usb2: Manufacturer: Linu=
x 5.4.0-4-amd64 xhci-hcd
Feb 17 19:11:37 vinco kernel: [    1.293830] usb usb2: SerialNumber: 0000=
:00:14.0
Feb 17 19:11:37 vinco kernel: [    1.293913] hub 2-0:1.0: USB hub found
Feb 17 19:11:37 vinco kernel: [    1.293933] hub 2-0:1.0: 14 ports detect=
ed
Feb 17 19:11:37 vinco kernel: [    1.296053] ehci-pci 0000:00:1d.0: EHCI =
Host Controller
Feb 17 19:11:37 vinco kernel: [    1.296057] ehci-pci 0000:00:1d.0: new U=
SB bus registered, assigned bus number 3
Feb 17 19:11:37 vinco kernel: [    1.296071] ehci-pci 0000:00:1d.0: debug=
 port 2
Feb 17 19:11:37 vinco kernel: [    1.296082] xhci_hcd 0000:00:14.0: xHCI =
Host Controller
Feb 17 19:11:37 vinco kernel: [    1.296084] xhci_hcd 0000:00:14.0: new U=
SB bus registered, assigned bus number 4
Feb 17 19:11:37 vinco kernel: [    1.296086] xhci_hcd 0000:00:14.0: Host =
supports USB 3.0 SuperSpeed
Feb 17 19:11:37 vinco kernel: [    1.296140] usb usb4: New USB device fou=
nd, idVendor=3D1d6b, idProduct=3D0003, bcdDevice=3D 5.04
Feb 17 19:11:37 vinco kernel: [    1.296141] usb usb4: New USB device str=
ings: Mfr=3D3, Product=3D2, SerialNumber=3D1
Feb 17 19:11:37 vinco kernel: [    1.296142] usb usb4: Product: xHCI Host=
 Controller
Feb 17 19:11:37 vinco kernel: [    1.296143] usb usb4: Manufacturer: Linu=
x 5.4.0-4-amd64 xhci-hcd
Feb 17 19:11:37 vinco kernel: [    1.296144] usb usb4: SerialNumber: 0000=
:00:14.0
Feb 17 19:11:37 vinco kernel: [    1.296232] hub 4-0:1.0: USB hub found
Feb 17 19:11:37 vinco kernel: [    1.296246] hub 4-0:1.0: 4 ports detecte=
d
Feb 17 19:11:37 vinco kernel: [    1.299980] ehci-pci 0000:00:1d.0: cache=
 line size of 64 is not supported
Feb 17 19:11:37 vinco kernel: [    1.299991] ehci-pci 0000:00:1d.0: irq 2=
3, io mem 0xf7a1b000
Feb 17 19:11:37 vinco kernel: [    1.312328] ehci-pci 0000:00:1d.0: USB 2=
=2E0 started, EHCI 1.00
Feb 17 19:11:37 vinco kernel: [    1.312355] usb usb3: New USB device fou=
nd, idVendor=3D1d6b, idProduct=3D0002, bcdDevice=3D 5.04
Feb 17 19:11:37 vinco kernel: [    1.312356] usb usb3: New USB device str=
ings: Mfr=3D3, Product=3D2, SerialNumber=3D1
Feb 17 19:11:37 vinco kernel: [    1.312356] usb usb3: Product: EHCI Host=
 Controller
Feb 17 19:11:37 vinco kernel: [    1.312357] usb usb3: Manufacturer: Linu=
x 5.4.0-4-amd64 ehci_hcd
Feb 17 19:11:37 vinco kernel: [    1.312358] usb usb3: SerialNumber: 0000=
:00:1d.0
Feb 17 19:11:37 vinco kernel: [    1.312459] hub 3-0:1.0: USB hub found
Feb 17 19:11:37 vinco kernel: [    1.312463] hub 3-0:1.0: 2 ports detecte=
d
Feb 17 19:11:37 vinco kernel: [    1.346343] i915 0000:00:02.0: VT-d acti=
ve for gfx access
Feb 17 19:11:37 vinco kernel: [    1.346345] checking generic (d0000000 3=
00000) vs hw (d0000000 10000000)
Feb 17 19:11:37 vinco kernel: [    1.346345] fb0: switching to inteldrmfb=
 from EFI VGA
Feb 17 19:11:37 vinco kernel: [    1.346395] Console: switching to colour=
 dummy device 80x25
Feb 17 19:11:37 vinco kernel: [    1.346422] i915 0000:00:02.0: vgaarb: d=
eactivate vga console
Feb 17 19:11:37 vinco kernel: [    1.346635] i915 0000:00:02.0: DMAR acti=
ve, disabling use of stolen memory
Feb 17 19:11:37 vinco kernel: [    1.347103] [drm] Supports vblank timest=
amp caching Rev 2 (21.10.2013).
Feb 17 19:11:37 vinco kernel: [    1.347103] [drm] Driver supports precis=
e vblank timestamp query.
Feb 17 19:11:37 vinco kernel: [    1.347438] i915 0000:00:02.0: vgaarb: c=
hanged VGA decodes: olddecodes=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
Feb 17 19:11:37 vinco kernel: [    1.358388] [drm] Initialized i915 1.6.0=
 20190822 for 0000:00:02.0 on minor 0
Feb 17 19:11:37 vinco kernel: [    1.358788] [Firmware Bug]: ACPI(PEGP) d=
efines _DOD but not _DOS
Feb 17 19:11:37 vinco kernel: [    1.359963] ACPI: Video Device [PEGP] (m=
ulti-head: yes  rom: yes  post: no)
Feb 17 19:11:37 vinco kernel: [    1.361923] input: Video Bus as /devices=
/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:4f/LNXVIDEO:00/input/input9
Feb 17 19:11:37 vinco kernel: [    1.363035] ACPI: Video Device [GFX0] (m=
ulti-head: yes  rom: no  post: no)
Feb 17 19:11:37 vinco kernel: [    1.364939] input: Video Bus as /devices=
/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/input/input10
Feb 17 19:11:37 vinco kernel: [    1.372829] fbcon: i915drmfb (fb0) is pr=
imary device
Feb 17 19:11:37 vinco kernel: [    1.496848] battery: ACPI: Battery Slot =
[BAT0] (battery present)
Feb 17 19:11:37 vinco kernel: [    1.603621] ata5: SATA link up 6.0 Gbps =
(SStatus 133 SControl 300)
Feb 17 19:11:37 vinco kernel: [    1.603641] ata3: SATA link up 1.5 Gbps =
(SStatus 113 SControl 300)
Feb 17 19:11:37 vinco kernel: [    1.605548] ata5.00: ACPI cmd ef/10:06:0=
0:00:00:00 (SET FEATURES) succeeded
Feb 17 19:11:37 vinco kernel: [    1.605550] ata5.00: ACPI cmd f5/00:00:0=
0:00:00:00 (SECURITY FREEZE LOCK) filtered out
Feb 17 19:11:37 vinco kernel: [    1.605551] ata5.00: ACPI cmd b1/c1:00:0=
0:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
Feb 17 19:11:37 vinco kernel: [    1.605893] ata5.00: supports DRM functi=
ons and may not be fully accessible
Feb 17 19:11:37 vinco kernel: [    1.606893] ata5.00: disabling queued TR=
IM support
Feb 17 19:11:37 vinco kernel: [    1.606895] ata5.00: ATA-9: Samsung SSD =
850 EVO 1TB, EMT02B6Q, max UDMA/133
Feb 17 19:11:37 vinco kernel: [    1.606897] ata5.00: 1953525168 sectors,=
 multi 1: LBA48 NCQ (depth 32), AA
Feb 17 19:11:37 vinco kernel: [    1.609098] ata3.00: ATAPI: TSSTcorp CDD=
VDW SU-228FB, AS00, max UDMA/100
Feb 17 19:11:37 vinco kernel: [    1.609765] ata5.00: ACPI cmd ef/10:06:0=
0:00:00:00 (SET FEATURES) succeeded
Feb 17 19:11:37 vinco kernel: [    1.609778] ata5.00: ACPI cmd f5/00:00:0=
0:00:00:00 (SECURITY FREEZE LOCK) filtered out
Feb 17 19:11:37 vinco kernel: [    1.609779] ata5.00: ACPI cmd b1/c1:00:0=
0:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
Feb 17 19:11:37 vinco kernel: [    1.610150] ata5.00: supports DRM functi=
ons and may not be fully accessible
Feb 17 19:11:37 vinco kernel: [    1.610970] ata5.00: disabling queued TR=
IM support
Feb 17 19:11:37 vinco kernel: [    1.612964] ata5.00: configured for UDMA=
/133
Feb 17 19:11:37 vinco kernel: [    1.614656] ata3.00: configured for UDMA=
/100
Feb 17 19:11:37 vinco kernel: [    1.623802] scsi 2:0:0:0: CD-ROM        =
    TSSTcorp CDDVDW SU-228FB  AS00 PQ: 0 ANSI: 5
Feb 17 19:11:37 vinco kernel: [    1.628377] usb 1-1: new high-speed USB =
device number 2 using ehci-pci
Feb 17 19:11:37 vinco kernel: [    1.628378] usb 2-3: new full-speed USB =
device number 2 using xhci_hcd
Feb 17 19:11:37 vinco kernel: [    1.648354] usb 3-1: new high-speed USB =
device number 2 using ehci-pci
Feb 17 19:11:37 vinco kernel: [    1.655615] scsi 4:0:0:0: Direct-Access =
    ATA      Samsung SSD 850  2B6Q PQ: 0 ANSI: 5
Feb 17 19:11:37 vinco kernel: [    1.657388] usb 1-1: New USB device foun=
d, idVendor=3D8087, idProduct=3D8008, bcdDevice=3D 0.05
Feb 17 19:11:37 vinco kernel: [    1.657391] usb 1-1: New USB device stri=
ngs: Mfr=3D0, Product=3D0, SerialNumber=3D0
Feb 17 19:11:37 vinco kernel: [    1.657859] hub 1-1:1.0: USB hub found
Feb 17 19:11:37 vinco kernel: [    1.658052] hub 1-1:1.0: 6 ports detecte=
d
Feb 17 19:11:37 vinco kernel: [    1.677390] usb 3-1: New USB device foun=
d, idVendor=3D8087, idProduct=3D8000, bcdDevice=3D 0.05
Feb 17 19:11:37 vinco kernel: [    1.677393] usb 3-1: New USB device stri=
ngs: Mfr=3D0, Product=3D0, SerialNumber=3D0
Feb 17 19:11:37 vinco kernel: [    1.677860] hub 3-1:1.0: USB hub found
Feb 17 19:11:37 vinco kernel: [    1.678052] hub 3-1:1.0: 8 ports detecte=
d
Feb 17 19:11:37 vinco kernel: [    1.779302] usb 2-3: New USB device foun=
d, idVendor=3D046d, idProduct=3Dc52b, bcdDevice=3D12.03
Feb 17 19:11:37 vinco kernel: [    1.779305] usb 2-3: New USB device stri=
ngs: Mfr=3D1, Product=3D2, SerialNumber=3D0
Feb 17 19:11:37 vinco kernel: [    1.779306] usb 2-3: Product: USB Receiv=
er
Feb 17 19:11:37 vinco kernel: [    1.779308] usb 2-3: Manufacturer: Logit=
ech
Feb 17 19:11:37 vinco kernel: [    1.789602] hidraw: raw HID events drive=
r (C) Jiri Kosina
Feb 17 19:11:37 vinco kernel: [    1.796121] usbcore: registered new inte=
rface driver usbhid
Feb 17 19:11:37 vinco kernel: [    1.796121] usbhid: USB HID core driver
Feb 17 19:11:37 vinco kernel: [    1.797899] input: Logitech USB Receiver=
 as /devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.0/0003:046D:C52B.0001=
/input/input14
Feb 17 19:11:37 vinco kernel: [    1.856710] hid-generic 0003:046D:C52B.0=
001: input,hidraw0: USB HID v1.11 Keyboard [Logitech USB Receiver] on usb=
-0000:00:14.0-3/input0
Feb 17 19:11:37 vinco kernel: [    1.857114] input: Logitech USB Receiver=
 Mouse as /devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.1/0003:046D:C52=
B.0002/input/input15
Feb 17 19:11:37 vinco kernel: [    1.857254] input: Logitech USB Receiver=
 Consumer Control as /devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.1/00=
03:046D:C52B.0002/input/input16
Feb 17 19:11:37 vinco kernel: [    1.908347] usb 2-5: new full-speed USB =
device number 3 using xhci_hcd
Feb 17 19:11:37 vinco kernel: [    1.916481] input: Logitech USB Receiver=
 System Control as /devices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.1/0003=
:046D:C52B.0002/input/input17
Feb 17 19:11:37 vinco kernel: [    1.916743] hid-generic 0003:046D:C52B.0=
002: input,hiddev0,hidraw1: USB HID v1.11 Mouse [Logitech USB Receiver] o=
n usb-0000:00:14.0-3/input1
Feb 17 19:11:37 vinco kernel: [    1.917177] hid-generic 0003:046D:C52B.0=
003: hiddev1,hidraw2: USB HID v1.11 Device [Logitech USB Receiver] on usb=
-0000:00:14.0-3/input2
Feb 17 19:11:37 vinco kernel: [    2.037600] logitech-djreceiver 0003:046=
D:C52B.0003: hiddev0,hidraw0: USB HID v1.11 Device [Logitech USB Receiver=
] on usb-0000:00:14.0-3/input2
Feb 17 19:11:37 vinco kernel: [    2.057873] usb 2-5: New USB device foun=
d, idVendor=3D8087, idProduct=3D07dc, bcdDevice=3D 0.01
Feb 17 19:11:37 vinco kernel: [    2.057876] usb 2-5: New USB device stri=
ngs: Mfr=3D0, Product=3D0, SerialNumber=3D0
Feb 17 19:11:37 vinco kernel: [    2.067486] psmouse serio4: elantech: as=
suming hardware version 4 (with firmware version 0x381fa2)
Feb 17 19:11:37 vinco kernel: [    2.080402] tsc: Refined TSC clocksource=
 calibration: 2494.226 MHz
Feb 17 19:11:37 vinco kernel: [    2.080415] clocksource: tsc: mask: 0xff=
ffffffffffffff max_cycles: 0x23f3eb3743e, max_idle_ns: 440795257847 ns
Feb 17 19:11:37 vinco kernel: [    2.080457] clocksource: Switched to clo=
cksource tsc
Feb 17 19:11:37 vinco kernel: [    2.086601] psmouse serio4: elantech: Sy=
naptics capabilities query result 0x10, 0x14, 0x0e.
Feb 17 19:11:37 vinco kernel: [    2.104725] psmouse serio4: elantech: El=
an sample query result 05, 1b, 64
Feb 17 19:11:37 vinco kernel: [    2.158413] input: Logitech Unifying Dev=
ice. Wireless PID:101b Mouse as /devices/pci0000:00/0000:00:14.0/usb2/2-3=
/2-3:1.2/0003:046D:C52B.0003/0003:046D:101B.0004/input/input19
Feb 17 19:11:37 vinco kernel: [    2.158569] hid-generic 0003:046D:101B.0=
004: input,hidraw1: USB HID v1.11 Mouse [Logitech Unifying Device. Wirele=
ss PID:101b] on usb-0000:00:14.0-3/input2:1
Feb 17 19:11:37 vinco kernel: [    2.178867] input: ETPS/2 Elantech Touch=
pad as /devices/platform/i8042/serio4/input/input13
Feb 17 19:11:37 vinco kernel: [    2.184433] usb 2-7: new high-speed USB =
device number 4 using xhci_hcd
Feb 17 19:11:37 vinco kernel: [    2.201915] input: Logitech M705 as /dev=
ices/pci0000:00/0000:00:14.0/usb2/2-3/2-3:1.2/0003:046D:C52B.0003/0003:04=
6D:101B.0004/input/input23
Feb 17 19:11:37 vinco kernel: [    2.202115] logitech-hidpp-device 0003:0=
46D:101B.0004: input,hidraw1: USB HID v1.11 Mouse [Logitech M705] on usb-=
0000:00:14.0-3/input2:1
Feb 17 19:11:37 vinco kernel: [    2.305742] usb 2-7: New USB device foun=
d, idVendor=3D13d3, idProduct=3D5188, bcdDevice=3D 8.14
Feb 17 19:11:37 vinco kernel: [    2.305746] usb 2-7: New USB device stri=
ngs: Mfr=3D3, Product=3D1, SerialNumber=3D2
Feb 17 19:11:37 vinco kernel: [    2.305748] usb 2-7: Product: USB2.0 UVC=
 HD Webcam
Feb 17 19:11:37 vinco kernel: [    2.305749] usb 2-7: Manufacturer: Azure=
wave
Feb 17 19:11:37 vinco kernel: [    2.305751] usb 2-7: SerialNumber: NULL
Feb 17 19:11:37 vinco kernel: [    2.576681] Console: switching to colour=
 frame buffer device 240x67
Feb 17 19:11:37 vinco kernel: [    2.602330] i915 0000:00:02.0: fb0: i915=
drmfb frame buffer device
Feb 17 19:11:37 vinco kernel: [    2.625420] sd 4:0:0:0: [sda] 1953525168=
 512-byte logical blocks: (1.00 TB/932 GiB)
Feb 17 19:11:37 vinco kernel: [    2.625429] sd 4:0:0:0: [sda] Write Prot=
ect is off
Feb 17 19:11:37 vinco kernel: [    2.625430] sd 4:0:0:0: [sda] Mode Sense=
: 00 3a 00 00
Feb 17 19:11:37 vinco kernel: [    2.625447] sd 4:0:0:0: [sda] Write cach=
e: enabled, read cache: enabled, doesn't support DPO or FUA
Feb 17 19:11:37 vinco kernel: [    2.665416]  sda: sda1 sda2 sda3 sda4 sd=
a6
Feb 17 19:11:37 vinco kernel: [    2.666570] sd 4:0:0:0: [sda] supports T=
CG Opal
Feb 17 19:11:37 vinco kernel: [    2.666572] sd 4:0:0:0: [sda] Attached S=
CSI disk
Feb 17 19:11:37 vinco kernel: [    2.676338] sr 2:0:0:0: [sr0] scsi3-mmc =
drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Feb 17 19:11:37 vinco kernel: [    2.676342] cdrom: Uniform CD-ROM driver=
 Revision: 3.20
Feb 17 19:11:37 vinco kernel: [    2.712843] sr 2:0:0:0: Attached scsi CD=
-ROM sr0
Feb 17 19:11:37 vinco kernel: [    3.088324] raid6: avx2x4   gen() 30980 =
MB/s
Feb 17 19:11:37 vinco kernel: [    3.156323] raid6: avx2x4   xor() 20391 =
MB/s
Feb 17 19:11:37 vinco kernel: [    3.224323] raid6: avx2x2   gen() 27525 =
MB/s
Feb 17 19:11:37 vinco kernel: [    3.292322] raid6: avx2x2   xor() 17664 =
MB/s
Feb 17 19:11:37 vinco kernel: [    3.360322] raid6: avx2x1   gen() 24341 =
MB/s
Feb 17 19:11:37 vinco kernel: [    3.428322] raid6: avx2x1   xor() 16231 =
MB/s
Feb 17 19:11:37 vinco kernel: [    3.496325] raid6: sse2x4   gen() 17432 =
MB/s
Feb 17 19:11:37 vinco kernel: [    3.564324] raid6: sse2x4   xor() 10889 =
MB/s
Feb 17 19:11:37 vinco kernel: [    3.632326] raid6: sse2x2   gen() 14336 =
MB/s
Feb 17 19:11:37 vinco kernel: [    3.700324] raid6: sse2x2   xor()  9624 =
MB/s
Feb 17 19:11:37 vinco kernel: [    3.768325] raid6: sse2x1   gen() 12405 =
MB/s
Feb 17 19:11:37 vinco kernel: [    3.836323] raid6: sse2x1   xor()  8425 =
MB/s
Feb 17 19:11:37 vinco kernel: [    3.836324] raid6: using algorithm avx2x=
4 gen() 30980 MB/s
Feb 17 19:11:37 vinco kernel: [    3.836324] raid6: .... xor() 20391 MB/s=
, rmw enabled
Feb 17 19:11:37 vinco kernel: [    3.836325] raid6: using avx2x2 recovery=
 algorithm
Feb 17 19:11:37 vinco kernel: [    3.842076] xor: automatically using bes=
t checksumming function   avx      =20
Feb 17 19:11:37 vinco kernel: [    3.883810] Btrfs loaded, crc32c=3Dcrc32=
c-intel
Feb 17 19:11:37 vinco kernel: [    4.040361] PM: Image not found (code -2=
2)
Feb 17 19:11:37 vinco kernel: [    4.117628] EXT4-fs (sda4): mounted file=
system with ordered data mode. Opts: (null)
Feb 17 19:11:37 vinco kernel: [    4.490621] EXT4-fs (sda4): re-mounted. =
Opts: errors=3Dremount-ro
Feb 17 19:11:37 vinco kernel: [    4.501574] lp: driver loaded but no dev=
ices found
Feb 17 19:11:37 vinco kernel: [    4.506761] ppdev: user-space parallel p=
ort driver
Feb 17 19:11:37 vinco kernel: [    4.647383] ACPI: AC Adapter [AC0] (on-l=
ine)
Feb 17 19:11:37 vinco kernel: [    4.647797] input: Asus Wireless Radio C=
ontrol as /devices/LNXSYSTM:00/LNXSYBUS:00/ATK4002:00/input/input24
Feb 17 19:11:37 vinco kernel: [    4.682575] EDAC ie31200: No ECC support=

Feb 17 19:11:37 vinco kernel: [    4.730865] EFI Variables Facility v0.08=
 2004-May-17
Feb 17 19:11:37 vinco kernel: [    4.731952] input: PC Speaker as /device=
s/platform/pcspkr/input/input25
Feb 17 19:11:37 vinco kernel: [    4.732605] iTCO_vendor_support: vendor-=
support=3D0
Feb 17 19:11:37 vinco kernel: [    4.733347] RAPL PMU: API unit is 2^-32 =
Joules, 4 fixed counters, 655360 ms ovfl timer
Feb 17 19:11:37 vinco kernel: [    4.733348] RAPL PMU: hw unit of domain =
pp0-core 2^-14 Joules
Feb 17 19:11:37 vinco kernel: [    4.733349] RAPL PMU: hw unit of domain =
package 2^-14 Joules
Feb 17 19:11:37 vinco kernel: [    4.733349] RAPL PMU: hw unit of domain =
dram 2^-14 Joules
Feb 17 19:11:37 vinco kernel: [    4.733350] RAPL PMU: hw unit of domain =
pp1-gpu 2^-14 Joules
Feb 17 19:11:37 vinco kernel: [    4.733812] sr 2:0:0:0: Attached scsi ge=
neric sg0 type 5
Feb 17 19:11:37 vinco kernel: [    4.734970] sd 4:0:0:0: Attached scsi ge=
neric sg1 type 0
Feb 17 19:11:37 vinco kernel: [    4.748396] asus_wmi: ASUS WMI generic d=
river loaded
Feb 17 19:11:37 vinco kernel: [    4.751315] asus_wmi: Initialization: 0x=
1
Feb 17 19:11:37 vinco kernel: [    4.751350] asus_wmi: BIOS WMI version: =
7.9
Feb 17 19:11:37 vinco kernel: [    4.751394] asus_wmi: SFUN value: 0x6a08=
77
Feb 17 19:11:37 vinco kernel: [    4.751397] asus-nb-wmi asus-nb-wmi: Det=
ected ATK, not ASUSWMI, use DSTS
Feb 17 19:11:37 vinco kernel: [    4.751398] asus-nb-wmi asus-nb-wmi: Det=
ected ATK, enable event queue
Feb 17 19:11:37 vinco kernel: [    4.754745] input: Asus WMI hotkeys as /=
devices/platform/asus-nb-wmi/input/input26
Feb 17 19:11:37 vinco kernel: [    4.809053] iTCO_wdt: Intel TCO WatchDog=
 Timer Driver v1.11
Feb 17 19:11:37 vinco kernel: [    4.809105] iTCO_wdt: Found a Lynx Point=
 TCO device (Version=3D2, TCOBASE=3D0x1860)
Feb 17 19:11:37 vinco kernel: [    4.810131] pstore: Using crash dump com=
pression: deflate
Feb 17 19:11:37 vinco kernel: [    4.812324] iTCO_wdt: initialized. heart=
beat=3D30 sec (nowayout=3D0)
Feb 17 19:11:37 vinco kernel: [    4.818124] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.818216] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.818298] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.818375] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.818453] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.818534] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.818615] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.818695] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.818776] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.818856] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.818937] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.819015] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.819089] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.819163] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.819235] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.819307] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.819382] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.819458] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.819534] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.819607] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.819680] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.819756] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.819829] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.819902] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.819982] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.820055] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.820129] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.820208] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.820286] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.820394] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.820471] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.820550] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.820627] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.820710] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.820789] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.820800] alg: No test for fips(ansi_c=
prng) (fips_ansi_cprng)
Feb 17 19:11:37 vinco kernel: [    4.820868] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.820931] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.820989] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.821045] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.821133] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.821218] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.821303] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.821378] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.821451] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.821522] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.821597] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.821667] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.821742] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.821815] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.821951] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.822108] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.822209] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.822315] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.822392] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.822472] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.822548] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.823331] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.823405] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.824157] pstore: crypto_comp_decompre=
ss failed, ret =3D -22!
Feb 17 19:11:37 vinco kernel: [    4.824196] pstore: Registered efi as pe=
rsistent store backend
Feb 17 19:11:37 vinco kernel: [    4.853284] mc: Linux media interface: v=
0.10
Feb 17 19:11:37 vinco kernel: [    4.853818] cryptd: max_cpu_qlen set to =
1000
Feb 17 19:11:37 vinco kernel: [    4.860342] Adding 15625212k swap on /de=
v/sda3.  Priority:-2 extents:1 across:15625212k SSFS
Feb 17 19:11:37 vinco kernel: [    4.876951] AVX2 version of gcm_enc/dec =
engaged.
Feb 17 19:11:37 vinco kernel: [    4.876952] AES CTR mode by8 optimizatio=
n enabled
Feb 17 19:11:37 vinco kernel: [    4.879323] videodev: Linux video captur=
e interface: v2.00
Feb 17 19:11:37 vinco kernel: [    4.902792] EXT4-fs (sda2): mounting ext=
2 file system using the ext4 subsystem
Feb 17 19:11:37 vinco kernel: [    4.904815] EXT4-fs (sda2): mounted file=
system without journal. Opts: (null)
Feb 17 19:11:37 vinco kernel: [    4.919832] EXT4-fs (sda6): mounted file=
system with ordered data mode. Opts: (null)
Feb 17 19:11:37 vinco kernel: [    4.979447] Intel(R) Wireless WiFi drive=
r for Linux
Feb 17 19:11:37 vinco kernel: [    4.979448] Copyright(c) 2003- 2015 Inte=
l Corporation
Feb 17 19:11:37 vinco kernel: [    4.984769] snd_hda_intel 0000:00:03.0: =
bound 0000:00:02.0 (ops i915_audio_component_bind_ops [i915])
Feb 17 19:11:37 vinco kernel: [    4.986353] iwlwifi 0000:04:00.0: firmwa=
re: direct-loading firmware iwlwifi-7260-17.ucode
Feb 17 19:11:37 vinco kernel: [    4.986579] iwlwifi 0000:04:00.0: loaded=
 firmware version 17.3216344376.0 op_mode iwlmvm
Feb 17 19:11:37 vinco kernel: [    5.006064] input: HDA Intel HDMI HDMI/D=
P,pcm=3D3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input27
Feb 17 19:11:37 vinco kernel: [    5.006118] input: HDA Intel HDMI HDMI/D=
P,pcm=3D7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input28
Feb 17 19:11:37 vinco kernel: [    5.006168] input: HDA Intel HDMI HDMI/D=
P,pcm=3D8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input29
Feb 17 19:11:37 vinco kernel: [    5.006214] input: HDA Intel HDMI HDMI/D=
P,pcm=3D9 as /devices/pci0000:00/0000:00:03.0/sound/card0/input30
Feb 17 19:11:37 vinco kernel: [    5.006258] input: HDA Intel HDMI HDMI/D=
P,pcm=3D10 as /devices/pci0000:00/0000:00:03.0/sound/card0/input31
Feb 17 19:11:37 vinco kernel: [    5.008284] uvcvideo: Found UVC 1.00 dev=
ice USB2.0 UVC HD Webcam (13d3:5188)
Feb 17 19:11:37 vinco kernel: [    5.019724] uvcvideo 2-7:1.0: Entity typ=
e for entity Extension 4 was not initialized!
Feb 17 19:11:37 vinco kernel: [    5.019726] uvcvideo 2-7:1.0: Entity typ=
e for entity Processing 2 was not initialized!
Feb 17 19:11:37 vinco kernel: [    5.019727] uvcvideo 2-7:1.0: Entity typ=
e for entity Camera 1 was not initialized!
Feb 17 19:11:37 vinco kernel: [    5.019794] input: USB2.0 UVC HD Webcam:=
 USB2.0 UV as /devices/pci0000:00/0000:00:14.0/usb2/2-7/2-7:1.0/input/inp=
ut32
Feb 17 19:11:37 vinco kernel: [    5.019845] usbcore: registered new inte=
rface driver uvcvideo
Feb 17 19:11:37 vinco kernel: [    5.019846] USB Video Class driver (1.1.=
1)
Feb 17 19:11:37 vinco kernel: [    5.085966] Bluetooth: Core ver 2.22
Feb 17 19:11:37 vinco kernel: [    5.085980] NET: Registered protocol fam=
ily 31
Feb 17 19:11:37 vinco kernel: [    5.085981] Bluetooth: HCI device and co=
nnection manager initialized
Feb 17 19:11:37 vinco kernel: [    5.085985] Bluetooth: HCI socket layer =
initialized
Feb 17 19:11:37 vinco kernel: [    5.085987] Bluetooth: L2CAP socket laye=
r initialized
Feb 17 19:11:37 vinco kernel: [    5.085990] Bluetooth: SCO socket layer =
initialized
Feb 17 19:11:37 vinco kernel: [    5.097617] iwlwifi 0000:04:00.0: Detect=
ed Intel(R) Dual Band Wireless N 7260, REV=3D0x144
Feb 17 19:11:37 vinco kernel: [    5.111783] snd_hda_codec_realtek hdaudi=
oC1D0: autoconfig for ALC668: line_outs=3D2 (0x14/0x1a/0x0/0x0/0x0) type:=
speaker
Feb 17 19:11:37 vinco kernel: [    5.111786] snd_hda_codec_realtek hdaudi=
oC1D0:    speaker_outs=3D0 (0x0/0x0/0x0/0x0/0x0)
Feb 17 19:11:37 vinco kernel: [    5.111787] snd_hda_codec_realtek hdaudi=
oC1D0:    hp_outs=3D1 (0x15/0x0/0x0/0x0/0x0)
Feb 17 19:11:37 vinco kernel: [    5.111788] snd_hda_codec_realtek hdaudi=
oC1D0:    mono: mono_out=3D0x0
Feb 17 19:11:37 vinco kernel: [    5.111789] snd_hda_codec_realtek hdaudi=
oC1D0:    inputs:
Feb 17 19:11:37 vinco kernel: [    5.111791] snd_hda_codec_realtek hdaudi=
oC1D0:      Headphone Mic=3D0x19
Feb 17 19:11:37 vinco kernel: [    5.111792] snd_hda_codec_realtek hdaudi=
oC1D0:      Headset Mic=3D0x1b
Feb 17 19:11:37 vinco kernel: [    5.111793] snd_hda_codec_realtek hdaudi=
oC1D0:      Internal Mic=3D0x12
Feb 17 19:11:37 vinco kernel: [    5.133092] iwlwifi 0000:04:00.0: base H=
W address: 48:51:b7:6b:7d:3a
Feb 17 19:11:37 vinco kernel: [    5.171259] audit: type=3D1400 audit(158=
1959496.537:2): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"aatest-nvidia_modprobe" pid=3D680 comm=3D"apparmor_p=
arser"
Feb 17 19:11:37 vinco kernel: [    5.171469] audit: type=3D1400 audit(158=
1959496.537:3): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"nvidia_modprobe" pid=3D683 comm=3D"apparmor_parser"
Feb 17 19:11:37 vinco kernel: [    5.171474] audit: type=3D1400 audit(158=
1959496.537:4): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"nvidia_modprobe//kmod" pid=3D683 comm=3D"apparmor_pa=
rser"
Feb 17 19:11:37 vinco kernel: [    5.177406] audit: type=3D1400 audit(158=
11959496.545:7): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"mdnsd" pid=3D681 comm=3D"apparmor_parser"
Feb 17 19:11:37 vinco kernel: [    5.177417] input: HDA Intel PCH Headpho=
ne Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input33
Feb 17 19:11:37 vinco kernel: [    5.177602] audit: type=3D1400 audit(158=
1959496.545:8): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"klogd" pid=3D687 comm=3D"apparmor_parser"
Feb 17 19:11:37 vinco kernel: [    5.179724] audit: type=3D1400 audit(158=
1959496.545:9): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/lib/ipsec/charon" pid=3D676 comm=3D"apparmor_pa=
rser"
Feb 17 19:11:37 vinco kernel: [    5.180687] audit: type=3D1400 audit(158=
1959496.549:10): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/sbin/haveged" pid=3D688 comm=3D"apparmor_parser=
"
Feb 17 19:11:37 vinco kernel: [    5.208709] kauditd_printk_skb: 16 callb=
acks suppressed
Feb 17 19:11:37 vinco kernel: [    5.208710] audit: type=3D1400 audit(158=
1959496.577:27): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"libreoffice-oopslash" pid=3D697 comm=3D"apparmor_par=
ser"
Feb 17 19:11:37 vinco kernel: [    5.209202] audit: type=3D1400 audit(158=
1959496.577:28): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"aatest-xdg-open" pid=3D677 comm=3D"apparmor_parser"
Feb 17 19:11:37 vinco kernel: [    5.209205] audit: type=3D1400 audit(158=
1959496.577:29): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"aatest-xdg-open//xdg-open" pid=3D677 comm=3D"apparmo=
r_parser"
Feb 17 19:11:37 vinco kernel: [    5.209207] audit: type=3D1400 audit(158=
1959496.577:30): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"aatest-xdg-open//xdg-open//sanitized_helper" pid=3D6=
77 comm=3D"apparmor_parser"
Feb 17 19:11:37 vinco kernel: [    5.212028] audit: type=3D1400 audit(158=
1959496.577:32): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"supertuxkart" pid=3D702 comm=3D"apparmor_parser"
Feb 17 19:11:37 vinco kernel: [    5.214570] audit: type=3D1400 audit(158=
1959496.581:33): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/{lib/*-linux-gnu*,lib,lib64}/qt5/examples/widge=
ts/mainwindows/application/application" pid=3D707 comm=3D"apparmor_parser=
"
Feb 17 19:11:37 vinco kernel: [    5.215195] audit: type=3D1400 audit(158=
1959496.581:34): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"firefox" pid=3D691 comm=3D"apparmor_parser"
Feb 17 19:11:37 vinco kernel: [    5.215197] audit: type=3D1400 audit(158=
1959496.581:35): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"firefox//browser_java" pid=3D691 comm=3D"apparmor_pa=
rser"
Feb 17 19:11:37 vinco kernel: [    5.215198] audit: type=3D1400 audit(158=
1959496.581:36): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"firefox//browser_openjdk" pid=3D691 comm=3D"apparmor=
_parser"
Feb 17 19:11:37 vinco kernel: [    5.244877] usbcore: registered new inte=
rface driver btusb
Feb 17 19:11:37 vinco kernel: [    5.257707] Bluetooth: hci0: read Intel =
version: 3707100180012d0d00
Feb 17 19:11:37 vinco kernel: [    5.259742] bluetooth hci0: firmware: di=
rect-loading firmware intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
Feb 17 19:11:37 vinco kernel: [    5.259745] Bluetooth: hci0: Intel Bluet=
ooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
Feb 17 19:11:37 vinco kernel: [    5.325313] ieee80211 phy0: Selected rat=
e control algorithm 'iwl-mvm-rs'
Feb 17 19:11:37 vinco kernel: [    5.328116] iwlwifi 0000:04:00.0 wlp4s0:=
 renamed from wlan0
Feb 17 19:11:37 vinco kernel: [    5.404739] intel_rapl_common: Found RAP=
L domain package
Feb 17 19:11:37 vinco kernel: [    5.404741] intel_rapl_common: Found RAP=
L domain core
Feb 17 19:11:37 vinco kernel: [    5.404743] intel_rapl_common: Found RAP=
L domain uncore
Feb 17 19:11:37 vinco kernel: [    5.404744] intel_rapl_common: Found RAP=
L domain dram
Feb 17 19:11:37 vinco kernel: [    5.404747] intel_rapl_common: RAPL pack=
age-0 domain package locked by BIOS
Feb 17 19:11:37 vinco kernel: [    5.404753] intel_rapl_common: RAPL pack=
age-0 domain dram locked by BIOS
Feb 17 19:11:37 vinco kernel: [    5.430697] Bluetooth: hci0: unexpected =
event for opcode 0xfc2f
Feb 17 19:11:37 vinco kernel: [    5.445709] Bluetooth: hci0: Intel firmw=
are patch completed and activated
Feb 17 19:11:37 vinco kernel: [    5.772688] bbswitch: loading out-of-tre=
e module taints kernel.
Feb 17 19:11:37 vinco kernel: [    5.772771] bbswitch: module verificatio=
n failed: signature and/or required key missing - tainting kernel
Feb 17 19:11:37 vinco kernel: [    5.773562] bbswitch: version 0.8
Feb 17 19:11:37 vinco kernel: [    5.773569] bbswitch: Found integrated V=
GA device 0000:00:02.0: \_SB_.PCI0.GFX0
Feb 17 19:11:37 vinco kernel: [    5.773576] bbswitch: Found discrete VGA=
 device 0000:01:00.0: \_SB_.PCI0.PEG0.PEGP
Feb 17 19:11:37 vinco kernel: [    5.773590] ACPI Warning: \_SB.PCI0.PEG0=
=2EPEGP._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [=
Package] (20190816/nsarguments-59)
Feb 17 19:11:37 vinco kernel: [    5.773701] bbswitch: detected an Optimu=
s _DSM function
Feb 17 19:11:37 vinco kernel: [    5.773786] bbswitch: Succesfully loaded=
=2E Discrete card 0000:01:00.0 is on
Feb 17 19:11:37 vinco kernel: [    5.774899] bbswitch: disabling discrete=
 graphics
Feb 17 19:11:37 vinco kernel: [    5.826089] IPMI message handler: versio=
n 39.2
Feb 17 19:11:37 vinco kernel: [    5.828258] ipmi device interface
Feb 17 19:11:37 vinco kernel: [    5.877282] nvidia: module license 'NVID=
IA' taints kernel.
Feb 17 19:11:37 vinco kernel: [    5.877284] Disabling lock debugging due=
 to kernel taint
Feb 17 19:11:37 vinco kernel: [    5.891352] nvidia-nvlink: Nvlink Core i=
s being initialized, major device number 244
Feb 17 19:11:37 vinco kernel: [    5.891593] nvidia 0000:01:00.0: Refused=
 to change power state, currently in D3
Feb 17 19:11:37 vinco kernel: [    5.891667] NVRM: This is a 64-bit BAR m=
apped above 4GB by the system
Feb 17 19:11:37 vinco kernel: [    5.891667] NVRM: BIOS or the Linux kern=
el, but the PCI bridge
Feb 17 19:11:37 vinco kernel: [    5.891667] NVRM: immediately upstream o=
f this GPU does not define
Feb 17 19:11:37 vinco kernel: [    5.891667] NVRM: a matching prefetchabl=
e memory window.
Feb 17 19:11:37 vinco kernel: [    5.891668] NVRM: This may be due to a k=
nown Linux kernel bug.  Please
Feb 17 19:11:37 vinco kernel: [    5.891668] NVRM: see the README section=
 on 64-bit BARs for additional
Feb 17 19:11:37 vinco kernel: [    5.891668] NVRM: information.
Feb 17 19:11:37 vinco kernel: [    5.891673] nvidia: probe of 0000:01:00.=
0 failed with error -1
Feb 17 19:11:37 vinco kernel: [    5.891687] NVRM: The NVIDIA probe routi=
ne failed for 1 device(s).
Feb 17 19:11:37 vinco kernel: [    5.891687] NVRM: None of the NVIDIA gra=
phics adapters were initialized!
Feb 17 19:11:37 vinco kernel: [    5.904531] Bluetooth: BNEP (Ethernet Em=
ulation) ver 1.3
Feb 17 19:11:37 vinco kernel: [    5.904532] Bluetooth: BNEP filters: pro=
tocol multicast
Feb 17 19:11:37 vinco kernel: [    5.904536] Bluetooth: BNEP socket layer=
 initialized
Feb 17 19:11:37 vinco kernel: [    5.933338] nvidia-nvlink: Unregistered =
the Nvlink Core, major device number 244
Feb 17 19:11:37 vinco kernel: [    6.227098] r8169 0000:05:00.1: firmware=
: direct-loading firmware rtl_nic/rtl8411-2.fw
Feb 17 19:11:37 vinco kernel: [    6.227165] Generic FE-GE Realtek PHY r8=
169-501:00: attached PHY driver [Generic FE-GE Realtek PHY] (mii_bus:phy_=
addr=3Dr8169-501:00, irq=3DIGNORE)
Feb 17 19:11:37 vinco kernel: [    6.352542] r8169 0000:05:00.1 enp5s0f1:=
 Link is Down
Feb 17 19:11:38 vinco kernel: [    7.078111] broken atomic modeset usersp=
ace detected, disabling atomic
Feb 17 19:11:40 vinco kernel: [    8.791709] r8169 0000:05:00.1 enp5s0f1:=
 Link is Up - 1Gbps/Full - flow control rx/tx
Feb 17 19:11:40 vinco kernel: [    8.791720] IPv6: ADDRCONF(NETDEV_CHANGE=
): enp5s0f1: link becomes ready
Feb 17 19:11:40 vinco kernel: [    8.829154] PPP generic driver version 2=
=2E4.2
Feb 17 19:11:40 vinco kernel: [    8.829952] NET: Registered protocol fam=
ily 24
Feb 17 19:11:40 vinco kernel: [    8.835163] l2tp_core: L2TP core driver,=
 V2.0
Feb 17 19:11:40 vinco kernel: [    8.836328] l2tp_netlink: L2TP netlink i=
nterface
Feb 17 19:11:40 vinco kernel: [    8.838234] l2tp_ppp: PPPoL2TP kernel dr=
iver, V2.0
Feb 17 19:11:40 vinco kernel: [    8.849850] vboxdrv: Found 8 processor c=
ores
Feb 17 19:11:40 vinco kernel: [    8.851937] Initializing XFRM netlink so=
cket
Feb 17 19:11:40 vinco kernel: [    8.868529] vboxdrv: TSC mode is Invaria=
nt, tentative frequency 2494224686 Hz
Feb 17 19:11:40 vinco kernel: [    8.868530] vboxdrv: Successfully loaded=
 version 6.1.2_Debian (interface 0x002d0001)
Feb 17 19:11:40 vinco kernel: [    8.877721] VBoxNetFlt: Successfully sta=
rted.
Feb 17 19:11:40 vinco kernel: [    8.884617] VBoxNetAdp: Successfully sta=
rted.
Feb 17 19:11:45 vinco kernel: [   13.879774] Bluetooth: RFCOMM TTY layer =
initialized
Feb 17 19:11:45 vinco kernel: [   13.879788] Bluetooth: RFCOMM socket lay=
er initialized
Feb 17 19:11:45 vinco kernel: [   13.879798] Bluetooth: RFCOMM ver 1.11
Feb 17 19:11:46 vinco kernel: [   14.961705] logitech-hidpp-device 0003:0=
46D:101B.0004: HID++ 1.0 device connected.
Feb 17 19:11:46 vinco kernel: [   15.071723] logitech-hidpp-device 0003:0=
46D:101B.0004: multiplier =3D 8
Feb 17 19:13:36 vinco kernel: [  125.709355] device-mapper: uevent: versi=
on 1.0.3
Feb 17 19:13:36 vinco kernel: [  125.709450] device-mapper: ioctl: 4.41.0=
-ioctl (2019-09-16) initialised: dm-devel@redhat.com
Feb 17 19:13:38 vinco kernel: [  127.693026] SGI XFS with ACLs, security =
attributes, realtime, no debug enabled
Feb 17 19:13:38 vinco kernel: [  127.703792] JFS: nTxBlock =3D 8192, nTxL=
ock =3D 65536
Feb 17 19:13:38 vinco kernel: [  127.733629] QNX4 filesystem 0.2.3 regist=
ered.
Feb 17 19:13:38 vinco kernel: [  127.750190] fuse: init (API version 7.31=
)
Feb 17 19:52:42 vinco kernel: [ 2471.335886] ------------[ cut here ]----=
--------
Feb 17 19:52:42 vinco kernel: [ 2471.335906] NETDEV WATCHDOG: enp5s0f1 (r=
8169): transmit queue 0 timed out
Feb 17 19:52:42 vinco kernel: [ 2471.335929] WARNING: CPU: 6 PID: 0 at ne=
t/sched/sch_generic.c:447 dev_watchdog+0x248/0x250
Feb 17 19:52:42 vinco kernel: [ 2471.335931] Modules linked in: fuse ufs =
qnx4 hfsplus hfs minix msdos jfs xfs dm_mod rfcomm xt_recent ipt_REJECT n=
f_reject_ipv4 xt_multiport xt_conntrack xt_hashlimit xt_addrtype xt_iface=
(OE) xt_mark nft_chain_nat xt_comment xt_CT xt_owner xt_tcpudp nft_compat=
 nft_counter xt_NFLOG nf_log_ipv4 nf_log_common xt_LOG nf_nat_tftp nf_nat=
_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp nf_nat_irc nf_nat_h3=
23 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_nat nf_conntrac=
k_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_pptp nf_conntrack_=
netlink nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_irc n=
f_conntrack_h323 nf_conntrack_ftp nf_conntrack nf_defrag_ipv6 nf_defrag_i=
pv4 nf_tables vboxnetadp(OE) vboxnetflt(OE) xfrm_user xfrm_algo vboxdrv(O=
E) l2tp_ppp l2tp_netlink l2tp_core ip6_udp_tunnel udp_tunnel pppox ppp_ge=
neric slhc bnep nfnetlink_log nfnetlink ipmi_devintf ipmi_msghandler bbsw=
itch(OE) intel_rapl_msr intel_rapl_common x86_pkg_temp_thermal intel_powe=
rclamp coretemp
Feb 17 19:52:42 vinco kernel: [ 2471.335976]  kvm_intel binfmt_misc kvm b=
tusb btrtl snd_hda_codec_realtek btbcm iwlmvm btintel nls_ascii irqbypass=
 mac80211 snd_hda_codec_generic nls_cp437 bluetooth uvcvideo ledtrig_audi=
o snd_hda_codec_hdmi libarc4 crct10dif_pclmul videobuf2_vmalloc vfat vide=
obuf2_memops snd_hda_intel videobuf2_v4l2 fat snd_intel_nhlt ghash_clmuln=
i_intel iwlwifi snd_hda_codec videobuf2_common aesni_intel videodev drbg =
crypto_simd snd_hda_core cryptd cfg80211 mc ansi_cprng glue_helper efi_ps=
tore snd_hwdep iTCO_wdt asus_nb_wmi ecdh_generic snd_pcm intel_cstate joy=
dev ecc asus_wmi snd_timer intel_uncore sparse_keymap rtsx_pci_ms iTCO_ve=
ndor_support pcspkr serio_raw efivars memstick sg watchdog rfkill snd int=
el_rapl_perf soundcore ie31200_edac evdev asus_wireless ac parport_pc ppd=
ev lp parport efivarfs ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2=
 btrfs xor zstd_decompress zstd_compress raid6_pq libcrc32c crc32c_generi=
c sr_mod cdrom sd_mod hid_logitech_hidpp hid_logitech_dj hid_generic usbh=
id hid i915
Feb 17 19:52:42 vinco kernel: [ 2471.336021]  i2c_algo_bit rtsx_pci_sdmmc=
 drm_kms_helper mmc_core ahci xhci_pci libahci xhci_hcd libata ehci_pci e=
hci_hcd drm rtsx_pci mxm_wmi crc32_pclmul psmouse usbcore scsi_mod r8169 =
crc32c_intel realtek i2c_i801 libphy lpc_ich mfd_core usb_common video wm=
i battery button
Feb 17 19:52:42 vinco kernel: [ 2471.336038] CPU: 6 PID: 0 Comm: swapper/=
6 Tainted: P           OE     5.4.0-4-amd64 #1 Debian 5.4.19-1
Feb 17 19:52:42 vinco kernel: [ 2471.336039] Hardware name: ASUSTeK COMPU=
TER INC. N551JM/N551JM, BIOS N551JM.205 02/13/2015
Feb 17 19:52:42 vinco kernel: [ 2471.336043] RIP: 0010:dev_watchdog+0x248=
/0x250
Feb 17 19:52:42 vinco kernel: [ 2471.336046] Code: 85 c0 75 e5 eb 9f 4c 8=
9 ef c6 05 58 1d a8 00 01 e8 0d e4 fa ff 44 89 e1 4c 89 ee 48 c7 c7 f0 cc=
 72 b8 48 89 c2 e8 76 40 a0 ff <0f> 0b eb 80 0f 1f 40 00 0f 1f 44 00 00 4=
1 57 41 56 49 89 d6 41 55
Feb 17 19:52:42 vinco kernel: [ 2471.336047] RSP: 0018:ffffa4d4c01e0e68 E=
FLAGS: 00010286
Feb 17 19:52:42 vinco kernel: [ 2471.336049] RAX: 0000000000000000 RBX: f=
fff93ebce3b3400 RCX: 000000000000083f
Feb 17 19:52:42 vinco kernel: [ 2471.336050] RDX: 0000000000000000 RSI: 0=
0000000000000f6 RDI: 000000000000083f
Feb 17 19:52:42 vinco kernel: [ 2471.336051] RBP: ffff93ebdc4c445c R08: f=
fff93ebded97688 R09: 0000000000000004
Feb 17 19:52:42 vinco kernel: [ 2471.336052] R10: 0000000000000000 R11: 0=
000000000000001 R12: 0000000000000000
Feb 17 19:52:42 vinco kernel: [ 2471.336053] R13: ffff93ebdc4c4000 R14: f=
fff93ebdc4c4480 R15: 0000000000000001
Feb 17 19:52:42 vinco kernel: [ 2471.336055] FS:  0000000000000000(0000) =
GS:ffff93ebded80000(0000) knlGS:0000000000000000
Feb 17 19:52:42 vinco kernel: [ 2471.336057] CS:  0010 DS: 0000 ES: 0000 =
CR0: 0000000080050033
Feb 17 19:52:42 vinco kernel: [ 2471.336058] CR2: 00007fd760fb4400 CR3: 0=
00000040440a003 CR4: 00000000001606e0
Feb 17 19:52:42 vinco kernel: [ 2471.336059] Call Trace:
Feb 17 19:52:42 vinco kernel: [ 2471.336061]  <IRQ>
Feb 17 19:52:42 vinco kernel: [ 2471.336067]  ? pfifo_fast_enqueue+0x150/=
0x150
Feb 17 19:52:42 vinco kernel: [ 2471.336070]  call_timer_fn+0x2d/0x130
Feb 17 19:52:42 vinco kernel: [ 2471.336073]  __run_timers.part.0+0x16f/0=
x260
Feb 17 19:52:42 vinco kernel: [ 2471.336079]  ? tick_sched_handle+0x22/0x=
60
Feb 17 19:52:42 vinco kernel: [ 2471.336082]  ? tick_sched_timer+0x38/0x8=
0
Feb 17 19:52:42 vinco kernel: [ 2471.336084]  ? tick_sched_do_timer+0x60/=
0x60
Feb 17 19:52:42 vinco kernel: [ 2471.336087]  run_timer_softirq+0x26/0x50=

Feb 17 19:52:42 vinco kernel: [ 2471.336091]  __do_softirq+0xe6/0x2e9
Feb 17 19:52:42 vinco kernel: [ 2471.336099]  irq_exit+0xa6/0xb0
Feb 17 19:52:42 vinco kernel: [ 2471.336101]  smp_apic_timer_interrupt+0x=
76/0x130
Feb 17 19:52:42 vinco kernel: [ 2471.336104]  apic_timer_interrupt+0xf/0x=
20
Feb 17 19:52:42 vinco kernel: [ 2471.336105]  </IRQ>
Feb 17 19:52:42 vinco kernel: [ 2471.336110] RIP: 0010:cpuidle_enter_stat=
e+0xc4/0x450
Feb 17 19:52:42 vinco kernel: [ 2471.336112] Code: e8 b1 54 ad ff 80 7c 2=
4 0f 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 61 03 00 00 31 ff e8 a3=
 74 b3 ff fb 66 0f 1f 44 00 00 <45> 85 e4 0f 88 8c 02 00 00 49 63 cc 4c 2=
b 6c 24 10 48 8d 04 49 48
Feb 17 19:52:42 vinco kernel: [ 2471.336113] RSP: 0018:ffffa4d4c00c7e68 E=
FLAGS: 00000246 ORIG_RAX: ffffffffffffff13
Feb 17 19:52:42 vinco kernel: [ 2471.336115] RAX: ffff93ebdedaa6c0 RBX: f=
fffffffb88b92e0 RCX: 000000000000001f
Feb 17 19:52:42 vinco kernel: [ 2471.336116] RDX: 0000000000000000 RSI: 0=
000000033518adf RDI: 0000000000000000
Feb 17 19:52:42 vinco kernel: [ 2471.336117] RBP: ffff93ebdedb4a00 R08: 0=
000023f671841db R09: 0000000000029fc0
Feb 17 19:52:42 vinco kernel: [ 2471.336118] R10: 0000000000000000 R11: f=
fff93ebdeda9580 R12: 0000000000000005
Feb 17 19:52:42 vinco kernel: [ 2471.336119] R13: 0000023f671841db R14: 0=
000000000000005 R15: ffff93ebdcaa8000
Feb 17 19:52:42 vinco kernel: [ 2471.336122]  ? cpuidle_enter_state+0x9f/=
0x450
Feb 17 19:52:42 vinco kernel: [ 2471.336125]  cpuidle_enter+0x29/0x40
Feb 17 19:52:42 vinco kernel: [ 2471.336129]  do_idle+0x1dc/0x270
Feb 17 19:52:42 vinco kernel: [ 2471.336133]  cpu_startup_entry+0x19/0x20=

Feb 17 19:52:42 vinco kernel: [ 2471.336137]  start_secondary+0x15f/0x1b0=

Feb 17 19:52:42 vinco kernel: [ 2471.336141]  secondary_startup_64+0xa4/0=
xb0
Feb 17 19:52:42 vinco kernel: [ 2471.336144] ---[ end trace adaeebe166829=
bfb ]---

--------------6B4E476C6BC68787477D6DB6--
