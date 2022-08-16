Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE445955F8
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 11:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbiHPJNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 05:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbiHPJNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 05:13:09 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01881E3420;
        Tue, 16 Aug 2022 00:28:55 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 130so8388129pfy.6;
        Tue, 16 Aug 2022 00:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=uhw5YLq3kbmyobs31AOG7QaA9AqSs4S3GvCroGptRNg=;
        b=YWWy0lT6g8R+25x0ozqymXyf25I2dWppwMHnB6AeeklMy+QO68v6JrYkug49477/xr
         8n7Pqzhy3c7ymdY7sdWXfa12gadtvAjsoDZW0cKZUeBf87u0FPY8+6scRt5NshiwV1GV
         egbZlZqPeLDX1e1mQ/HY6Qh3mH0OlOLhghSMNGgBK/QggQWSD2A7NYBFCkN8MsWJHK4K
         JlVSGkBA1pgSwvRuWSvgLZbCycOH4uFmwlH2n6D41hnruWehir1oJ7fMt3BZM4ctJb8T
         1x4/94h1lVLuZ4Y5gMOgZ/dxwzeUSdweZcJ+8wjByJ/+EWmDwfO0Kb/uAmux2SJMHrUL
         xslg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=uhw5YLq3kbmyobs31AOG7QaA9AqSs4S3GvCroGptRNg=;
        b=nzNq9JRda0BXRHKWGV16cFn4jDAFZiBaJ109EqvweE7KryGbWjhjxxMmVRexxgE0CW
         PuMheRPg24ZBbMaSwIsu6DAH1lOHdXer5rdIZdjdu3OF3chw69+wRl5Y6StSUsvPYtBc
         kB2NwIaYLvjSGiHZhLS5glnL9nZUTeOuVUHB4GIlwUIMVnymGwNAJZ+t9VXu6pm1rg4t
         M/yku/dL3djOpxYY8gJbZZHcQKqxK4cvtBbtee+3oUn/t9YAa0SBQT6w90vwr2DOGvyw
         n12efm2Xc/TxmUb9ubDgp9ANH44GrxSgoa8OY3ys9xPRQY/GCDke83nD8NG/DPYkuF5F
         OVYA==
X-Gm-Message-State: ACgBeo2INgD0Ym/A6NV8C0KY1mJjWzzRDf6hnlpsSDQEymM9PQDeFMJN
        xP2BadNsO/45r6uXagOnoNA=
X-Google-Smtp-Source: AA6agR4/WhALdB4ioPbWoAwfUIyHR0F2WSCiAohOSegvh4o8IWmJqgifDDFvfL8vNUmRgSBA4CiJCA==
X-Received: by 2002:a62:798c:0:b0:52d:7523:d42a with SMTP id u134-20020a62798c000000b0052d7523d42amr19948986pfc.5.1660634934416;
        Tue, 16 Aug 2022 00:28:54 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e7-20020a17090a4a0700b001f327021900sm5685879pjh.1.2022.08.16.00.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 00:28:53 -0700 (PDT)
Date:   Tue, 16 Aug 2022 15:28:49 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net v3 1/2] selftests: include bonding tests into the
 kselftest infra
Message-ID: <YvtHMQZy3WdTKM5l@Laptop-X1>
References: <cover.1660572700.git.jtoppins@redhat.com>
 <3cb3b4ce2b761a1e1ac56b0505b9ea63dbf9e075.1660572700.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cb3b4ce2b761a1e1ac56b0505b9ea63dbf9e075.1660572700.git.jtoppins@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 11:08:34AM -0400, Jonathan Toppins wrote:
