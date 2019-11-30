Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3BD10DE5E
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 18:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfK3RF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 12:05:28 -0500
Received: from li321-167.members.linode.com ([66.228.40.167]:38714 "EHLO
        mymail.doitnext.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbfK3RF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 12:05:27 -0500
Received: from [192.168.0.98] (c-24-18-104-42.hsd1.wa.comcast.net [24.18.104.42])
        by mymail.doitnext.com (Postfix) with ESMTPSA id F3B6A43460
        for <netdev@vger.kernel.org>; Sat, 30 Nov 2019 17:05:23 +0000 (UTC)
Subject: iwlwifi driver crash on boot Ubuntu 18.04LTS
From:   Steve Owens <steve@doitnext.com>
To:     netdev@vger.kernel.org
References: <S1726924AbfK3QhZ/20191130163725Z+195@vger.kernel.org>
 <5540a8a1-4fe6-6688-2c61-21b30c1e00e5@doitnext.com>
Message-ID: <f2595cda-ed1f-4dc3-202c-2f733f18c874@doitnext.com>
Date:   Sat, 30 Nov 2019 09:05:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <5540a8a1-4fe6-6688-2c61-21b30c1e00e5@doitnext.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

|
|
> |Greetings, |
>
> |I have been trying to figure out how to get my internal wifi working 
> on a relatively new Costco HP Pavillion.  I have installed the iwlwifi 
> drivers but they seem to crash and I am stuck.|
>
> |I will provide the relevant parts of the boot log in the hopes that 
> someone more knowledgable may have a clue on how to proceed.|
>
> |I have tried following the directions on 
> ||https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/debugging|
>
> |But I get stuck at the part where it says: |
>
> |First you'll need to allow DEV_COREDUMP by setting 
> CONFIG_ALLOW_DEV_COREDUMP to Y. Then, you'll need to create a core 
> dump. This can be done by: |
>
> |echo 1 > /sys/kernel/debug/iwlwifi/0000\:0X\:00.0/iwlmvm/fw_dbg_collect|
>
> |When I run that command I get:|
>
> |root@steve-HP-Pavilion-Laptop-15-cs3xxx:~# echo 1 > 
> /sys/kernel/debug/iwlwifi/0000\:0X\:00.0/iwlmvm/fw_dbg_collect -bash: 
> /sys/kernel/debug/iwlwifi/0000:0X:00.0/iwlmvm/fw_dbg_collect: No such 
> file or directory|
>
> |If I search the path I can see:|
>
> |root@steve-HP-Pavilion-Laptop-15-cs3xxx:~# ls 
> /sys/kernel/debug/iwlwifi 0000:00:14.3|
>
> |root@steve-HP-Pavilion-Laptop-15-cs3xxx:~# ls 
> /sys/kernel/debug/iwlwifi/0000\:00\:14.3/ trans|
>
> |root@steve-HP-Pavilion-Laptop-15-cs3xxx:~# ls 
> /sys/kernel/debug/iwlwifi/0000\:00\:14.3/trans/ csr fh_reg interrupt 
> monitor_data rfkill rx_queue tx_queue |
>
> | So the instructions don't match my system.|
>
> ||
>
> |Here is the boot log extract. |
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x0000000000000000-0x000000000009efff] usable|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x000000000009f000-0x00000000000fffff] reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x0000000000100000-0x0000000033969fff] usable|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x000000003396a000-0x000000003396afff] ACPI NVS|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x000000003396b000-0x00000000339c0fff] usable|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x00000000339c1000-0x00000000339c1fff] reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x00000000339c2000-0x0000000042a2efff] usable|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x0000000042a2f000-0x0000000042dfefff] type 20|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x0000000042dff000-0x000000004518efff] reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x000000004518f000-0x0000000045f7efff] ACPI NVS|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x0000000045f7f000-0x0000000045ffefff] ACPI data|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x0000000045fff000-0x0000000045ffffff] usable|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x0000000046000000-0x0000000049ffffff] reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x000000004a200000-0x000000004a3fffff] reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x000000004b000000-0x00000000cfffffff] reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x00000000fc800000-0x00000000fe7fffff] reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x00000000fec00000-0x00000000fec00fff] reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x00000000fed00000-0x00000000fed00fff] reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x00000000fed10000-0x00000000fed17fff] reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x00000000fed20000-0x00000000fed7ffff] reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x00000000feda0000-0x00000000feda1fff] reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x00000000fee00000-0x00000000fee00fff] reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x00000000ff400000-0x00000000ffffffff] reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BIOS-e820: 
> [mem 0x0000000100000000-0x00000004afbfffff] usable|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: NX 
> (Execute Disable) protection: active|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: efi: EFI 
> v2.70 by INSYDE Corp.|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: efi: 
> ACPI=0x45ffe000 ACPI 2.0=0x45ffe014 ESRT=0x44394d18 SMBIOS=0x43d71000 
> SMBIOS 3.0=0x43d6f000 MEMATTR=0x31b67018 |
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: SMBIOS 
> 3.2.0 present.|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: DMI: HP HP 
> Pavilion Laptop 15-cs3xxx/86E2, BIOS F.03 08/23/2019|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: tsc: 
> Detected 1500.000 MHz processor|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: tsc: 
> Detected 1497.600 MHz TSC|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: e820: 
> update [mem 0x00000000-0x00000fff] usable ==> reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: e820: 
> remove [mem 0x000a0000-0x000fffff] usable|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: last_pfn = 
> 0x4afc00 max_arch_pfn = 0x400000000|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: MTRR 
> default type: write-back|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: MTRR fixed 
> ranges enabled:|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> 00000-9FFFF write-back|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> A0000-BFFFF uncachable|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> C0000-FFFFF write-protect|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: MTRR 
> variable ranges enabled:|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 0 base 
> 0080000000 mask 7F80000000 uncachable|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 1 base 
> 0060000000 mask 7FE0000000 uncachable|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 2 base 
> 0050000000 mask 7FF0000000 uncachable|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 3 base 
> 004C000000 mask 7FFC000000 uncachable|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 4 base 
> 004B000000 mask 7FFF000000 uncachable|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 5 base 
> 2000000000 mask 6000000000 uncachable|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 6 base 
> 1000000000 mask 7000000000 uncachable|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 7 base 
> 0800000000 mask 7800000000 uncachable|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 8 base 
> 4000000000 mask 4000000000 uncachable|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 9 disabled|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: x86/PAT: 
> Configuration [0-7]: WB WC UC- UC WB WP UC- WT |
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: last_pfn = 
> 0x46000 max_arch_pfn = 0x400000000|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: esrt: 
> Reserving ESRT space from 0x0000000044394d18 to 0x0000000044394da0.|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: check: 
> Scanning 1 areas for low memory corruption|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Using GB 
> pages for direct mapping|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BRK 
> [0x3f9c01000, 0x3f9c01fff] PGTABLE|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BRK 
> [0x3f9c02000, 0x3f9c02fff] PGTABLE|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BRK 
> [0x3f9c03000, 0x3f9c03fff] PGTABLE|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BRK 
> [0x3f9c04000, 0x3f9c04fff] PGTABLE|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BRK 
> [0x3f9c05000, 0x3f9c05fff] PGTABLE|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BRK 
> [0x3f9c06000, 0x3f9c06fff] PGTABLE|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BRK 
> [0x3f9c07000, 0x3f9c07fff] PGTABLE|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BRK 
> [0x3f9c08000, 0x3f9c08fff] PGTABLE|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: BRK 
> [0x3f9c09000, 0x3f9c09fff] PGTABLE|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Secure 
> boot could not be determined|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: RAMDISK: 
> [mem 0x2e711000-0x30c59fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Early table checksum verification disabled|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: RSDP 
> 0x0000000045FFE014 000024 (v02 HPQOEM)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: XSDT 
> 0x0000000045FD6188 000124 (v01 HPQOEM SLIC-MPC 00000002 HP 01000013)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: FACP 
> 0x0000000045FD8000 00010C (v05 HPQOEM SLIC-MPC 00000002 HP 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: DSDT 
> 0x0000000045F9F000 0344BC (v02 HPQOEM 86E2 00000002 ACPI 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: FACS 
> 0x0000000045F0E000 000040|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: UEFI 
> 0x0000000045F7E000 000236 (v01 HPQOEM 86E2 00000001 HP 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0x0000000045FF9000 003E0A (v02 HPQOEM 86E2 00001000 ACPI 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0x0000000045FF7000 001B60 (v02 HPQOEM 86E2 00003000 ACPI 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0x0000000045FF3000 003389 (v02 HPQOEM 86E2 00003000 ACPI 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0x0000000045FEC000 0066CE (v02 HPQOEM 86E2 00001000 ACPI 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0x0000000045FEB000 000781 (v01 HPQOEM 86E2 00001000 ACPI 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: TPM2 
> 0x0000000045FEA000 000034 (v04 HPQOEM 86E2 00000002 HP 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0x0000000045FE9000 0001C7 (v01 HPQOEM 86E2 00001000 ACPI 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0x0000000045FE2000 006C05 (v01 HPQOEM 86E2 00001000 ACPI 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: MSDM 
> 0x0000000045FE1000 000055 (v03 HPQOEM SLIC-MPC 00000001 HP 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: LPIT 
> 0x0000000045FE0000 000094 (v01 HPQOEM 86E2 00000002 HP 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: WSMT 
> 0x0000000045FDF000 000028 (v01 HPQOEM 86E2 00000002 HP 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0x0000000045FDE000 000B70 (v02 HPQOEM 86E2 00001000 ACPI 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: DBGP 
> 0x0000000045FDD000 000034 (v01 HPQOEM SLIC-MPC 00000002 HP 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: DBG2 
> 0x0000000045FDC000 000054 (v00 HPQOEM 86E2 00000002 HP 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0x0000000045FDB000 0007EA (v02 HPQOEM 86E2 00001000 ACPI 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: NHLT 
> 0x0000000045FDA000 00002D (v00 HPQOEM 86E2 00000002 HP 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: ECDT 
> 0x0000000045FD9000 000069 (v01 HPQOEM 86E2 00000002 HP 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: HPET 
> 0x0000000045FD7000 000038 (v01 HPQOEM 86E2 00000002 HP 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: APIC 
> 0x0000000045FFD000 00012C (v03 HPQOEM 86E2 00000002 HP 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: MCFG 
> 0x0000000045FD5000 00003C (v01 HPQOEM 86E2 00000002 HP 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0x0000000045F9E000 0000F5 (v01 HPQOEM 86E2 00000002 ACPI 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: DMAR 
> 0x0000000045F9D000 0000A8 (v01 HPQOEM 86E2 00000002 HP 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0x0000000045F99000 003325 (v01 HPQOEM 86E2 00001000 ACPI 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0x0000000045F98000 00095F (v02 HPQOEM 86E2 00001000 ACPI 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0x0000000045F97000 000164 (v01 HPQOEM 86E2 00001000 ACPI 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0x0000000045F96000 00005C (v02 HPQOEM 86E2 00001000 ACPI 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: UEFI 
> 0x0000000045738000 00063A (v01 HPQOEM 86E2 00000000 HP 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: UEFI 
> 0x0000000045737000 00005C (v01 HPQOEM 86E2 00000000 HP 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: FPDT 
> 0x0000000045F95000 000044 (v01 HPQOEM SLIC-MPC 00000002 HP 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: BGRT 
> 0x0000000045F94000 000038 (v01 HPQOEM 86E2 00000001 HP 00040000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Local APIC address 0xfee00000|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: No NUMA 
> configuration found|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Faking a 
> node at [mem 0x0000000000000000-0x00000004afbfffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> NODE_DATA(0) allocated [mem 0x4afbd5000-0x4afbfffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Zone ranges:|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: DMA [mem 
> 0x0000000000001000-0x0000000000ffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: DMA32 [mem 
> 0x0000000001000000-0x00000000ffffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Normal 
> [mem 0x0000000100000000-0x00000004afbfffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Device empty|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Movable 
> zone start for each node|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Early 
> memory node ranges|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: node 0: 
> [mem 0x0000000000001000-0x000000000009efff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: node 0: 
> [mem 0x0000000000100000-0x0000000033969fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: node 0: 
> [mem 0x000000003396b000-0x00000000339c0fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: node 0: 
> [mem 0x00000000339c2000-0x0000000042a2efff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: node 0: 
> [mem 0x0000000045fff000-0x0000000045ffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: node 0: 
> [mem 0x0000000100000000-0x00000004afbfffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Zeroed 
> struct page in unavailable ranges: 22068 pages|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Initmem 
> setup node 0 [mem 0x0000000000001000-0x00000004afbfffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: On node 0 
> totalpages: 4138444|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: DMA zone: 
> 64 pages used for memmap|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: DMA zone: 
> 22 pages reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: DMA zone: 
> 3998 pages, LIFO batch:0|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: DMA32 
> zone: 4201 pages used for memmap|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: DMA32 
> zone: 268846 pages, LIFO batch:63|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Normal 
> zone: 60400 pages used for memmap|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Normal 
> zone: 3865600 pages, LIFO batch:63|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Reserving 
> Intel graphics memory at [mem 0x4c800000-0x503fffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> PM-Timer IO Port: 0x1808|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Local APIC address 0xfee00000|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> LAPIC_NMI (acpi_id[0x09] high edge lint[0x1])|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> LAPIC_NMI (acpi_id[0x0a] high edge lint[0x1])|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> LAPIC_NMI (acpi_id[0x0b] high edge lint[0x1])|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> LAPIC_NMI (acpi_id[0x0c] high edge lint[0x1])|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> LAPIC_NMI (acpi_id[0x0d] high edge lint[0x1])|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> LAPIC_NMI (acpi_id[0x0e] high edge lint[0x1])|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> LAPIC_NMI (acpi_id[0x0f] high edge lint[0x1])|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> LAPIC_NMI (acpi_id[0x10] high edge lint[0x1])|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: IOAPIC[0]: 
> apic_id 2, version 32, address 0xfec00000, GSI 0-119|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: IRQ0 
> used by override.|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: IRQ9 
> used by override.|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Using ACPI 
> (MADT) for SMP configuration information|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: HPET 
> id: 0x8086a201 base: 0xfed00000|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: smpboot: 
> Allowing 8 CPUs, 0 hotplug CPUs|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0x00000000-0x00000fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0x0009f000-0x000fffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0x3396a000-0x3396afff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0x339c1000-0x339c1fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0x42a2f000-0x42dfefff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0x42dff000-0x4518efff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0x4518f000-0x45f7efff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0x45f7f000-0x45ffefff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0x46000000-0x49ffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0x4a000000-0x4a1fffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0x4a200000-0x4a3fffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0x4a400000-0x4affffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0x4b000000-0xcfffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0xd0000000-0xfc7fffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0xfc800000-0xfe7fffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0xfe800000-0xfebfffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0xfec00000-0xfec00fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0xfec01000-0xfecfffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0xfed00000-0xfed00fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0xfed01000-0xfed0ffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0xfed10000-0xfed17fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0xfed18000-0xfed1ffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0xfed20000-0xfed7ffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0xfed80000-0xfed9ffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0xfeda0000-0xfeda1fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0xfeda2000-0xfedfffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0xfee00000-0xfee00fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0xfee01000-0xff3fffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registered nosave memory: [mem 0xff400000-0xffffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: [mem 
> 0xd0000000-0xfc7fffff] available for PCI devices|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Booting 
> paravirtualized kernel on bare hardware|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, 
> max_idle_ns: 7645519600211568 ns|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> setup_percpu: NR_CPUS:8192 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: percpu: 
> Embedded 55 pages/cpu s188416 r8192 d28672 u262144|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> pcpu-alloc: s188416 r8192 d28672 u262144 alloc=1*2097152|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> pcpu-alloc: [0] 0 1 2 3 4 5 6 7 |
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Built 1 
> zonelists, mobility grouping on. Total pages: 4073757|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Policy 
> zone: Normal|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Kernel 
> command line: BOOT_IMAGE=/boot/vmlinuz-5.2.0-050200rc3-generic 
> root=UUID=7cf0f262-1dbc-4f7b-85ac-bbc39b6e7fa9 ro nouveau.modeset=0 
> nomodes|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: You have 
> booted with nomodeset. This means your GPU drivers are DISABLED|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Any video 
> related functionality will be severely degraded, and you may not even 
> be able to suspend the system properly|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Unless you 
> actually understand what nomodeset does, you should reboot without 
> enabling it|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Calgary: 
> detecting Calgary via BIOS EBDA area|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Calgary: 
> Unable to locate Rio Grande table in EBDA - bailing!|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Memory: 
> 16118704K/16553776K available (14339K kernel code, 2360K rwdata, 4512K 
> rodata, 2624K init, 5128K bss, 435072K reserved, 0K cma-reserved)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: SLUB: 
> HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ftrace: 
> allocating 42364 entries in 166 pages|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: rcu: 
> Hierarchical RCU implementation.|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: rcu: RCU 
> restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=8.|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Tasks RCU 
> enabled.|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: rcu: RCU 
> calculated value of scheduler-enlistment delay is 25 jiffies.|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: rcu: 
> Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: NR_IRQS: 
> 524544, nr_irqs: 2048, preallocated irqs: 16|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: random: 
> crng done (trusting CPU's manufacturer)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Console: 
> colour dummy device 80x25|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: printk: 
> console [tty0] enabled|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: Core 
> revision 20190509|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, 
> max_idle_ns: 99544814920 ns|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: hpet 
> clockevent registered|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: APIC: 
> Switch to symmetric I/O mode setup|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: DMAR: Host 
> address width 39|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: DMAR: DRHD 
> base: 0x000000fed90000 flags: 0x0|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: DMAR: 
> dmar0: reg_base_addr fed90000 ver 4:0 cap 1c0000c40660462 ecap 
> 49e2ff0505e|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: DMAR: DRHD 
> base: 0x000000fed91000 flags: 0x1|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: DMAR: 
> dmar1: reg_base_addr fed91000 ver 1:0 cap d2008c40660462 ecap f050da|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: DMAR: RMRR 
> base: 0x00000045041000 end: 0x00000045060fff|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: DMAR: RMRR 
> base: 0x0000004c000000 end: 0x000000503fffff|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: DMAR-IR: 
> IOAPIC id 2 under DRHD base 0xfed91000 IOMMU 1|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: DMAR-IR: 
> HPET id 0 under DRHD base 0xfed91000|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: DMAR-IR: 
> x2apic is disabled because BIOS sets x2apic opt out bit.|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: DMAR-IR: 
> Use 'intremap=no_x2apic_optout' to override the BIOS setting.|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: DMAR-IR: 
> Enabled IRQ remapping in xapic mode|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: x2apic: 
> IRQ remapping doesn't support X2APIC mode|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ..TIMER: 
> vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 
> 0x159647815e3, max_idle_ns: 440795269835 ns|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> Calibrating delay loop (skipped), value calculated using timer 
> frequency.. 2995.20 BogoMIPS (lpj=5990400)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pid_max: 
> default: 32768 minimum: 301|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: LSM: 
> Security Framework initializing|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Yama: 
> becoming mindful.|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: AppArmor: 
> AppArmor initialized|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Dentry 
> cache hash table entries: 2097152 (order: 12, 16777216 bytes)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: *** 
> VALIDATE proc ***|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: *** 
> VALIDATE cgroup1 ***|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: *** 
> VALIDATE cgroup2 ***|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: x86/cpu: 
> User Mode Instruction Prevention (UMIP) activated|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: mce: CPU0: 
> Thermal monitoring enabled (TM1)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: process: 
> using mwait in idle threads|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Last level 
> iTLB entries: 4KB 0, 2MB 0, 4MB 0|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Last level 
> dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Spectre V2 
> : Mitigation: Enhanced IBRS|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Spectre V2 
> : Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Spectre V2 
> : mitigation: Enabling conditional Indirect Branch Prediction Barrier|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> Speculative Store Bypass: Mitigation: Speculative Store Bypass 
> disabled via prctl and seccomp|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Freeing 
> SMP alternatives memory: 36K|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: TSC 
> deadline timer enabled|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: smpboot: 
> CPU0: Intel(R) Core(TM) i7-1065G7 CPU @ 1.30GHz (family: 0x6, model: 
> 0x7e, stepping: 0x5)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> Performance Events: PEBS fmt4+-baseline, Icelake events, 32-deep LBR, 
> full-width counters, Intel PMU driver.|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ... 
> version: 5|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ... bit 
> width: 48|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ... 
> generic registers: 8|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ... value 
> mask: 0000ffffffffffff|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ... max 
> period: 00007fffffffffff|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ... 
> fixed-purpose events: 4|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ... event 
> mask: 0000000f000000ff|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: rcu: 
> Hierarchical SRCU implementation.|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: NMI 
> watchdog: Enabled. Permanently consumes one hw-PMU counter.|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: smp: 
> Bringing up secondary CPUs ...|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: x86: 
> Booting SMP configuration:|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: .... node 
> #0, CPUs: #1 #2 #3 #4 #5 #6 #7|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: smp: 
> Brought up 1 node, 8 CPUs|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: smpboot: 
> Max logical packages: 1|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: smpboot: 
> Total of 8 processors activated (23961.60 BogoMIPS)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: devtmpfs: 
> initialized|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: x86/mm: 
> Memory block size: 128MB|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registering ACPI NVS region [mem 0x3396a000-0x3396afff] (4096 bytes)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: 
> Registering ACPI NVS region [mem 0x4518f000-0x45f7efff] (14614528 bytes)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, 
> max_idle_ns: 7645041785100000 ns|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: futex hash 
> table entries: 2048 (order: 5, 131072 bytes)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pinctrl 
> core: initialized pinctrl subsystem|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PM: RTC 
> time: 14:53:35, date: 2019-11-30|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: NET: 
> Registered protocol family 16|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: audit: 
> initializing netlink subsys (disabled)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: audit: 
> type=2000 audit(1575125615.048:1): state=initialized audit_enabled=0 
> res=1|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: EISA bus 
> registered|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: cpuidle: 
> using governor ladder|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: cpuidle: 
> using governor menu|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI FADT 
> declares the system doesn't support PCIe ASPM, so disable it|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: bus 
> type PCI registered|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: acpiphp: 
> ACPI Hot Plug PCI Controller Driver version: 0.5|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PCI: 
> MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] 
> (base 0xc0000000)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PCI: 
> MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PCI: Using 
> configuration type 1 for base access|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> ENERGY_PERF_BIAS: Set to 'normal', was 'performance'|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: HugeTLB 
> registered 1.00 GiB page size, pre-allocated 0 pages|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: HugeTLB 
> registered 2.00 MiB page size, pre-allocated 0 pages|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Added _OSI(Module Device)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Added _OSI(Processor Device)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Added _OSI(3.0 _SCP Extensions)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Added _OSI(Processor Aggregator Device)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Added _OSI(Linux-Dell-Video)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Added _OSI(Linux-Lenovo-NV-HDMI-Audio)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Added _OSI(Linux-HPI-Hybrid-Graphics)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 15 
> ACPI AML tables successfully acquired and loaded|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: EC: 
> EC started|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: EC: 
> interrupt blocked|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: \: 
> Used as first EC|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: \: 
> GPE=0x6e, EC_CMD/EC_SC=0x66, EC_DATA=0x62|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: EC: 
> Boot ECDT EC used to handle transactions|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Dynamic OEM Table Load:|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0xFFFF9B305D37E400 0000F4 (v02 PmRef Cpu0Psd 00003000 INTL 20160422)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> \_SB_.PR00: _OSC native thermal LVT Acked|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Dynamic OEM Table Load:|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0xFFFF9B305D389400 000386 (v02 PmRef Cpu0Cst 00003001 INTL 20160422)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Dynamic OEM Table Load:|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0xFFFF9B305D2E7800 000437 (v02 PmRef Cpu0Ist 00003000 INTL 20160422)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Dynamic OEM Table Load:|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0xFFFF9B305D327000 00012C (v02 PmRef Cpu0Hwp 00003000 INTL 20160422)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Dynamic OEM Table Load:|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0xFFFF9B305D2E2000 000724 (v02 PmRef HwpLvt 00003000 INTL 20160422)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Dynamic OEM Table Load:|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0xFFFF9B305D2E4000 0005FC (v02 PmRef ApIst 00003000 INTL 20160422)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Dynamic OEM Table Load:|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0xFFFF9B305D38BC00 000317 (v02 PmRef ApHwp 00003000 INTL 20160422)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Dynamic OEM Table Load:|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0xFFFF9B305F556000 000AB0 (v02 PmRef ApPsd 00003000 INTL 20160422)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Dynamic OEM Table Load:|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: SSDT 
> 0xFFFF9B305D389000 00030A (v02 PmRef ApCst 00003000 INTL 20160422)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Interpreter enabled|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> (supports S0 S3 S4 S5)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Using IOAPIC for interrupt routing|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PCI: Using 
> host bridge windows from ACPI; if necessary, use "pci=nocrs" and 
> report a bug|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Enabled 10 GPEs in block 00 to 7F|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Power Resource [PC01] (on)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Power Resource [V0PR] (on)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Power Resource [V1PR] (on)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Power Resource [V2PR] (on)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Power Resource [WRST] (on)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: acpi 
> ABCD0000:00: ACPI dock station (docks/bays count: 1)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Power Resource [TBT0] (on)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Power Resource [TBT1] (on)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Power Resource [D3C] (on)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI BIOS 
> Error (bug): Could not resolve symbol [\_SB.IPPF._STA.POS1], 
> AE_NOT_FOUND (20190509/psargs-330)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: No Local 
> Variables are initialized for Method [_STA]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: No 
> Arguments are initialized for method [_STA]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI 
> Error: Aborting method \_SB.IPPF._STA due to previous error 
> (AE_NOT_FOUND) (20190509/psparse-531)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> Power Resource [PIN] (off)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: PCI 
> Root Bridge [PCI0] (domain 0000 [bus 00-fe])|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: acpi 
> PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments 
> MSI HPX-Type3]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: acpi 
> PNP0A08:00: _OSC: platform does not support [AER]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: acpi 
> PNP0A08:00: _OSC: OS now controls [PCIeHotplug SHPCHotplug PME 
> PCIeCapability LTR]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: acpi 
> PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PCI host 
> bridge to bus 0000:00|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:00: root bus resource [io 0x0000-0x0cf7 window]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:00: root bus resource [io 0x0d00-0xffff window]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:00: root bus resource [mem 0x50400000-0xbfffffff window]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:00: root bus resource [mem 0x4000000000-0x7fffffffff window]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:00: root bus resource [bus 00-fe]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:00.0: [8086:8a12] type 00 class 0x060000|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:02.0: [8086:8a52] type 00 class 0x030000|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:02.0: reg 0x10: [mem 0x6015000000-0x6015ffffff 64bit]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:02.0: reg 0x18: [mem 0x4000000000-0x400fffffff 64bit pref]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:02.0: reg 0x20: [io 0x7000-0x703f]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:02.0: BAR 2: assigned to efifb|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:04.0: [8086:8a03] type 00 class 0x118000|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:04.0: reg 0x10: [mem 0x6016100000-0x601610ffff 64bit]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:14.0: [8086:34ed] type 00 class 0x0c0330|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:14.0: reg 0x10: [mem 0x55000000-0x5500ffff 64bit]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:14.0: PME# supported from D3hot D3cold|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:14.2: [8086:34ef] type 00 class 0x050000|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:14.2: reg 0x10: [mem 0x6016118000-0x6016119fff 64bit]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:14.2: reg 0x18: [mem 0x6016120000-0x6016120fff 64bit]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:14.3: [8086:34f0] type 00 class 0x028000|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:14.3: reg 0x10: [mem 0x6016114000-0x6016117fff 64bit]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:14.3: PME# supported from D0 D3hot D3cold|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:15.0: [8086:34e8] type 00 class 0x0c8000|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:15.0: reg 0x10: [mem 0x00000000-0x00000fff 64bit]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:15.1: [8086:34e9] type 00 class 0x0c8000|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:15.1: reg 0x10: [mem 0x00000000-0x00000fff 64bit]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:16.0: [8086:34e0] type 00 class 0x078000|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:16.0: reg 0x10: [mem 0x601611d000-0x601611dfff 64bit]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:16.0: PME# supported from D3hot|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:17.0: [8086:282a] type 00 class 0x010400|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:17.0: reg 0x10: [mem 0x55010000-0x55011fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:17.0: reg 0x14: [mem 0x55014000-0x550140ff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:17.0: reg 0x18: [io 0x7080-0x7087]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:17.0: reg 0x1c: [io 0x7088-0x708b]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:17.0: reg 0x20: [io 0x7060-0x707f]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:17.0: reg 0x24: [mem 0x55013000-0x550137ff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:17.0: PME# supported from D3hot|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1c.0: [8086:34b8] type 01 class 0x060400|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1c.0: PME# supported from D0 D3hot D3cold|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1c.4: [8086:34bc] type 01 class 0x060400|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1c.4: PME# supported from D0 D3hot D3cold|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1c.4: PTM enabled (root), 4dns granularity|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1d.0: [8086:34b0] type 01 class 0x060400|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1d.0: PME# supported from D0 D3hot D3cold|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1d.1: [8086:34b1] type 01 class 0x060400|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1d.1: PME# supported from D0 D3hot D3cold|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1d.1: PTM enabled (root), 4dns granularity|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1e.0: [8086:34a8] type 00 class 0x078000|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1e.0: reg 0x10: [mem 0x00000000-0x00000fff 64bit]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1e.2: [8086:34aa] type 00 class 0x0c8000|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1e.2: reg 0x10: [mem 0x00000000-0x00000fff 64bit]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1f.0: [8086:3482] type 00 class 0x060100|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1f.3: [8086:34c8] type 00 class 0x040380|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1f.3: reg 0x10: [mem 0x6016110000-0x6016113fff 64bit]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1f.3: reg 0x20: [mem 0x6016000000-0x60160fffff 64bit]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1f.3: PME# supported from D3hot D3cold|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1f.4: [8086:34a3] type 00 class 0x0c0500|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1f.4: reg 0x10: [mem 0x601611a000-0x601611a0ff 64bit]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1f.4: reg 0x20: [io 0x7040-0x705f]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1f.5: [8086:34a4] type 00 class 0x0c8000|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1f.5: reg 0x10: [mem 0xfe010000-0xfe010fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1c.0: PCI bridge to [bus 01-05]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1c.0: bridge window [io 0x6000-0x6fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1c.0: bridge window [mem 0x54000000-0x54ffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1c.0: bridge window [mem 0x6012000000-0x6012ffffff 64bit pref]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:06:00.0: [10de:1d13] type 00 class 0x030200|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:06:00.0: reg 0x10: [mem 0x53000000-0x53ffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:06:00.0: reg 0x14: [mem 0x6000000000-0x600fffffff 64bit pref]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:06:00.0: reg 0x1c: [mem 0x6010000000-0x6011ffffff 64bit pref]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:06:00.0: reg 0x24: [io 0x5000-0x507f]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:06:00.0: reg 0x30: [mem 0xfff80000-0xffffffff pref]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1c.4: PCI bridge to [bus 06-0a]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1c.4: bridge window [io 0x5000-0x5fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1c.4: bridge window [mem 0x53000000-0x53ffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1c.4: bridge window [mem 0x6000000000-0x6011ffffff 64bit pref]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1d.0: PCI bridge to [bus 0b-0f]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1d.0: bridge window [io 0x4000-0x4fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1d.0: bridge window [mem 0x52000000-0x52ffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1d.0: bridge window [mem 0x6013000000-0x6013ffffff 64bit pref]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:10:00.0: [10ec:8168] type 00 class 0x020000|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:10:00.0: reg 0x10: [io 0x3000-0x30ff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:10:00.0: reg 0x18: [mem 0x51004000-0x51004fff 64bit]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:10:00.0: reg 0x20: [mem 0x51000000-0x51003fff 64bit]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:10:00.0: supports D1 D2|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:10:00.0: PME# supported from D0 D1 D2 D3hot D3cold|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1d.1: PCI bridge to [bus 10-14]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1d.1: bridge window [io 0x3000-0x3fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1d.1: bridge window [mem 0x51000000-0x51ffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1d.1: bridge window [mem 0x6014000000-0x6014ffffff 64bit pref]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI BIOS 
> Error (bug): Could not resolve symbol [\_SB.IPPF._STA.POS1], 
> AE_NOT_FOUND (20190509/psargs-330)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: No Local 
> Variables are initialized for Method [_STA]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: No 
> Arguments are initialized for method [_STA]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI 
> Error: Aborting method \_SB.IPPF._STA due to previous error 
> (AE_NOT_FOUND) (20190509/psparse-531)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: EC: 
> interrupt unblocked|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: EC: 
> event unblocked|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> \_SB_.PCI0.LPCB.EC0_: GPE=0x6e, EC_CMD/EC_SC=0x66, EC_DATA=0x62|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: 
> \_SB_.PCI0.LPCB.EC0_: Boot DSDT EC used to handle transactions and events|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:02.0: vgaarb: setting as boot VGA device|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:02.0: vgaarb: VGA device added: 
> decodes=io+mem,owns=io+mem,locks=none|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:02.0: vgaarb: bridge control possible|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: vgaarb: 
> loaded|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: SCSI 
> subsystem initialized|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: libata 
> version 3.00 loaded.|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI: bus 
> type USB registered|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: usbcore: 
> registered new interface driver usbfs|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: usbcore: 
> registered new interface driver hub|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: usbcore: 
> registered new device driver usb|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pps_core: 
> LinuxPPS API ver. 1 registered|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pps_core: 
> Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti 
> ||<giometti@linux.it>|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PTP clock 
> support registered|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: EDAC MC: 
> Ver: 3.0.0|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Registered 
> efivars operations|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PCI: Using 
> ACPI for IRQ routing|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PCI: 
> pci_cache_line_size set to 64 bytes|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1f.5: can't claim BAR 0 [mem 0xfe010000-0xfe010fff]: no 
> compatible bridge window|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: e820: 
> reserve RAM buffer [mem 0x0009f000-0x0009ffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: e820: 
> reserve RAM buffer [mem 0x3396a000-0x33ffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: e820: 
> reserve RAM buffer [mem 0x339c1000-0x33ffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: e820: 
> reserve RAM buffer [mem 0x42a2f000-0x43ffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: e820: 
> reserve RAM buffer [mem 0x46000000-0x47ffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: e820: 
> reserve RAM buffer [mem 0x4afc00000-0x4afffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: NetLabel: 
> Initializing|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: NetLabel: 
> domain hash size = 128|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: NetLabel: 
> protocols = UNLABELED CIPSOv4 CALIPSO|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: NetLabel: 
> unlabeled traffic allowed by default|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: hpet0: at 
> MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: hpet0: 8 
> comparators, 64-bit 19.200000 MHz counter|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> clocksource: Switched to clocksource tsc-early|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: VFS: Disk 
> quotas dquot_6.6.0|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: VFS: 
> Dquot-cache hash table entries: 512 (order 0, 4096 bytes)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: *** 
> VALIDATE hugetlbfs ***|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: AppArmor: 
> AppArmor Filesystem Enabled|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pnp: PnP 
> ACPI init|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:00: [io 0x0680-0x069f] has been reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:00: [io 0x164e-0x164f] has been reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pnp 00:01: 
> Plug and Play ACPI device, IDs HPQ8001 PNP0303 (active)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pnp 00:02: 
> Plug and Play ACPI device, IDs ETD074c SYN1e00 SYN0002 PNP0f13 (active)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:03: [mem 0xfed10000-0xfed17fff] has been reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:03: [mem 0xfeda0000-0xfeda0fff] has been reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:03: [mem 0xfeda1000-0xfeda1fff] has been reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:03: [mem 0xc0000000-0xcfffffff] has been reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:03: [mem 0xfed20000-0xfed7ffff] could not be reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:03: [mem 0xfed90000-0xfed93fff] could not be reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:03: [mem 0xfee00000-0xfeefffff] could not be reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:04: [io 0x1800-0x18fe] has been reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:04: [mem 0xfd000000-0xfd68ffff] has been reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:04: [mem 0xfd6b0000-0xfd6cffff] has been reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:04: [mem 0xfd6f0000-0xfdffffff] has been reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:04: [mem 0xfe000000-0xfe01ffff] has been reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:04: [mem 0xfe200000-0xfe7fffff] has been reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:04: [mem 0xff000000-0xffffffff] could not be reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:05: [io 0x2000-0x20fe] has been reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:06: [mem 0xfe038000-0xfe038fff] has been reserved|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: system 
> 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI BIOS 
> Error (bug): Could not resolve symbol [\_SB.IPPF._STA.POS1], 
> AE_NOT_FOUND (20190509/psargs-330)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: No Local 
> Variables are initialized for Method [_STA]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: No 
> Arguments are initialized for method [_STA]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: ACPI 
> Error: Aborting method \_SB.IPPF._STA due to previous error 
> (AE_NOT_FOUND) (20190509/psparse-531)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pnp: PnP 
> ACPI: found 7 devices|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, 
> max_idle_ns: 2085701024 ns|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:06:00.0: can't claim BAR 6 [mem 0xfff80000-0xffffffff pref]: no 
> compatible bridge window|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:15.0: BAR 0: assigned [mem 0x4010000000-0x4010000fff 64bit]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:15.1: BAR 0: assigned [mem 0x4010001000-0x4010001fff 64bit]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1e.0: BAR 0: assigned [mem 0x4010002000-0x4010002fff 64bit]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1e.2: BAR 0: assigned [mem 0x4010003000-0x4010003fff 64bit]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1f.5: BAR 0: no space for [mem size 0x00001000]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1f.5: BAR 0: trying firmware assignment [mem 
> 0xfe010000-0xfe010fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1f.5: BAR 0: [mem 0xfe010000-0xfe010fff] conflicts with 
> Reserved [mem 0xfc800000-0xfe7fffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1f.5: BAR 0: failed to assign [mem size 0x00001000]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1c.0: PCI bridge to [bus 01-05]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1c.0: bridge window [io 0x6000-0x6fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1c.0: bridge window [mem 0x54000000-0x54ffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1c.0: bridge window [mem 0x6012000000-0x6012ffffff 64bit pref]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:06:00.0: BAR 6: no space for [mem size 0x00080000 pref]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:06:00.0: BAR 6: failed to assign [mem size 0x00080000 pref]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1c.4: PCI bridge to [bus 06-0a]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1c.4: bridge window [io 0x5000-0x5fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1c.4: bridge window [mem 0x53000000-0x53ffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1c.4: bridge window [mem 0x6000000000-0x6011ffffff 64bit pref]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1d.0: PCI bridge to [bus 0b-0f]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1d.0: bridge window [io 0x4000-0x4fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1d.0: bridge window [mem 0x52000000-0x52ffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1d.0: bridge window [mem 0x6013000000-0x6013ffffff 64bit pref]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1d.1: PCI bridge to [bus 10-14]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1d.1: bridge window [io 0x3000-0x3fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1d.1: bridge window [mem 0x51000000-0x51ffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:1d.1: bridge window [mem 0x6014000000-0x6014ffffff 64bit pref]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:00: Some PCI device resources are unassigned, try booting with 
> pci=realloc|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:00: resource 4 [io 0x0000-0x0cf7 window]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:00: resource 5 [io 0x0d00-0xffff window]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:00: resource 7 [mem 0x50400000-0xbfffffff window]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:00: resource 8 [mem 0x4000000000-0x7fffffffff window]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:01: resource 0 [io 0x6000-0x6fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:01: resource 1 [mem 0x54000000-0x54ffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:01: resource 2 [mem 0x6012000000-0x6012ffffff 64bit pref]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:06: resource 0 [io 0x5000-0x5fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:06: resource 1 [mem 0x53000000-0x53ffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:06: resource 2 [mem 0x6000000000-0x6011ffffff 64bit pref]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:0b: resource 0 [io 0x4000-0x4fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:0b: resource 1 [mem 0x52000000-0x52ffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:0b: resource 2 [mem 0x6013000000-0x6013ffffff 64bit pref]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:10: resource 0 [io 0x3000-0x3fff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:10: resource 1 [mem 0x51000000-0x51ffffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci_bus 
> 0000:10: resource 2 [mem 0x6014000000-0x6014ffffff 64bit pref]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: NET: 
> Registered protocol family 2|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> tcp_listen_portaddr_hash hash table entries: 8192 (order: 5, 131072 
> bytes)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: TCP 
> established hash table entries: 131072 (order: 8, 1048576 bytes)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: TCP bind 
> hash table entries: 65536 (order: 8, 1048576 bytes)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: TCP: Hash 
> tables configured (established 131072 bind 65536)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: UDP hash 
> table entries: 8192 (order: 6, 262144 bytes)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: UDP-Lite 
> hash table entries: 8192 (order: 6, 262144 bytes)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: NET: 
> Registered protocol family 1|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: NET: 
> Registered protocol family 44|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: pci 
> 0000:00:02.0: Video device with shadowed ROM at [mem 
> 0x000c0000-0x000dffff]|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PCI: CLS 
> 64 bytes, default 64|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Trying to 
> unpack rootfs image as initramfs...|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Freeing 
> initrd memory: 38180K|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: PCI-DMA: 
> Using software bounce buffering for IO (SWIOTLB)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: software 
> IO TLB: mapped [mem 0x3e07d000-0x4207d000] (64MB)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x159647815e3, 
> max_idle_ns: 440795269835 ns|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> clocksource: Switched to clocksource tsc|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: platform 
> rtc_cmos: registered platform RTC device (no PNP device found)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: check: 
> Scanning for low memory corruption every 60 seconds|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Initialise 
> system trusted keyrings|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Key type 
> blacklist registered|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> workingset: timestamp_bits=36 max_order=22 bucket_order=0|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: zbud: loaded|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: squashfs: 
> version 4.0 (2009/01/31) Phillip Lougher|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: fuse: init 
> (API version 7.30)|
>
> |Nov 30 06:53:43 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Platform 
> Keyring initialized|
>
> |----cut ---|
>
> |--- continue ---|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: Intel(R) 
> Wireless WiFi driver for Linux|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: 
> Copyright(c) 2003- 2015 Intel Corporation|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: Found debug destination: EXTERNAL_DRAM|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: Found debug configuration: 0|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: loaded firmware version 48.13675109.0 op_mode iwlmvm|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: Detected Intel(R) Wi-Fi 6 AX101, REV=0x338|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: Applying debug destination EXTERNAL_DRAM|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: Allocated 0x00400000 bytes for firmware monitor.|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: Microcode SW error detected. Restarting 0x0.|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: Start IWL Error Log Dump:|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: Status: 0x00000000, count: 597370579|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: Loaded firmware version: 48.13675109.0|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x53F4EB5F | ADVANCED_SYSASSERT |
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x3B713A11 | trm_hw_status0|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x12C57890 | trm_hw_status1|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x4D8BD7C7 | branchlink2|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xDFF3D83F | interruptlink1|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x83840090 | interruptlink2|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x8660001B | data1|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x64D0D9B6 | data2|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xFD5F3FEB | data3|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x3806CA20 | beacon time|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x189A1D03 | tsf low|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x4F4FCEE3 | tsf hi|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xEF7B5EAE | time gp1|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x95001848 | time gp2|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x8184427A | uCode revision type|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xF94FFDE5 | uCode version major|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xE0FDEBEE | uCode version minor|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xC0FE0020 | hw version|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x888F8334 | board version|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x0098004C | hcmd|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xBB7BEB5B | isr0|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xB5FA85FD | isr1|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x4BB4C8F8 | isr2|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x8D19A283 | isr3|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x2675F53B | isr4|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xF15DF77E | last cmd Id|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x2A4E900D | wait_event|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xA90A0033 | l2p_control|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x0FD79BFF | l2p_duration|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xAFFDBEE7 | l2p_mhvalid|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x00725CC2 | l2p_addr_match|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x12475000 | lmpm_pmg_sel|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xDA5BEBC7 | timestamp|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x5E3B7B7E | flow_handler|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: Start IWL Error Log Dump:|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: Status: 0x00000000, count: 7|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x201013F1 | ADVANCED_SYSASSERT|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x00000000 | umac branchlink1|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xC008D49C | umac branchlink2|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x00000000 | umac interruptlink1|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x00000000 | umac interruptlink2|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x00000003 | umac data1|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x02000300 | umac data2|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x01300504 | umac data3|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x00000030 | umac major|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x13675109 | umac minor|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x000060A9 | frame pointer|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xC0887F58 | stack pointer|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x00000000 | last host cmd|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x00000000 | isr status reg|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: SecBoot CPU1 Status: 0x6010, CPU2 Status: 0x3|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: Failed to start RT ucode: -5|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: Collecting data: trigger 16 fired.|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: Firmware not running - cannot dump error|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: Failed to run INIT ucode: -5|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx ureadahead[352]: 
> ureadahead: Error while tracing: No such file or directory|
>
> |Nov 30 06:53:44 steve-HP-Pavilion-Laptop-15-cs3xxx systemd[1]: 
> Started Load/Save Random Seed.|
>
> |Nov 30 06:53:44 steve-HP-Pavilion-Laptop-15-cs3xxx 
> systemd-modules-load[350]: Inserted module 'iwlwifi'|
>
> |Nov 30 06:53:44 steve-HP-Pavilion-Laptop-15-cs3xxx systemd[1]: 
> Started Load Kernel Modules.|
>
> |Nov 30 06:53:44 steve-HP-Pavilion-Laptop-15-cs3xxx systemd[1]: 
> Starting Apply Kernel Variables...|
>
> |Nov 30 06:53:44 steve-HP-Pavilion-Laptop-15-cs3xxx systemd[1]: 
> Mounting FUSE Control File System...|
>
> |Nov 30 06:53:44 steve-HP-Pavilion-Laptop-15-cs3xxx systemd[1]: 
> Mounting Kernel Configuration File System...|
>
> |Nov 30 06:53:44 steve-HP-Pavilion-Laptop-15-cs3xxx systemd[1]: 
> Mounted FUSE Control File System.|
>
> |lines 860-913|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x3806CA20 | beacon time|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x189A1D03 | tsf low|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x4F4FCEE3 | tsf hi|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xEF7B5EAE | time gp1|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x95001848 | time gp2|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x8184427A | uCode revision type|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xF94FFDE5 | uCode version major|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xE0FDEBEE | uCode version minor|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xC0FE0020 | hw version|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x888F8334 | board version|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x0098004C | hcmd|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xBB7BEB5B | isr0|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xB5FA85FD | isr1|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x4BB4C8F8 | isr2|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x8D19A283 | isr3|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x2675F53B | isr4|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xF15DF77E | last cmd Id|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x2A4E900D | wait_event|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xA90A0033 | l2p_control|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x0FD79BFF | l2p_duration|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xAFFDBEE7 | l2p_mhvalid|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x00725CC2 | l2p_addr_match|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x12475000 | lmpm_pmg_sel|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xDA5BEBC7 | timestamp|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x5E3B7B7E | flow_handler|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: Start IWL Error Log Dump:|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: Status: 0x00000000, count: 7|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x201013F1 | ADVANCED_SYSASSERT|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x00000000 | umac branchlink1|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xC008D49C | umac branchlink2|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x00000000 | umac interruptlink1|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x00000000 | umac interruptlink2|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x00000003 | umac data1|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x02000300 | umac data2|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x01300504 | umac data3|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x00000030 | umac major|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x13675109 | umac minor|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x000060A9 | frame pointer|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0xC0887F58 | stack pointer|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x00000000 | last host cmd|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: 0x00000000 | isr status reg|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: SecBoot CPU1 Status: 0x6010, CPU2 Status: 0x3|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: Failed to start RT ucode: -5|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: Collecting data: trigger 16 fired.|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: Firmware not running - cannot dump error|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx kernel: iwlwifi 
> 0000:00:14.3: Failed to run INIT ucode: -5|
>
> |Nov 30 06:53:47 steve-HP-Pavilion-Laptop-15-cs3xxx ureadahead[352]: 
> ureadahead: Error while tracing: No such file or directory|
>
