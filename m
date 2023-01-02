Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F5065ACFA
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 04:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjABDf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 22:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjABDfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 22:35:55 -0500
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94632D84
        for <netdev@vger.kernel.org>; Sun,  1 Jan 2023 19:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1672630364;
    s=strato-dkim-0002; d=xenosoft.de;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=wH6ZUO7J0AcIxk2tWtudQmGG68BDM/GwIGysI7jFImo=;
    b=cuyVOCGQmhucqHo2nu4OSy99epbVxEov/5GuYvP8X7D6eWyz6ESBcG9FoDJQXo0SJj
    OB8gk1QueDdrgPkOmOCe2hNwBGNrvTqevFKl1f8todOs8fiLaStLvpnf4PY+hlRDsQhT
    E4saWVErlqi3pKDoYX9rRW3a+4hJQfq9PbKrqWLF53plBtluYeJ0emWFFNfYIdO0mX9c
    7aXUeeM2dji9yI9lqEm4b4Y6AIh7JUXfb8FC6rr+/3doT/IHydDVbk0b2BBTGld37xN0
    +C4ck51Gwu6ZOMPz0BBwQv4npNYW1KOinJ1tFKx37Dii2QvmqKbmVOsGah6yhGxW2DvI
    onDQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGM4l4Hio94KKxRySfLxnHfJ+Dkjp5DdBfio0GngadwjX4M5RB1pvK++FgVycZqCWMJGghA=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a02:8109:8980:4474:29da:718a:6882:44e8]
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id e28afdz023WgFTc
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 2 Jan 2023 04:32:42 +0100 (CET)
Message-ID: <8be26a07-3f48-cd61-1b74-1605827bfae3@xenosoft.de>
Date:   Mon, 2 Jan 2023 04:32:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [FSL P50x0] DPAA Ethernet issue
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
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
In-Reply-To: <a40020bd-c190-4283-1977-9e4d9627b888@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01 January 2023 at 07:11 pm, Sean Anderson wrote:

Thank you for testing this. Unfortunately, I have no P-series hardware,
so I was unable to test the 10gec/dtsec parts of this conversion. I had
hoped that this would get tested by someone with the hardware (at NXP)
before now, but it seems you get to be the "lucky" first user.

I see you have labeled one of your kernels as supporting QEMU.  Do you
happen to have instructions for running Linux on QEMU?

Can you try the following patch. I think my mail client will mangle it,  
so I have also attached it to this email.

------------

Hi Sean,

Thanks a lot for your answer.

I use the virtio-net device in a virtual e5500 QEMU/KVM HV machine. [1] [2]

I will test your patch as soon as possible.

Thanks,
Christian

[1] QEMU command: qemu-system-ppc64 -M ppce500 -cpu e5500 -m 1024 
-kernel uImage-6.2 -drive 
format=raw,file=void-live-powerpc-20220129.img,index=0,if=virtio -netdev 
user,id=mynet0 -device virtio-net,netdev=mynet0 -append "rw 
root=/dev/vda2" -device virtio-gpu -device virtio-mouse-pci -device 
virtio-keyboard-pci -device pci-ohci,id=newusb -audiodev 
id=sndbe,driver=pa,server=/run/user/1000/pulse/native -device 
usb-audio,bus=newusb.0 -enable-kvm -smp 4 -fsdev 
local,security_model=passthrough,id=fsdev0,path=/home/amigaone/Music 
-device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare

[2] https://forum.hyperion-entertainment.com/viewtopic.php?p=46749
