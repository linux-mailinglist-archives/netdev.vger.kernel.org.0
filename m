Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F5A2D47C3
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 18:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbgLIRVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 12:21:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728516AbgLIRVg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 12:21:36 -0500
Date:   Wed, 9 Dec 2020 09:20:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607534454;
        bh=g/Kd/BS1ET7SJJ66LTSQ46UrFPGUqs93R0VP9Me7D3w=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=KaKdRfwI/vFnIOz3taElE99Pjptc6hevLus1z3r4zZ4GHSXvihFyfMA7Pc4lvmhMB
         XTVInf+xQmOf9BKuO2WS/3uWRMgQrALAJZ/MMj/ulAJxSpGuHQSXdGNzp9KHVhBzs0
         NOMVaNr0lQyq3dk5DHsrG87nYx1dLz2tqk8fP5PzW2vEGd8c23e70C8EYFlHevwM6Q
         XyxVEPw/2ZLBjZRmIoEMfo0V/f2Io0TC63XqylIAplWHDA2W9ceyvQoP4Fi4Y10Za+
         tGp5+cYbywELpYt0fgf851ivV8FVyHqA8aJe00Y6PA9tHe+uLy9jW4DsTP3ganB8G4
         7VlG9ArlGeYgA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jianlin Shi <jishi@redhat.com>,
        CKI Project <cki-project@redhat.com>, netdev@vger.kernel.org,
        skt-results-master@redhat.com, Yi Zhang <yi.zhang@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        Jianwen Ji <jiji@redhat.com>, Hangbin Liu <haliu@redhat.com>,
        Ondrej Moris <omoris@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Changhui Zhong <czhong@redhat.com>,
        Xiong Zhou <xzhou@redhat.com>,
        Rachel Sibley <rasibley@redhat.com>,
        David Arcari <darcari@redhat.com>
Subject: Re: =?UTF-8?B?4p2M?= FAIL: Test report for kernel 5.10.0-rc6
 (mainline.kernel.org)
