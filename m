Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508142DE74D
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 17:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730962AbgLRQMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 11:12:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbgLRQMM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 11:12:12 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608307891;
        bh=ClWBn8o57NW0CkJAgffZbgq5xfQcalIZeFPVbn3N+Tw=;
        h=In-Reply-To:References:Cc:From:To:Subject:Date:From;
        b=HVlymSYl4kYNF2f3DWDg/RIifIsjdUvepXtVhjf5gWTrG/PmmcZgRdLiKjvGlZdcR
         7Vc+YtSPrsj4/GvRLB9v3xar0BbGq929k9CnbcYtB8ABlCmx02FQlKdsUGj42cPX1z
         v64GpzSfV4/NBgldVPVZCnkkP/5MnLOKl5PtNrxl7Dk7FLs+FSiA3DItTP8V3RYMB4
         dugYHctodZm48MowIl1xt9yKJtI4uEy2WhrM3ndAGAo3xmMlsRlUV4MtaV56y4WwEs
         UNJT9UL1U+82zefncoi9rS+UfQj4wpKzZ/iblVGBv/YgzeelLl5ok/mk8BPORfGyKP
         Ti3XTp1uJC0kg==
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <202012182344.1bEcUiOJ-lkp@intel.com>
References: <20201217162521.1134496-2-atenart@kernel.org> <202012182344.1bEcUiOJ-lkp@intel.com>
Cc:     kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        netdev@vger.kernel.org, pabeni@redhat.com
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kernel test robot <lkp@intel.com>,
        kuba@kernel.org
Subject: Re: [PATCH net 1/4] net-sysfs: take the rtnl lock when storing xps_cpus
Message-ID: <160830788823.3591.10049543791193131034@kwain.local>
Date:   Fri, 18 Dec 2020 17:11:28 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

That build issue seems unrelated to the patch. The series as a whole
builds fine according to the same report, and this code is not modified
by later patches.

It looks a lot like this report from yesterday:
https://www.spinics.net/lists/netdev/msg709132.html

Which also seemed unrelated to the changes:
https://www.spinics.net/lists/netdev/msg709264.html

Thanks!
Antoine

Quoting kernel test robot (2020-12-18 16:27:46)
> Hi Antoine,
>=20
> I love your patch! Yet something to improve:
>=20
> [auto build test ERROR on net/master]
>=20
> url:    https://github.com/0day-ci/linux/commits/Antoine-Tenart/net-sysfs=
-fix-race-conditions-in-the-xps-code/20201218-002852
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 3ae=
32c07815a24ae12de2e7838d9d429ba31e5e0
> config: riscv-randconfig-r014-20201217 (attached as .config)
> compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project cee1=
e7d14f4628d6174b33640d502bff3b54ae45)
> reproduce (this is a W=3D1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbi=
n/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install riscv cross compiling tool for clang build
>         # apt-get install binutils-riscv64-linux-gnu
>         # https://github.com/0day-ci/linux/commit/f989c3dcbe4d9abd1c6c48b=
34f08c6c0cd9d44b3
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Antoine-Tenart/net-sysfs-fix-rac=
e-conditions-in-the-xps-code/20201218-002852
>         git checkout f989c3dcbe4d9abd1c6c48b34f08c6c0cd9d44b3
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make.cross AR=
CH=3Driscv=20
>=20
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>=20
> Note: the linux-review/Antoine-Tenart/net-sysfs-fix-race-conditions-in-th=
e-xps-code/20201218-002852 HEAD 563d144b47845dea594b409ecf22914b9797cd1e bu=
ilds fine.
>       It only hurts bisectibility.
>=20
> All errors (new ones prefixed by >>):
>=20
>    /tmp/ics932s401-422897.s: Assembler messages:
> >> /tmp/ics932s401-422897.s:260: Error: unrecognized opcode `zext.b a1,s1=
1'
>    /tmp/ics932s401-422897.s:362: Error: unrecognized opcode `zext.b a1,s1=
1'
>    /tmp/ics932s401-422897.s:518: Error: unrecognized opcode `zext.b a1,s1=
1'
>    /tmp/ics932s401-422897.s:637: Error: unrecognized opcode `zext.b a1,s1=
1'
>    /tmp/ics932s401-422897.s:774: Error: unrecognized opcode `zext.b a1,s1=
1'
>    /tmp/ics932s401-422897.s:893: Error: unrecognized opcode `zext.b a1,s1=
1'
>    /tmp/ics932s401-422897.s:1021: Error: unrecognized opcode `zext.b a1,s=
11'
> >> /tmp/ics932s401-422897.s:1180: Error: unrecognized opcode `zext.b a1,s=
2'
>    clang-12: error: assembler command failed with exit code 1 (use -v to =
see invocation)
>=20
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
