Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8086128748B
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 14:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730089AbgJHMwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 08:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729722AbgJHMwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 08:52:23 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49E5C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 05:52:22 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id h6so4216611pgk.4
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 05:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z9E83L4vWHmW2Akb3kBAcs05hdm/jEavtvluy+5hgTg=;
        b=QPIq88bbCn1ZyaqzeEGFhzRxNA0cTGIOJ2QcEVkgl8LuhacDLBfQJA1DcvWPPhPNln
         8O7qKU3l69GG9OErTPKaTgMeRWtWPCiAOiU+rBMsBuUTY0AoZQf9tExXQLh2YOhT+4hJ
         l892IGzU9lxQPlziUamlNO04a0yhPDRj4PzilhDtcCdWq+DRc5bAFGsO6Q1AcW5AYbSS
         0SLwRir/5CnCed3hLopapPT32Qd/Zp0EEedYmGT+foStGdQ3zlD5eOqSbj1fotf8vcmE
         ddpplcMkVk3iXFGyiVr1IVpHVPRTnvYAKTZtcugiQRjATd7pG4mlcDLQV+uhEa7mct07
         T7og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z9E83L4vWHmW2Akb3kBAcs05hdm/jEavtvluy+5hgTg=;
        b=lwIBQw7U2dkGG1+7TN09Tgprm/jbOPaN9JZls5/l+hWlRKvILD5/66kzzBOfyJyWLK
         WQoVn2tUv4nYpIoSZlg3xI6VfBemoE8k25D8DOgHRm1cobrjSSI3pyJwM67bRXpSqGiu
         OfH2IF+EFafq9qjTduJQWKd/CKN9nofpx5hQinlibhwGbKUA9srbnWIDMfEZXCM5G2jB
         90EofncqTlwZRBlZv5T11Yu+ZAynSuv3hZ7pYvW5/UXRXyQwV/2LgcSJGU8IndLYG0od
         /0Dt4vRG3+Y2VHruij2//S3qV09TEZb3kTxG14V0v1eZvKkjbUr4TaSgnJy5xFEEpY5t
         d26Q==
X-Gm-Message-State: AOAM533aDVGgfdyI2WVPfNrHIHbSDKvjNij7lY2yege7+QA4TwiWDmHd
        v/b0mQe2+gREsVKNUmgtIX4=
X-Google-Smtp-Source: ABdhPJy/ODXGPYFLZRLqaa3kHMtPEzcrRyAfLOJMs8EGBtcRrmc+ualRtz82GlY6TMzCVzuYmX9EbQ==
X-Received: by 2002:a17:90a:d57:: with SMTP id 23mr7967927pju.232.1602161542010;
        Thu, 08 Oct 2020 05:52:22 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id z12sm7362931pfr.197.2020.10.08.05.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 05:52:21 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Thu, 8 Oct 2020 20:52:14 +0800
To:     Shung-Hsi Yu <shung-hsi.yu@suse.com>
Cc:     netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [RFC 0/3] staging: qlge: Re-writing the debugging features
Message-ID: <20201008125214.wiorgfcsd5hjkt4z@Rk>
References: <20200814160601.901682-1-coiby.xu@gmail.com>
 <20200826075206.GG16060@localhost.localdomain>
 <20200827095443.GL16060@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200827095443.GL16060@localhost.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 27, 2020 at 05:54:43PM +0800, Shung-Hsi Yu wrote:
