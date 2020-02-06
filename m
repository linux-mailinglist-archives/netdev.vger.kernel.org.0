Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E74BA154626
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 15:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgBFO3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 09:29:18 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:14371 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgBFO3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 09:29:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1580999352;
        s=strato-dkim-0002; d=xenosoft.de;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=m8YS/QWbAuZBVFtsr7hO2HWlKHxq+32ds22S6vZN0aA=;
        b=MMJWRxMh6w08cNpQE/KwR0w8XR3oHhN/B90wsVFBhEP+nBNStmZLfGJzu0UhhN7Ge0
        iAsAm6H9+z7MTHFVjFckOHyaWfBVhHDckrGGTr36z3M5qtjz7DMicTcAcaEOCwW9lrDi
        qNObG1hnJCTryl00I90pbnbBUj5o++X/w5QnMAsvQuCMcmZnfE2Lvhu1q44hMazQDuPM
        pYoPWne6GS33PNOoTVHU36MoVuqo+14s9ce+wH8qhslqSjFGyl3vJbaWWQB3oJY/fZyW
        OFBgGY3QnTxT+fmmgHZQ7OEPg7G4xSyDNThhDssyxAqJSplQyStWdCoRw6DM/ekboBrx
        Y64g==
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGM4l4Hio94KKxRySfLxnHfJ+Dkjp5DdBJSrwuuqxvPhaLukTGHvIso26evMpB0Xs05Kjiw=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a02:8109:89c0:ebfc:9861:356d:d6ca:1eb6]
        by smtp.strato.de (RZmta 46.1.12 AUTH)
        with ESMTPSA id 40bcf3w16ESKZZ7
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Thu, 6 Feb 2020 15:28:20 +0100 (CET)
Subject: Re: Latest Git kernel: avahi-daemon[2410]: ioctl(): Inappropriate
 ioctl for device
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        DTML <devicetree@vger.kernel.org>,
        Darren Stevens <darren@stevens-zone.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev@ozlabs.org, "contact@a-eon.com" <contact@a-eon.com>,
        "R.T.Dickinson" <rtd2@xtra.co.nz>, Christoph Hellwig <hch@lst.de>,
        mad skateman <madskateman@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20200203095325.24c3ab1c@cakuba.hsd1.ca.comcast.net>
 <C11859E1-BE71-494F-81E2-9B27E27E60EE@xenosoft.de>
 <87tv441gg1.fsf@mpe.ellerman.id.au>
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
Message-ID: <f438e4ed-7746-1d80-6d72-455281884a1e@xenosoft.de>
Date:   Thu, 6 Feb 2020 15:28:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <87tv441gg1.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: de-DE
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06 February 2020 at 05:35 am, Michael Ellerman wrote:
> Christian Zigotzky <chzigotzky@xenosoft.de> writes:
>> Kernel 5.5 PowerPC is also affected.
> I don't know what you mean by that. What sha are you talking about?
>
> I have a system with avahi running and everything's fine.
>
>    # grep use- /etc/avahi/avahi-daemon.conf
>    use-ipv4=yes
>    use-ipv6=yes
>    
>    # systemctl status -l --no-pager avahi-daemon
>    ● avahi-daemon.service - Avahi mDNS/DNS-SD Stack
>       Loaded: loaded (/lib/systemd/system/avahi-daemon.service; enabled; vendor preset: enabled)
>       Active: active (running) since Thu 2020-02-06 14:55:34 AEDT; 38min ago
>     Main PID: 1884 (avahi-daemon)
>       Status: "avahi-daemon 0.7 starting up."
>       CGroup: /system.slice/avahi-daemon.service
>               ├─1884 avahi-daemon: running [mpe-ubuntu-le.local]
>               └─1888 avahi-daemon: chroot helper
>    
>    Feb 06 14:55:34 mpe-ubuntu-le avahi-daemon[1884]: Registering new address record for fe80::5054:ff:fe66:2a19 on eth0.*.
>    Feb 06 14:55:34 mpe-ubuntu-le avahi-daemon[1884]: Registering new address record for 10.61.141.81 on eth0.IPv4.
>    Feb 06 14:55:34 mpe-ubuntu-le avahi-daemon[1884]: Registering new address record for ::1 on lo.*.
>    Feb 06 14:55:34 mpe-ubuntu-le avahi-daemon[1884]: Registering new address record for 127.0.0.1 on lo.IPv4.
>    Feb 06 14:55:34 mpe-ubuntu-le systemd[1]: Started Avahi mDNS/DNS-SD Stack.
>    Feb 06 14:55:35 mpe-ubuntu-le avahi-daemon[1884]: Server startup complete. Host name is mpe-ubuntu-le.local. Local service cookie is 3972418141.
>    Feb 06 14:55:38 mpe-ubuntu-le avahi-daemon[1884]: Leaving mDNS multicast group on interface eth0.IPv6 with address fe80::5054:ff:fe66:2a19.
>    Feb 06 14:55:38 mpe-ubuntu-le avahi-daemon[1884]: Joining mDNS multicast group on interface eth0.IPv6 with address fd69:d75f:b8b5:61:5054:ff:fe66:2a19.
>    Feb 06 14:55:38 mpe-ubuntu-le avahi-daemon[1884]: Registering new address record for fd69:d75f:b8b5:61:5054:ff:fe66:2a19 on eth0.*.
>    Feb 06 14:55:38 mpe-ubuntu-le avahi-daemon[1884]: Withdrawing address record for fe80::5054:ff:fe66:2a19 on eth0.
>    
>    # uname -r
>    5.5.0-gcc-8.2.0
>
>
> The key question is what ioctl is it complaining about. You should be
> able to find that via strace.
>
> cheers
>
Hello Michael,

Sorry it isn't true that the kernel 5.5 is also affected. A Power Mac G5 
user told me that but this isn't correct. I compiled and tested the 
stable kernel 5.5.1 and 5.5.2 today and both kernels don't have the 
issue with the avahi daemon.
Could you please also test the latest Git kernel?

strace /usr/sbin/avahi-daemon

...
poll([{fd=4, events=POLLIN}, {fd=16, events=POLLIN}, {fd=15, 
events=POLLIN}, {fd=14, events=POLLIN}, {fd=13, events=POLLIN}, {fd=12, 
events=POLLIN}, {fd=11, events=POLLIN}, {fd=10, events=POLLIN}, {fd=9, 
events=POLLIN}, {fd=8, events=POLLIN}, {fd=6, events=POLLIN}], 11, 65) = 
2 ([{fd=12, revents=POLLIN}, {fd=9, revents=POLLIN}])
ioctl(12, FIONREAD, 0xffba6f24)         = -1 ENOTTY (Inappropriate ioctl 
for device)
write(2, "ioctl(): Inappropriate ioctl for"..., 39ioctl(): Inappropriate 
ioctl for device) = 39
write(2, "\n", 1
)                       = 1
...

Thanks,
Christian
