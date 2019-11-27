Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E117810AD1F
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 11:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfK0KCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 05:02:09 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35078 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfK0KCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 05:02:08 -0500
Received: by mail-lf1-f67.google.com with SMTP id r15so13706374lff.2
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 02:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=EY4H80pYKzfm6qV5UPHRTU6m7PSm9enhWlVJXB84wb0=;
        b=vc9glajPpy6mgZ0yHifMD7DYC8Kd/LxZnjhzsKohQMPXjC8JLB2poLT+4eojc65qo6
         zFcP8luSrvIiJBhkVoPq1CfCGXH2qiaCD0gljPUWa7s0a61pz3TNzDpJvCEf3h9WIYok
         mPa+y3DvBIq2HQM2phgpWclDId8qxiBnUl4uqN7RqwXiyeSfdxlTTVNFvxhIBqtIn75v
         w0DoYWF0CnX+LZWnf7H1plq583MEIVqEIDEQoQ7gGJvYWrFr3W0zxOSReVumlLIh3k8C
         +Vbs51zZ1R9Bf43yxrXatmcudquBQoV7mIvjliF9Nv+g/Hr50Ndgm49yn4SVYSh6ddFE
         0BPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=EY4H80pYKzfm6qV5UPHRTU6m7PSm9enhWlVJXB84wb0=;
        b=ZEXDrC68ZFuxDughgY/CSsyknYpLiBQFm0c6TSaeDpqEDCjch4X6meZuR1wYclHz22
         KxP4o9B1j99LGibeAnPCu20xERU4xc3DvqFH/Ph2/r7AsFrQLbk1MgbhTwMCFeAN2kKZ
         PMq5+73tzP9/PB3mr97aFJT/LZJSiB86dfD+GYHKJNy0TsY5MXoXTjEm3h9V8eXwcUCE
         u1TP7YkwdiMNPfXbSy+JATyQsoeLEZVNInb0O2sIP0v8oMifVoMPGHfOwZYRV1Fyo+1v
         6w1G9PQOKZtm9E68mD26XJ70umslhtbRF1Y5u701GZRk3mQJMpm9A5GJlyefxD6Wf20e
         EujA==
X-Gm-Message-State: APjAAAVrmfIJvxcIulKZc+BnGv/bV8rqdDUJpjApr3B3VJIjMofmvQzk
        J7qZ35Uea2ahtlDJ7PvoMXvyvuUwzVkCgms5SAguYNIt2JQ=
X-Google-Smtp-Source: APXvYqzllpI/nj+sdxunC5MqF9gCtlPe+vBQi4t9tGvv3YdmTcnl19BUY36EzMozzs8Hu4upWJFyVzfuGyngH0fH600=
X-Received: by 2002:a19:f811:: with SMTP id a17mr27529288lff.132.1574848925236;
 Wed, 27 Nov 2019 02:02:05 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 27 Nov 2019 15:31:53 +0530
Message-ID: <CA+G9fYvom-=jCpGTNck+hSQm8xZgOt6EegWrJifvrbrx=rpGvg@mail.gmail.com>
Subject: mainline-5.4.0: regressions detected in project mainline
To:     Netdev <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Cc:     Shuah Khan <shuah@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kafai@fb.com,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        andriin@fb.com, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Results from Linaro=E2=80=99s test farm.
Regressions on arm64, arm, x86_64, and i386.
The listed bpf tests failed. please find complete details below.

Summary
------------------------------------------------------------------------

kernel: 5.4.0
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t
git branch: master
git commit: 386403a115f95997c2715691226e11a7b5cffcfd
git describe: v5.4-3419-g386403a115f9
Test details: https://qa-reports.linaro.org/lkft/linux-mainline-oe/build/v5=
.4-3419-g386403a115f9
config: http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei=
7-64/lkft/linux-mainline/2270/config

Regressions (compared to build v5.4)
------------------------------------------------------------------------
  kselftest:
    * bpf_test_dev_cgroup
    * bpf_test_skb_cgroup_id.sh
    * bpf_test_sysctl
    * bpf_test_xdp_meta.sh
    * bpf_test_xdp_redirect.sh
    * bpf_test_xdp_vlan_mode_generic.sh
    * bpf_test_xdp_vlan_mode_native.sh

Test output log:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
# selftests bpf test_dev_cgroup
bpf: test_dev_cgroup_ #
# libbpf failed to open ./dev_cgroup.o No such file or directory
failed: to_open #
# Failed to load DEV_CGROUP program
to: load_DEV_CGROUP #
[   75.524368] IPv6: ADDRCONF(NETDEV_CHANGE): test_sock_addr1: link
becomes ready
[FAIL] 9 selftests bpf test_dev_cgroup # exit=3D1
selftests: bpf_test_dev_cgroup [FAIL]

=3D=3D=3D
# selftests bpf test_skb_cgroup_id.sh
bpf: test_skb_cgroup_id.sh_ #
# Wait for testing link-local IP to become available ... OK
for: testing_link-local #
# Error opening object ./test_skb_cgroup_id_kern.o No such file or director=
y
opening: object_./test_skb_cgroup_id_kern.o #
# Cannot initialize ELF context!
initialize: ELF_context! #
# Unable to load program
to: load_program #
[FAIL] 33 selftests bpf test_skb_cgroup_id.sh # exit=3D1
selftests: bpf_test_skb_cgroup_id.sh [FAIL]

