Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5461AE996D
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 10:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfJ3JtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 05:49:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:42725 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbfJ3JtH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 05:49:07 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Oct 2019 02:49:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,247,1569308400"; 
   d="gz'50?scan'50,208,50";a="211291634"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 30 Oct 2019 02:49:03 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iPkb8-00085u-Hs; Wed, 30 Oct 2019 17:49:02 +0800
Date:   Wed, 30 Oct 2019 17:48:18 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>
Cc:     kbuild-all@lists.01.org, "hch@lst.de" <hch@lst.de>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: Re: [PATCH v2 1/3] dma-mapping: introduce new dma unmap and sync api
 variants
Message-ID: <201910301705.uLxW2OtK%lkp@intel.com>
References: <20191024124130.16871-2-laurentiu.tudor@nxp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vlnajn522vh26pjs"
Content-Disposition: inline
In-Reply-To: <20191024124130.16871-2-laurentiu.tudor@nxp.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vlnajn522vh26pjs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Laurentiu,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]
[also build test ERROR on v5.4-rc5 next-20191029]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Laurentiu-Tudor/dma-mapping-introduce-new-dma-unmap-and-sync-variants/20191027-173418
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 503a64635d5ef7351657c78ad77f8b5ff658d5fc
config: um-x86_64_defconfig (attached as .config)
compiler: gcc-7 (Debian 7.4.0-14) 7.4.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=um SUBARCH=x86_64

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/skbuff.h:31:0,
                    from include/net/net_namespace.h:38,
                    from include/linux/inet.h:42,
                    from include/linux/sunrpc/msg_prot.h:204,
                    from include/linux/sunrpc/auth.h:16,
                    from include/linux/nfs_fs.h:31,
                    from init/do_mounts.c:23:
   include/linux/dma-mapping.h: In function 'dma_sync_single_for_cpu_desc':
   include/linux/dma-mapping.h:539:1: warning: no return statement in function returning non-void [-Wreturn-type]
    }
    ^
   include/linux/dma-mapping.h: In function 'dma_unmap_single_attrs_desc':
>> include/linux/dma-mapping.h:638:34: error: implicit declaration of function 'get_dma_ops'; did you mean 'get_mm_rss'? [-Werror=implicit-function-declaration]
     const struct dma_map_ops *ops = get_dma_ops(dev);
                                     ^~~~~~~~~~~
                                     get_mm_rss
   include/linux/dma-mapping.h:638:34: warning: initialization makes pointer from integer without a cast [-Wint-conversion]
   cc1: some warnings being treated as errors

vim +638 include/linux/dma-mapping.h

   534	
   535	static inline void *
   536	dma_sync_single_for_cpu_desc(struct device *dev, dma_addr_t addr, size_t size,
   537				     enum dma_data_direction dir)
   538	{
 > 539	}
   540	static inline void dma_sync_single_for_device(struct device *dev,
   541			dma_addr_t addr, size_t size, enum dma_data_direction dir)
   542	{
   543	}
   544	static inline void dma_sync_sg_for_cpu(struct device *dev,
   545			struct scatterlist *sg, int nelems, enum dma_data_direction dir)
   546	{
   547	}
   548	static inline void dma_sync_sg_for_device(struct device *dev,
   549			struct scatterlist *sg, int nelems, enum dma_data_direction dir)
   550	{
   551	}
   552	static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
   553	{
   554		return -ENOMEM;
   555	}
   556	static inline void *dma_alloc_attrs(struct device *dev, size_t size,
   557			dma_addr_t *dma_handle, gfp_t flag, unsigned long attrs)
   558	{
   559		return NULL;
   560	}
   561	static void dma_free_attrs(struct device *dev, size_t size, void *cpu_addr,
   562			dma_addr_t dma_handle, unsigned long attrs)
   563	{
   564	}
   565	static inline void *dmam_alloc_attrs(struct device *dev, size_t size,
   566			dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
   567	{
   568		return NULL;
   569	}
   570	static inline void dmam_free_coherent(struct device *dev, size_t size,
   571			void *vaddr, dma_addr_t dma_handle)
   572	{
   573	}
   574	static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
   575			enum dma_data_direction dir)
   576	{
   577	}
   578	static inline int dma_get_sgtable_attrs(struct device *dev,
   579			struct sg_table *sgt, void *cpu_addr, dma_addr_t dma_addr,
   580			size_t size, unsigned long attrs)
   581	{
   582		return -ENXIO;
   583	}
   584	static inline int dma_mmap_attrs(struct device *dev, struct vm_area_struct *vma,
   585			void *cpu_addr, dma_addr_t dma_addr, size_t size,
   586			unsigned long attrs)
   587	{
   588		return -ENXIO;
   589	}
   590	static inline bool dma_can_mmap(struct device *dev)
   591	{
   592		return false;
   593	}
   594	static inline int dma_supported(struct device *dev, u64 mask)
   595	{
   596		return 0;
   597	}
   598	static inline int dma_set_mask(struct device *dev, u64 mask)
   599	{
   600		return -EIO;
   601	}
   602	static inline int dma_set_coherent_mask(struct device *dev, u64 mask)
   603	{
   604		return -EIO;
   605	}
   606	static inline u64 dma_get_required_mask(struct device *dev)
   607	{
   608		return 0;
   609	}
   610	static inline size_t dma_max_mapping_size(struct device *dev)
   611	{
   612		return 0;
   613	}
   614	static inline unsigned long dma_get_merge_boundary(struct device *dev)
   615	{
   616		return 0;
   617	}
   618	#endif /* CONFIG_HAS_DMA */
   619	
   620	static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
   621			size_t size, enum dma_data_direction dir, unsigned long attrs)
   622	{
   623		debug_dma_map_single(dev, ptr, size);
   624		return dma_map_page_attrs(dev, virt_to_page(ptr), offset_in_page(ptr),
   625				size, dir, attrs);
   626	}
   627	
   628	static inline void dma_unmap_single_attrs(struct device *dev, dma_addr_t addr,
   629			size_t size, enum dma_data_direction dir, unsigned long attrs)
   630	{
   631		return dma_unmap_page_attrs(dev, addr, size, dir, attrs);
   632	}
   633	
   634	static inline void *
   635	dma_unmap_single_attrs_desc(struct device *dev, dma_addr_t addr, size_t size,
   636				    enum dma_data_direction dir, unsigned long attrs)
   637	{
 > 638		const struct dma_map_ops *ops = get_dma_ops(dev);
   639		void *ptr = NULL;
   640	
   641		if (ops && ops->get_virt_addr)
   642			ptr = ops->get_virt_addr(dev, addr);
   643	
   644		dma_unmap_single_attrs(dev, addr, size, dir, attrs);
   645	
   646		return ptr;
   647	}
   648	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--vlnajn522vh26pjs
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
t/LoHIAAAA==

--vlnajn522vh26pjs--
