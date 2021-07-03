Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30EE3BA7FE
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 11:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhGCJGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 05:06:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33885 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229582AbhGCJGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Jul 2021 05:06:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625303055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TVu0raAXHHac8RYBeboQlPHsVSFx1+2WCdPZevKx+R0=;
        b=EVFXqqoBc85nnNKiYKr/a03krcowvMv+XbMOLvPBBH0YIGt1cMcahHe3rVn2tRK5kI7qM7
        W1Vf1Okc9ILQdyeKkdZ5WKShGh7IQB31afeHJAzcYwwhonZoMJD7k4DTzYiGemAtmSTvAf
        WM1hspD8jk9A+UJjjZxS87iVWI1LrhA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-X0vpI8kfNpmnalXYWuHW1g-1; Sat, 03 Jul 2021 05:04:14 -0400
X-MC-Unique: X0vpI8kfNpmnalXYWuHW1g-1
Received: by mail-wm1-f72.google.com with SMTP id j38-20020a05600c1c26b02901dbf7d18ff8so7537752wms.8
        for <netdev@vger.kernel.org>; Sat, 03 Jul 2021 02:04:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TVu0raAXHHac8RYBeboQlPHsVSFx1+2WCdPZevKx+R0=;
        b=TSBuInW2c6ZT1EARGgVa2srY68MbekEEoXXeKHG2GdOZSwWuKZnCpKZVdWIdR9LMi+
         MHbSVMB40KFJhW87lS9iuxvm7l05Cn+kx5hyHwe3of9b31DUY1SawN2d3aPiIAdobrW4
         Aj0ymIpoXY6oZ0Darqv5jKXD+qoAIZ6CzL451oegbfoAKEUrgvMHesHrPIBL+YnhgbrB
         Uk6dlpD0J7N1/gUfuU4NW8LBxHCOI8JJU6JFFr87BihQmcZ5z9I/wmAfXsNwVq0rAm3K
         1NMuVH2N+fjz9RDSqFYjXCDTwEiF3q7fMfTlcQlFXVQwIOaNEpXx1Z4T8qagssi2IInr
         sAbA==
X-Gm-Message-State: AOAM531RErbqEr8xg+pAqUYYffNO7ggi3GggKyo5I6gdIGegA0qpbHp9
        muznA7XWHgQyoqw+03Pg/sUe52hfby6T3R8q3eu5E+lg5CVAju5/LnfKdWd7h+9reWcP5H1Hi++
        3AuK0ABQRCmOLatDq
X-Received: by 2002:a05:600c:1d06:: with SMTP id l6mr1310992wms.111.1625303051925;
        Sat, 03 Jul 2021 02:04:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBiMbxnrnsML4eQwt8oUtcimEaS5j9QhAj9zlj+jkBSqLAfDER1GiUjarz9whoxVL6duyUJw==
X-Received: by 2002:a05:600c:1d06:: with SMTP id l6mr1310965wms.111.1625303051644;
        Sat, 03 Jul 2021 02:04:11 -0700 (PDT)
Received: from redhat.com ([2.55.4.39])
        by smtp.gmail.com with ESMTPSA id 2sm5714024wrz.87.2021.07.03.02.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jul 2021 02:04:11 -0700 (PDT)
Date:   Sat, 3 Jul 2021 05:04:07 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>, jasowang@redhat.com,
        clang-built-linux@googlegroups.com, kbuild-all@lists.01.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] vDPA/ifcvf: implement management netlink framework
 for ifcvf
Message-ID: <20210703050320-mutt-send-email-mst@kernel.org>
References: <20210630082145.5729-3-lingshan.zhu@intel.com>
 <202107010221.pN7dwv6A-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202107010221.pN7dwv6A-lkp@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 03:04:09AM +0800, kernel test robot wrote:
> Hi Zhu,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on linus/master]
> [also build test WARNING on v5.13 next-20210630]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/0day-ci/linux/commits/Zhu-Lingshan/vDPA-ifcvf-implement-management-netlink-framework/20210630-162940
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 007b350a58754a93ca9fe50c498cc27780171153
> config: x86_64-randconfig-a015-20210630 (attached as .config)
> compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project 8d21d5472501460933e78aead04cf59579025ba4)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install x86_64 cross compiling tool for clang build
>         # apt-get install binutils-x86-64-linux-gnu
>         # https://github.com/0day-ci/linux/commit/7ea782fbd896e1a5b3c01b29f4929773748a525f
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Zhu-Lingshan/vDPA-ifcvf-implement-management-netlink-framework/20210630-162940
>         git checkout 7ea782fbd896e1a5b3c01b29f4929773748a525f
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=x86_64 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
> >> drivers/vdpa/ifcvf/ifcvf_main.c:612:14: warning: variable 'adapter' is uninitialized when used here [-Wuninitialized]
>            put_device(&adapter->vdpa.dev);
>                        ^~~~~~~
>    drivers/vdpa/ifcvf/ifcvf_main.c:546:31: note: initialize the variable 'adapter' to silence this warning
>            struct ifcvf_adapter *adapter;
>                                         ^
>                                          = NULL
>    1 warning generated.
> 


