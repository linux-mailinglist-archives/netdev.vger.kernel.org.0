Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDDEE1690FE
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 18:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgBVRwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 12:52:01 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37488 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbgBVRv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 12:51:58 -0500
Received: by mail-wm1-f67.google.com with SMTP id a6so5216845wme.2
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 09:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ejFbKCq09h2XskfnkGWosm5HlJe8IXtLEK9x0s1RQm0=;
        b=OG8vPY8reCDgMQJdZLftOh6ChZ0ijI7quKHggCsjdY9MGcqJw7kI+rpLV8pR9WtY/e
         y5WyPtBZCnEOyi7Z9Xz3TazPtrz3t0YmV6FflYHemDrmndkV2O/foUkjHnyHMeZJLKYE
         8ym24jGaeKOZqBf7+uhhhDHLgRObdn79jLNos=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=ejFbKCq09h2XskfnkGWosm5HlJe8IXtLEK9x0s1RQm0=;
        b=A34ovsdN6MG0+Zqk+381jRyCXHBINbncl2Vw0qal+yRB5/WzjzpHz2CjWEpv8xY0Nb
         O/KTOVU0Yk0PARQhvV0Iz/PTAVgrwvpFT0gcRQq0Z8ynhXTmgtwApampvK9An4WRH6jX
         WjXA8vd54kkCFz/CPpJou59j4Rn0Vva2J6xRTL+GdxUDyGlYXT0FYFaEUZ1NkFAr/c7C
         jVPE79a2gpGVXfZgzs9foEShyHcE9qPkkvoePzNjJmZPLY9kpn+zmXhnzTH1PBJX3nzR
         0KSv2o8qCTBUzTkDeR+nGnGYyPSrN51/A8CVS0QsP4ErnvwAIey6L/ykTw71FOXCa7I+
         hMDw==
X-Gm-Message-State: APjAAAWQn+RaQ4zRTL63EvJyZjlByuTzzQOE2DsCpsY07nFD8Dx1utRp
        3gUqdQuPLfmJnj4ez1XHc3Ekbg==
X-Google-Smtp-Source: APXvYqwGldJb461jnmitpcAvxJYf2nJLWGBHd9BxNgtDSq+iImh7e1DyR/QKZxxBiwVbM8mCR3uoEw==
X-Received: by 2002:a1c:6408:: with SMTP id y8mr11177928wmb.130.1582393913514;
        Sat, 22 Feb 2020 09:51:53 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id s15sm9476144wrp.4.2020.02.22.09.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2020 09:51:52 -0800 (PST)
Date:   Sat, 22 Feb 2020 18:51:50 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-arch@vger.kernel.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-unionfs@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH 3/7] docs: fix broken references to text files
Message-ID: <20200222175150.GI2363188@phenom.ffwll.local>
Mail-Followup-To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-arch@vger.kernel.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-mm@kvack.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <cover.1582361737.git.mchehab+huawei@kernel.org>
 <5cfeed6df208b74913312a1c97235ee615180f91.1582361737.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5cfeed6df208b74913312a1c97235ee615180f91.1582361737.git.mchehab+huawei@kernel.org>
X-Operating-System: Linux phenom 5.3.0-3-amd64 
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 22, 2020 at 10:00:03AM +0100, Mauro Carvalho Chehab wrote:
> Several references got broken due to txt to ReST conversion.
> 
> Several of them can be automatically fixed with:
> 
> 	scripts/documentation-file-ref-check --fix
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/admin-guide/kernel-parameters.txt      | 10 +++++-----
>  Documentation/filesystems/cifs/cifsroot.txt          |  2 +-
>  Documentation/memory-barriers.txt                    |  2 +-
>  Documentation/process/submit-checklist.rst           |  2 +-
>  .../translations/it_IT/process/submit-checklist.rst  |  2 +-
>  Documentation/translations/ko_KR/memory-barriers.txt |  2 +-
>  .../translations/zh_CN/filesystems/sysfs.txt         |  2 +-
>  .../translations/zh_CN/process/submit-checklist.rst  |  2 +-
>  Documentation/virt/kvm/arm/pvtime.rst                |  2 +-
>  Documentation/virt/kvm/devices/vcpu.rst              |  2 +-
>  Documentation/virt/kvm/hypercalls.rst                |  4 ++--
>  arch/powerpc/include/uapi/asm/kvm_para.h             |  2 +-
>  drivers/gpu/drm/Kconfig                              |  2 +-
>  drivers/gpu/drm/drm_ioctl.c                          |  2 +-

