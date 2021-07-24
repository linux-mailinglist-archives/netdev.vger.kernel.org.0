Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AB83D472B
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 12:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235375AbhGXJyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 05:54:40 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:15065 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235259AbhGXJyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 05:54:39 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GX2YD1KWYzZsKR;
        Sat, 24 Jul 2021 18:31:44 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 24 Jul 2021 18:35:09 +0800
Subject: Re: [PATCH V6 7/8] PCI: Add "pci=disable_10bit_tag=" parameter for
 peer-to-peer support
To:     kernel test robot <lkp@intel.com>, <helgaas@kernel.org>,
        <hch@infradead.org>, <kw@linux.com>, <logang@deltatee.com>,
        <linux-pci@vger.kernel.org>, <rajur@chelsio.com>,
        <hverkuil-cisco@xs4all.nl>
References: <1627038402-114183-8-git-send-email-liudongdong3@huawei.com>
 <202107240055.m4UVeYyu-lkp@intel.com>
CC:     <clang-built-linux@googlegroups.com>, <kbuild-all@lists.01.org>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <dac094c5-24ce-43bc-55be-30230e20e08f@huawei.com>
Date:   Sat, 24 Jul 2021 18:35:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <202107240055.m4UVeYyu-lkp@intel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/7/24 0:58, kernel test robot wrote:
> Hi Dongdong,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on pci/next]
> [also build test WARNING on linuxtv-media/master linus/master v5.14-rc2 next-20210723]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Dongdong-Liu/PCI-Enable-10-Bit-tag-support-for-PCIe-devices/20210723-190930
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git next
> config: x86_64-randconfig-b001-20210723 (attached as .config)
> compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project 9625ca5b602616b2f5584e8a49ba93c52c141e40)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install x86_64 cross compiling tool for clang build
>         # apt-get install binutils-x86-64-linux-gnu
>         # https://github.com/0day-ci/linux/commit/2ff0b803971a3df5815c96c5c4874f4eef64fa2f
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Dongdong-Liu/PCI-Enable-10-Bit-tag-support-for-PCIe-devices/20210723-190930
>         git checkout 2ff0b803971a3df5815c96c5c4874f4eef64fa2f
>         # save the attached .config to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/pci/
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>    drivers/pci/pci.c:6618:34: error: expected identifier
>            pcie_capability_clear_word(dev, PCI_EXP_DEVCTL2,
>                                            ^
>    include/uapi/linux/pci_regs.h:657:26: note: expanded from macro 'PCI_EXP_DEVCTL2'
>    #define PCI_EXP_DEVCTL2         40      /* Device Control 2 */
>                                    ^
>>> drivers/pci/pci.c:6618:2: warning: declaration specifier missing, defaulting to 'int'
>            pcie_capability_clear_word(dev, PCI_EXP_DEVCTL2,
>            ^
>            int
>    drivers/pci/pci.c:6618:28: error: this function declaration is not a prototype [-Werror,-Wstrict-prototypes]
>            pcie_capability_clear_word(dev, PCI_EXP_DEVCTL2,
>                                      ^
>    drivers/pci/pci.c:6618:2: error: conflicting types for 'pcie_capability_clear_word'
>            pcie_capability_clear_word(dev, PCI_EXP_DEVCTL2,
>            ^
>    include/linux/pci.h:1161:19: note: previous definition is here
>    static inline int pcie_capability_clear_word(struct pci_dev *dev, int pos,
>                      ^
>    drivers/pci/pci.c:6621:2: error: expected parameter declarator
>            pci_info(dev, "disabled 10-Bit Tag Requester\n");
>            ^
>    include/linux/pci.h:2472:46: note: expanded from macro 'pci_info'
>    #define pci_info(pdev, fmt, arg...)     dev_info(&(pdev)->dev, fmt, ##arg)
>                                                     ^
>    drivers/pci/pci.c:6621:2: error: expected ')'
>    include/linux/pci.h:2472:46: note: expanded from macro 'pci_info'
>    #define pci_info(pdev, fmt, arg...)     dev_info(&(pdev)->dev, fmt, ##arg)
>                                                     ^
>    drivers/pci/pci.c:6621:2: note: to match this '('
>    include/linux/pci.h:2472:37: note: expanded from macro 'pci_info'
>    #define pci_info(pdev, fmt, arg...)     dev_info(&(pdev)->dev, fmt, ##arg)
>                                            ^
>    include/linux/dev_printk.h:118:11: note: expanded from macro 'dev_info'
>            _dev_info(dev, dev_fmt(fmt), ##__VA_ARGS__)
>                     ^
>    drivers/pci/pci.c:6621:2: warning: declaration specifier missing, defaulting to 'int'
>            pci_info(dev, "disabled 10-Bit Tag Requester\n");
>            ^
>            int
>    include/linux/pci.h:2472:37: note: expanded from macro 'pci_info'
>    #define pci_info(pdev, fmt, arg...)     dev_info(&(pdev)->dev, fmt, ##arg)
>                                            ^
>    include/linux/dev_printk.h:118:2: note: expanded from macro 'dev_info'
>            _dev_info(dev, dev_fmt(fmt), ##__VA_ARGS__)
>            ^
>    drivers/pci/pci.c:6621:2: error: this function declaration is not a prototype [-Werror,-Wstrict-prototypes]
>    include/linux/pci.h:2472:37: note: expanded from macro 'pci_info'
>    #define pci_info(pdev, fmt, arg...)     dev_info(&(pdev)->dev, fmt, ##arg)
>                                            ^
>    include/linux/dev_printk.h:118:11: note: expanded from macro 'dev_info'
>            _dev_info(dev, dev_fmt(fmt), ##__VA_ARGS__)
>                     ^
>    drivers/pci/pci.c:6621:2: error: conflicting types for '_dev_info'
>    include/linux/pci.h:2472:37: note: expanded from macro 'pci_info'
>    #define pci_info(pdev, fmt, arg...)     dev_info(&(pdev)->dev, fmt, ##arg)
>                                            ^
>    include/linux/dev_printk.h:118:2: note: expanded from macro 'dev_info'
>            _dev_info(dev, dev_fmt(fmt), ##__VA_ARGS__)
>            ^
>    include/linux/dev_printk.h:56:6: note: previous declaration is here
>    void _dev_info(const struct device *dev, const char *fmt, ...);
>         ^
>    drivers/pci/pci.c:6622:1: error: extraneous closing brace ('}')
>    }
>    ^
>    2 warnings and 8 errors generated.
>
>
> vim +/int +6618 drivers/pci/pci.c
>
>   6580	
>   6581		if (!disable_10bit_tag_param)
>   6582			return;
>   6583	
>   6584		p = disable_10bit_tag_param;
>   6585		while (*p) {
>   6586			ret = pci_dev_str_match(dev, p, &p);
>   6587			if (ret < 0) {
>   6588				pr_info_once("PCI: Can't parse disable_10bit_tag parameter: %s\n",
>   6589					     disable_10bit_tag_param);
>   6590	
>   6591				break;
>   6592			} else if (ret == 1) {
>   6593				/* Found a match */
>   6594				break;
>   6595			}
>   6596	
>   6597			if (*p != ';' && *p != ',') {
>   6598				/* End of param or invalid format */
>   6599				break;
>   6600			}
>   6601			p++;
>   6602		}
>   6603	
>   6604		if (ret != 1)
>   6605			return;
>   6606	
>   6607	#ifdef CONFIG_PCI_IOV
>   6608		if (dev->is_virtfn) {
>   6609			iov = dev->physfn->sriov;
>   6610			iov->ctrl &= ~PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN;
>   6611			pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL,
>   6612					      iov->ctrl);
>   6613			pci_info(dev, "disabled PF SRIOV 10-Bit Tag Requester\n");
>   6614			return;
>   6615	#endif
>   6616		}
I made a mistake here, will fix.

Thanks,
Dongdong
>   6617	
>> 6618		pcie_capability_clear_word(dev, PCI_EXP_DEVCTL2,
>   6619					   PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
>   6620	
>   6621		pci_info(dev, "disabled 10-Bit Tag Requester\n");
>   6622	}
>   6623	
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
>
