Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C1C2A1DAA
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 12:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgKALuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 06:50:08 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5244 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbgKALuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 06:50:07 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9ea0f90001>; Sun, 01 Nov 2020 03:50:17 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 1 Nov
 2020 11:50:05 +0000
Date:   Sun, 1 Nov 2020 13:50:02 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     wenxu <wenxu@ucloud.cn>
CC:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: mlx5_vdpa problem
Message-ID: <20201101115002.GA33117@mtl-vdi-166.wap.labs.mlnx>
References: <401b2eb1-f77b-f7d5-8d6f-03ec30e81d6a@ucloud.cn>
 <258f86a8-d6ae-010a-11f8-c155b1df4723@ucloud.cn>
 <20201029124544.GC139728@mtl-vdi-166.wap.labs.mlnx>
 <40968d30-f4c4-5f9c-5c6c-fe3d7e5571a3@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <40968d30-f4c4-5f9c-5c6c-fe3d7e5571a3@ucloud.cn>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604231417; bh=poGeaVtitzxBx8vsgA9ufPmyC19uN02LHmcdqwEv5Jc=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:Content-Transfer-Encoding:
         In-Reply-To:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=ZJXwK+LZCku2AlbtGIT4Hqfl7Y9CzSf9Y0f/QyF0zz9cVGaqpq9dqoKpGIHWFzoAH
         q2e2Q1ovbB8qu4OjqbV6K5TRXW9BjayzlPJe9r8h+ndov6JsRYB7uR+0T7z8EbDD7r
         kUIIiWsfAGAzapBkTMcVJqmMmjv4mmBaZXkmrvlVXaFUSaX6oFmNsTcZNhWe3LvOpi
         Vm2OkIAfSEGU3g5ZvsSMHuGTCSnPJhzbC1jPG4X7whXWxLhMfefLhq/34fw+7R+fj/
         LUU/WGnHR8kDXeV0wWoUwA/ToD1B2ul50RMfsnpc8T7aCuH6SeCUl1bQQZ7y9bQbr9
         GKwmT2JN2ubEg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 03:50:21PM +0800, wenxu wrote:
> Hi Eli,
>=20
>=20
> Thanks for your reply.
>=20
>=20
> I update the firmware to the lasted one
>=20
> firmware-version: 22.28.4000 (MT_0000000430)
>=20
>=20
> I find there are the same problems as my description.
>=20
> It is the same for the test what your suggestion.
>=20
> I did the experiment with two hosts so the host the
> representor for your VF and the uplink representor are connected to an
> ovs switch and other host is configured with ip address 10.0.0.7/24.
>=20
> And the ovs enable hw-offload, So the packet don't go through rep port of=
 VF.
> But there are the same problems. I think it maybe a FW bug. Thx.

I will refer you to firmware engineer to work with.

>=20
> On 10/29/2020 8:45 PM, Eli Cohen wrote:
> > On Thu, Oct 22, 2020 at 06:40:56PM +0800, wenxu wrote:
> >
> > Please make sure your firmware is updated.
> >
> > https://www.mellanox.com/support/firmware/connectx6dx
> >
> >> Hi mellanox team,
> >>
> >>
> >> I test the mlx5 vdpa=A0 in linux-5.9 and meet several problem.
> >>
> >>
> >> # lspci | grep Ether | grep Dx
> >> b3:00.0 Ethernet controller: Mellanox Technologies MT2892 Family [Conn=
ectX-6 Dx]
> >> b3:00.1 Ethernet controller: Mellanox Technologies MT2892 Family [Conn=
ectX-6 Dx]
> >>
> >> # ethtool -i net2
> >> driver: mlx5e_rep
> >> version: 5.9.0
> >> firmware-version: 22.28.1002 (MT_0000000430)
> >> expansion-rom-version:
> >> bus-info: 0000:b3:00.0
> >> supports-statistics: yes
> >> supports-test: no
> >> supports-eeprom-access: no
> >> supports-register-dump: no
> >> supports-priv-flags: no
> >>
> >>
> >> init switchdev:
> >>
> >>
> >> # echo 1 > /sys/class/net/net2/device/sriov_numvfs
> >> # echo 0000:b3:00.2 > /sys/bus/pci/drivers/mlx5_core/unbind
> >> # devlink dev eswitch set pci/0000:b3:00.0=A0 mode switchdev encap ena=
ble
> >>
> >> # modprobe vdpa vhost-vdpa mlx5_vdpa
> >>
> >> # ip l set dev net2 vf 0 mac 52:90:01:00:02:13
> >> # echo 0000:b3:00.2 > /sys/bus/pci/drivers/mlx5_core/bind
> >>
> >>
> >> setup vm:
> >>
> >> # qemu-system-x86_64 -name test=A0 -enable-kvm -smp 16,sockets=3D2,cor=
es=3D8,threads=3D1 -m 8192 -drive file=3D./centos7.qcow2,format=3Dqcow2,if=
=3Dnone,id=3Ddrive-virtio-disk0 -device virtio-blk-pci,scsi=3Doff,bus=3Dpci=
.0,addr=3D0x7,drive=3Ddrive-virtio-disk0,id=3Dvirtio-disk0,bootindex=3D1 -n=
etdev type=3Dvhost-vdpa,vhostdev=3D/dev/vhost-vdpa-0,id=3Dvhost-vdpa0 -devi=
ce virtio-net-pci,netdev=3Dvhost-vdpa0,page-per-vq=3Don,iommu_platform=3Don=
,id=3Dnet0,bus=3Dpci.0,addr=3D0x3,disable-legacy=3Don -vnc 0.0.0.0:0
> >>
> >>
> >> In the vm:=A0 virtio net device=A0 eth0 with ip address 10.0.0.75/24
> >>
> >> On the host: VF0 rep device pf0vf0 with ip address 10.0.0.7/24
> >>
> >>
> >> problem 1:
> >>
> >> On the host:
> >>
> >> # ping 10.0.0.75
> >>
> >> Some times there will be loss packets.
> >>
> >> And in the VM:
> >>
> >> dmesg shows:
> >>
> >> eth0: bad tso: type 100, size: 0
> >>
> >> eth0: bad tso: type 10, size: 28
> >>
> >>
> >> So I think maybe the vnet header is not init with 0?=A0 And Then I cle=
ar the gso_type, gso_size and flags in the virtio_net driver.=A0 There is n=
o packets dropped.
> >>
> >>
> >> problem 2:
> >>
> >> In the vm: iperf -s
> >>
> >> On the host: iperf -c 10.0.0.75 -t 100 -i 2.
> >>
> >>
> >> The tcp connection can't established for the syn+ack with partail cum =
but not handle correct by hardware.
> >>
> >> After I set the csum off=A0 for eth0 in the vm, the problem is resolve=
d. Although the mlx5_vnet support VIRTIO_NET_F_CSUM feature.
> >>
> >>
> >>
> >> problem 3:
> >>
> >>
> >> The iperf perofrmance not stable before I disable the pf0vf0 tso offlo=
ad
> >>
> >> #ethtool -K pf0vf0 tso off
> >>
> >>
> >> I know the mlx5_vnet did not support feature VIRTIO_NET_F_GUEST_TSO4. =
But the hardware can't=A0 cut the big tso packet to several small tcp packe=
t and send to virtio=A0 net device?
> >>
> >>
> >>
> >>
> >> BR
> >>
> >> wenxu
> >>
> >>
> >>
