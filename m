Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EFA65B9EA
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 05:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjACEGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 23:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjACEGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 23:06:20 -0500
X-Greylist: delayed 88398 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 02 Jan 2023 20:06:17 PST
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956DAA1
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 20:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1672718597;
    s=strato-dkim-0002; d=xenosoft.de;
    h=In-Reply-To:References:Cc:To:From:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=x34rSALjTO9AJbmCypdJbQcgKSJTsf0XEQorEUjJXMU=;
    b=mh0N1VW2tV2kIyWi1Mv0BR5u+K1DZpBasdxGjqWgEnZtj0EMaxr6V938SV6dY42uni
    yRFQL6fi/LAgzElw6ZkVedfZkAvAqHigi10ygU98xJ6Nevzs0/8CyzkmvBP91YUXnlI5
    SifSdUkRwY2+4o3027nwTu7sds5ZREiBo7b6PGXL6UDUOMKfj9608BfpgBx625gmzMav
    XzfX/p9qnXMUVZb1kIFKaB5un4geeDQO9N0WWxUpANnA0ufm2OXFMXNk5V14yVG2WrkY
    cDsr23nrRcgOdt8jQsT06k/DygCX6HJ8KpndAKAn4olviSFL43Z/9QCj+2CeajWnaBO8
    3zug==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGM4l4Hio94KKxRySfLxnHfJ+Dkjp5DdBfio0GngadwiHvQwieZ0xdBsMaw5dId26M4sA8Q=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a02:8109:8980:4474:bd6f:a8f4:de7c:e110]
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id e28afdz0343FIbX
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 3 Jan 2023 05:03:15 +0100 (CET)
Message-ID: <430001ad-bc25-d4be-6013-673c14e87dba@xenosoft.de>
Date:   Tue, 3 Jan 2023 05:03:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [FSL P50x0] DPAA Ethernet issue
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
To:     Sean Anderson <seanga2@gmail.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     darren@stevens-zone.net, info@xenosoft.de,
        linuxppc-dev@lists.ozlabs.org, madskateman@gmail.com,
        matthew@a-eon.biz, rtd2@xtra.co.nz, sean.anderson@seco.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <0bfc8f3d-cb62-25f4-2590-ff424adbe48a@xenosoft.de>
 <a40020bd-c190-4283-1977-9e4d9627b888@gmail.com>
 <8be26a07-3f48-cd61-1b74-1605827bfae3@xenosoft.de>
In-Reply-To: <8be26a07-3f48-cd61-1b74-1605827bfae3@xenosoft.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02 January 2023 at 04:32 am, Christian Zigotzky wrote:
> On 01 January 2023 at 07:11 pm, Sean Anderson wrote:
>
> Thank you for testing this. Unfortunately, I have no P-series hardware,
> so I was unable to test the 10gec/dtsec parts of this conversion. I had
> hoped that this would get tested by someone with the hardware (at NXP)
> before now, but it seems you get to be the "lucky" first user.
>
> I see you have labeled one of your kernels as supporting QEMU.  Do you
> happen to have instructions for running Linux on QEMU?
>
> Can you try the following patch. I think my mail client will mangle 
> it,  so I have also attached it to this email.
>
> ------------
>
> Hi Sean,
>
> Thanks a lot for your answer.
>
> I use the virtio-net device in a virtual e5500 QEMU/KVM HV machine. 
> [1] [2]
>
> I will test your patch as soon as possible.
>
> Thanks,
> Christian
>
> [1] QEMU command: qemu-system-ppc64 -M ppce500 -cpu e5500 -m 1024 
> -kernel uImage-6.2 -drive 
> format=raw,file=void-live-powerpc-20220129.img,index=0,if=virtio 
> -netdev user,id=mynet0 -device virtio-net,netdev=mynet0 -append "rw 
> root=/dev/vda2" -device virtio-gpu -device virtio-mouse-pci -device 
> virtio-keyboard-pci -device pci-ohci,id=newusb -audiodev 
> id=sndbe,driver=pa,server=/run/user/1000/pulse/native -device 
> usb-audio,bus=newusb.0 -enable-kvm -smp 4 -fsdev 
> local,security_model=passthrough,id=fsdev0,path=/home/amigaone/Music 
> -device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare
>
> [2] https://forum.hyperion-entertainment.com/viewtopic.php?p=46749

