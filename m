Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8EC66C1268
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 13:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbjCTMyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 08:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbjCTMyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 08:54:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC5313D59;
        Mon, 20 Mar 2023 05:53:00 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32KCbYAa026848;
        Mon, 20 Mar 2023 12:52:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : from : subject : content-type :
 content-transfer-encoding; s=pp1;
 bh=BIvJiCznPDNbzaZBl9HbW1hjJQmUsDhiqqJwSnDiS64=;
 b=YMItdal3B+ARTXjWv9wdPhykOuDa7oYIQwVgtSRXgpXLvHc15DxsjXsUaGV9TVslMPYl
 BmXnkjQ6Yo8yaCHzpSJga7iXvbPLPMsySvEsHoVx2dTBZIfRN/MoCMGHIST/V/XDIHEi
 jO8PJb4g9nSUKTkwMJRm5YiZnbZipkTJSgvXilVxJyYMr9f7QGADB6qJ+2VSffdCexLq
 IBSiHrRmE65c2II60WIiguCRepNC826lnxPHUecCQ/2Gmtg6LUxklC1+2it+4teK8Kob
 c4lyjS3g2MXQljrk1CwTz1ZakzHve5YAsr4eUVZa5kGacaMe2/GgJZgll5zoQ7RRknYF RA== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pdpvs0qmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Mar 2023 12:52:47 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32KB2SkQ019467;
        Mon, 20 Mar 2023 12:52:46 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([9.208.129.114])
        by ppma04wdc.us.ibm.com (PPS) with ESMTPS id 3pd4x6vsjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Mar 2023 12:52:46 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
        by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32KCqj1O13894344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Mar 2023 12:52:45 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54BEF5804E;
        Mon, 20 Mar 2023 12:52:45 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA71B5803F;
        Mon, 20 Mar 2023 12:52:42 +0000 (GMT)
Received: from [9.43.7.238] (unknown [9.43.7.238])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 20 Mar 2023 12:52:42 +0000 (GMT)
Message-ID: <7fe9d0b0-7d77-79cc-405d-3ca38b552782@linux.vnet.ibm.com>
Date:   Mon, 20 Mar 2023 18:22:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     linux-next <linux-next@vger.kernel.org>, lorenzo@kernel.org
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Brian King <brking@linux.vnet.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
From:   Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Subject: [next-20230317][PPC/MLX5][bisected 4d5ab0a] Boot WARNING: CPU: 0 PID:
 9 at net/core/dev.c:1928 call_netdevice_notifiers_info
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZJhaSpgbDPlcWzJgHVl3u4Cp8FgOcnB_
X-Proofpoint-GUID: ZJhaSpgbDPlcWzJgHVl3u4Cp8FgOcnB_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_08,2023-03-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=949 lowpriorityscore=0
 adultscore=0 clxscore=1011 spamscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200107
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greeting's

Warning is seen while booting kernels from 6.3.0-rc3-next-20230317 on my 
powerpc Power 10 LPAR

Boots fine without warnings when below patch is reverted

commit 4d5ab0ad964df178beba031b89429a601893ff61
Author: Lorenzo Bianconi <lorenzo@kernel.org>
Date:   Thu Mar 9 13:25:31 2023 +0100

     net/mlx5e: take into account device reconfiguration for 
xdp_features flag

     Take into account LRO and GRO configuration setting device xdp_features
     flag. Consider channel rq_wq_type enabling rx scatter-gatter support in
     xdp_features flag and disable NETDEV_XDP_ACT_NDO_XMIT_SG since it 
is not
     supported yet by the driver.
     Moreover always enable NETDEV_XDP_ACT_NDO_XMIT as the ndo_xdp_xmit

4d5ab0ad got introduced in next-20230314

@Lorenzo Could you please look into this

Boot console logs

sd 0:0:1:0: [sdb] Preferred minimum I/O size 32768 bytes
  sdb: sdb1 sdb2 sdb3