These two look very correct. The patch that moved edid.rst seems to have
not updated a lot of references :-/

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

>  drivers/hwtracing/coresight/Kconfig                  |  2 +-
>  fs/fat/Kconfig                                       |  8 ++++----
>  fs/fuse/Kconfig                                      |  2 +-
>  fs/fuse/dev.c                                        |  2 +-
>  fs/nfs/Kconfig                                       |  2 +-
>  fs/overlayfs/Kconfig                                 |  6 +++---
>  include/linux/mm.h                                   |  4 ++--
>  include/uapi/linux/ethtool_netlink.h                 |  2 +-
>  include/uapi/rdma/rdma_user_ioctl_cmds.h             |  2 +-
>  mm/gup.c                                             | 12 ++++++------
>  net/ipv4/Kconfig                                     |  6 +++---
>  net/ipv4/ipconfig.c                                  |  2 +-
>  virt/kvm/arm/vgic/vgic-mmio-v3.c                     |  2 +-
>  virt/kvm/arm/vgic/vgic.h                             |  4 ++--
>  28 files changed, 47 insertions(+), 47 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 8be1d0bbfd16..e0fe9f70d22b 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -957,7 +957,7 @@
>  			edid/1680x1050.bin, or edid/1920x1080.bin is given
>  			and no file with the same name exists. Details and
>  			instructions how to build your own EDID data are
> -			available in Documentation/driver-api/edid.rst. An EDID
> +			available in Documentation/admin-guide/edid.rst. An EDID
>  			data set will only be used for a particular connector,
>  			if its name and a colon are prepended to the EDID
>  			name. Each connector may use a unique EDID data
> @@ -1884,7 +1884,7 @@
>  			No delay
>  
>  	ip=		[IP_PNP]
> -			See Documentation/filesystems/nfs/nfsroot.txt.
> +			See Documentation/admin-guide/nfs/nfsroot.rst.
>  
>  	ipcmni_extend	[KNL] Extend the maximum number of unique System V
>  			IPC identifiers from 32,768 to 16,777,216.
> @@ -2863,13 +2863,13 @@
>  			Default value is 0.
>  
>  	nfsaddrs=	[NFS] Deprecated.  Use ip= instead.
> -			See Documentation/filesystems/nfs/nfsroot.txt.
> +			See Documentation/admin-guide/nfs/nfsroot.rst.
>  
>  	nfsroot=	[NFS] nfs root filesystem for disk-less boxes.
> -			See Documentation/filesystems/nfs/nfsroot.txt.
> +			See Documentation/admin-guide/nfs/nfsroot.rst.
>  
>  	nfsrootdebug	[NFS] enable nfsroot debugging messages.
> -			See Documentation/filesystems/nfs/nfsroot.txt.
> +			See Documentation/admin-guide/nfs/nfsroot.rst.
>  
>  	nfs.callback_nr_threads=
>  			[NFSv4] set the total number of threads that the
> diff --git a/Documentation/filesystems/cifs/cifsroot.txt b/Documentation/filesystems/cifs/cifsroot.txt
> index 0fa1a2c36a40..947b7ec6ce9e 100644
> --- a/Documentation/filesystems/cifs/cifsroot.txt
> +++ b/Documentation/filesystems/cifs/cifsroot.txt
> @@ -13,7 +13,7 @@ network by utilizing SMB or CIFS protocol.
>  
>  In order to mount, the network stack will also need to be set up by
>  using 'ip=' config option. For more details, see
> -Documentation/filesystems/nfs/nfsroot.txt.
> +Documentation/admin-guide/nfs/nfsroot.rst.
>  
>  A CIFS root mount currently requires the use of SMB1+UNIX Extensions
>  which is only supported by the Samba server. SMB1 is the older
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index e1c355e84edd..eaabc3134294 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -620,7 +620,7 @@ because the CPUs that the Linux kernel supports don't do writes
>  until they are certain (1) that the write will actually happen, (2)
>  of the location of the write, and (3) of the value to be written.
>  But please carefully read the "CONTROL DEPENDENCIES" section and the
> -Documentation/RCU/rcu_dereference.txt file:  The compiler can and does
> +Documentation/RCU/rcu_dereference.rst file:  The compiler can and does
>  break dependencies in a great many highly creative ways.
>  
>  	CPU 1		      CPU 2
> diff --git a/Documentation/process/submit-checklist.rst b/Documentation/process/submit-checklist.rst
> index 8e56337d422d..3f8e9d5d95c2 100644
> --- a/Documentation/process/submit-checklist.rst
> +++ b/Documentation/process/submit-checklist.rst
> @@ -107,7 +107,7 @@ and elsewhere regarding submitting Linux kernel patches.
>      and why.
>  
>  26) If any ioctl's are added by the patch, then also update
> -    ``Documentation/ioctl/ioctl-number.rst``.
> +    ``Documentation/userspace-api/ioctl/ioctl-number.rst``.
>  
>  27) If your modified source code depends on or uses any of the kernel
>      APIs or features that are related to the following ``Kconfig`` symbols,
> diff --git a/Documentation/translations/it_IT/process/submit-checklist.rst b/Documentation/translations/it_IT/process/submit-checklist.rst
> index 995ee69fab11..3e575502690f 100644
> --- a/Documentation/translations/it_IT/process/submit-checklist.rst
> +++ b/Documentation/translations/it_IT/process/submit-checklist.rst
> @@ -117,7 +117,7 @@ sottomissione delle patch, in particolare
>      sorgenti che ne spieghi la logica: cosa fanno e perché.
>  
>  25) Se la patch aggiunge nuove chiamate ioctl, allora aggiornate
> -    ``Documentation/ioctl/ioctl-number.rst``.
> +    ``Documentation/userspace-api/ioctl/ioctl-number.rst``.
>  
>  26) Se il codice che avete modificato dipende o usa una qualsiasi interfaccia o
>      funzionalità del kernel che è associata a uno dei seguenti simboli
> diff --git a/Documentation/translations/ko_KR/memory-barriers.txt b/Documentation/translations/ko_KR/memory-barriers.txt
> index 2e831ece6e26..e50fe6541335 100644
> --- a/Documentation/translations/ko_KR/memory-barriers.txt
> +++ b/Documentation/translations/ko_KR/memory-barriers.txt
> @@ -641,7 +641,7 @@ P 는 짝수 번호 캐시 라인에 저장되어 있고, 변수 B 는 홀수 
>  리눅스 커널이 지원하는 CPU 들은 (1) 쓰기가 정말로 일어날지, (2) 쓰기가 어디에
>  이루어질지, 그리고 (3) 쓰여질 값을 확실히 알기 전까지는 쓰기를 수행하지 않기
>  때문입니다.  하지만 "컨트롤 의존성" 섹션과
> -Documentation/RCU/rcu_dereference.txt 파일을 주의 깊게 읽어 주시기 바랍니다:
> +Documentation/RCU/rcu_dereference.rst 파일을 주의 깊게 읽어 주시기 바랍니다:
>  컴파일러는 매우 창의적인 많은 방법으로 종속성을 깰 수 있습니다.
>  
>  	CPU 1		      CPU 2
> diff --git a/Documentation/translations/zh_CN/filesystems/sysfs.txt b/Documentation/translations/zh_CN/filesystems/sysfs.txt
> index ee1f37da5b23..a15c3ebdfa82 100644
> --- a/Documentation/translations/zh_CN/filesystems/sysfs.txt
> +++ b/Documentation/translations/zh_CN/filesystems/sysfs.txt
> @@ -281,7 +281,7 @@ drivers/ 包含了每个已为特定总线上的设备而挂载的驱动程序
>  假定驱动没有跨越多个总线类型)。
>  
>  fs/ 包含了一个为文件系统设立的目录。现在每个想要导出属性的文件系统必须
> -在 fs/ 下创建自己的层次结构(参见Documentation/filesystems/fuse.txt)。
> +在 fs/ 下创建自己的层次结构(参见Documentation/filesystems/fuse.rst)。
>  
>  dev/ 包含两个子目录： char/ 和 block/。在这两个子目录中，有以
>  <major>:<minor> 格式命名的符号链接。这些符号链接指向 sysfs 目录
> diff --git a/Documentation/translations/zh_CN/process/submit-checklist.rst b/Documentation/translations/zh_CN/process/submit-checklist.rst
> index 8738c55e42a2..50386e0e42e7 100644
> --- a/Documentation/translations/zh_CN/process/submit-checklist.rst
> +++ b/Documentation/translations/zh_CN/process/submit-checklist.rst
> @@ -97,7 +97,7 @@ Linux内核补丁提交清单
>  24) 所有内存屏障例如 ``barrier()``, ``rmb()``, ``wmb()`` 都需要源代码中的注
>      释来解释它们正在执行的操作及其原因的逻辑。
>  
> -25) 如果补丁添加了任何ioctl，那么也要更新 ``Documentation/ioctl/ioctl-number.rst``
> +25) 如果补丁添加了任何ioctl，那么也要更新 ``Documentation/userspace-api/ioctl/ioctl-number.rst``
>  
>  26) 如果修改后的源代码依赖或使用与以下 ``Kconfig`` 符号相关的任何内核API或
>      功能，则在禁用相关 ``Kconfig`` 符号和/或 ``=m`` （如果该选项可用）的情况
> diff --git a/Documentation/virt/kvm/arm/pvtime.rst b/Documentation/virt/kvm/arm/pvtime.rst
> index 2357dd2d8655..687b60d76ca9 100644
> --- a/Documentation/virt/kvm/arm/pvtime.rst
> +++ b/Documentation/virt/kvm/arm/pvtime.rst
> @@ -76,5 +76,5 @@ It is advisable that one or more 64k pages are set aside for the purpose of
>  these structures and not used for other purposes, this enables the guest to map
>  the region using 64k pages and avoids conflicting attributes with other memory.
>  
> -For the user space interface see Documentation/virt/kvm/devices/vcpu.txt
> +For the user space interface see Documentation/virt/kvm/devices/vcpu.rst
>  section "3. GROUP: KVM_ARM_VCPU_PVTIME_CTRL".
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index 9963e680770a..ca374d3fe085 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -110,5 +110,5 @@ Returns:
>  
>  Specifies the base address of the stolen time structure for this VCPU. The
>  base address must be 64 byte aligned and exist within a valid guest memory
> -region. See Documentation/virt/kvm/arm/pvtime.txt for more information
> +region. See Documentation/virt/kvm/arm/pvtime.rst for more information
>  including the layout of the stolen time structure.
> diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/hypercalls.rst
> index dbaf207e560d..ed4fddd364ea 100644
> --- a/Documentation/virt/kvm/hypercalls.rst
> +++ b/Documentation/virt/kvm/hypercalls.rst
> @@ -22,7 +22,7 @@ S390:
>    number in R1.
>  
>    For further information on the S390 diagnose call as supported by KVM,
> -  refer to Documentation/virt/kvm/s390-diag.txt.
> +  refer to Documentation/virt/kvm/s390-diag.rst.
>  
>  PowerPC:
>    It uses R3-R10 and hypercall number in R11. R4-R11 are used as output registers.
> @@ -30,7 +30,7 @@ PowerPC:
>  
>    KVM hypercalls uses 4 byte opcode, that are patched with 'hypercall-instructions'
>    property inside the device tree's /hypervisor node.
> -  For more information refer to Documentation/virt/kvm/ppc-pv.txt
> +  For more information refer to Documentation/virt/kvm/ppc-pv.rst
>  
>  MIPS:
>    KVM hypercalls use the HYPCALL instruction with code 0 and the hypercall
> diff --git a/arch/powerpc/include/uapi/asm/kvm_para.h b/arch/powerpc/include/uapi/asm/kvm_para.h
> index be48c2215fa2..a809b1b44ddf 100644
> --- a/arch/powerpc/include/uapi/asm/kvm_para.h
> +++ b/arch/powerpc/include/uapi/asm/kvm_para.h
> @@ -31,7 +31,7 @@
>   * Struct fields are always 32 or 64 bit aligned, depending on them being 32
>   * or 64 bit wide respectively.
>   *
> - * See Documentation/virt/kvm/ppc-pv.txt
> + * See Documentation/virt/kvm/ppc-pv.rst
>   */
>  struct kvm_vcpu_arch_shared {
>  	__u64 scratch1;
> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
> index d0aa6cff2e02..df0970994655 100644
> --- a/drivers/gpu/drm/Kconfig
> +++ b/drivers/gpu/drm/Kconfig
> @@ -164,7 +164,7 @@ config DRM_LOAD_EDID_FIRMWARE
>  	  monitor are unable to provide appropriate EDID data. Since this
>  	  feature is provided as a workaround for broken hardware, the
>  	  default case is N. Details and instructions how to build your own
> -	  EDID data are given in Documentation/driver-api/edid.rst.
> +	  EDID data are given in Documentation/admin-guide/edid.rst.
>  
>  config DRM_DP_CEC
>  	bool "Enable DisplayPort CEC-Tunneling-over-AUX HDMI support"
> diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
> index 5afb39688b55..e469e701b381 100644
> --- a/drivers/gpu/drm/drm_ioctl.c
> +++ b/drivers/gpu/drm/drm_ioctl.c
> @@ -740,7 +740,7 @@ static const struct drm_ioctl_desc drm_ioctls[] = {
>   *     };
>   *
>   * Please make sure that you follow all the best practices from
> - * ``Documentation/ioctl/botching-up-ioctls.rst``. Note that drm_ioctl()
> + * ``Documentation/process/botching-up-ioctls.rst``. Note that drm_ioctl()
>   * automatically zero-extends structures, hence make sure you can add more stuff
>   * at the end, i.e. don't put a variable sized array there.
>   *
> diff --git a/drivers/hwtracing/coresight/Kconfig b/drivers/hwtracing/coresight/Kconfig
> index 6ff30e25af55..6d42a6d3766f 100644
> --- a/drivers/hwtracing/coresight/Kconfig
> +++ b/drivers/hwtracing/coresight/Kconfig
> @@ -107,7 +107,7 @@ config CORESIGHT_CPU_DEBUG
>  	  can quickly get to know program counter (PC), secure state,
>  	  exception level, etc. Before use debugging functionality, platform
>  	  needs to ensure the clock domain and power domain are enabled
> -	  properly, please refer Documentation/trace/coresight-cpu-debug.rst
> +	  properly, please refer Documentation/trace/coresight/coresight-cpu-debug.rst
>  	  for detailed description and the example for usage.
>  
>  endif
> diff --git a/fs/fat/Kconfig b/fs/fat/Kconfig
> index 718163d0c621..ca31993dcb47 100644
> --- a/fs/fat/Kconfig
> +++ b/fs/fat/Kconfig
> @@ -69,7 +69,7 @@ config VFAT_FS
>  
>  	  The VFAT support enlarges your kernel by about 10 KB and it only
>  	  works if you said Y to the "DOS FAT fs support" above.  Please read
> -	  the file <file:Documentation/filesystems/vfat.txt> for details.  If
> +	  the file <file:Documentation/filesystems/vfat.rst> for details.  If
>  	  unsure, say Y.
>  
>  	  To compile this as a module, choose M here: the module will be called
> @@ -82,7 +82,7 @@ config FAT_DEFAULT_CODEPAGE
>  	help
>  	  This option should be set to the codepage of your FAT filesystems.
>  	  It can be overridden with the "codepage" mount option.
> -	  See <file:Documentation/filesystems/vfat.txt> for more information.
> +	  See <file:Documentation/filesystems/vfat.rst> for more information.
>  
>  config FAT_DEFAULT_IOCHARSET
>  	string "Default iocharset for FAT"
> @@ -96,7 +96,7 @@ config FAT_DEFAULT_IOCHARSET
>  	  Note that "utf8" is not recommended for FAT filesystems.
>  	  If unsure, you shouldn't set "utf8" here - select the next option
>  	  instead if you would like to use UTF-8 encoded file names by default.
> -	  See <file:Documentation/filesystems/vfat.txt> for more information.
> +	  See <file:Documentation/filesystems/vfat.rst> for more information.
>  
>  	  Enable any character sets you need in File Systems/Native Language
>  	  Support.
> @@ -114,4 +114,4 @@ config FAT_DEFAULT_UTF8
>  
>  	  Say Y if you use UTF-8 encoding for file names, N otherwise.
>  
> -	  See <file:Documentation/filesystems/vfat.txt> for more information.
> +	  See <file:Documentation/filesystems/vfat.rst> for more information.
> diff --git a/fs/fuse/Kconfig b/fs/fuse/Kconfig
> index eb2a585572dc..774b2618018a 100644
> --- a/fs/fuse/Kconfig
> +++ b/fs/fuse/Kconfig
> @@ -12,7 +12,7 @@ config FUSE_FS
>  	  although chances are your distribution already has that library
>  	  installed if you've installed the "fuse" package itself.
>  
> -	  See <file:Documentation/filesystems/fuse.txt> for more information.
> +	  See <file:Documentation/filesystems/fuse.rst> for more information.
>  	  See <file:Documentation/Changes> for needed library/utility version.
>  
>  	  If you want to develop a userspace FS, or if you want to use
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 97eec7522bf2..c7a65cf2bcca 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -2081,7 +2081,7 @@ static void end_polls(struct fuse_conn *fc)
>   * The same effect is usually achievable through killing the filesystem daemon
>   * and all users of the filesystem.  The exception is the combination of an
>   * asynchronous request and the tricky deadlock (see
> - * Documentation/filesystems/fuse.txt).
> + * Documentation/filesystems/fuse.rst).
>   *
>   * Aborting requests under I/O goes as follows: 1: Separate out unlocked
>   * requests, they should be finished off immediately.  Locked requests will be
> diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
> index 40b6c5ac46c0..88e1763e02f3 100644
> --- a/fs/nfs/Kconfig
> +++ b/fs/nfs/Kconfig
> @@ -164,7 +164,7 @@ config ROOT_NFS
>  	  If you want your system to mount its root file system via NFS,
>  	  choose Y here.  This is common practice for managing systems
>  	  without local permanent storage.  For details, read
> -	  <file:Documentation/filesystems/nfs/nfsroot.txt>.
> +	  <file:Documentation/admin-guide/nfs/nfsroot.rst>.
>  
>  	  Most people say N here.
>  
> diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
> index 444e2da4f60e..b35e128ee2fd 100644
> --- a/fs/overlayfs/Kconfig
> +++ b/fs/overlayfs/Kconfig
> @@ -9,7 +9,7 @@ config OVERLAY_FS
>  	  'lower' filesystem is either hidden or, in the case of directories,
>  	  merged with the 'upper' object.
>  
> -	  For more information see Documentation/filesystems/overlayfs.txt
> +	  For more information see Documentation/filesystems/overlayfs.rst
>  
>  config OVERLAY_FS_REDIRECT_DIR
>  	bool "Overlayfs: turn on redirect directory feature by default"
> @@ -38,7 +38,7 @@ config OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW
>  	  If backward compatibility is not an issue, then it is safe and
>  	  recommended to say N here.
>  
> -	  For more information, see Documentation/filesystems/overlayfs.txt
> +	  For more information, see Documentation/filesystems/overlayfs.rst
>  
>  	  If unsure, say Y.
>  
> @@ -102,7 +102,7 @@ config OVERLAY_FS_XINO_AUTO
>  	  If compatibility with applications that expect 32bit inodes is not an
>  	  issue, then it is safe and recommended to say Y here.
>  
> -	  For more information, see Documentation/filesystems/overlayfs.txt
> +	  For more information, see Documentation/filesystems/overlayfs.rst
>  
>  	  If unsure, say N.
>  
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 9f8fb6a34157..65ced68ab010 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1108,7 +1108,7 @@ void unpin_user_pages(struct page **pages, unsigned long npages);
>   * used to track the pincount (instead using of the GUP_PIN_COUNTING_BIAS
>   * scheme).
>   *
> - * For more information, please see Documentation/vm/pin_user_pages.rst.
> + * For more information, please see Documentation/core-api/pin_user_pages.rst.
>   *
>   * @page:	pointer to page to be queried.
>   * @Return:	True, if it is likely that the page has been "dma-pinned".
> @@ -2711,7 +2711,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
>   * releasing pages: get_user_pages*() pages must be released via put_page(),
>   * while pin_user_pages*() pages must be released via unpin_user_page().
>   *
> - * Please see Documentation/vm/pin_user_pages.rst for more information.
> + * Please see Documentation/core-api/pin_user_pages.rst for more information.
>   */
>  
>  static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
> diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
> index 7e0b460f872c..76513acc650f 100644
> --- a/include/uapi/linux/ethtool_netlink.h
> +++ b/include/uapi/linux/ethtool_netlink.h
> @@ -2,7 +2,7 @@
>  /*
>   * include/uapi/linux/ethtool_netlink.h - netlink interface for ethtool
>   *
> - * See Documentation/networking/ethtool-netlink.txt in kernel source tree for
> + * See Documentation/networking/ethtool-netlink.rst in kernel source tree for
>   * doucumentation of the interface.
>   */
>  
> diff --git a/include/uapi/rdma/rdma_user_ioctl_cmds.h b/include/uapi/rdma/rdma_user_ioctl_cmds.h
> index 7b1ec806f8f9..38ab7accb7be 100644
> --- a/include/uapi/rdma/rdma_user_ioctl_cmds.h
> +++ b/include/uapi/rdma/rdma_user_ioctl_cmds.h
> @@ -36,7 +36,7 @@
>  #include <linux/types.h>
>  #include <linux/ioctl.h>
>  
> -/* Documentation/ioctl/ioctl-number.rst */
> +/* Documentation/userspace-api/ioctl/ioctl-number.rst */
>  #define RDMA_IOCTL_MAGIC	0x1b
>  #define RDMA_VERBS_IOCTL \
>  	_IOWR(RDMA_IOCTL_MAGIC, 1, struct ib_uverbs_ioctl_hdr)
> diff --git a/mm/gup.c b/mm/gup.c
> index 441f7a48f370..bbf2d627b7f3 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2770,9 +2770,9 @@ EXPORT_SYMBOL_GPL(get_user_pages_fast);
>   * the arguments here are identical.
>   *
>   * FOLL_PIN means that the pages must be released via unpin_user_page(). Please
> - * see Documentation/vm/pin_user_pages.rst for further details.
> + * see Documentation/core-api/pin_user_pages.rst for further details.
>   *
> - * This is intended for Case 1 (DIO) in Documentation/vm/pin_user_pages.rst. It
> + * This is intended for Case 1 (DIO) in Documentation/core-api/pin_user_pages.rst. It
>   * is NOT intended for Case 2 (RDMA: long-term pins).
>   */
>  int pin_user_pages_fast(unsigned long start, int nr_pages,
> @@ -2795,9 +2795,9 @@ EXPORT_SYMBOL_GPL(pin_user_pages_fast);
>   * the arguments here are identical.
>   *
>   * FOLL_PIN means that the pages must be released via unpin_user_page(). Please
> - * see Documentation/vm/pin_user_pages.rst for details.
> + * see Documentation/core-api/pin_user_pages.rst for details.
>   *
> - * This is intended for Case 1 (DIO) in Documentation/vm/pin_user_pages.rst. It
> + * This is intended for Case 1 (DIO) in Documentation/core-api/pin_user_pages.rst. It
>   * is NOT intended for Case 2 (RDMA: long-term pins).
>   */
>  long pin_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
> @@ -2822,9 +2822,9 @@ EXPORT_SYMBOL(pin_user_pages_remote);
>   * FOLL_PIN is set.
>   *
>   * FOLL_PIN means that the pages must be released via unpin_user_page(). Please
> - * see Documentation/vm/pin_user_pages.rst for details.
> + * see Documentation/core-api/pin_user_pages.rst for details.
>   *
> - * This is intended for Case 1 (DIO) in Documentation/vm/pin_user_pages.rst. It
> + * This is intended for Case 1 (DIO) in Documentation/core-api/pin_user_pages.rst. It
>   * is NOT intended for Case 2 (RDMA: long-term pins).
>   */
>  long pin_user_pages(unsigned long start, unsigned long nr_pages,
> diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
> index 6490b845e17b..25a8888826b8 100644
> --- a/net/ipv4/Kconfig
> +++ b/net/ipv4/Kconfig
> @@ -129,7 +129,7 @@ config IP_PNP_DHCP
>  
>  	  If unsure, say Y. Note that if you want to use DHCP, a DHCP server
>  	  must be operating on your network.  Read
> -	  <file:Documentation/filesystems/nfs/nfsroot.txt> for details.
> +	  <file:Documentation/admin-guide/nfs/nfsroot.rst> for details.
>  
>  config IP_PNP_BOOTP
>  	bool "IP: BOOTP support"
> @@ -144,7 +144,7 @@ config IP_PNP_BOOTP
>  	  does BOOTP itself, providing all necessary information on the kernel
>  	  command line, you can say N here. If unsure, say Y. Note that if you
>  	  want to use BOOTP, a BOOTP server must be operating on your network.
> -	  Read <file:Documentation/filesystems/nfs/nfsroot.txt> for details.
> +	  Read <file:Documentation/admin-guide/nfs/nfsroot.rst> for details.
>  
>  config IP_PNP_RARP
>  	bool "IP: RARP support"
> @@ -157,7 +157,7 @@ config IP_PNP_RARP
>  	  older protocol which is being obsoleted by BOOTP and DHCP), say Y
>  	  here. Note that if you want to use RARP, a RARP server must be
>  	  operating on your network. Read
> -	  <file:Documentation/filesystems/nfs/nfsroot.txt> for details.
> +	  <file:Documentation/admin-guide/nfs/nfsroot.rst> for details.
>  
>  config NET_IPIP
>  	tristate "IP: tunneling"
> diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
> index 4438f6b12335..561f15b5a944 100644
> --- a/net/ipv4/ipconfig.c
> +++ b/net/ipv4/ipconfig.c
> @@ -1621,7 +1621,7 @@ late_initcall(ip_auto_config);
>  
>  /*
>   *  Decode any IP configuration options in the "ip=" or "nfsaddrs=" kernel
> - *  command line parameter.  See Documentation/filesystems/nfs/nfsroot.txt.
> + *  command line parameter.  See Documentation/admin-guide/nfs/nfsroot.rst.
>   */
>  static int __init ic_proto_name(char *name)
>  {
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index ebc218840fc2..84fcd88cc34e 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -252,7 +252,7 @@ static unsigned long vgic_v3_uaccess_read_pending(struct kvm_vcpu *vcpu,
>  	 * pending state of interrupt is latched in pending_latch variable.
>  	 * Userspace will save and restore pending state and line_level
>  	 * separately.
> -	 * Refer to Documentation/virt/kvm/devices/arm-vgic-v3.txt
> +	 * Refer to Documentation/virt/kvm/devices/arm-vgic-v3.rst
>  	 * for handling of ISPENDR and ICPENDR.
>  	 */
>  	for (i = 0; i < len * 8; i++) {
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index c7fefd6b1c80..42166ce359b4 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -42,7 +42,7 @@
>  			    VGIC_AFFINITY_LEVEL(val, 3))
>  
>  /*
> - * As per Documentation/virt/kvm/devices/arm-vgic-v3.txt,
> + * As per Documentation/virt/kvm/devices/arm-vgic-v3.rst,
>   * below macros are defined for CPUREG encoding.
>   */
>  #define KVM_REG_ARM_VGIC_SYSREG_OP0_MASK   0x000000000000c000
> @@ -63,7 +63,7 @@
>  				      KVM_REG_ARM_VGIC_SYSREG_OP2_MASK)
>  
>  /*
> - * As per Documentation/virt/kvm/devices/arm-vgic-its.txt,
> + * As per Documentation/virt/kvm/devices/arm-vgic-its.rst,
>   * below macros are defined for ITS table entry encoding.
>   */
>  #define KVM_ITS_CTE_VALID_SHIFT		63
> -- 
> 2.24.1
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
