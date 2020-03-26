Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 079731936A1
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 04:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbgCZDSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 23:18:16 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:43333 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbgCZDSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 23:18:16 -0400
Received: by mail-qv1-f68.google.com with SMTP id c28so2254407qvb.10
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 20:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=z0xH10P8BnZnQGUDog+F8lcoSLv4AUNCDo7n53LZO/o=;
        b=NFj3Uqo2m9dTgjTtYSvC3gHE0YxrlC91vwx1ILOFKTd+C/1u74OmkHcs005vy82Sio
         1IvA7is5XU0F7SYzCzyxlXTLuIcWYwXgRP83SUcClJxQLGB/kr3QYOLbu5inbVM1Vqfe
         Wk9kJVLVey+Ggr3cawSySJAcv4NFHrKonQ7DahXgHJNb/VjUXF4Y/YmrTvzNKjFOlq18
         kCKDfZRXHse5Tfj0NgHZfHMUV+lr2WXkGt0WimCvd4FSdaLAL0Vak7yXos7hR4p198PR
         LqS1Wm6hzVlW8FHV+hQD/bGFtw6WVAo48xUD6WOsH/ciesYGjfeZhVVGxsGtcfXCeOcz
         3/Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=z0xH10P8BnZnQGUDog+F8lcoSLv4AUNCDo7n53LZO/o=;
        b=ToN8Z8EDl9/KvScRrXBzxBX4I6o7xmPnhM8RbV4NFVv3TWj58hHSfdPlLWFjZqWxmf
         aIfpX0vF/zgAU0XkNASN8qiGT6FVwaT3IKTulSR5wfbYDNNOw3ljRW3BqEgOc+iqpI2s
         grDGWzpdVtRI+fNiP+NHWnJ3/AfddJ/c5cmFMR3A02wMlHWNdeFD+dTd1VGGpe3gnsje
         WN9dIB49M2hzeu6W/kEHTSjizwIy5GPr6SPsawR/giuqydCJGHSB+AsljRbkIVXPXSzl
         OOYb9VrKt9otcDbWd4WlTxyZl7yGz/7E76LN4ZbLUfRJwyQLsw5SOa55UpU5OwKl7pHZ
         IoYA==
X-Gm-Message-State: ANhLgQ3/8Cv/VL/RMAqszGBTM8uvOG3vhwuv8A7C49cy6aQQjqoqOWPQ
        DiClsHRs301Gb1ENPAIH8Rkuck1XRbt7ng==
X-Google-Smtp-Source: ADFU+vtc5cV2NiCPmhAh8h86lzFE7U7sTvFWRo0L5vr8iXQNGIZknAICdioyngLKyoHnYHlOlxT8PQ==
X-Received: by 2002:ad4:4564:: with SMTP id o4mr6051101qvu.190.1585192695066;
        Wed, 25 Mar 2020 20:18:15 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id u4sm612138qka.35.2020.03.25.20.18.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Mar 2020 20:18:14 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: No networking due to "net/mlx5e: Add support for devlink-port in
 non-representors mode"
From:   Qian Cai <cai@lca.pw>
In-Reply-To: <6b539e30f4a610b2476fde1c637c31db36fb1e92.camel@mellanox.com>
Date:   Wed, 25 Mar 2020 23:18:12 -0400
Cc:     Moshe Shemesh <moshe@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Parav Pandit <parav@mellanox.com>,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <90C3FFD4-C7E9-4B93-99E1-F1980EAA246D@lca.pw>
References: <0DF043A6-F507-4CB4-9764-9BD472ABCF01@lca.pw>
 <52874e86-a8ae-dcf0-a798-a10e8c97d09e@mellanox.com>
 <483B11FF-4004-4909-B89A-06CA48E3BBBC@lca.pw>
 <6b539e30f4a610b2476fde1c637c31db36fb1e92.camel@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 25, 2020, at 8:17 PM, Saeed Mahameed <saeedm@mellanox.com> =