Message-ID: <20201209092052.19a39676@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CABE0yyj997uCwzHoob8q2Ckd2i5Pv1k+JDRbF3fnn11_R2XN1Q@mail.gmail.com>
References: <cki.4066A31294.UNMQ21P718@redhat.com>
        <CABE0yyi9gS8nao0n1Dts_Og80R71h8PUkizy4rM9E9E3QbJwvA@mail.gmail.com>
        <CABE0yyj997uCwzHoob8q2Ckd2i5Pv1k+JDRbF3fnn11_R2XN1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric, could this possibly be commit 4179b00c04d1 ("geneve: pull IP
header before ECN decapsulation")?

On Wed, 9 Dec 2020 10:05:14 +0800 Jianlin Shi wrote:
> Hi ,
>=20
> I reported a bug in bugzilla.kernel.org for geneve issue:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D210569
>=20
> Thanks & Best Regards,
> Jianlin Shi
>=20
>=20
> On Tue, Dec 8, 2020 at 9:38 AM Jianlin Shi <jishi@redhat.com> wrote:
> >
> > Hi ,
> >
> >
> > On Tue, Dec 8, 2020 at 8:25 AM CKI Project <cki-project@redhat.com> wro=
te: =20
> >>
> >>
> >> Hello,
> >>
> >> We ran automated tests on a recent commit from this kernel tree:
> >>
> >>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/to=
rvalds/linux.git
> >>             Commit: 7059c2c00a21 - Merge branch 'for-linus' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/dtor/input
> >>
> >> The results of these automated tests are provided below.
> >>
> >>     Overall result: FAILED (see details below)
> >>              Merge: OK
> >>            Compile: OK
> >>  Selftests compile: FAILED
> >>              Tests: FAILED
> >>
> >>     Pipeline: https://xci32.lab.eng.rdu2.redhat.com/cki-project/cki-pi=
peline/-/pipelines/619303
> >>
> >>     Check out our dashboard including known failures tagged by our bot=
 at
> >>       https://datawarehouse.internal.cki-project.org/kcidb/revisions/7=
748
> >>
> >> One or more kernel tests failed:
> >>
> >>     s390x:
> >>      =E2=9D=8C LTP
> >>      =E2=9D=8C Networking tunnel: geneve basic test
> >>
> >>     ppc64le:
> >>      =E2=9D=8C Boot test
> >>      =E2=9D=8C LTP
> >>      =E2=9D=8C Networking tunnel: geneve basic test
> >>
> >>     aarch64:
> >>      =E2=9D=8C storage: software RAID testing
> >>      =E2=9D=8C LTP
> >>      =E2=9D=8C Networking tunnel: geneve basic test
> >>
> >>     x86_64:
> >>      =E2=9D=8C LTP
> >>      =E2=9D=8C Networking tunnel: geneve basic test =20
> >
> >
> > the basic traffic over geneve would fail, could you help to check. Shou=
ld we report a bug or not?
> >
> >
> > ip netns add client
> >
> > ip netns add server
> >
> >
> >
> > ip link add veth0_c type veth peer name veth0_s
> >
> > ip link set veth0_c netns client
> >
> > ip link set veth0_s netns server
> >
> >
> >
> > ip netns exec client ip link set lo up
> >
> > ip netns exec client ip link set veth0_c up
> >
> >
> >
> > ip netns exec server ip link set lo up
> >
> > ip netns exec server ip link set veth0_s up
> >
> >
> >
> >
> >
> > ip netns exec client ip addr add 2000::1/64 dev veth0_c
> >
> > ip netns exec client ip addr add 10.10.0.1/24 dev veth0_c
> >
> >
> >
> > ip netns exec server ip addr add 2000::2/64 dev veth0_s
> >
> > ip netns exec server ip addr add 10.10.0.2/24 dev veth0_s
> >
> >
> >
> > ip netns exec client ping 10.10.0.2 -c 2
> >
> > ip netns exec client ping6 2000::2 -c 2
> >
> >
> >
> > ip netns exec client ip link add geneve1 type geneve vni 1234 remote 10=
.10.0.2 ttl 64
> >
> > ip netns exec server ip link add geneve1 type geneve vni 1234 remote 10=
.10.0.1 ttl 64
> >
> >
> >
> > ip netns exec client ip link set geneve1 up
> >
> > ip netns exec client ip addr add 1.1.1.1/24 dev geneve1
> >
> > ip netns exec server ip link set geneve1 up
> >
> > ip netns exec server ip addr add 1.1.1.2/24 dev geneve1
> > ip netns exec client ping 1.1.1.2 -c 3
> >
> > =20
> >>
> >>      =E2=9D=8C storage: software RAID testing
> >>
> >> We hope that these logs can help you find the problem quickly. For the=
 full
> >> detail on our testing procedures, please scroll to the bottom of this =
message.
> >>
> >> Please reply to this email if you have any questions about the tests t=
hat we
> >> ran or if you have any suggestions on how to make future tests more ef=
fective.
> >>
> >>         ,-.   ,-.
> >>        ( C ) ( K )  Continuous
> >>         `-',-.`-'   Kernel
> >>           ( I )     Integration
> >>            `-'
> >> ______________________________________________________________________=
________
> >>
> >> Compile testing
> >> ---------------
> >>
> >> We compiled the kernel for 4 architectures:
> >>
> >>     aarch64:
> >>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
> >>
> >>     ppc64le:
> >>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
> >>
> >>     s390x:
> >>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
> >>
> >>     x86_64:
> >>       make options: make -j30 INSTALL_MOD_STRIP=3D1 targz-pkg
> >>
> >>
> >> We built the following selftests:
> >>
> >>   x86_64:
> >>       net: OK
> >>       bpf: fail
> >>       install and packaging: OK
> >>
> >> You can find the full log (build-selftests.log) in the artifact storag=
e above.
> >>
> >>
> >> Hardware testing
> >> ----------------
> >> All the testing jobs are listed here:
> >>
> >>   https://beaker.engineering.redhat.com/jobs/?jobsearch-0.table=3DWhit=
eboard&jobsearch-0.operation=3Dcontains&jobsearch-0.value=3Dcki%40gitlab%3A=
619303
> >>
> >> We booted each kernel and ran the following tests:
> >>
> >>   aarch64:
> >>     Host 1: https://beaker.engineering.redhat.com/recipes/9156933
> >>        =E2=9C=85 Boot test
> >>        =E2=9C=85 selinux-policy: serge-testsuite
> >>        =E2=9D=8C storage: software RAID testing
> >>        =E2=9C=85 stress: stress-ng
> >>         =E2=9D=8C xfstests - ext4
> >>         =E2=9C=85 xfstests - xfs
> >>         =E2=9C=85 xfstests - btrfs
> >>         =E2=9D=8C IPMI driver test
> >>         =E2=9C=85 IPMItool loop stress test
> >>         =E2=9C=85 Storage blktests
> >>         =E2=9C=85 Storage block - filesystem fio test
> >>         =E2=9C=85 Storage block - queue scheduler test
> >>         =E2=9C=85 Storage nvme - tcp
> >>         =E2=9C=85 Storage: swraid mdadm raid_module test
> >>
> >>     Host 2: https://beaker.engineering.redhat.com/recipes/9156932
> >>        =E2=9C=85 Boot test
> >>        =E2=9C=85 ACPI table test
> >>        =E2=9C=85 ACPI enabled test
> >>        =E2=9D=8C LTP
> >>        =E2=9C=85 Loopdev Sanity
> >>        =E2=9C=85 Memory: fork_mem
> >>        =E2=9C=85 Memory function: memfd_create
> >>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
> >>        =E2=9C=85 Networking bridge: sanity
> >>        =E2=9C=85 Networking socket: fuzz
> >>        =E2=9C=85 Networking: igmp conformance test
> >>        =E2=9C=85 Networking route: pmtu
> >>        =E2=9C=85 Networking route_func - local
> >>        =E2=9C=85 Networking route_func - forward
> >>        =E2=9C=85 Networking TCP: keepalive test
> >>        =E2=9C=85 Networking UDP: socket
> >>        =E2=9D=8C Networking tunnel: geneve basic test
> >>        =E2=9C=85 Networking tunnel: gre basic
> >>        =E2=9C=85 L2TP basic test
> >>        =E2=9C=85 Networking tunnel: vxlan basic
> >>        =E2=9C=85 Networking ipsec: basic netns - transport
> >>        =E2=9C=85 Networking ipsec: basic netns - tunnel
> >>        =E2=9C=85 Libkcapi AF_ALG test
> >>        =E2=9C=85 pciutils: update pci ids test
> >>        =E2=9C=85 ALSA PCM loopback test
> >>        =E2=9C=85 ALSA Control (mixer) Userspace Element test
> >>        =E2=9C=85 storage: SCSI VPD
> >>         =E2=9C=85 CIFS Connectathon
> >>         =E2=9C=85 POSIX pjd-fstest suites
> >>         =E2=9C=85 Firmware test suite
> >>         =E2=9C=85 jvm - jcstress tests
> >>         =E2=9C=85 Memory function: kaslr
> >>         =E2=9C=85 Ethernet drivers sanity
> >>         =E2=9C=85 Networking firewall: basic netfilter test
> >>         =E2=9C=85 audit: audit testsuite test
> >>         =E2=9C=85 trace: ftrace/tracer
> >>         =E2=9C=85 kdump - kexec_boot
> >>
> >>   ppc64le:
> >>     Host 1: https://beaker.engineering.redhat.com/recipes/9156935
> >>        =E2=9D=8C Boot test
> >>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 selinux-policy: serge-testsuite
> >>        =E2=9A=A1=E2=9A=A1=E2=9A=A1 storage: software RAID testing
> >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - ext4
> >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - xfs
> >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 xfstests - btrfs
> >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
> >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
> >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
> >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - filesystem fio test
> >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - queue scheduler te=
st
> >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage nvme - tcp
> >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: swraid mdadm raid_module =
test
> >>
> >>     Host 2: https://beaker.engineering.redhat.com/recipes/9156934
> >>        =E2=9C=85 Boot test
> >>        =E2=9D=8C LTP
> >>        =E2=9C=85 Loopdev Sanity
> >>        =E2=9C=85 Memory: fork_mem
> >>        =E2=9C=85 Memory function: memfd_create
> >>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
> >>        =E2=9C=85 Networking bridge: sanity
> >>        =E2=9C=85 Networking socket: fuzz
> >>        =E2=9C=85 Networking route: pmtu
> >>        =E2=9C=85 Networking route_func - local
> >>        =E2=9C=85 Networking route_func - forward
> >>        =E2=9C=85 Networking TCP: keepalive test
> >>        =E2=9C=85 Networking UDP: socket
> >>        =E2=9D=8C Networking tunnel: geneve basic test
> >>        =E2=9C=85 Networking tunnel: gre basic
> >>        =E2=9C=85 L2TP basic test
> >>        =E2=9C=85 Networking tunnel: vxlan basic
> >>        =E2=9C=85 Networking ipsec: basic netns - tunnel
> >>        =E2=9C=85 Libkcapi AF_ALG test
> >>        =E2=9C=85 pciutils: update pci ids test
> >>        =E2=9C=85 ALSA PCM loopback test
> >>        =E2=9C=85 ALSA Control (mixer) Userspace Element test
> >>         =E2=9C=85 CIFS Connectathon
> >>         =E2=9C=85 POSIX pjd-fstest suites
> >>         =E2=9C=85 jvm - jcstress tests
> >>         =E2=9C=85 Memory function: kaslr
> >>         =E2=9C=85 Ethernet drivers sanity
> >>         =E2=9C=85 Networking firewall: basic netfilter test
> >>         =E2=9C=85 audit: audit testsuite test
> >>         =E2=9C=85 trace: ftrace/tracer
> >>
> >>   s390x:
> >>     Host 1: https://beaker.engineering.redhat.com/recipes/9156940
> >>        =E2=9C=85 Boot test
> >>        =E2=9C=85 selinux-policy: serge-testsuite
> >>        =E2=9C=85 stress: stress-ng
> >>         =E2=9C=85 Storage blktests
> >>         =E2=9D=8C Storage nvme - tcp
> >>         =E2=9C=85 Storage: swraid mdadm raid_module test
> >>
> >>     Host 2: https://beaker.engineering.redhat.com/recipes/9156939
> >>        =E2=9C=85 Boot test
> >>        =E2=9D=8C LTP
> >>        =E2=9C=85 Loopdev Sanity
> >>        =E2=9C=85 Memory: fork_mem
> >>        =E2=9C=85 Memory function: memfd_create
> >>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
> >>        =E2=9C=85 Networking bridge: sanity
> >>        =E2=9C=85 Networking route: pmtu
> >>        =E2=9C=85 Networking route_func - local
> >>        =E2=9C=85 Networking route_func - forward
> >>        =E2=9C=85 Networking TCP: keepalive test
> >>        =E2=9C=85 Networking UDP: socket
> >>        =E2=9D=8C Networking tunnel: geneve basic test
> >>        =E2=9C=85 Networking tunnel: gre basic
> >>        =E2=9C=85 L2TP basic test
> >>        =E2=9C=85 Networking tunnel: vxlan basic
> >>        =E2=9C=85 Networking ipsec: basic netns - transport
> >>        =E2=9C=85 Networking ipsec: basic netns - tunnel
> >>        =E2=9C=85 Libkcapi AF_ALG test
> >>         =E2=9C=85 CIFS Connectathon
> >>         =E2=9C=85 POSIX pjd-fstest suites
> >>         =E2=9C=85 jvm - jcstress tests
> >>         =E2=9C=85 Memory function: kaslr
> >>         =E2=9C=85 Ethernet drivers sanity
> >>         =E2=9C=85 Networking firewall: basic netfilter test
> >>         =E2=9D=8C audit: audit testsuite test
> >>         =E2=9C=85 trace: ftrace/tracer
> >>
> >>   x86_64:
> >>     Host 1: https://beaker.engineering.redhat.com/recipes/9156936
> >>        =E2=9C=85 Boot test
> >>        =E2=9C=85 ACPI table test
> >>        =E2=9D=8C LTP
> >>        =E2=9C=85 Loopdev Sanity
> >>        =E2=9C=85 Memory: fork_mem
> >>        =E2=9C=85 Memory function: memfd_create
> >>        =E2=9C=85 AMTU (Abstract Machine Test Utility)
> >>        =E2=9C=85 Networking bridge: sanity
> >>        =E2=9C=85 Networking socket: fuzz
> >>        =E2=9C=85 Networking: igmp conformance test
> >>        =E2=9C=85 Networking route: pmtu
> >>        =E2=9C=85 Networking route_func - local
> >>        =E2=9C=85 Networking route_func - forward
> >>        =E2=9C=85 Networking TCP: keepalive test
> >>        =E2=9C=85 Networking UDP: socket
> >>        =E2=9D=8C Networking tunnel: geneve basic test
> >>        =E2=9C=85 Networking tunnel: gre basic
> >>        =E2=9C=85 L2TP basic test
> >>        =E2=9C=85 Networking tunnel: vxlan basic
> >>        =E2=9C=85 Networking ipsec: basic netns - transport
> >>        =E2=9C=85 Networking ipsec: basic netns - tunnel
> >>        =E2=9C=85 Libkcapi AF_ALG test
> >>        =E2=9C=85 pciutils: sanity smoke test
> >>        =E2=9C=85 pciutils: update pci ids test
> >>        =E2=9C=85 ALSA PCM loopback test
> >>        =E2=9C=85 ALSA Control (mixer) Userspace Element test
> >>        =E2=9C=85 storage: SCSI VPD
> >>         =E2=9C=85 CIFS Connectathon
> >>         =E2=9C=85 POSIX pjd-fstest suites
> >>         =E2=9C=85 Firmware test suite
> >>         =E2=9C=85 jvm - jcstress tests
> >>         =E2=9C=85 Memory function: kaslr
> >>         =E2=9C=85 Ethernet drivers sanity
> >>         =E2=9C=85 Networking firewall: basic netfilter test
> >>         =E2=9C=85 audit: audit testsuite test
> >>         =E2=9C=85 trace: ftrace/tracer
> >>         =E2=9C=85 kdump - kexec_boot
> >>
> >>     Host 2: https://beaker.engineering.redhat.com/recipes/9156937
> >>        =E2=9C=85 Boot test
> >>         =E2=9C=85 kdump - sysrq-c
> >>         =E2=9C=85 kdump - file-load
> >>
> >>     Host 3: https://beaker.engineering.redhat.com/recipes/9156938
> >>
> >>        =E2=9A=A1 Internal infrastructure issues prevented one or more =
tests (marked
> >>        with =E2=9A=A1=E2=9A=A1=E2=9A=A1) from running on this architec=
ture.
> >>        This is not the fault of the kernel that was tested.
> >>
> >>        =E2=9C=85 Boot test
> >>        =E2=9C=85 selinux-policy: serge-testsuite
> >>        =E2=9D=8C storage: software RAID testing
> >>        =E2=9C=85 stress: stress-ng
> >>         =E2=9D=8C CPU: Frequency Driver Test
> >>         =E2=9C=85 CPU: Idle Test
> >>         =E2=9D=8C xfstests - ext4
> >>         =E2=9C=85 xfstests - xfs
> >>         =E2=9C=85 xfstests - btrfs
> >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMI driver test
> >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 IPMItool loop stress test
> >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 power-management: cpupower/sanity =
test
> >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage blktests
> >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - filesystem fio test
> >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage block - queue scheduler te=
st
> >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage nvme - tcp
> >>         =E2=9A=A1=E2=9A=A1=E2=9A=A1 Storage: swraid mdadm raid_module =
test
> >>
> >>   Test sources: https://gitlab.com/cki-project/kernel-tests
> >>     Pull requests are welcome for new tests or improvements to existin=
g tests!
> >>
> >> Aborted tests
> >> -------------
> >> Tests that didn't complete running successfully are marked with =E2=9A=
=A1=E2=9A=A1=E2=9A=A1.
> >> If this was caused by an infrastructure issue, we try to mark that
> >> explicitly in the report.
> >>
> >> Waived tests
> >> ------------
> >> If the test run included waived tests, they are marked with . Such tes=
ts are
> >> executed but their results are not taken into account. Tests are waive=
d when
> >> their results are not reliable enough, e.g. when they're just introduc=
ed or are
> >> being fixed.
> >>
> >> Testing timeout
> >> ---------------
> >> We aim to provide a report within reasonable timeframe. Tests that hav=
en't
> >> finished running yet are marked with =E2=8F=B1.
> >>
> >> Reproducing results
> >> -------------------
> >> Click on a link below to access a web page that allows you to adjust t=
he
> >> Beaker job and re-run any failed tests. These links are generated for
> >> failed or aborted tests that are not waived. Please adjust the Beaker
> >> job whiteboard string in the web page so that it is easy for you to fi=
nd
> >> and so that it is not confused with a regular CKI job.
> >>
> >> After clicking the "Submit the job!" button, a dialog will open that s=
hould
> >> contain a link to the newly submitted Beaker job.
> >>
> >>   https://beaker-respin.internal.cki-project.org/respin?whiteboard=3Dr=
espin_job_4794082&recipe_id=3D9156933&recipe_id=3D9156932&job_id=3D4794082
> >>   https://beaker-respin.internal.cki-project.org/respin?whiteboard=3Dr=
espin_job_4794083&recipe_id=3D9156935&recipe_id=3D9156934&job_id=3D4794083
> >>   https://beaker-respin.internal.cki-project.org/respin?whiteboard=3Dr=
espin_job_4794085&recipe_id=3D9156939&job_id=3D4794085
> >>   https://beaker-respin.internal.cki-project.org/respin?whiteboard=3Dr=
espin_job_4794084&recipe_id=3D9156936&recipe_id=3D9156938&job_id=3D4794084
> >> =20
>=20