> This creates a test collection in drivers/net/bonding for bonding
> specific kernel selftests.
> 
> The first test is a reproducer that provisions a bond and given the
> specific order in how the ip-link(8) commands are issued the bond never
> transmits an LACPDU frame on any of its slaves.
> 
> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
> ---
> 
> Notes:
>     v2:
>      * fully integrated the test into the kselftests infrastructure
>      * moved the reproducer to under
>        tools/testing/selftests/drivers/net/bonding
>      * reduced the test to its minimial amount and used ip-link(8) for
>        all bond interface configuration
>     v3:
>      * rebase to latest net/master
>      * remove `#set -x` requested by Hangbin
> 
>  MAINTAINERS                                   |  1 +
>  tools/testing/selftests/Makefile              |  1 +
>  .../selftests/drivers/net/bonding/Makefile    |  6 ++
>  .../net/bonding/bond-break-lacpdu-tx.sh       | 81 +++++++++++++++++++
>  .../selftests/drivers/net/bonding/config      |  1 +
>  .../selftests/drivers/net/bonding/settings    |  1 +
>  6 files changed, 91 insertions(+)
>  create mode 100644 tools/testing/selftests/drivers/net/bonding/Makefile
>  create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh
>  create mode 100644 tools/testing/selftests/drivers/net/bonding/config
>  create mode 100644 tools/testing/selftests/drivers/net/bonding/settings
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f2d64020399b..e5fb14dc302d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3672,6 +3672,7 @@ F:	Documentation/networking/bonding.rst
>  F:	drivers/net/bonding/
>  F:	include/net/bond*
>  F:	include/uapi/linux/if_bonding.h
> +F:	tools/testing/selftests/net/bonding/
>  
>  BOSCH SENSORTEC BMA400 ACCELEROMETER IIO DRIVER
>  M:	Dan Robertson <dan@dlrobertson.com>
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index 10b34bb03bc1..c2064a35688b 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -12,6 +12,7 @@ TARGETS += cpu-hotplug
>  TARGETS += damon
>  TARGETS += drivers/dma-buf
>  TARGETS += drivers/s390x/uvdevice
> +TARGETS += drivers/net/bonding
>  TARGETS += efivarfs
>  TARGETS += exec
>  TARGETS += filesystems
> diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
> new file mode 100644
> index 000000000000..ab6c54b12098
> --- /dev/null
> +++ b/tools/testing/selftests/drivers/net/bonding/Makefile
> @@ -0,0 +1,6 @@
> +# SPDX-License-Identifier: GPL-2.0
> +# Makefile for net selftests
> +
> +TEST_PROGS := bond-break-lacpdu-tx.sh
> +
> +include ../../../lib.mk
> diff --git a/tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh b/tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh
> new file mode 100755
> index 000000000000..47ab90596acb
> --- /dev/null
> +++ b/tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh
> @@ -0,0 +1,81 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0
> +
> +# Regression Test:
> +#   Verify LACPDUs get transmitted after setting the MAC address of
> +#   the bond.
> +#
> +# https://bugzilla.redhat.com/show_bug.cgi?id=2020773
> +#
> +#       +---------+
> +#       | fab-br0 |
> +#       +---------+
> +#            |
> +#       +---------+
> +#       |  fbond  |
> +#       +---------+
> +#        |       |
> +#    +------+ +------+
> +#    |veth1 | |veth2 |
> +#    +------+ +------+
> +#
> +# We use veths instead of physical interfaces
> +
> +set -e
> +tmp=$(mktemp -q dump.XXXXXX)
> +cleanup() {
> +	ip link del fab-br0 >/dev/null 2>&1 || :
> +	ip link del fbond  >/dev/null 2>&1 || :
> +	ip link del veth1-bond  >/dev/null 2>&1 || :
> +	ip link del veth2-bond  >/dev/null 2>&1 || :
> +	modprobe -r bonding  >/dev/null 2>&1 || :
> +	rm -f -- ${tmp}
> +}
> +
> +trap cleanup 0 1 2
> +cleanup
> +sleep 1
> +
> +# create the bridge
> +ip link add fab-br0 address 52:54:00:3B:7C:A6 mtu 1500 type bridge \
> +	forward_delay 15
> +
> +# create the bond
> +ip link add fbond type bond mode 4 miimon 200 xmit_hash_policy 1 \
> +	ad_actor_sys_prio 65535 lacp_rate fast
> +
> +# set bond address
> +ip link set fbond address 52:54:00:3B:7C:A6
> +ip link set fbond up
> +
> +# set again bond sysfs parameters
> +ip link set fbond type bond ad_actor_sys_prio 65535
> +
> +# create veths
> +ip link add name veth1-bond type veth peer name veth1-end
> +ip link add name veth2-bond type veth peer name veth2-end
> +
> +# add ports
> +ip link set fbond master fab-br0
> +ip link set veth1-bond down master fbond
> +ip link set veth2-bond down master fbond
> +
> +# bring up
> +ip link set veth1-end up
> +ip link set veth2-end up
> +ip link set fab-br0 up
> +ip link set fbond up
> +ip addr add dev fab-br0 10.0.0.3
> +
> +tcpdump -n -i veth1-end -e ether proto 0x8809 >${tmp} 2>&1 &
> +sleep 15
> +pkill tcpdump >/dev/null 2>&1
> +rc=0
> +num=$(grep "packets captured" ${tmp} | awk '{print $1}')
> +if test "$num" -gt 0; then
> +	echo "PASS, captured ${num}"
> +else
> +	echo "FAIL"
> +	rc=1
> +fi
> +exit $rc
> diff --git a/tools/testing/selftests/drivers/net/bonding/config b/tools/testing/selftests/drivers/net/bonding/config
> new file mode 100644
> index 000000000000..dc1c22de3c92
> --- /dev/null
> +++ b/tools/testing/selftests/drivers/net/bonding/config
> @@ -0,0 +1 @@
> +CONFIG_BONDING=y
> diff --git a/tools/testing/selftests/drivers/net/bonding/settings b/tools/testing/selftests/drivers/net/bonding/settings
> new file mode 100644
> index 000000000000..867e118223cd
> --- /dev/null
> +++ b/tools/testing/selftests/drivers/net/bonding/settings
> @@ -0,0 +1 @@
> +timeout=60
> -- 
> 2.31.1
> 

Acked-by: Hangbin Liu <liuhangbin@gmail.com>
