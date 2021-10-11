Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA1E428C35
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 13:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbhJKLlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 07:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233878AbhJKLlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 07:41:04 -0400
X-Greylist: delayed 66 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 11 Oct 2021 04:39:03 PDT
Received: from lb2-smtp-cloud9.xs4all.net (lb2-smtp-cloud9.xs4all.net [IPv6:2001:888:0:108::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0C6C061570;
        Mon, 11 Oct 2021 04:39:03 -0700 (PDT)
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud9.xs4all.net with ESMTPA
        id ZtcrmeTHF8cVwZtcum6mB7; Mon, 11 Oct 2021 13:37:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s2;
        t=1633952274; bh=EJ468NMYmDML0AsBV+rtlsJvCbh1Ozlsqt14xY8DshU=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=uewlgQFmKMF1tLoPklw8UyISWs4X+SzrBkgZk9a4yocsOCZl9USgHVN8k1m1Ovf3P
         ZghQAFKZTYKNfc+WJx9ZxvzVCcIWPInpuqmOiIbKblHBPGmJiKt6wQkgMdp2E2AsbJ
         fKOQ+rdzQ90EtLElLP9nTW1IYLFryKItG7rXdOcEN9jv0ECaVynxanulCyNldxIxCR
         Yn7uKUFdO8rBWPEHWi93OtbPLWmyyjs7pJMGqQr8YdUveZviQS10T/Cgj+oqb+o+gv
         SqHLZV383tgzP9e/rw29caG8P3hEobf0z9HA1sRw133bLAVGoKVDolpPtstQid/Ai8
         Uhwoh2d0gNAsg==
Subject: Re: [PATCH v2 2/2] qcom_scm: hide Kconfig symbol
To:     Arnd Bergmann <arnd@kernel.org>, linux-kernel@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-gpio@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Alex Elder <elder@linaro.org>
References: <20211007151010.333516-1-arnd@kernel.org>
 <20211007151010.333516-2-arnd@kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <007b8902-312a-cbfd-5504-761687b7fdf8@xs4all.nl>
Date:   Mon, 11 Oct 2021 13:37:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211007151010.333516-2-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfJuuxVzHxX/HmRjTyBbu47R9dyBNkr37HCMQ1Xbi17ioHXz/+hb+Aj8C3tlEtmlSao8NmcH59bXPGXlwwWTUYI7+sNIQF+aiRYEQeezpnbcfpOtkrwq8
 Q3CRj9K7XRQ8VBtz/bAyVP+BqkL3tf6mu4cwRnHr2V30MWOzgJs6sJI/WKL1zfSQ6Edn4Xs/GXz5wO7d4/f6yf8mY8R0Qtdc6tOLXwfiZg44jNDCwvY4jwxD
 58z29k40YCgWdFKgdHtxq0jIbAzixXJVygYwSTkSnX/Yg4+Oo9H5jZRTH5n+0FICC62LzOG8uIgEhjzea5lne6zyDC/7eqTmxgH0IUuK0pbjgjXVflG5jqdv
 kUp1gU5FeukXumMNNFa1NZWuWZhAq5idlljOJXUrGZRKed307o29pbbLWA472cBxhDF9BQdGKmTCsF75pnxvPMD8yyBvGgd448ENjtqQS9o4QQ0v5XlP5uvm
 tXAqXCAG3FWAv+Q/hFu7ncuj5feQDHbXVK0/bDTC7MGnecml/Zc6v1OllO2CiqPxZeMu7irEWqsnKLdamV3ps+fgcoAz/Dzvfc61OdZkyoNQnYv8zfoWziuz
 nx7wOzWY+5NGM3kDxeU9Jmc/srCjIC8NuqTpV50wlcWCZ5VOsnHP16UywKJMIYomgWsyVfMVSD+Quk0+F6fbaUvUOgL3+iOjbE2pRzuuUDeTPGPPOeh6chfd
 QU4iWqSBFqIkhYUSylrmHj81ryYQwC5SPxaLsIvJt2mikIWprBBDGP6bzJrJKQIbdjg2K6eeVXkTjEqxHhvDLm4Fod8MWYHJPR4TlzFbfZg2pze0xlfPRMeo
 8XC+rDnxfCeLsjJgT6/a1NSgTtabgCDl7v0mU7ojS+tChDV7a2T20gooopVuFizGq9+GZ1gzqYYVuzZeC9LXh0UQnxrm4AjVNE3OxerZ9pIHYtsW/8q7LWVl
 Ul19nQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/10/2021 17:10, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Now that SCM can be a loadable module, we have to add another
> dependency to avoid link failures when ipa or adreno-gpu are
> built-in:
> 
> aarch64-linux-ld: drivers/net/ipa/ipa_main.o: in function `ipa_probe':
> ipa_main.c:(.text+0xfc4): undefined reference to `qcom_scm_is_available'
> 
> ld.lld: error: undefined symbol: qcom_scm_is_available
>>>> referenced by adreno_gpu.c
>>>>               gpu/drm/msm/adreno/adreno_gpu.o:(adreno_zap_shader_load) in archive drivers/built-in.a
> 
> This can happen when CONFIG_ARCH_QCOM is disabled and we don't select
> QCOM_MDT_LOADER, but some other module selects QCOM_SCM. Ideally we'd
> use a similar dependency here to what we have for QCOM_RPROC_COMMON,
> but that causes dependency loops from other things selecting QCOM_SCM.
> 
> This appears to be an endless problem, so try something different this
> time:
> 
>  - CONFIG_QCOM_SCM becomes a hidden symbol that nothing 'depends on'
>    but that is simply selected by all of its users
> 
>  - All the stubs in include/linux/qcom_scm.h can go away
> 
>  - arm-smccc.h needs to provide a stub for __arm_smccc_smc() to
>    allow compile-testing QCOM_SCM on all architectures.
> 
>  - To avoid a circular dependency chain involving RESET_CONTROLLER
>    and PINCTRL_SUNXI, drop the 'select RESET_CONTROLLER' statement.
>    According to my testing this still builds fine, and the QCOM
>    platform selects this symbol already.

Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Thanks,

	Hans

> 
> Acked-by: Kalle Valo <kvalo@codeaurora.org>
> Acked-by: Alex Elder <elder@linaro.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Changes in v2:
> - fix the iommu dependencies
> 
> I've queued this version as a bugfix along with patch 1/2
> in my asm-generic tree.
> 
>  drivers/firmware/Kconfig                   |  5 +-
>  drivers/gpu/drm/msm/Kconfig                |  4 +-
>  drivers/iommu/Kconfig                      |  3 +-
>  drivers/iommu/arm/arm-smmu/Makefile        |  3 +-
>  drivers/iommu/arm/arm-smmu/arm-smmu-impl.c |  3 +-
>  drivers/media/platform/Kconfig             |  2 +-
>  drivers/mmc/host/Kconfig                   |  2 +-
>  drivers/net/ipa/Kconfig                    |  1 +
>  drivers/net/wireless/ath/ath10k/Kconfig    |  2 +-
>  drivers/pinctrl/qcom/Kconfig               |  3 +-
>  include/linux/arm-smccc.h                  | 10 +++
>  include/linux/qcom_scm.h                   | 71 ----------------------
>  12 files changed, 24 insertions(+), 85 deletions(-)
> 
> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> index 220a58cf0a44..cda7d7162cbb 100644
> --- a/drivers/firmware/Kconfig
> +++ b/drivers/firmware/Kconfig
> @@ -203,10 +203,7 @@ config INTEL_STRATIX10_RSU
>  	  Say Y here if you want Intel RSU support.
>  
>  config QCOM_SCM
> -	tristate "Qcom SCM driver"
> -	depends on ARM || ARM64
> -	depends on HAVE_ARM_SMCCC
> -	select RESET_CONTROLLER
> +	tristate
>  
>  config QCOM_SCM_DOWNLOAD_MODE_DEFAULT
>  	bool "Qualcomm download mode enabled by default"
> diff --git a/drivers/gpu/drm/msm/Kconfig b/drivers/gpu/drm/msm/Kconfig
> index e9c6af78b1d7..3ddf739a6f9b 100644
> --- a/drivers/gpu/drm/msm/Kconfig
> +++ b/drivers/gpu/drm/msm/Kconfig
> @@ -17,7 +17,7 @@ config DRM_MSM
>  	select DRM_SCHED
>  	select SHMEM
>  	select TMPFS
> -	select QCOM_SCM if ARCH_QCOM
> +	select QCOM_SCM
>  	select WANT_DEV_COREDUMP
>  	select SND_SOC_HDMI_CODEC if SND_SOC
>  	select SYNC_FILE
> @@ -55,7 +55,7 @@ config DRM_MSM_GPU_SUDO
>  
>  config DRM_MSM_HDMI_HDCP
>  	bool "Enable HDMI HDCP support in MSM DRM driver"
> -	depends on DRM_MSM && QCOM_SCM
> +	depends on DRM_MSM
>  	default y
>  	help
>  	  Choose this option to enable HDCP state machine
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 124c41adeca1..c5c71b7ab7e8 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -308,7 +308,6 @@ config APPLE_DART
>  config ARM_SMMU
>  	tristate "ARM Ltd. System MMU (SMMU) Support"
>  	depends on ARM64 || ARM || (COMPILE_TEST && !GENERIC_ATOMIC64)
> -	depends on QCOM_SCM || !QCOM_SCM #if QCOM_SCM=m this can't be =y
>  	select IOMMU_API
>  	select IOMMU_IO_PGTABLE_LPAE
>  	select ARM_DMA_USE_IOMMU if ARM
> @@ -438,7 +437,7 @@ config QCOM_IOMMU
>  	# Note: iommu drivers cannot (yet?) be built as modules
>  	bool "Qualcomm IOMMU Support"
>  	depends on ARCH_QCOM || (COMPILE_TEST && !GENERIC_ATOMIC64)
> -	depends on QCOM_SCM=y
> +	select QCOM_SCM
>  	select IOMMU_API
>  	select IOMMU_IO_PGTABLE_LPAE
>  	select ARM_DMA_USE_IOMMU
> diff --git a/drivers/iommu/arm/arm-smmu/Makefile b/drivers/iommu/arm/arm-smmu/Makefile
> index e240a7bcf310..b0cc01aa20c9 100644
> --- a/drivers/iommu/arm/arm-smmu/Makefile
> +++ b/drivers/iommu/arm/arm-smmu/Makefile
> @@ -1,4 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
>  obj-$(CONFIG_QCOM_IOMMU) += qcom_iommu.o
>  obj-$(CONFIG_ARM_SMMU) += arm_smmu.o
> -arm_smmu-objs += arm-smmu.o arm-smmu-impl.o arm-smmu-nvidia.o arm-smmu-qcom.o
> +arm_smmu-objs += arm-smmu.o arm-smmu-impl.o arm-smmu-nvidia.o
> +arm_smmu-$(CONFIG_ARM_SMMU_QCOM) += arm-smmu-qcom.o
> diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-impl.c b/drivers/iommu/arm/arm-smmu/arm-smmu-impl.c
> index 9f465e146799..2c25cce38060 100644
> --- a/drivers/iommu/arm/arm-smmu/arm-smmu-impl.c
> +++ b/drivers/iommu/arm/arm-smmu/arm-smmu-impl.c
> @@ -215,7 +215,8 @@ struct arm_smmu_device *arm_smmu_impl_init(struct arm_smmu_device *smmu)
>  	    of_device_is_compatible(np, "nvidia,tegra186-smmu"))
>  		return nvidia_smmu_impl_init(smmu);
>  
> -	smmu = qcom_smmu_impl_init(smmu);
> +	if (IS_ENABLED(CONFIG_ARM_SMMU_QCOM))
> +		smmu = qcom_smmu_impl_init(smmu);
>  
>  	if (of_device_is_compatible(np, "marvell,ap806-smmu-500"))
>  		smmu->impl = &mrvl_mmu500_impl;
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 157c924686e4..80321e03809a 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -565,7 +565,7 @@ config VIDEO_QCOM_VENUS
>  	depends on VIDEO_DEV && VIDEO_V4L2 && QCOM_SMEM
>  	depends on (ARCH_QCOM && IOMMU_DMA) || COMPILE_TEST
>  	select QCOM_MDT_LOADER if ARCH_QCOM
> -	select QCOM_SCM if ARCH_QCOM
> +	select QCOM_SCM
>  	select VIDEOBUF2_DMA_CONTIG
>  	select V4L2_MEM2MEM_DEV
>  	help
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index 71313961cc54..95b3511b0560 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -547,7 +547,7 @@ config MMC_SDHCI_MSM
>  	depends on MMC_SDHCI_PLTFM
>  	select MMC_SDHCI_IO_ACCESSORS
>  	select MMC_CQHCI
> -	select QCOM_SCM if MMC_CRYPTO && ARCH_QCOM
> +	select QCOM_SCM if MMC_CRYPTO
>  	help
>  	  This selects the Secure Digital Host Controller Interface (SDHCI)
>  	  support present in Qualcomm SOCs. The controller supports
> diff --git a/drivers/net/ipa/Kconfig b/drivers/net/ipa/Kconfig
> index 8f99cfa14680..d037682fb7ad 100644
> --- a/drivers/net/ipa/Kconfig
> +++ b/drivers/net/ipa/Kconfig
> @@ -4,6 +4,7 @@ config QCOM_IPA
>  	depends on ARCH_QCOM || COMPILE_TEST
>  	depends on QCOM_RPROC_COMMON || (QCOM_RPROC_COMMON=n && COMPILE_TEST)
>  	select QCOM_MDT_LOADER if ARCH_QCOM
> +	select QCOM_SCM
>  	select QCOM_QMI_HELPERS
>  	help
>  	  Choose Y or M here to include support for the Qualcomm
> diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
> index 741289e385d5..ca007b800f75 100644
> --- a/drivers/net/wireless/ath/ath10k/Kconfig
> +++ b/drivers/net/wireless/ath/ath10k/Kconfig
> @@ -44,7 +44,7 @@ config ATH10K_SNOC
>  	tristate "Qualcomm ath10k SNOC support"
>  	depends on ATH10K
>  	depends on ARCH_QCOM || COMPILE_TEST
> -	depends on QCOM_SCM || !QCOM_SCM #if QCOM_SCM=m this can't be =y
> +	select QCOM_SCM
>  	select QCOM_QMI_HELPERS
>  	help
>  	  This module adds support for integrated WCN3990 chip connected
> diff --git a/drivers/pinctrl/qcom/Kconfig b/drivers/pinctrl/qcom/Kconfig
> index 32ea2a8ec02b..5ff4207df66e 100644
> --- a/drivers/pinctrl/qcom/Kconfig
> +++ b/drivers/pinctrl/qcom/Kconfig
> @@ -3,7 +3,8 @@ if (ARCH_QCOM || COMPILE_TEST)
>  
>  config PINCTRL_MSM
>  	tristate "Qualcomm core pin controller driver"
> -	depends on GPIOLIB && (QCOM_SCM || !QCOM_SCM) #if QCOM_SCM=m this can't be =y
> +	depends on GPIOLIB
> +	select QCOM_SCM
>  	select PINMUX
>  	select PINCONF
>  	select GENERIC_PINCONF
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index 7d1cabe15262..63ccb5252190 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -321,10 +321,20 @@ asmlinkage unsigned long __arm_smccc_sve_check(unsigned long x0);
>   * from register 0 to 3 on return from the SMC instruction.  An optional
>   * quirk structure provides vendor specific behavior.
>   */
> +#ifdef CONFIG_HAVE_ARM_SMCCC
>  asmlinkage void __arm_smccc_smc(unsigned long a0, unsigned long a1,
>  			unsigned long a2, unsigned long a3, unsigned long a4,
>  			unsigned long a5, unsigned long a6, unsigned long a7,
>  			struct arm_smccc_res *res, struct arm_smccc_quirk *quirk);
> +#else
> +static inline void __arm_smccc_smc(unsigned long a0, unsigned long a1,
> +			unsigned long a2, unsigned long a3, unsigned long a4,
> +			unsigned long a5, unsigned long a6, unsigned long a7,
> +			struct arm_smccc_res *res, struct arm_smccc_quirk *quirk)
> +{
> +	*res = (struct arm_smccc_res){};
> +}
> +#endif
>  
>  /**
>   * __arm_smccc_hvc() - make HVC calls
> diff --git a/include/linux/qcom_scm.h b/include/linux/qcom_scm.h
> index c0475d1c9885..81cad9e1e412 100644
> --- a/include/linux/qcom_scm.h
> +++ b/include/linux/qcom_scm.h
> @@ -61,7 +61,6 @@ enum qcom_scm_ice_cipher {
>  #define QCOM_SCM_PERM_RW (QCOM_SCM_PERM_READ | QCOM_SCM_PERM_WRITE)
>  #define QCOM_SCM_PERM_RWX (QCOM_SCM_PERM_RW | QCOM_SCM_PERM_EXEC)
>  
> -#if IS_ENABLED(CONFIG_QCOM_SCM)
>  extern bool qcom_scm_is_available(void);
>  
>  extern int qcom_scm_set_cold_boot_addr(void *entry, const cpumask_t *cpus);
> @@ -115,74 +114,4 @@ extern int qcom_scm_lmh_dcvsh(u32 payload_fn, u32 payload_reg, u32 payload_val,
>  extern int qcom_scm_lmh_profile_change(u32 profile_id);
>  extern bool qcom_scm_lmh_dcvsh_available(void);
>  
> -#else
> -
> -#include <linux/errno.h>
> -
> -static inline bool qcom_scm_is_available(void) { return false; }
> -
> -static inline int qcom_scm_set_cold_boot_addr(void *entry,
> -		const cpumask_t *cpus) { return -ENODEV; }
> -static inline int qcom_scm_set_warm_boot_addr(void *entry,
> -		const cpumask_t *cpus) { return -ENODEV; }
> -static inline void qcom_scm_cpu_power_down(u32 flags) {}
> -static inline u32 qcom_scm_set_remote_state(u32 state,u32 id)
> -		{ return -ENODEV; }
> -
> -static inline int qcom_scm_pas_init_image(u32 peripheral, const void *metadata,
> -		size_t size) { return -ENODEV; }
> -static inline int qcom_scm_pas_mem_setup(u32 peripheral, phys_addr_t addr,
> -		phys_addr_t size) { return -ENODEV; }
> -static inline int qcom_scm_pas_auth_and_reset(u32 peripheral)
> -		{ return -ENODEV; }
> -static inline int qcom_scm_pas_shutdown(u32 peripheral) { return -ENODEV; }
> -static inline bool qcom_scm_pas_supported(u32 peripheral) { return false; }
> -
> -static inline int qcom_scm_io_readl(phys_addr_t addr, unsigned int *val)
> -		{ return -ENODEV; }
> -static inline int qcom_scm_io_writel(phys_addr_t addr, unsigned int val)
> -		{ return -ENODEV; }
> -
> -static inline bool qcom_scm_restore_sec_cfg_available(void) { return false; }
> -static inline int qcom_scm_restore_sec_cfg(u32 device_id, u32 spare)
> -		{ return -ENODEV; }
> -static inline int qcom_scm_iommu_secure_ptbl_size(u32 spare, size_t *size)
> -		{ return -ENODEV; }
> -static inline int qcom_scm_iommu_secure_ptbl_init(u64 addr, u32 size, u32 spare)
> -		{ return -ENODEV; }
> -extern inline int qcom_scm_mem_protect_video_var(u32 cp_start, u32 cp_size,
> -						 u32 cp_nonpixel_start,
> -						 u32 cp_nonpixel_size)
> -		{ return -ENODEV; }
> -static inline int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
> -		unsigned int *src, const struct qcom_scm_vmperm *newvm,
> -		unsigned int dest_cnt) { return -ENODEV; }
> -
> -static inline bool qcom_scm_ocmem_lock_available(void) { return false; }
> -static inline int qcom_scm_ocmem_lock(enum qcom_scm_ocmem_client id, u32 offset,
> -		u32 size, u32 mode) { return -ENODEV; }
> -static inline int qcom_scm_ocmem_unlock(enum qcom_scm_ocmem_client id,
> -		u32 offset, u32 size) { return -ENODEV; }
> -
> -static inline bool qcom_scm_ice_available(void) { return false; }
> -static inline int qcom_scm_ice_invalidate_key(u32 index) { return -ENODEV; }
> -static inline int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
> -				       enum qcom_scm_ice_cipher cipher,
> -				       u32 data_unit_size) { return -ENODEV; }
> -
> -static inline bool qcom_scm_hdcp_available(void) { return false; }
> -static inline int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt,
> -		u32 *resp) { return -ENODEV; }
> -
> -static inline int qcom_scm_qsmmu500_wait_safe_toggle(bool en)
> -		{ return -ENODEV; }
> -
> -static inline int qcom_scm_lmh_dcvsh(u32 payload_fn, u32 payload_reg, u32 payload_val,
> -				     u64 limit_node, u32 node_id, u64 version)
> -		{ return -ENODEV; }
> -
> -static inline int qcom_scm_lmh_profile_change(u32 profile_id) { return -ENODEV; }
> -
> -static inline bool qcom_scm_lmh_dcvsh_available(void) { return -ENODEV; }
> -#endif
>  #endif
> 