wrote:
>=20
> On Wed, 2020-03-25 at 16:25 -0400, Qian Cai wrote:
>>> On Mar 25, 2020, at 3:33 PM, Moshe Shemesh <moshe@mellanox.com>
>>> wrote:
>>>=20
>>>=20
>>> On 3/25/2020 6:01 AM, Qian Cai wrote:
>>>> Reverted the linux-next commit c6acd629ee (=E2=80=9Cnet/mlx5e: Add
>>>> support for devlink-port in non-representors mode=E2=80=9D)
>>>> and its dependencies,
>>>>=20
>>>> 162add8cbae4 (=E2=80=9Cnet/mlx5e: Use devlink virtual flavour for =
VF
>>>> devlink port=E2=80=9D)
>>>> 31e87b39ba9d (=E2=80=9Cnet/mlx5e: Fix devlink port register =
sequence=E2=80=9D)
>>>>=20
>>>> on the top of next-20200324 allowed NICs to obtain an IPv4
>>>> address from DHCP again.
>>>=20
>>> These patches should not interfere DHCP.
>>>=20
>>> You might have dependencies on interface name which was changed by
>>> this patch, please check.
>>=20
>> Yes,
>>=20
>> Before,
>> [  238.225149][ T2021] mlx5_core 0000:0b:00.1 enp11s0f1: renamed from
>> eth1
>> [  238.511324][ T2035] mlx5_core 0000:0b:00.0 enp11s0f0: renamed from
>> eth0
>>=20
>> Now,
>> [  234.448420][ T2013] mlx5_core 0000:0b:00.1 enp11s0f1np1: renamed
>> from eth1
>> [  234.664236][ T2042] mlx5_core 0000:0b:00.0 enp11s0f0np0: renamed
>> from eth0
>>=20
>=20
> it is not a good idea to use the interface name as a unique =
identifier,
> this is not resilient for kernel updates or configuration updates, e.g
> installing an extra card
>=20
> Just use the HW mac address as a unique identifier in the network=20
> scripts:
>=20
> from [1]:
> HWADDR=3DMAC-address
> where MAC-address is the hardware address of the Ethernet device in =
the
> form AA:BB:CC:DD:EE:FF. This directive must be used in machines
> containing more than one NIC to ensure that the interfaces are =
assigned
> the correct device names regardless of the configured load order for
> each NIC's module.=20
>=20
> [1]=20
> =
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/h=
tml/deployment_guide/s1-networkscripts-interfaces

Is it really necessary to cause a device naming change?

The installer/NetworkManager here (annaconda) will create those files =
automatically.
They don=E2=80=99t usually use hard-coded HWADDR. Ironically, it is =
RHEL-8.1.

# cat /etc/sysconfig/network-scripts/ifcfg-enp11s0f0
# Generated by dracut initrd
NAME=3D"enp11s0f0"
DEVICE=3D"enp11s0f0"
ONBOOT=3Dyes
NETBOOT=3Dyes
UUID=3D"be2237f3-e40b-4404-be6c-bcb484dbebf6"
IPV6INIT=3Dyes
BOOTPROTO=3Ddhcp
TYPE=3DEthernet

# cat /etc/sysconfig/network-scripts/ifcfg-enp11s0f1
TYPE=3DEthernet
PROXY_METHOD=3Dnone
BROWSER_ONLY=3Dno
BOOTPROTO=3Ddhcp
DEFROUTE=3Dyes
IPV4_FAILURE_FATAL=3Dno
IPV6INIT=3Dyes
IPV6_AUTOCONF=3Dyes
IPV6_DEFROUTE=3Dyes
IPV6_FAILURE_FATAL=3Dno
IPV6_ADDR_GEN_MODE=3Dstable-privacy
NAME=3Denp11s0f1
UUID=3D400773fc-5436-4a85-9cee-a8e18cee9230
DEVICE=3Denp11s0f1
ONBOOT=3Dno

Imagining a kernel update from enterprise distros contain those patches =
which
would break all those existing setup. It is trivial for me to fix =
myself, but it could
be a different story for those customers with thousand of machines need =
to
change.

