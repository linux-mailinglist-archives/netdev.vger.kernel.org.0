Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C70B401B30
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 14:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242227AbhIFM23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 08:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242100AbhIFM22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 08:28:28 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B3EC061757
        for <netdev@vger.kernel.org>; Mon,  6 Sep 2021 05:27:23 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id lc21so13182437ejc.7
        for <netdev@vger.kernel.org>; Mon, 06 Sep 2021 05:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Y5hIRzIcGYWYEqJdUxq8kIJNt4wpkM8c30kp0VYy3s0=;
        b=RpyN+7kHyZxh7p46y90oto/q/ZN++UGDtiIxG6GpGVk0trybvspmC+nH9gB70ft8Si
         irAuD2Vd88vmIks9NwnrqTc0d/TmlkprPB64kM+pdqJNt9ewnxkL1btFlXHriUEDw2Na
         yBAMXZ0VMyXpIJWR2HLr2sAKg2bF7XvHIVpYV4cfdyH3ZESXmQ6+QvzaD2OHAn8Si3eT
         nWI9rJg1Od7tSj25gidkcnLp8eMNwQ/tpXtOMw/EuokwTQmeyh3pWW2Et6t0D610VJBP
         aDS9AXD8Wssfk/L2jPaZlMR521EvfI9jy63yhz4pO9eXrvZHb+kSoTT6sAc0yL/teydo
         vq0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Y5hIRzIcGYWYEqJdUxq8kIJNt4wpkM8c30kp0VYy3s0=;
        b=f4M8fiyYNhhH4U6RCa1Jq6cOj3aCzyQ0XYnxNOgzO0kSWJ2iMDmDrXoX6IVkyjOI+B
         kNWlxu0Q82oApeVIoKjO86VK3IRFTXzoWCSsqfWlYJXfoLrR/vI1TF/2wr4AQawxrf6T
         8Ds+fwbeogohyNdy0iuoQv8278WBqoO2Lwg/w+f75pDocEXWXv1xaV32VJENquRo3tNO
         TUDJcaQlAbHdKv6dyQgoAgHAXEOA6Jp5Ld8WNOOyfhngaGBXo8VWms+22dJM+zzLdnve
         yZ6op47jx6Fh2x0swU2V/DYsh/wWD6nKVOOiF81mGtB+vr4ma04AWmXmdZahdMh7e2lh
         sGiA==
X-Gm-Message-State: AOAM532qHQH733eczhQ63gkSLLO/mxhxWU4sayD3GR4VD+1CVZszmScx
        KQuugFPEud+6EU8WVKQUt6o5SpHY6PNJUZG67TnCaw==
X-Google-Smtp-Source: ABdhPJw0fbyJT0dChQiU4JYE+nMwo9KS/iOIxBb429I4Yc0RaqXikg9Jo2aRrEQxqUWcWGSxlBGOzJ4qEAlj8KR0Cpk=
X-Received: by 2002:a17:906:84d0:: with SMTP id f16mr13543927ejy.6.1630931241703;
 Mon, 06 Sep 2021 05:27:21 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 6 Sep 2021 17:57:10 +0530
Message-ID: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
Subject: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger than
 1024 bytes [-Werror=frame-larger-than=]
To:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Please ignore this email if it is already reported ]
Following build warnings/ errors noticed while building linux mainline
master branch
with gcc-11 for arm architecture with provided config file.

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm
CROSS_COMPILE=arm-linux-gnueabihf- 'CC=sccache
arm-linux-gnueabihf-gcc' 'HOSTCC=sccache gcc' olddefconfig
make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm
CROSS_COMPILE=arm-linux-gnueabihf- 'CC=sccache
arm-linux-gnueabihf-gcc' 'HOSTCC=sccache gcc'
/builds/linux/arch/arm/boot/dts/bcm2711-rpi-4-b.dts:220.10-231.4:
Warning (pci_device_reg): /scb/pcie@7d500000/pci@1,0: PCI unit address
format error, expected 0,0
/builds/linux/arch/arm/boot/dts/bcm2711-rpi-4-b.dts:220.10-231.4:
Warning (pci_device_reg): /scb/pcie@7d500000/pci@1,0: PCI unit address
format error, expected 0,0
/builds/linux/net/ipv4/tcp.c: In function 'do_tcp_getsockopt.constprop':
/builds/linux/net/ipv4/tcp.c:4234:1: error: the frame size of 1152
bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
 4234 | }
      | ^
cc1: all warnings being treated as errors
make[3]: *** [/builds/linux/scripts/Makefile.build:277: net/ipv4/tcp.o] Error 1
/builds/linux/fs/select.c: In function 'do_sys_poll':
/builds/linux/fs/select.c:1041:1: error: the frame size of 1264 bytes
is larger than 1024 bytes [-Werror=frame-larger-than=]
 1041 | }
      | ^
cc1: all warnings being treated as errors
make[2]: *** [/builds/linux/scripts/Makefile.build:277: fs/select.o] Error 1
make[3]: Target '__build' not remade because of errors.
make[2]: *** [/builds/linux/scripts/Makefile.build:540: net/ipv4] Error 2
make[2]: Target '__build' not remade because of errors.
make[1]: *** [/builds/linux/Makefile:1872: fs] Error 2
/builds/linux/net/mac80211/mlme.c: In function 'ieee80211_sta_rx_queued_mgmt':
/builds/linux/net/mac80211/mlme.c:4345:1: error: the frame size of
1040 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
 4345 | }
      | ^
