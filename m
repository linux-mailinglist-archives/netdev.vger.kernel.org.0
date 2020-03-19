Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF60B18B96A
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 15:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbgCSObz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 10:31:55 -0400
Received: from comms.puri.sm ([159.203.221.185]:52516 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726795AbgCSObz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 10:31:55 -0400
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id 095C1E0198;
        Thu, 19 Mar 2020 07:31:52 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bthujeVkMd3k; Thu, 19 Mar 2020 07:31:51 -0700 (PDT)
To:     amitkarwar@gmail.com, siva8118@gmail.com, kvalo@codeaurora.org
Cc:     davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
Subject: BUG: KASAN: slab-out-of-bounds in
 rsi_sdio_write_register_multiple+0xdc/0x1b8 [rsi_sdio]
Autocrypt: addr=martin.kepplinger@puri.sm; keydata=
 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
 ekMtxgNYb/8oDry09UFHbGHLsWn6oBo=
Message-ID: <e6bd4034-9e2b-2110-b0fd-d7edd1f93845@puri.sm>
Date:   Thu, 19 Mar 2020 15:31:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,

I'm running Linus' tree and hit the following when KASAN is enabled. Do
you have an idea of what goes wrong here? I'm happy to test any changes:


Mar 19 11:26:24 pureos kernel: [   23.375247]
==================================================================
Mar 19 11:26:24 pureos kernel: [   23.382592] BUG: KASAN:
slab-out-of-bounds in rsi_sdio_write_register_multiple+0xdc/0x1b8 [rsi_sdio]
Mar 19 11:26:24 pureos kernel: [   23.391761] Read of size 16 at addr
ffff0000bf1ed400 by task systemd-udevd/338
Mar 19 11:26:24 pureos kernel: [   23.399003]
Mar 19 11:26:24 pureos kernel: [   23.400528] CPU: 0 PID: 338 Comm:
systemd-udevd Not tainted 5.6.0-1-librem5 #31
Mar 19 11:26:24 pureos kernel: [   23.400542] Hardware name: Purism
Librem 5 (DT)
Mar 19 11:26:24 pureos kernel: [   23.400555] Call trace:
Mar 19 11:26:24 pureos kernel: [   23.400590]  dump_backtrace+0x0/0x2a8
Mar 19 11:26:24 pureos kernel: [   23.400615]  show_stack+0x1c/0x28
Mar 19 11:26:24 pureos kernel: [   23.400638]  dump_stack+0x110/0x188
Mar 19 11:26:24 pureos kernel: [   23.400669]
print_address_description.isra.11+0x6c/0x354
Mar 19 11:26:24 pureos kernel: [   23.400691]  __kasan_report+0x130/0x244
Mar 19 11:26:24 pureos kernel: [   23.400712]  kasan_report+0xc/0x18
Mar 19 11:26:24 pureos kernel: [   23.400736]
check_memory_region+0x17c/0x1e8
Mar 19 11:26:24 pureos kernel: [   23.400758]  __asan_loadN+0x14/0x20
Mar 19 11:26:24 pureos kernel: [   23.400813]
rsi_sdio_write_register_multiple+0xdc/0x1b8 [rsi_sdio]
Mar 19 11:26:24 pureos kernel: [   23.400863]
rsi_sdio_master_reg_write+0x94/0x140 [rsi_sdio]
Mar 19 11:26:24 pureos kernel: [   23.400962]
rsi_hal_prepare_fwload+0x1a8/0x250 [rsi_91x]
Mar 19 11:26:24 pureos kernel: [   23.401049]
rsi_hal_device_init+0xd4/0x1110 [rsi_91x]
Mar 19 11:26:24 pureos kernel: [   23.401099]  rsi_probe+0x3d0/0x5a0
[rsi_sdio]
Mar 19 11:26:24 pureos kernel: [   23.401122]  sdio_bus_probe+0x13c/0x288
Mar 19 11:26:24 pureos kernel: [   23.401147]  really_probe+0x1bc/0x5e0
Mar 19 11:26:24 pureos kernel: [   23.401170]
driver_probe_device+0xdc/0x1a8
Mar 19 11:26:24 pureos kernel: [   23.401193]
device_driver_attach+0x9c/0xa8
Mar 19 11:26:24 pureos kernel: [   23.401215]  __driver_attach+0x110/0x1a0
Mar 19 11:26:24 pureos kernel: [   23.401237]  bus_for_each_dev+0xf0/0x158
Mar 19 11:26:24 pureos kernel: [   23.401258]  driver_attach+0x38/0x48
Mar 19 11:26:24 pureos kernel: [   23.401279]  bus_add_driver+0x280/0x2e8
Mar 19 11:26:24 pureos kernel: [   23.401302]  driver_register+0xc4/0x1d8
Mar 19 11:26:24 pureos kernel: [   23.401328]
sdio_register_driver+0x50/0x60
Mar 19 11:26:24 pureos kernel: [   23.401377]  rsi_module_init+0x24/0x50
[rsi_sdio]
Mar 19 11:26:24 pureos kernel: [   23.401399]  do_one_initcall+0xa4/0x3d8
Mar 19 11:26:24 pureos kernel: [   23.401424]  do_init_module+0xe8/0x360
Mar 19 11:26:24 pureos kernel: [   23.401445]  load_module+0x2efc/0x3390
Mar 19 11:26:24 pureos kernel: [   23.401468]
__do_sys_finit_module+0x11c/0x1a0
Mar 19 11:26:24 pureos kernel: [   23.401491]
__arm64_sys_finit_module+0x48/0x58
Mar 19 11:26:24 pureos kernel: [   23.401518]
el0_svc_common.constprop.1+0xcc/0x1e0
Mar 19 11:26:24 pureos kernel: [   23.401541]  do_el0_svc+0x34/0x40
Mar 19 11:26:24 pureos kernel: [   23.401563]  el0_sync_handler+0x134/0x1a8
Mar 19 11:26:24 pureos kernel: [   23.401581]  el0_sync+0x140/0x180
Mar 19 11:26:24 pureos kernel: [   23.401592]
Mar 19 11:26:24 pureos kernel: [   23.403105] Allocated by task 338:
Mar 19 11:26:24 pureos kernel: [   23.406536]  save_stack+0x24/0xb0
Mar 19 11:26:24 pureos kernel: [   23.406559]
__kasan_kmalloc.isra.10+0xc4/0xe0
Mar 19 11:26:24 pureos kernel: [   23.406579]  kasan_kmalloc+0xc/0x18
Mar 19 11:26:24 pureos kernel: [   23.406600]
kmem_cache_alloc_trace+0x170/0x328
Mar 19 11:26:24 pureos kernel: [   23.406652]
rsi_sdio_master_reg_write+0x4c/0x140 [rsi_sdio]
Mar 19 11:26:24 pureos kernel: [   23.406744]
rsi_hal_prepare_fwload+0x1a8/0x250 [rsi_91x]
Mar 19 11:26:24 pureos kernel: [   23.406831]
rsi_hal_device_init+0xd4/0x1110 [rsi_91x]
Mar 19 11:26:24 pureos kernel: [   23.406880]  rsi_probe+0x3d0/0x5a0
[rsi_sdio]
Mar 19 11:26:24 pureos kernel: [   23.406900]  sdio_bus_probe+0x13c/0x288
Mar 19 11:26:24 pureos kernel: [   23.406923]  really_probe+0x1bc/0x5e0
Mar 19 11:26:24 pureos kernel: [   23.406946]
driver_probe_device+0xdc/0x1a8
Mar 19 11:26:24 pureos kernel: [   23.406968]
device_driver_attach+0x9c/0xa8
Mar 19 11:26:24 pureos kernel: [   23.406989]  __driver_attach+0x110/0x1a0
Mar 19 11:26:24 pureos kernel: [   23.407010]  bus_for_each_dev+0xf0/0x158
Mar 19 11:26:24 pureos kernel: [   23.407031]  driver_attach+0x38/0x48
Mar 19 11:26:24 pureos kernel: [   23.407052]  bus_add_driver+0x280/0x2e8
Mar 19 11:26:24 pureos kernel: [   23.407074]  driver_register+0xc4/0x1d8
Mar 19 11:26:24 pureos kernel: [   23.407100]
sdio_register_driver+0x50/0x60
Mar 19 11:26:24 pureos kernel: [   23.407149]  rsi_module_init+0x24/0x50
[rsi_sdio]
Mar 19 11:26:24 pureos kernel: [   23.407168]  do_one_initcall+0xa4/0x3d8
Mar 19 11:26:24 pureos kernel: [   23.407191]  do_init_module+0xe8/0x360
Mar 19 11:26:24 pureos kernel: [   23.407212]  load_module+0x2efc/0x3390
Mar 19 11:26:24 pureos kernel: [   23.407234]
__do_sys_finit_module+0x11c/0x1a0
Mar 19 11:26:24 pureos kernel: [   23.407257]
__arm64_sys_finit_module+0x48/0x58
Mar 19 11:26:24 pureos kernel: [   23.407282]
el0_svc_common.constprop.1+0xcc/0x1e0
Mar 19 11:26:24 pureos kernel: [   23.407304]  do_el0_svc+0x34/0x40
Mar 19 11:26:24 pureos kernel: [   23.407326]  el0_sync_handler+0x134/0x1a8
Mar 19 11:26:24 pureos kernel: [   23.407343]  el0_sync+0x140/0x180
Mar 19 11:26:24 pureos kernel: [   23.407352]
Mar 19 11:26:24 pureos kernel: [   23.408863] Freed by task 338:
Mar 19 11:26:24 pureos kernel: [   23.411947]  save_stack+0x24/0xb0
Mar 19 11:26:24 pureos kernel: [   23.411969]  __kasan_slab_free+0x10c/0x188
Mar 19 11:26:24 pureos kernel: [   23.411991]  kasan_slab_free+0x10/0x18
Mar 19 11:26:24 pureos kernel: [   23.412009]  kfree+0x88/0x378
Mar 19 11:26:24 pureos kernel: [   23.412032]
ext4_ext_map_blocks+0x518/0x14c0
Mar 19 11:26:24 pureos kernel: [   23.412059]  ext4_map_blocks+0x53c/0x888
Mar 19 11:26:24 pureos kernel: [   23.412082]  ext4_getblk+0xa0/0x298
Mar 19 11:26:24 pureos kernel: [   23.412105]  ext4_bread_batch+0x70/0x228
Mar 19 11:26:24 pureos kernel: [   23.412129]  __ext4_find_entry+0x25c/0x5f8
Mar 19 11:26:24 pureos kernel: [   23.412149]  ext4_lookup+0x120/0x350
Mar 19 11:26:24 pureos kernel: [   23.412168]  __lookup_slow+0x100/0x200
Mar 19 11:26:24 pureos kernel: [   23.412187]  walk_component+0x384/0x538
Mar 19 11:26:24 pureos kernel: [   23.412206]
path_lookupat.isra.47+0xac/0x1b0
Mar 19 11:26:24 pureos kernel: [   23.412226]
filename_lookup.part.64+0xec/0x1e8
Mar 19 11:26:24 pureos kernel: [   23.412245]  user_path_at_empty+0x54/0x68
Mar 19 11:26:24 pureos kernel: [   23.412266]  vfs_statx+0xe0/0x160
Mar 19 11:26:24 pureos kernel: [   23.412287]  __do_sys_newfstatat+0x84/0xd0
Mar 19 11:26:24 pureos kernel: [   23.412308]
__arm64_sys_newfstatat+0x58/0x68
Mar 19 11:26:24 pureos kernel: [   23.412335]
el0_svc_common.constprop.1+0xcc/0x1e0
Mar 19 11:26:24 pureos kernel: [   23.412357]  do_el0_svc+0x34/0x40
Mar 19 11:26:24 pureos kernel: [   23.412378]  el0_sync_handler+0x134/0x1a8
Mar 19 11:26:24 pureos kernel: [   23.412395]  el0_sync+0x140/0x180
Mar 19 11:26:24 pureos kernel: [   23.412404]
Mar 19 11:26:24 pureos kernel: [   23.413922] The buggy address belongs
to the object at ffff0000bf1ed400
Mar 19 11:26:24 pureos kernel: [   23.413922]  which belongs to the
cache kmalloc-128 of size 128
Mar 19 11:26:24 pureos kernel: [   23.426475] The buggy address is
located 0 bytes inside of
Mar 19 11:26:24 pureos kernel: [   23.426475]  128-byte region
[ffff0000bf1ed400, ffff0000bf1ed480)
Mar 19 11:26:24 pureos kernel: [   23.438063] The buggy address belongs
to the page:
Mar 19 11:26:24 pureos kernel: [   23.442889] page:fffffe0002dc7b40
refcount:1 mapcount:0 mapping:ffff00008ec03c00 index:0x0
Mar 19 11:26:24 pureos kernel: [   23.442909] flags:
0x4000000000000200(slab)
Mar 19 11:26:24 pureos kernel: [   23.442943] raw: 4000000000000200
fffffe0001f50a40 0000000e00000002 ffff00008ec03c00
Mar 19 11:26:24 pureos kernel: [   23.442969] raw: 0000000000000000
0000000080100010 00000001ffffffff 0000000000000000
Mar 19 11:26:24 pureos kernel: [   23.442981] page dumped because:
kasan: bad access detected
Mar 19 11:26:24 pureos kernel: [   23.442991]
Mar 19 11:26:24 pureos kernel: [   23.444499] Memory state around the
buggy address:
Mar 19 11:26:24 pureos kernel: [   23.449321]  ffff0000bf1ed300: 00 00
00 00 fc fc fc fc fc fc fc fc fc fc fc fc
Mar 19 11:26:24 pureos kernel: [   23.456576]  ffff0000bf1ed380: fc fc
fc fc fc fc fc fc fc fc fc fc fc fc fc fc
Mar 19 11:26:24 pureos kernel: [   23.463827] >ffff0000bf1ed400: 00 04
fc fc fc fc fc fc fc fc fc fc fc fc fc fc
Mar 19 11:26:24 pureos kernel: [   23.471068]                       ^
Mar 19 11:26:24 pureos kernel: [   23.474586]  ffff0000bf1ed480: fc fc
fc fc fc fc fc fc fc fc fc fc fc fc fc fc
Mar 19 11:26:24 pureos kernel: [   23.481838]  ffff0000bf1ed500: 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00
Mar 19 11:26:24 pureos kernel: [   23.489080]
==================================================================
