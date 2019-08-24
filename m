Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF879BD7B
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 14:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbfHXMDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 08:03:51 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:38115 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbfHXMDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 08:03:51 -0400
Received: by mail-io1-f68.google.com with SMTP id p12so26422968iog.5
        for <netdev@vger.kernel.org>; Sat, 24 Aug 2019 05:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=V9KRnyPkfE21ELcw3mos84+9YDwvf37rBB3O1NIsji0=;
        b=qbV2+1MQikGhIz3PgIy2qEtdQ/tehC6dtY0H6Ndrla7p4F+FMF4uk/aGpj7/zdK9xB
         doWyTL880FaDzo3GiP3SIF05jc8mbUbM1fEFgI5AIIsSVuAnSaFqkM6rXieTGnW4p3EB
         W27+Q5G/FPQBd0if1Q6pyZxiTqbJIj7YBXt95EO90Fdv8NsrntNo1A669xbDeWTBQBos
         ARYc3qpm3J7NkebymbdPAb7Zm8ozY8wuJazHsYTXjJR1eAY2bG5kVbGcX4xZ9RmKzxQc
         /G0l2SufRCjrqOsj4H7YTr+nweNnPS4+TTJnqZyMAmc6kbD4JjEzqXEESq4zTMEj1UNL
         KxMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=V9KRnyPkfE21ELcw3mos84+9YDwvf37rBB3O1NIsji0=;
        b=BZH5RK5/JIVaTYgE37qO0FgawpRiH3WP8ovA8sqdb1Ploc+eInR5yZPv3GRbv7e1Vu
         H1Hgn54CluNJauY0Pu+9k3HKNVyFvTjd5duT6553y9Iqm57tGDaT4vD87PO5hVAVP37q
         AOSDNauKEWOe2fZ7nNdZO3e0PIhQw4FGpt5gnA1+tWc9TpDfAd89WoMndPgFkaW3X2dZ
         IMU0k2dT+TWejYQq5Ed6lJth8fT6BkkuFhSbDKf/5vKaYBtMWNLMNiOKPKo+xhwJi1wD
         WQ3QOD0AwMDt4/z7nN1liCzfJFpYIsi9D4sbVJGuHpVTvcshuVzILo2imD/dBfI1/qrD
         ZPXw==
X-Gm-Message-State: APjAAAW9PTsVlLPdsacmWCpxRzSFbBR3JaeXEnF7T1zDL+4xfM/ztyrN
        UW+VAZi/OEDGagMqsN0XsKqewTiG7+s=
X-Google-Smtp-Source: APXvYqzXM09i4fMwo7oZXiqyJQBWhtixPYMgNy9NQo+53PfhxMwWW5bLZOBAQ62/f2FeCAvM6O/pIw==
X-Received: by 2002:a5e:8344:: with SMTP id y4mr5809532iom.213.1566648229784;
        Sat, 24 Aug 2019 05:03:49 -0700 (PDT)
Received: from xps13.local.tld (cpe-67-255-90-149.maine.res.rr.com. [67.255.90.149])
        by smtp.gmail.com with ESMTPSA id h9sm5338926ior.9.2019.08.24.05.03.48
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 24 Aug 2019 05:03:49 -0700 (PDT)
Date:   Sat, 24 Aug 2019 08:03:45 -0400
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 204669] New: TLS: module crash with TLS record double free
Message-ID: <20190824080345.042cc7b4@xps13.local.tld>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This may have already been fixed, but forwarding to check.

Begin forwarded message:

Date: Thu, 22 Aug 2019 12:34:10 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 204669] New: TLS: module crash with TLS record double free


https://bugzilla.kernel.org/show_bug.cgi?id=204669

            Bug ID: 204669
           Summary: TLS: module crash with TLS record double free
           Product: Networking
           Version: 2.5
    Kernel Version: v5.3-rc4
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: mallesh537@gmail.com
        Regression: No

Created attachment 284565
  --> https://bugzilla.kernel.org/attachment.cgi?id=284565&action=edit  
tls crash log

TLS module is crashing While running SSL record encryption using
Klts_send_[file] 

Precondition:
1) Installed 5.3-rc4.
2) Nitrox5 card pluggin.


Steps to produce the issue:
1) Install n5pf.ko.(drivers/crypto/cavium/nitrox)
2) Install tls.ko if not is installed by default(net/tls)
3) Taken uperf tool from git.
   3.1) Modified uperf to use tls module by using setsocket.
   3.2) Modified uperf tool to support sendfile with SSL.


Test:
1) Running uperf with 4threads.
2) Each Thread send the data using sendfile over SSL protocol.


After few seconds kernel is crashing because of record list corruption