cc1: all warnings being treated as errors
make[3]: *** [/builds/linux/scripts/Makefile.build:277:
net/mac80211/mlme.o] Error 1
make[3]: Target '__build' not remade because of errors.
make[2]: *** [/builds/linux/scripts/Makefile.build:540: net/mac80211] Error 2
make[2]: Target '__build' not remade because of errors.
make[1]: *** [/builds/linux/Makefile:1872: net] Error 2
/builds/linux/drivers/base/test/property-entry-test.c: In function
'pe_test_uint_arrays':
/builds/linux/drivers/base/test/property-entry-test.c:250:1: error:
the frame size of 1040 bytes is larger than 1024 bytes
[-Werror=frame-larger-than=]
  250 | }
      | ^
cc1: all warnings being treated as errors
make[4]: *** [/builds/linux/scripts/Makefile.build:277:
drivers/base/test/property-entry-test.o] Error 1
make[4]: Target '__build' not remade because of errors.
make[3]: *** [/builds/linux/scripts/Makefile.build:540:
drivers/base/test] Error 2
make[3]: Target '__build' not remade because of errors.
make[2]: *** [/builds/linux/scripts/Makefile.build:540: drivers/base] Error 2
/builds/linux/drivers/usb/host/xhci.c: In function 'xhci_reserve_bandwidth':
/builds/linux/drivers/usb/host/xhci.c:2867:1: error: the frame size of
1064 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
 2867 | }
      | ^
cc1: all warnings being treated as errors
make[4]: *** [/builds/linux/scripts/Makefile.build:277:
drivers/usb/host/xhci.o] Error 1
make[4]: Target '__build' not remade because of errors.
make[3]: *** [/builds/linux/scripts/Makefile.build:540:
drivers/usb/host] Error 2
/builds/linux/drivers/net/ethernet/qlogic/qede/qede_filter.c: In
function 'qede_config_rx_mode':
/builds/linux/drivers/net/ethernet/qlogic/qede/qede_filter.c:1278:1:
error: the frame size of 1072 bytes is larger than 1024 bytes
[-Werror=frame-larger-than=]
 1278 | }
      | ^
cc1: all warnings being treated as errors
make[6]: *** [/builds/linux/scripts/Makefile.build:277:
drivers/net/ethernet/qlogic/qede/qede_filter.o] Error 1
make[6]: Target '__build' not remade because of errors.
make[5]: *** [/builds/linux/scripts/Makefile.build:540:
drivers/net/ethernet/qlogic/qede] Error 2
make[5]: Target '__build' not remade because of errors.
make[4]: *** [/builds/linux/scripts/Makefile.build:540:
drivers/net/ethernet/qlogic] Error 2
make[3]: Target '__build' not remade because of errors.
make[2]: *** [/builds/linux/scripts/Makefile.build:540: drivers/usb] Error 2
make[4]: Target '__build' not remade because of errors.
make[3]: *** [/builds/linux/scripts/Makefile.build:540:
drivers/net/ethernet] Error 2
make[3]: Target '__build' not remade because of errors.
make[2]: *** [/builds/linux/scripts/Makefile.build:540: drivers/net] Error 2
/builds/linux/drivers/media/dvb-frontends/mxl5xx.c: In function 'config_ts':
/builds/linux/drivers/media/dvb-frontends/mxl5xx.c:1575:1: error: the
frame size of 1232 bytes is larger than 1024 bytes
[-Werror=frame-larger-than=]
 1575 | }
      | ^
cc1: all warnings being treated as errors
make[4]: *** [/builds/linux/scripts/Makefile.build:277:
drivers/media/dvb-frontends/mxl5xx.o] Error 1
make[4]: Target '__build' not remade because of errors.
make[3]: *** [/builds/linux/scripts/Makefile.build:540:
drivers/media/dvb-frontends] Error 2
make[3]: Target '__build' not remade because of errors.
make[2]: *** [/builds/linux/scripts/Makefile.build:540: drivers/media] Error 2
make[2]: Target '__build' not remade because of errors.
make[1]: *** [/builds/linux/Makefile:1872: drivers] Error 2
make[1]: Target '__all' not remade because of errors.
make: *** [Makefile:219: __sub-make] Error 2
make: Target '__all' not remade because of errors.

Build config:
https://builds.tuxbuild.com/1xjZpYj47LrrGs1OE1xApznPplW/config

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

meta data:
-----------
    git_describe: v5.14-9687-g27151f177827
    git_ref:
    git_repo: https://gitlab.com/Linaro/lkft/mirrors/torvalds/linux-mainline
    git_sha: 27151f177827d478508e756c7657273261aaf8a9
    git_short_log: 27151f177827 (\Merge tag
'perf-tools-for-v5.15-2021-09-04' of
git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux\)
    kconfig: [
        defconfig
        https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/lkft.config
        https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/lkft-crypto.config
        https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/distro-overrides.config
        https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/systemd.config
        https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/virtio.config
        CONFIG_ARM_TI_CPUFREQ=y
        CONFIG_SERIAL_8250_OMAP=y
        CONFIG_POSIX_MQUEUE=y
        CONFIG_OF=y
        CONFIG_KASAN=y
        CONFIG_KUNIT=y
        CONFIG_KUNIT_ALL_TESTS=y
    ],
    kernel_version: 5.14.0
    target_arch: arm
    toolchain: gcc-11

steps to reproduce:
https://builds.tuxbuild.com/1xjZpYj47LrrGs1OE1xApznPplW/tuxmake_reproducer.sh

--
Linaro LKFT
https://lkft.linaro.org