=3D=3D=3D
# selftests bpf test_sysctl
bpf: test_sysctl_ #
# libbpf failed to open ./test_sysctl_prog.o No such file or directory
failed: to_open #
# (test_sysctl.c1490 errno No such file or directory) >>> Loading
program (./test_sysctl_prog.o) error.
errno: No_suc[   78.078283] ip (1336) used greatest stack depth: 11144
bytes left
h #
#
: _ #
# libbpf failed to open ./test_sysctl_prog.o No such file or directory
failed: to_open #
# (test_sysctl.c1490 errno No such file or directory) >>> Loading
program (./test_sysctl_prog.o) error.
errno: No_such #
#
: _ #
# libbpf failed to open ./test_sysctl_prog.o No such file or directory
failed: to_open #
# (test_sysctl.c1490 errno No such file or directory) >>> Loading
program (./test_sysctl_prog.o) error.
errno: No_such #

...
37: PASSED,_3 #
[FAIL] 20 selftests bpf test_sysctl # exit=3D255
selftests: bpf_test_sysctl [FAIL]

=3D=3D=3D
# selftests bpf test_xdp_meta.sh
bpf: test_xdp_meta.sh_ #
# Error opening object test_xdp_meta.o No such file or directory
opening: object_test_xdp_meta.o #
# Cannot initialize ELF context!
initialize: ELF_context! #
# Unable to load program
to: load_program #
# selftests test_xdp_meta [FAILED]
test_xdp_meta: [FAILED]_ #
[FAIL] 26 selftests bpf test_xdp_meta.sh # exit=3D1
selftests: bpf_test_xdp_meta.sh [FAIL]

=3D=3D=3D
# selftests bpf test_xdp_redirect.sh
bpf: test_xdp_redirect.sh_ #
# Error opening object test_xdp_redirect.o No such file or directory
opening: object_test_xdp_redirect.o #
# Cannot initialize ELF context!
initialize: ELF_context! #
# selftests test_xdp_redirect [FAILED]
test_xdp_redirect: [FAILED]_ #
[FAIL] 25 selftests bpf test_xdp_redirect.sh # exit=3D255
selftests: bpf_test_xdp_redirect.sh [FAIL]

=3D=3D=3D
# selftests bpf test_xdp_vlan_mode_generic.sh
bpf: test_xdp_vlan_mode_generic.sh_ #
# PING 100.64.41.1 (100.64.41.1) 56(84) bytes of data.
100.64.41.1: (100.64.41.1)_56(84) #
#
: _ #
# --- 100.64.41.1 ping statistics ---
100.64.41.1: ping_statistics #
# 1 packets transmitted, 0 received, 100% packet loss, time 0ms
packets: transmitted,_0 #
#
: _ #
# Success First ping must fail
First: ping_must #
# Error opening object test_xdp_vlan.o No such file or directory
opening: object_test_xdp_vlan.o #
# Cannot initialize ELF context!
initialize: ELF_context! #
# selftests xdp_vlan_mode_generic [FAILED]
xdp_vlan_mode_generic: [FAILED]_ #
[FAIL] 35 selftests bpf test_xdp_vlan_mode_generic.sh # exit=3D255
selftests: bpf_test_xdp_vlan_mode_generic.sh [FAIL]

=3D=3D=3D
# selftests bpf test_xdp_vlan_mode_native.sh
bpf: test_xdp_vlan_mode_native.sh_ #
# PING 100.64.41.1 (100.64.41.1) 56(84) bytes of data.
100.64.41.1: (100.64.41.1)_56(84) #
#
: _ #
# --- 100.64.41.1 ping statistics ---
100.64.41.1: ping_statistics #
# 1 packets transmitted, 0 received, 100% packet loss, time 0ms
packets: transmitted,_0 #
#
: _ #
# Success First ping must fail
First: ping_must #
# Error opening object test_xdp_vlan.o No such file or directory
opening: object_test_xdp_vlan.o #
# Cannot initialize ELF context!
initialize: ELF_context! #
# selftests xdp_vlan_mode_native [FAILED]
xdp_vlan_mode_native: [FAILED]_ #
[FAIL] 36 selftests bpf test_xdp_vlan_mode_native.sh # exit=3D255
selftests: bpf_test_xdp_vlan_mode_native.sh [FAIL]

Ref links:
https://lkft.validation.linaro.org/scheduler/job/1024055

Dashboard link,
https://qa-reports.linaro.org/lkft/linux-mainline-oe/tests/kselftest/bpf_te=
st_dev_cgroup
https://qa-reports.linaro.org/lkft/linux-mainline-oe/tests/kselftest/bpf_te=
st_skb_cgroup_id.sh
https://qa-reports.linaro.org/lkft/linux-mainline-oe/tests/kselftest/bpf_te=
st_sysctl
https://qa-reports.linaro.org/lkft/linux-mainline-oe/tests/kselftest/bpf_te=
st_xdp_meta.sh
https://qa-reports.linaro.org/lkft/linux-mainline-oe/tests/kselftest/bpf_te=
st_xdp_redirect.sh
https://qa-reports.linaro.org/lkft/linux-mainline-oe/tests/kselftest/bpf_te=
st_xdp_vlan_mode_generic.sh
https://qa-reports.linaro.org/lkft/linux-mainline-oe/tests/kselftest/bpf_te=
st_xdp_vlan_mode_native.sh

--
Linaro LKFT
https://lkft.linaro.org