Actually the problem is real and this is almost surely the wrong fix.
We need an extra label to skip using put_device when adapter was not
yet initialized.



> vim +/adapter +612 drivers/vdpa/ifcvf/ifcvf_main.c
> 
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  541  
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  542  static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  543  {
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  544  	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  545  	struct device *dev = &pdev->dev;
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  546  	struct ifcvf_adapter *adapter;
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  547  	u32 dev_type;
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  548  	int ret;
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  549  
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  550  	ifcvf_mgmt_dev = kzalloc(sizeof(struct ifcvf_vdpa_mgmt_dev), GFP_KERNEL);
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  551  	if (!ifcvf_mgmt_dev) {
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  552  		IFCVF_ERR(pdev, "Failed to alloc memory for the vDPA management device\n");
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  553  		return -ENOMEM;
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  554  	}
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  555  
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  556  	dev_type = get_dev_type(pdev);
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  557  	switch (dev_type) {
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  558  	case VIRTIO_ID_NET:
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  559  		ifcvf_mgmt_dev->mdev.id_table = id_table_net;
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  560  		break;
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  561  	case VIRTIO_ID_BLOCK:
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  562  		ifcvf_mgmt_dev->mdev.id_table = id_table_blk;
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  563  		break;
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  564  	default:
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  565  		IFCVF_ERR(pdev, "VIRTIO ID %u not supported\n", dev_type);
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  566  		ret = -EOPNOTSUPP;
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  567  		goto err;
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  568  	}
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  569  
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  570  	ifcvf_mgmt_dev->mdev.ops = &ifcvf_vdpa_mgmt_dev_ops;
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  571  	ifcvf_mgmt_dev->mdev.device = dev;
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  572  	ifcvf_mgmt_dev->pdev = pdev;
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  573  
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  574  	ret = pcim_enable_device(pdev);
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  575  	if (ret) {
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  576  		IFCVF_ERR(pdev, "Failed to enable device\n");
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  577  		goto err;
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  578  	}
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  579  
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  580  	ret = pcim_iomap_regions(pdev, BIT(0) | BIT(2) | BIT(4),
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  581  				 IFCVF_DRIVER_NAME);
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  582  	if (ret) {
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  583  		IFCVF_ERR(pdev, "Failed to request MMIO region\n");
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  584  		goto err;
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  585  	}
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  586  
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  587  	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  588  	if (ret) {
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  589  		IFCVF_ERR(pdev, "No usable DMA configuration\n");
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  590  		goto err;
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  591  	}
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  592  
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  593  	ret = devm_add_action_or_reset(dev, ifcvf_free_irq_vectors, pdev);
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  594  	if (ret) {
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  595  		IFCVF_ERR(pdev,
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  596  			  "Failed for adding devres for freeing irq vectors\n");
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  597  		goto err;
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  598  	}
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  599  
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  600  	pci_set_master(pdev);
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  601  
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  602  	ret = vdpa_mgmtdev_register(&ifcvf_mgmt_dev->mdev);
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  603  	if (ret) {
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  604  		IFCVF_ERR(pdev,
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  605  			  "Failed to initialize the management interfaces\n");
> 5a2414bc454e89 drivers/virtio/vdpa/ifcvf/ifcvf_main.c Zhu Lingshan 2020-03-26  606  		goto err;
> 5a2414bc454e89 drivers/virtio/vdpa/ifcvf/ifcvf_main.c Zhu Lingshan 2020-03-26  607  	}
> 5a2414bc454e89 drivers/virtio/vdpa/ifcvf/ifcvf_main.c Zhu Lingshan 2020-03-26  608  
> 5a2414bc454e89 drivers/virtio/vdpa/ifcvf/ifcvf_main.c Zhu Lingshan 2020-03-26  609  	return 0;
> 5a2414bc454e89 drivers/virtio/vdpa/ifcvf/ifcvf_main.c Zhu Lingshan 2020-03-26  610  
> 5a2414bc454e89 drivers/virtio/vdpa/ifcvf/ifcvf_main.c Zhu Lingshan 2020-03-26  611  err:
> 5a2414bc454e89 drivers/virtio/vdpa/ifcvf/ifcvf_main.c Zhu Lingshan 2020-03-26 @612  	put_device(&adapter->vdpa.dev);
> 7ea782fbd896e1 drivers/vdpa/ifcvf/ifcvf_main.c        Zhu Lingshan 2021-06-30  613  	kfree(ifcvf_mgmt_dev);
> 5a2414bc454e89 drivers/virtio/vdpa/ifcvf/ifcvf_main.c Zhu Lingshan 2020-03-26  614  	return ret;
> 5a2414bc454e89 drivers/virtio/vdpa/ifcvf/ifcvf_main.c Zhu Lingshan 2020-03-26  615  }
> 5a2414bc454e89 drivers/virtio/vdpa/ifcvf/ifcvf_main.c Zhu Lingshan 2020-03-26  616  
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org