Hi Sean,

I tested your patch with the RC2 today but unfortunately the kernel 
doesn't link after compiling.

Error messages:

   LD      .tmp_vmlinux.kallsyms1
`.exit.text' referenced in section `__bug_table' of crypto/algboss.o: 
defined in discarded section `.exit.text' of crypto/algboss.o
`.exit.text' referenced in section `__bug_table' of crypto/algif_hash.o: 
defined in discarded section `.exit.text' of crypto/algif_hash.o
`.exit.text' referenced in section `__bug_table' of 
drivers/char/hw_random/core.o: defined in discarded section `.exit.text' 
of drivers/char/hw_random/core.o
make[1]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
make: *** [Makefile:1252: vmlinux] Error 2

Maybe it is not an issue because of the patch because the RC1 compilied 
and linked with the patch.

@Dave
Please test the RC1 with Sean's patch.

Download: http://www.xenosoft.de/uImage-6.2-dpaa-t1

sudo dmesg | grep -i dpaa

[    3.017121] fsl_dpaa_mac ffe4e8000.ethernet: FMan dTSEC version: 
0x08240101
[    3.017256] fsl_dpaa_mac ffe4e8000.ethernet: FMan MAC address: 
00:04:a3:6b:41:65
[    3.017534] fsl_dpaa_mac ffe4f0000.ethernet: 
of_get_mac_address(/soc@ffe000000/fman@400000/ethernet@f0000) failed
[    3.017745] fsl_dpaa_mac ffe4f0000.ethernet: of_get_phy_mode() for 
/soc@ffe000000/fman@400000/ethernet@f0000 failed. Defaulting to SGMII
[    3.017975] fsl_dpaa_mac: FMan XGEC version: 0x00010330
[    3.018293] fsl_dpaa_mac ffe5e8000.ethernet: FMan dTSEC version: 
0x08240101
[    3.018413] fsl_dpaa_mac ffe5e8000.ethernet: FMan MAC address: 
00:1e:c0:f8:01:59
[    3.018656] fsl_dpaa_mac ffe5f0000.ethernet: 
of_get_mac_address(/soc@ffe000000/fman@500000/ethernet@f0000) failed
[    3.018871] fsl_dpaa_mac ffe5f0000.ethernet: of_get_phy_mode() for 
/soc@ffe000000/fman@500000/ethernet@f0000 failed. Defaulting to SGMII
[    3.019099] fsl_dpaa_mac: FMan XGEC version: 0x00010330
[    3.021559] fsl_dpaa_mac ffe4e8000.ethernet eth0: Probed interface eth0
[    3.023358] fsl_dpaa_mac ffe4f0000.ethernet: Using random MAC 
address: 5e:d0:6f:2b:29:35
[    3.024041] fsl_dpaa_mac ffe4f0000.ethernet eth1: Probed interface eth1
[    3.026381] fsl_dpaa_mac ffe5e8000.ethernet eth2: Probed interface eth2
[    3.028199] fsl_dpaa_mac ffe5f0000.ethernet: Using random MAC 
address: c2:ec:b7:35:67:37
[    3.028878] fsl_dpaa_mac ffe5f0000.ethernet eth3: Probed interface eth3
[    7.543868] fsl_dpaa_mac ffe4e8000.ethernet eth0: PHY 
[mdio@ffe4e1120:03] driver [Generic PHY] (irq=POLL)
[    7.549774] fsl_dpaa_mac ffe4e8000.ethernet eth0: configuring for 
phy/rgmii link mode
[    7.583166] fsl_dpaa_mac ffe5e8000.ethernet eth2: PHY 
[mdio@ffe4e1120:07] driver [Generic PHY] (irq=POLL)
[    7.589079] fsl_dpaa_mac ffe5e8000.ethernet eth2: configuring for 
phy/rgmii link mode

Cheers,
Christian