sd 0:0:1:0: [sdb] Attached SCSI disk
mlx5_core 4001:01:00.0: enabling device (0000 -> 0002)
mlx5_core 4001:01:00.0: firmware version: 14.32.1010
------------[ cut here ]------------
RTNL: assertion failed at net/core/dev.c (1928)
WARNING: CPU: 0 PID: 9 at net/core/dev.c:1928 
call_netdevice_notifiers_info+0xd8/0xe0
Modules linked in: mlx5_core(+) sd_mod t10_pi crc64_rocksoft crc64 sg 
ibmvfc mlxfw scsi_transport_fc ibmveth ptp pps_core dm_multipath 
dm_mirror dm_region_hash dm_log dm_mod fuse
CPU: 0 PID: 9 Comm: kworker/0:1 Not tainted 
6.3.0-rc2-next-20230317-autotest #1
Hardware name: IBM,9080-HEX POWER10 (raw) 0x800200 0xf000006 
of:IBM,FW1030.00 (NH1030_029) hv:phyp pSeries
Workqueue: events work_for_cpu_fn
NIP:  c000000000aca1f8 LR: c000000000aca1f4 CTR: 0000000000725d40
REGS: c0000000038230a0 TRAP: 0700   Not tainted 
(6.3.0-rc2-next-20230317-autotest)
MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 48228824 
XER: 00000010
CFAR: c000000000154c40 IRQMASK: 0
GPR00: c000000000aca1f4 c000000003823340 c0000000011ccb00 000000000000002f
GPR04: 00000000ffff7fff c000000003823110 c000000003823108 0000000000000027
GPR08: c000000c7cc07e90 0000000000000001 0000000000000027 c0000000028f7c30
GPR12: 0000000048228824 c000000002d10000 c000000000191b58 c0000000032f1000
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR20: 0000000000000000 c0000000032f9200 fffffffffffff000 0000000000000000
GPR24: c000000076c001a0 c00800000042c588 c000000008d06c00 c000000008d069a0
GPR28: c000000076c301a0 c000000002d01780 0000000000000028 c0000000038233e8
NIP [c000000000aca1f8] call_netdevice_notifiers_info+0xd8/0xe0
LR [c000000000aca1f4] call_netdevice_notifiers_info+0xd4/0xe0
Call Trace:
[c000000003823340] [c000000000aca1f4] 
call_netdevice_notifiers_info+0xd4/0xe0 (unreliable)
[c0000000038233c0] [c000000000aca23c] call_netdevice_notifiers+0x3c/0x70
[c000000003823400] [c000000000b1f64c] xdp_set_features_flag+0x3c/0x50
[c000000003823420] [c008000000c56db0] mlx5e_set_xdp_feature+0x48/0x90 
[mlx5_core]
[c000000003823440] [c008000000c59414] mlx5e_probe+0x3cc/0x880 [mlx5_core]
[c000000003823500] [c00000000088561c] auxiliary_bus_probe+0x6c/0xf0
[c000000003823580] [c0000000008725e8] really_probe+0x108/0x530
[c000000003823610] [c000000000872ac4] __driver_probe_device+0xb4/0x230
[c000000003823690] [c000000000872c98] driver_probe_device+0x58/0x120
[c0000000038236d0] [c000000000872e7c] __device_attach_driver+0x11c/0x1e0
[c000000003823750] [c00000000086e994] bus_for_each_drv+0xb4/0x130
[c0000000038237b0] [c0000000008723cc] __device_attach+0x15c/0x250
[c000000003823850] [c0000000008704e8] bus_probe_device+0xf8/0x100
[c0000000038238a0] [c00000000086c258] device_add+0x798/0x9e0
[c000000003823960] [c0000000008857d8] __auxiliary_device_add+0x58/0xe0
[c0000000038239d0] [c008000000c35350] add_adev+0xb8/0x180 [mlx5_core]
[c000000003823a10] [c008000000c35614] 
mlx5_rescan_drivers_locked.part.11+0x1fc/0x260 [mlx5_core]
[c000000003823ad0] [c008000000c35d88] mlx5_register_device+0xb0/0x100 
[mlx5_core]
[c000000003823b10] [c008000000c02aa8] mlx5_init_one+0x340/0x680 [mlx5_core]
[c000000003823ba0] [c008000000c03e10] probe_one+0x258/0x540 [mlx5_core]
[c000000003823c30] [c00000000077c2bc] local_pci_probe+0x6c/0x110
[c000000003823cb0] [c00000000017f9b8] work_for_cpu_fn+0x38/0x60
[c000000003823ce0] [c0000000001853d4] process_one_work+0x284/0x550
[c000000003823d80] [c0000000001858f0] worker_thread+0x250/0x5d0
[c000000003823e00] [c000000000191c88] kthread+0x138/0x140
[c000000003823e50] [c00000000000cf5c] ret_from_kernel_thread+0x5c/0x64
--- interrupt: 0 at 0x0
NIP:  0000000000000000 LR: 0000000000000000 CTR: 0000000000000000
REGS: c000000003823e80 TRAP: 0000   Not tainted 
(6.3.0-rc2-next-20230317-autotest)
MSR:  0000000000000000 <>  CR: 00000000  XER: 00000000
CFAR: 0000000000000000 IRQMASK: 0
GPR00: 0000000000000000 c000000003824000 0000000000000000 0000000000000000
GPR04: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR08: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR12: 0000000000000000 0000000000000000 c000000000191b58 c0000000032f1000
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR24: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR28: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
NIP [0000000000000000] 0x0
LR [0000000000000000] 0x0
--- interrupt: 0
Code: 2f890000 409eff9c 39200001 3c82fff1 3c62fff1 3d42017d 38a00788 
3884b3c8 3863b3d8 992a2141 4b68a969 60000000 <0fe00000> 60000000 
3c4c0070 38422900

-- 
Regard's

Abdul Haleem
IBM Linux Technology Center