>On Wed, Aug 26, 2020 at 03:52:06PM +0800, Shung-Hsi Yu wrote:
>> On Sat, Aug 15, 2020 at 12:05:58AM +0800, Coiby Xu wrote:
>> > This patch set aims to avoid dumping registers, data structures and
>> > coredump to dmesg and also to reduce the code size of the qlge driver.
>> >
>> > As pointed out by Benjamin [1],
>> >
>> > > At 2000 lines, qlge_dbg.c alone is larger than some entire ethernet
>> > > drivers. Most of what it does is dump kernel data structures or pci
>> > > memory mapped registers to dmesg. There are better facilities for that.
>> > > My thinking is not simply to delete qlge_dbg.c but to replace it, making
>> > > sure that most of the same information is still available. For data
>> > > structures, crash or drgn can be used; possibly with a script for the
>> > > latter which formats the data. For pci registers, they should be
>> > > included in the ethtool register dump and a patch added to ethtool to
>> > > pretty print them. That's what other drivers like e1000e do. For the
>> > > "coredump", devlink health can be used.
>> >
>> > So the debugging features are re-written following Benjamin's advice,
>> >    - use ethtool to dump registers
>> >    - dump kernel data structures in drgn
>> >    - use devlink health to do coredump
>> >
>> > The get_regs ethtool_ops has already implemented. What lacks is a patch
>> > for the userland ethtool to do the pretty-printing. I haven't yet provided
>> > a patch to the userland ethtool because I'm aware ethtool is moving towards
>> > the netlink interface [2]. I'm curious if a generalized mechanism of
>> > pretty-printing will be implemented thus making pretty-printing for a
>> > specific driver unnecessary. As of this writing, `-d|--register-dump`
>> > hasn't been implemented for the netlink interface.
>> >
>> >
>> > To dump kernel data structures, the following Python script can be used
>> > in drgn,
>> >
>> >
>> >     ```python
>> >     def align(x, a):
>> >         """the alignment a should be a power of 2
>> >         """
>> >         mask = a - 1
>> >         return (x+ mask) & ~mask
>> >
>> >     def struct_size(struct_type):
>> >         struct_str = "struct {}".format(struct_type)
>> >         return sizeof(Object(prog, struct_str, address=0x0))
>> >
>> >     def netdev_priv(netdevice):
>> >         NETDEV_ALIGN = 32
>> >         return netdevice.value_() + align(struct_size("net_device"), NETDEV_ALIGN)
>> >
>> >     name = 'xxx'
>> >     qlge_device = None
>> >     netdevices = prog['init_net'].dev_base_head.address_of_()
>> >     for netdevice in list_for_each_entry("struct net_device", netdevices, "dev_list"):
>> >         if netdevice.name.string_().decode('ascii') == name:
>> >             print(netdevice.name)
>> >
>> >     ql_adapter = Object(prog, "struct ql_adapter", address=netdev_priv(qlge_device))
>> >     ```
>> >
>> > The struct ql_adapter will be printed in drgn as follows,
>> >     >>> ql_adapter
>> >     (struct ql_adapter){
>> >             .ricb = (struct ricb){
>> >                     .base_cq = (u8)0,
>> >                     .flags = (u8)120,
>> >                     .mask = (__le16)26637,
>> >                     .hash_cq_id = (u8 [1024]){ 172, 142, 255, 255 },
>> >                     .ipv6_hash_key = (__le32 [10]){},
>> >                     .ipv4_hash_key = (__le32 [4]){},
>> >             },
>> >             .flags = (unsigned long)0,
>> >             .wol = (u32)0,
>> >             .nic_stats = (struct nic_stats){
>> >                     .tx_pkts = (u64)0,
>> >                     .tx_bytes = (u64)0,
>> >                     .tx_mcast_pkts = (u64)0,
>> >                     .tx_bcast_pkts = (u64)0,
>> >                     .tx_ucast_pkts = (u64)0,
>> >                     .tx_ctl_pkts = (u64)0,
>> >                     .tx_pause_pkts = (u64)0,
>> >                     ...
>> >             },
>> >             .active_vlans = (unsigned long [64]){
>> >                     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52780853100545, 18446744073709551615,
>> >                     18446619461681283072, 0, 42949673024, 2147483647,
>> >             },
>> >             .rx_ring = (struct rx_ring [17]){
>> >                     {
>> >                             .cqicb = (struct cqicb){
>> >                                     .msix_vect = (u8)0,
>> >                                     .reserved1 = (u8)0,
>> >                                     .reserved2 = (u8)0,
>> >                                     .flags = (u8)0,
>> >                                     .len = (__le16)0,
>> >                                     .rid = (__le16)0,
>> >                                     ...
>> >                             },
>> >                             .cq_base = (void *)0x0,
>> >                             .cq_base_dma = (dma_addr_t)0,
>> >                     }
>> >                     ...
>> >             }
>> >     }
>> >
>> >
>> > And the coredump obtained via devlink in json format looks like,
>> >
>> >     $ devlink health dump show DEVICE reporter coredump -p -j
>> >     {
>> >         "Core Registers": {
>> >             "segment": 1,
>> >             "values": [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ]
>> >         },
>> >         "Test Logic Regs": {
>> >             "segment": 2,
>> >             "values": [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ]
>> >         },
>> >         "RMII Registers": {
>> >             "segment": 3,
>> >             "values": [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ]
>> >         },
>> >         ...
>> >         "Sem Registers": {
>> >             "segment": 50,
>> >             "values": [ 0,0,0,0 ]
>> >         }
>> >     }
>> >
>> > Since I don't have a QLGE device and neither could I find a software
>> > simulator, I put some functions into e1000 to get the above result.
>>
>> I'm not familiar with qlge, but I do happen to have one accessible. You can
>> add me to CC for future version of this patch.
>>
>> Testing with the refreshed patch set I got from Benjamin (apply over commit
>> fc80c51fd4b2) with debugging options KASAN, UBSAN, DEBUG_ATOMIC_SLEEP,
>> PROVE_LOCKING and DEBUG_KMEMLEAK enabled, I can verify coredump through
>> devlink works.
>
>Benjamin reminded me to check for errors in the remove callpaths as well,
>and some error showed up in the remove callpath indeed.
>
>  $ modprobe qlge
>  [ 1314.256249] qlge: module is from the staging directory, the quality is unknown, you have been warned.
>  [ 1320.184708] qlge 0000:00:04.0: QLogic 10 Gigabit PCI-E Ethernet Driver
>  [ 1320.185619] qlge 0000:00:04.0: Driver name: qlge, Version: 1.00.00.35.
>  [ 1320.196987] qlge 0000:00:04.0 eth0: Link is down.
>  [ 1320.197830] qlge 0000:00:04.0 eth0: Clearing MAC address
>  [ 1320.199184] qlge 0000:00:04.0 eth0: Function #0, Port 0, NIC Roll 0, NIC Rev = 1, XG Roll = 0, XG Rev = 1.
>  [ 1320.200793] qlge 0000:00:04.0 eth0: MAC address 00:c0:dd:14:54:b8
>  [ 1320.276835] qlge 0000:00:04.0 ens4: renamed from eth0
>  [ 1326.920224] PCI Interrupt Link [LNKB] enabled at IRQ 10
>  [ 1326.943443] qlge 0000:00:05.0 eth0: Link is down.
>  [ 1326.944188] qlge 0000:00:05.0 eth0: Clearing MAC address
>  [ 1326.944975] qlge 0000:00:05.0 eth0: Function #1, Port 1, NIC Roll 0, NIC Rev = 1, XG Roll = 0, XG Rev = 1.
>  [ 1326.946396] qlge 0000:00:05.0 eth0: MAC address 00:c0:dd:14:54:ba
>  [ 1326.997071] qlge 0000:00:05.0 ens5: renamed from eth0
>  $ rmmod qlge
>
>Simple load and unload works fine.
>
>  $ modprobe qlge
>  [ 1348.642124] qlge: module is from the staging directory, the quality is unknown, you have been warned.
>  [ 1355.090448] qlge 0000:00:04.0: QLogic 10 Gigabit PCI-E Ethernet Driver
>  [ 1355.091439] qlge 0000:00:04.0: Driver name: qlge, Version: 1.00.00.35.
>  [ 1355.098890] qlge 0000:00:04.0 eth0: Link is down.
>  [ 1355.099647] qlge 0000:00:04.0 eth0: Clearing MAC address
>  [ 1355.100708] qlge 0000:00:04.0 eth0: Function #0, Port 0, NIC Roll 0, NIC Rev = 1, XG Roll = 0, XG Rev = 1.
>  [ 1355.102301] qlge 0000:00:04.0 eth0: MAC address 00:c0:dd:14:54:b8
>  [ 1355.170258] qlge 0000:00:04.0 ens4: renamed from eth0
>  [ 1361.809918] qlge 0000:00:05.0 eth0: Link is down.
>  [ 1361.810674] qlge 0000:00:05.0 eth0: Clearing MAC address
>  [ 1361.811431] qlge 0000:00:05.0 eth0: Function #1, Port 1, NIC Roll 0, NIC Rev = 1, XG Roll = 0, XG Rev = 1.
>  [ 1361.812594] qlge 0000:00:05.0 eth0: MAC address 00:c0:dd:14:54:ba
>  [ 1361.874453] qlge 0000:00:05.0 ens5: renamed from eth0
>  $ ip link set ens4 up
>  [ 1370.994196] qlge 0000:00:04.0 ens4: MSI-X Enabled, got 2 vectors.
>  [ 1371.199630] qlge 0000:00:04.0 ens4: Clearing MAC address
>  [ 1371.299084] qlge 0000:00:04.0 ens4: Passed Get Port Configuration.
>  $ devlink health dump show pci/0000:00:04.0 reporter coredump -p -j >log.jsonho
>  $ rmmod qlge
>  [ 1413.537710] qlge 0000:00:04.0 ens4: Link is down.
>  [ 1413.538570] qlge 0000:00:04.0 ens4: Clearing MAC address
>  [ 1413.539819] qlge 0000:00:04.0 ens4: Command not supported by firmware.
>  [ 1413.541068] qlge 0000:00:04.0 ens4: Command not supported by firmware.
>  [ 1413.649713] qlge 0000:00:04.0 ens4: Command not supported by firmware.
>  [ 1413.761705] qlge 0000:00:04.0 ens4: Command not supported by firmware.
>  [ 1413.873716] qlge 0000:00:04.0 ens4: Command not supported by firmware.
>  [ 1413.985746] qlge 0000:00:04.0 ens4: Command not supported by firmware.
>  [ 1414.097743] qlge 0000:00:04.0 ens4: Command not supported by firmware.
>
>Unloading the module after coredump through devlink shows the above error.
>At first glance this look quite similar to the errors I get when trying to
>coredump when the interface is down, causing the device to go into an
>invalid state as well.
>
>  $ modprobe qlge
>  [ 1606.229089] qlge: module is from the staging directory, the quality is unknown, you have been warned.
>  [ 1612.423342] qlge 0000:00:04.0: QLogic 10 Gigabit PCI-E Ethernet Driver
>  [ 1612.424551] qlge 0000:00:04.0: Driver name: qlge, Version: 1.00.00.35.
>  [ 1612.432718] qlge 0000:00:04.0 eth0: Link is down.
>  [ 1612.433627] qlge 0000:00:04.0 eth0: Clearing MAC address
>  [ 1612.434621] qlge 0000:00:04.0 eth0: Function #0, Port 0, NIC Roll 0, NIC Rev = 1, XG Roll = 0, XG Rev = 1.
>  [ 1612.436582] qlge 0000:00:04.0 eth0: MAC address 00:c0:dd:14:54:b8
>  [ 1612.494647] qlge 0000:00:04.0 ens4: renamed from eth0
>  [ 1619.078325] qlge 0000:00:05.0 eth0: Link is down.
>  [ 1619.079119] qlge 0000:00:05.0 eth0: Clearing MAC address
>  [ 1619.080165] qlge 0000:00:05.0 eth0: Function #1, Port 1, NIC Roll 0, NIC Rev = 1, XG Roll = 0, XG Rev = 1.
>  [ 1619.081938] qlge 0000:00:05.0 eth0: MAC address 00:c0:dd:14:54:ba
>  [ 1619.154477] qlge 0000:00:05.0 ens5: renamed from eth0
>  $ ip link set ens4 up
>  [ 1629.717532] qlge 0000:00:04.0 ens4: Command not supported by firmware.
>  [ 1629.720692] qlge 0000:00:04.0 ens4: Command not supported by firmware.
>  [ 1629.827878] qlge 0000:00:04.0 ens4: Command not supported by firmware.
>  [ 1629.939891] qlge 0000:00:04.0 ens4: Command not supported by firmware.
>  [ 1630.051855] qlge 0000:00:04.0 ens4: Command not supported by firmware.
>  [ 1630.163885] qlge 0000:00:04.0 ens4: Command not supported by firmware.
>  [ 1630.275872] qlge 0000:00:04.0 ens4: Command not supported by firmware.
>  [ 1630.387893] qlge 0000:00:04.0 ens4: Command not supported by firmware.
>  [ 1630.412685] qlge 0000:00:04.0 ens4: MSI-X Enabled, got 2 vectors.
>  [ 1630.420868] qlge 0000:00:04.0 ens4: Failed about firmware command
>  [ 1630.425110] qlge 0000:00:04.0 ens4: Failed to start port.
>  [ 1630.427966] qlge 0000:00:04.0 ens4: Clearing MAC address
>  [ 1630.487603] qlge 0000:00:04.0 ens4: Failed Get Port Configuration.
>
>I'll report when I've more findings.
>

Thank you for the testing! I will assume these errors are caused by
coredump when the interface is down. Please let me know it still occurs
in v1.
>
<snip>
>

--
Best regards,
Coiby
