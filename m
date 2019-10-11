Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFA8D3F32
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 14:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbfJKMHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 08:07:23 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39462 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727243AbfJKMHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 08:07:22 -0400
Received: by mail-wr1-f66.google.com with SMTP id r3so11656757wrj.6
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 05:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DXHRllLSJ/1e62jK/WoBiAvlasUoqg+VrQjUmvDHO/E=;
        b=DbiKHYxSPV9it/2ZCvnjMRUWTrKt/xUPh+FDv3p5vbVHO8cvFJcAQTqgmxFwPZ74ac
         cFh+XTO5LtB5cZU44CYg2cMf0tzfWtouWtbbCM1qWV2O6exqgFBFDQvu71z7GdfQPTDm
         wQbfHCjag/55tfIC5ATL10KVCE/fNy75VtnITaGHByTvO6BZ+/lVKYqe+LivPRgXN4Qn
         omQyvYlmNcuuiOS2vbuXGmu0dASKkzlcCTGkDh+nsqka9oceabS4455+yVqjFnj7KRX7
         es/iRQR+9HNxIfo5o2bhY8GM9vMiDX37QRHWJts+//AAC8nLuGs/C4YKRg1Cs1XMLW0I
         IYiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DXHRllLSJ/1e62jK/WoBiAvlasUoqg+VrQjUmvDHO/E=;
        b=rj/vgGOdZIrLoWgbu0p/eUG0urFAZQijrh7iSP75TRz1/UE/SSFL5muNr0hBNdX2kZ
         yH0+jRMnVBI8HaRUiDCIsrNgmGxMExBjPs9KaAwyFCtjk/+I/FDfreaLHqjIuTGRoEWl
         Jl5md+IKbN3E6aNZuY8UwhLUPa1EzUkZ8TE4DNSqh70BD5OAqoNezChQsSbO5/pv6xRN
         oPnBkE8zuIJGfwF8WtYDmzA+orrMW4ADabWMv07DSc0s69KgdaseDXGNIxMmCLsDo6xc
         2/MQCe9lG5CKFVKnkmh7rL1DV2GpRG6rNqVsisri4vjMchXs6Q+V2Nmv/3KAzL+uryZh
         zclQ==
X-Gm-Message-State: APjAAAXRve9CtBHL5q5MbgdWHKyaBs8c7bFxjiNntoecR4RiA3BWZ7e7
        XdHcy+ayeIAL7Zk9/Q2MqO3wzA==
X-Google-Smtp-Source: APXvYqx4zRh3/lzQcnR7JYi7OUgMTk+geVvTywZNozNZoACrkzaTYw+O/9aIxTn4yeAf3B7n2bSkTQ==
X-Received: by 2002:a5d:4108:: with SMTP id l8mr12459949wrp.391.1570795639449;
        Fri, 11 Oct 2019 05:07:19 -0700 (PDT)
Received: from apalos.home (ppp-94-65-93-45.home.otenet.gr. [94.65.93.45])
        by smtp.gmail.com with ESMTPSA id w9sm13356785wrt.62.2019.10.11.05.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 05:07:18 -0700 (PDT)
Date:   Fri, 11 Oct 2019 15:07:15 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v5 bpf-next 00/15] samples: bpf: improve/fix
 cross-compilation
