Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3B73D4AA
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 19:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406628AbfFKR5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 13:57:17 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:7998 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406287AbfFKR5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 13:57:17 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x5BHvEeM011674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jun 2019 11:57:14 -0600 (CST)
Received: from eng1n65.eng.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x5BHvDWV040271
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 11 Jun 2019 11:57:13 -0600
To:     netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
From:   Robert Hancock <hancock@sedsystems.ca>
Subject: net-next: KSZ switch driver oops in ksz_mib_read_work
Openpgp: preference=signencrypt
Autocrypt: addr=hancock@sedsystems.ca; prefer-encrypt=mutual; keydata=
 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
Organization: SED Systems
Message-ID: <6dc8cc46-6225-011c-68bc-c96a819fa00d@sedsystems.ca>
Date:   Tue, 11 Jun 2019 11:57:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are using an embedded platform with a KSZ9897 switch. I am getting
the oops below in ksz_mib_read_work when testing with net-next branch.
After adding in some debug output, the problem is in this code:

	for (i = 0; i < dev->mib_port_cnt; i++) {
		p = &dev->ports[i];
		mib = &p->mib;
		mutex_lock(&mib->cnt_mutex);

		/* Only read MIB counters when the port is told to do.
		 * If not, read only dropped counters when link is not up.
		 */
		if (!p->read) {
			const struct dsa_port *dp = dsa_to_port(dev->ds, i);

			if (!netif_carrier_ok(dp->slave))
				mib->cnt_ptr = dev->reg_mib_cnt;
		}

The oops is happening on port index 3 (i.e. 4th port) which is not
connected on our platform and so has no entry in the device tree. For
that port, dp->slave is NULL and so netif_carrier_ok explodes.

If I change the code to skip the port entirely in the loop if dp->slave
is NULL it seems to fix the crash, but I'm not that familiar with this
code. Can someone confirm whether that is the proper fix?

[   17.842829] Unable to handle kernel NULL pointer dereference at
virtual address 0000002c
[   17.850983] pgd = (ptrval)
[   17.853711] [0000002c] *pgd=00000000
[   17.857317] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
[   17.862632] Modules linked in:
[   17.865695] CPU: 1 PID: 21 Comm: kworker/1:1 Not tainted 5.2.0-rc3 #1
[   17.872142] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[   17.878688] Workqueue: events ksz_mib_read_work
[   17.883227] PC is at ksz_mib_read_work+0x58/0x94
[   17.887848] LR is at ksz_mib_read_work+0x38/0x94
[   17.887852] pc : [<c04843dc>]    lr : [<c04843bc>]    psr: 60070113
[   17.887857] sp : e8147f08  ip : e8148000  fp : ffffe000
[   17.887860] r10: 00000000  r9 : e8aa7040  r8 : e867cc44
[   17.887865] r7 : 00000c20  r6 : e8aa7120  r5 : 00000003  r4 : e867c958
[   17.887868] r3 : 00000000  r2 : 00000000  r1 : 00000003  r0 : e8aa7040
[   17.887879] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
Segment none
[   17.948224] Control: 10c5387d  Table: 38d9404a  DAC: 00000051
[   17.948230] Process kworker/1:1 (pid: 21, stack limit = 0x(ptrval))
[   17.948236] Stack: (0xe8147f08 to 0xe8148000)
[   17.948245] 7f00:                   e8aa7120 e80a8080 eb7aef40
eb7b2000 00000000 e8aa7124
[   17.948254] 7f20: 00000000 c013865c 00000008 c0b03d00 e80a8080
e80a8094 eb7aef40 00000008
[   17.958073] systemd[1]: storage.mount: Unit is bound to inactive unit
dev-mmcblk1p2.device. Stopping, too.
[   17.963306] 7f40: c0b03d00 eb7aef58 eb7aef40 c01393a0 ffffe000
c0b46b09 c084e464 00000000
[   17.963314] 7f60: ffffe000 e8053140 e80530c0 00000000 e8146000
e80a8080 c013935c e80a1eac
[   17.963322] 7f80: e805315c c013e78c 00000000 e80530c0 c013e648
00000000 00000000 00000000
[   17.969893] random: systemd: uninitialized urandom read (16 bytes read)
[   17.973942] 7fa0: 00000000 00000000 00000000 c01010e8 00000000
00000000 00000000 00000000
[   17.973949] 7fc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   17.973958] 7fe0: 00000000 00000000 00000000 00000000 00000013
00000000 00000000 00000000
[   17.982246] random: systemd: uninitialized urandom read (16 bytes read)
[   17.990329] [<c04843dc>] (ksz_mib_read_work) from [<c013865c>]
(process_one_work+0x17c/0x390)
[   17.990345] [<c013865c>] (process_one_work) from [<c01393a0>]
(worker_thread+0x44/0x518)
[   18.009394] random: systemd: uninitialized urandom read (16 bytes read)
[   18.016344] [<c01393a0>] (worker_thread) from [<c013e78c>]
(kthread+0x144/0x14c)
[   18.016358] [<c013e78c>] (kthread) from [<c01010e8>]
(ret_from_fork+0x14/0x2c)
[   18.016362] Exception stack(0xe8147fb0 to 0xe8147ff8)
[   18.016369] 7fa0:                                     00000000
00000000 00000000 00000000
[   18.031159] 7fc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   18.031166] 7fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[   18.031176] Code: 1a000006 e51630e0 e0833405 e5933050 (e593302c)
[   18.031279] ---[ end trace ca82392a6c2aa959 ]---


-- 
Robert Hancock
Senior Software Developer
SED Systems, a division of Calian Ltd.
Email: hancock@sedsystems.ca