[  270.888952] ------------[ cut here ]------------
[  270.890450] list_del corruption, ffff91cc3753a800->prev is LIST_POISON2
(dead000000000122)
[  270.891194] WARNING: CPU: 1 PID: 7387 at lib/list_debug.c:50
__list_del_entry_valid+0x62/0x90
[  270.892037] Modules linked in: n5pf(OE) netconsole tls(OE) bonding
intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp
coretemp kvm_intel kvm iTCO_wdt iTCO_vendor_support irqbypass crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel aesni_intel crypto_simd mei_me cryptd
glue_helper ipmi_si sg mei lpc_ich pcspkr joydev ioatdma i2c_i801 ipmi_devintf
ipmi_msghandler wmi ip_tables xfs libcrc32c sd_mod mgag200 drm_vram_helper ttm
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm isci libsas
ahci scsi_transport_sas libahci crc32c_intel serio_raw igb libata ptp pps_core
dca i2c_algo_bit dm_mirror dm_region_hash dm_log dm_mod [last unloaded:
nitrox_drv]
[  270.896836] CPU: 1 PID: 7387 Comm: uperf Kdump: loaded Tainted: G          
OE     5.3.0-rc4 #1
[  270.897711] Hardware name: Supermicro SYS-1027R-N3RF/X9DRW, BIOS 3.0c
03/24/2014
[  270.898597] RIP: 0010:__list_del_entry_valid+0x62/0x90
[  270.899478] Code: 00 00 00 c3 48 89 fe 48 89 c2 48 c7 c7 e0 f9 ee 8d e8 b2
cf c8 ff 0f 0b 31 c0 c3 48 89 fe 48 c7 c7 18 fa ee 8d e8 9e cf c8 ff <0f> 0b 31
c0 c3 48 89 f2 48 89 fe 48 c7 c7 50 fa ee 8d e8 87 cf c8
[  270.901321] RSP: 0018:ffffb6ea86eb7c20 EFLAGS: 00010282
[  270.902240] RAX: 0000000000000000 RBX: ffff91cc3753c000 RCX:
0000000000000000
[  270.903157] RDX: ffff91bc3f867080 RSI: ffff91bc3f857738 RDI:
ffff91bc3f857738
[  270.904074] RBP: ffff91bc36020940 R08: 0000000000000560 R09:
0000000000000000
[  270.904988] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000000
[  270.905902] R13: ffff91cc3753a800 R14: ffff91cc37cc6400 R15:
ffff91cc3753a800
[  270.906809] FS:  00007f454a88d700(0000) GS:ffff91bc3f840000(0000)
knlGS:0000000000000000
[  270.907715] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  270.908606] CR2: 00007f453c00292c CR3: 000000103554e003 CR4:
00000000001606e0
[  270.909490] Call Trace:
[  270.910373]  tls_tx_records+0x138/0x1c0 [tls]
[  270.911262]  tls_sw_sendpage+0x3e0/0x420 [tls]
[  270.912154]  inet_sendpage+0x52/0x90
[  270.913045]  ? direct_splice_actor+0x40/0x40
[  270.913941]  kernel_sendpage+0x1a/0x30
[  270.914831]  sock_sendpage+0x20/0x30
[  270.915714]  pipe_to_sendpage+0x62/0x90
[  270.916592]  __splice_from_pipe+0x80/0x180
[  270.917461]  ? direct_splice_actor+0x40/0x40
[  270.918334]  splice_from_pipe+0x5d/0x90
[  270.919208]  direct_splice_actor+0x35/0x40
[  270.920086]  splice_direct_to_actor+0x103/0x230
[  270.920966]  ? generic_pipe_buf_nosteal+0x10/0x10
[  270.921850]  do_splice_direct+0x9a/0xd0
[  270.922733]  do_sendfile+0x1c9/0x3d0
[  270.923612]  __x64_sys_sendfile64+0x5c/0xc0


(gdb) list *(tls_tx_records+0x138)
0x2d18 is in tls_tx_records (./include/linux/list.h:131).
126      * Note: list_empty() on entry does not return true after this, the
entry is
127      * in an undefined state.
128      */
129     static inline void __list_del_entry(struct list_head *entry)
130     {
131             if (!__list_del_entry_valid(entry))
132                     return;
133     
134             __list_del(entry->prev, entry->next);
135     }
(gdb) 
(gdb) list *(tls_sw_sendpage+0x3e0)
0x48e0 is in tls_sw_sendpage (/home/mjatharkonda/5_3_rc4/tls/tls_sw.c:1211).
1206    
1207            if (num_async) {
1208                    /* Transmit if any encryptions have completed */
1209                    if (test_and_clear_bit(BIT_TX_SCHEDULED,
&ctx->tx_bitmask)) {
1210                            cancel_delayed_work(&ctx->tx_work.work);
1211                            tls_tx_records(sk, flags);
1212                    }
1213            }
1214    sendpage_end:
1215            ret = sk_stream_error(sk, flags, ret);
(gdb) 



Attached complete crash log

-- 
You are receiving this mail because:
You are the assignee for the bug.