Message-ID: <20191011120715.GA7944@apalos.home>
References: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 03:27:53AM +0300, Ivan Khoronzhuk wrote:
> This series contains mainly fixes/improvements for cross-compilation
> but not only, tested for arm, arm64, and intended for any arch.
> Also verified on native build (not cross compilation) for x86_64
> and arm, arm64.
> 
> Initial RFC link:
> https://lkml.org/lkml/2019/8/29/1665
> 
> Prev. version:
> https://lkml.org/lkml/2019/10/9/1045
> 
> Besides the patches given here, the RFC also contains couple patches
> related to llvm clang
>   arm: include: asm: swab: mask rev16 instruction for clang
>   arm: include: asm: unified: mask .syntax unified for clang
> They are necessarily to verify arm 32 build.
> 
> Also, couple more fixes were added but are not merged in bpf-next yet,
> they can be needed for verification/configuration steps, if not in
> your tree the fixes can be taken here:
> https://www.spinics.net/lists/netdev/msg601716.html
> https://www.spinics.net/lists/netdev/msg601714.html
> https://www.spinics.net/lists/linux-kbuild/msg23468.html
> 
> Now, to build samples, SAMPLE_BPF should be enabled in config.
> 
> The change touches not only cross-compilation and can have impact on
> other archs and build environments, so might be good idea to verify
> it in order to add appropriate changes, some warn options could be
> tuned also.
> 
> All is tested on x86-64 with clang installed (has to be built containing
> targets for arm, arm64..., see llc --version, usually it's present already)
> 
> Instructions to test native on x86_64
> =================================================
> Native build on x86_64 is done in usual way and shouldn't have difference
> except HOSTCC is now printed as CC wile building the samples.
> 
> Instructions to test cross compilation on arm64
> =================================================
> #Toolchain used for test:
> gcc version 8.3.0
> (GNU Toolchain for the A-profile Architecture 8.3-2019.03 (arm-rel-8.36))
> 
> # Get some arm64 FS, containing at least libelf
> I've used sdk for TI am65x got here:
> http://downloads.ti.com/processor-sdk-linux/esd/AM65X/latest/exports/\
> ti-processor-sdk-linux-am65xx-evm-06.00.00.07-Linux-x86-Install.bin
> 
> # Install this binary to some dir, say "sdk".
> # Configure kernel (use defconfig as no matter), but clean everything
> # before.
> make ARCH=arm64 -C tools/ clean
> make ARCH=arm64 -C samples/bpf clean
> make ARCH=arm64 clean
> make ARCH=arm64 defconfig
> 
> # Enable SAMPLE_BPF and it's dependencies in config
> 
> # The kernel version used in sdk doesn't correspond to checked one,
> # but for this verification only headers need to be syched,
> # so install them (can be enabled in config):
> make ARCH=arm64 headers_install
> 
> # or on SDK if need keep them in sync (not necessarily to verify):
> 
> make ARCH=arm64 INSTALL_HDR_PATH=/../sdk/\
> ti-processor-sdk-linux-am65xx-evm-06.00.00.07/linux-devkit/sysroots/\
> aarch64-linux/usr headers_install
> 
> # Build samples
> make samples/bpf/ ARCH=arm64 CROSS_COMPILE="aarch64-linux-gnu-"\
> SYSROOT="/../sdk/ti-processor-sdk-linux-am65xx-evm-06.00.00.07/\
> linux-devkit/sysroots/aarch64-linux"
> 
> Instructions to test cross compilation on arm
> =================================================
> #Toolchains used for test:
> arm-linux-gnueabihf-gcc (Linaro GCC 7.2-2017.11) 7.2.1 20171011
> or
> arm-linux-gnueabihf-gcc
> (GNU Toolchain for the A-profile Architecture 8.3-2019.03 \
> (arm-rel-8.36)) 8.3.0
> 
> # Get some FS, I've used sdk for TI am52xx got here:
> http://downloads.ti.com/processor-sdk-linux/esd/AM57X/05_03_00_07/exports/\
> ti-processor-sdk-linux-am57xx-evm-05.03.00.07-Linux-x86-Install.bin
> 
> # Install this binary to some dir, say "sdk".
> # Configure kernel, but clean everything before.
> make ARCH=arm -C tools/ clean
> make ARCH=arm -C samples/bpf clean
> make ARCH=arm clean
> make ARCH=arm omap2plus_defconfig
> 
> # The kernel version used in sdk doesn't correspond to checked one, but
> # headers only should be synched,
> # so install them (can be enabled in config):
> 
> make ARCH=arm headers_install
> 
> # or on SDK if need keep them in sync (not necessarily):
> 
> make ARCH=arm INSTALL_HDR_PATH=/../sdk/\
> ti-processor-sdk-linux-am57xx-evm-05.03.00.07/linux-devkit/sysroots/\
> armv7ahf-neon-linux-gnueabi/usr headers_install
> 
> # Build samples
> make samples/bpf/ ARCH=arm CROSS_COMPILE="arm-linux-gnueabihf-"\
> SYSROOT="/../sdk/ti-processor-sdk-linux-am57xx-evm-05.03\
> .00.07/linux-devkit/sysroots/armv7ahf-neon-linux-gnueabi"
> 
> 
> Based on bpf-next/master
> 
> v5..v4:
> - any changes, only missed SOBs are added
> 
> v4..v3:
> - renamed CLANG_EXTRA_CFLAGS on BPF_EXTRA_CFLAGS
> - used filter for ARCH_ARM_SELECTOR
> - omit "-fomit-frame-pointer" and use same flags for native and "cross"
> - used sample/bpf prefixes
> - use C instead of C++ compiler for test_libbpf target
> 
> v3..v2:
> - renamed makefile.progs to makeifle.target, as more appropriate
> - left only __LINUX_ARM_ARCH__ for D options for arm
> - for host build - left options from KBUILD_HOST for compatibility reasons
> - split patch adding c/cxx/ld flags to libbpf by modules
> - moved readme change to separate patch
> - added patch setting options for cross-compile
> - fixed issue with option error for syscall_nrs.S,
>   avoiding overlap for ccflags-y.
> 
> v2..v1:
> - restructured patches order
> - split "samples: bpf: Makefile: base progs build on Makefile.progs"
>   to make change more readable. It added couple nice extra patches.
> - removed redundant patch:
>   "samples: bpf: Makefile: remove target for native build"
> - added fix:
>   "samples: bpf: makefile: fix cookie_uid_helper_example obj build"
> - limited -D option filter only for arm
> - improved comments
> - added couple instructions to verify cross compilation for arm and
>   arm64 arches based on TI am57xx and am65xx sdks.
> - corrected include a little order
> 
> Ivan Khoronzhuk (15):
>   samples/bpf: fix HDR_PROBE "echo"
>   samples/bpf: fix cookie_uid_helper_example obj build
>   samples/bpf: use --target from cross-compile
>   samples/bpf: use own EXTRA_CFLAGS for clang commands
>   samples/bpf: use __LINUX_ARM_ARCH__ selector for arm
>   samples/bpf: drop unnecessarily inclusion for bpf_load
>   samples/bpf: add makefile.target for separate CC target build
>   samples/bpf: base target programs rules on Makefile.target
>   samples/bpf: use own flags but not HOSTCFLAGS
>   samples/bpf: use target CC environment for HDR_PROBE
>   libbpf: don't use cxx to test_libpf target
>   libbpf: add C/LDFLAGS to libbpf.so and test_libpf targets
>   samples/bpf: provide C/LDFLAGS to libbpf
>   samples/bpf: add sysroot support
>   samples/bpf: add preparation steps and sysroot info to readme
> 
>  samples/bpf/Makefile                          | 164 ++++++++++--------
>  samples/bpf/Makefile.target                   |  75 ++++++++
>  samples/bpf/README.rst                        |  41 ++++-
>  tools/lib/bpf/Makefile                        |  23 +--
>  .../bpf/{test_libbpf.cpp => test_libbpf.c}    |  14 +-
>  5 files changed, 218 insertions(+), 99 deletions(-)
>  create mode 100644 samples/bpf/Makefile.target
>  rename tools/lib/bpf/{test_libbpf.cpp => test_libbpf.c} (61%)
> 
> -- 
> 2.17.1
> 

For native compilation on x86_64 and aarch64 

Tested-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
