Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3163AE3F8
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 09:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhFUHUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 03:20:50 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5057 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhFUHUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 03:20:46 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G7gjW4jX5zXjQ2;
        Mon, 21 Jun 2021 15:13:19 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 21 Jun 2021 15:18:27 +0800
Subject: Re: [RESEND PATCH V3 1/6] PCI: Use cached Device Capabilities
 Register
To:     kernel test robot <lkp@intel.com>, <helgaas@kernel.org>,
        <hch@infradead.org>, <kw@linux.com>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>
References: <1623576555-40338-2-git-send-email-liudongdong3@huawei.com>
 <202106182257.tOtKvefG-lkp@intel.com>
CC:     <kbuild-all@lists.01.org>, <clang-built-linux@googlegroups.com>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <ecbf9316-77db-e9fa-9d6e-4aee2117986a@huawei.com>
Date:   Mon, 21 Jun 2021 15:18:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <202106182257.tOtKvefG-lkp@intel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/6/18 22:51, kernel test robot wrote:
> Hi Dongdong,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on pci/next]
> [also build test WARNING on linuxtv-media/master linus/master v5.13-rc6 next-20210618]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Dongdong-Liu/PCI-Enable-10-Bit-tag-support-for-PCIe-devices/20210617-041115
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git next
> config: s390-randconfig-r032-20210618 (attached as .config)
> compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project 64720f57bea6a6bf033feef4a5751ab9c0c3b401)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install s390 cross compiling tool for clang build
>         # apt-get install binutils-s390x-linux-gnu
>         # https://github.com/0day-ci/linux/commit/caefa7e6d0209bc08eb1934b58dae3aaa0b9dbba
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Dongdong-Liu/PCI-Enable-10-Bit-tag-support-for-PCIe-devices/20210617-041115
>         git checkout caefa7e6d0209bc08eb1934b58dae3aaa0b9dbba
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=s390
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>    In file included from drivers/media/pci/cobalt/cobalt-driver.c:18:
>    In file included from drivers/media/pci/cobalt/cobalt-driver.h:16:
>    In file included from include/linux/pci.h:39:
>    In file included from include/linux/io.h:13:
>    In file included from arch/s390/include/asm/io.h:75:
>    include/asm-generic/io.h:464:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            val = __raw_readb(PCI_IOBASE + addr);
>                              ~~~~~~~~~~ ^
>    include/asm-generic/io.h:477:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
>                                                            ~~~~~~~~~~ ^
>    include/uapi/linux/byteorder/big_endian.h:36:59: note: expanded from macro '__le16_to_cpu'
>    #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
>                                                              ^
>    include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
>    #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
>                                                         ^
>    In file included from drivers/media/pci/cobalt/cobalt-driver.c:18:
>    In file included from drivers/media/pci/cobalt/cobalt-driver.h:16:
>    In file included from include/linux/pci.h:39:
>    In file included from include/linux/io.h:13:
>    In file included from arch/s390/include/asm/io.h:75:
>    include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
>                                                            ~~~~~~~~~~ ^
>    include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from macro '__le32_to_cpu'
>    #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
>                                                              ^
>    include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
>    #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
>                                                         ^
>    In file included from drivers/media/pci/cobalt/cobalt-driver.c:18:
>    In file included from drivers/media/pci/cobalt/cobalt-driver.h:16:
>    In file included from include/linux/pci.h:39:
>    In file included from include/linux/io.h:13:
>    In file included from arch/s390/include/asm/io.h:75:
>    include/asm-generic/io.h:501:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            __raw_writeb(value, PCI_IOBASE + addr);
>                                ~~~~~~~~~~ ^
>    include/asm-generic/io.h:511:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
>                                                          ~~~~~~~~~~ ^
>    include/asm-generic/io.h:521:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
>                                                          ~~~~~~~~~~ ^
>    include/asm-generic/io.h:609:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            readsb(PCI_IOBASE + addr, buffer, count);
>                   ~~~~~~~~~~ ^
>    include/asm-generic/io.h:617:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            readsw(PCI_IOBASE + addr, buffer, count);
>                   ~~~~~~~~~~ ^
>    include/asm-generic/io.h:625:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            readsl(PCI_IOBASE + addr, buffer, count);
>                   ~~~~~~~~~~ ^
>    include/asm-generic/io.h:634:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            writesb(PCI_IOBASE + addr, buffer, count);
>                    ~~~~~~~~~~ ^
>    include/asm-generic/io.h:643:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            writesw(PCI_IOBASE + addr, buffer, count);
>                    ~~~~~~~~~~ ^
>    include/asm-generic/io.h:652:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>            writesl(PCI_IOBASE + addr, buffer, count);
>                    ~~~~~~~~~~ ^
>>> drivers/media/pci/cobalt/cobalt-driver.c:199:7: warning: variable 'capa' is uninitialized when used here [-Wuninitialized]
>                        capa,
>                        ^~~~
>    drivers/media/pci/cobalt/cobalt-driver.h:160:71: note: expanded from macro 'cobalt_info'
>    #define cobalt_info(fmt, arg...) v4l2_info(&cobalt->v4l2_dev, fmt, ## arg)
>                                                                          ^~~
>    include/media/v4l2-common.h:67:39: note: expanded from macro 'v4l2_info'
>            v4l2_printk(KERN_INFO, dev, fmt , ## arg)
>                                                 ^~~
>    include/media/v4l2-common.h:58:44: note: expanded from macro 'v4l2_printk'
>            printk(level "%s: " fmt, (dev)->name , ## arg)
>                                                      ^~~
>    drivers/media/pci/cobalt/cobalt-driver.c:189:10: note: initialize the variable 'capa' to silence this warning
>            u32 capa;
>                    ^
>                     = 0
>    13 warnings generated.
>
>
> vim +/capa +199 drivers/media/pci/cobalt/cobalt-driver.c
>
>    184	
>    185	void cobalt_pcie_status_show(struct cobalt *cobalt)
>    186	{
>    187		struct pci_dev *pci_dev = cobalt->pci_dev;
>    188		struct pci_dev *pci_bus_dev = cobalt->pci_dev->bus->self;
>    189		u32 capa;
>    190		u16 stat, ctrl;
>    191	
>    192		if (!pci_is_pcie(pci_dev) || !pci_is_pcie(pci_bus_dev))
>    193			return;
>    194	
>    195		/* Device */
>    196		pcie_capability_read_word(pci_dev, PCI_EXP_DEVCTL, &ctrl);
>    197		pcie_capability_read_word(pci_dev, PCI_EXP_DEVSTA, &stat);
>    198		cobalt_info("PCIe device capability 0x%08x: Max payload %d\n",
>  > 199			    capa,
Will fix with pci_dev->pcie_devcap.

Thanks,
Dongdong
>    200			    get_payload_size(pci_dev->pcie_devcap & PCI_EXP_DEVCAP_PAYLOAD));
>    201		cobalt_info("PCIe device control 0x%04x: Max payload %d. Max read request %d\n",
>    202			    ctrl,
>    203			    get_payload_size((ctrl & PCI_EXP_DEVCTL_PAYLOAD) >> 5),
>    204			    get_payload_size((ctrl & PCI_EXP_DEVCTL_READRQ) >> 12));
>    205		cobalt_info("PCIe device status 0x%04x\n", stat);
>    206	
>    207		/* Link */
>    208		pcie_capability_read_dword(pci_dev, PCI_EXP_LNKCAP, &capa);
>    209		pcie_capability_read_word(pci_dev, PCI_EXP_LNKCTL, &ctrl);
>    210		pcie_capability_read_word(pci_dev, PCI_EXP_LNKSTA, &stat);
>    211		cobalt_info("PCIe link capability 0x%08x: %s per lane and %u lanes\n",
>    212				capa, get_link_speed(capa),
>    213				(capa & PCI_EXP_LNKCAP_MLW) >> 4);
>    214		cobalt_info("PCIe link control 0x%04x\n", ctrl);
>    215		cobalt_info("PCIe link status 0x%04x: %s per lane and %u lanes\n",
>    216			    stat, get_link_speed(stat),
>    217			    (stat & PCI_EXP_LNKSTA_NLW) >> 4);
>    218	
>    219		/* Bus */
>    220		pcie_capability_read_dword(pci_bus_dev, PCI_EXP_LNKCAP, &capa);
>    221		cobalt_info("PCIe bus link capability 0x%08x: %s per lane and %u lanes\n",
>    222				capa, get_link_speed(capa),
>    223				(capa & PCI_EXP_LNKCAP_MLW) >> 4);
>    224	
>    225		/* Slot */
>    226		pcie_capability_read_dword(pci_dev, PCI_EXP_SLTCAP, &capa);
>    227		pcie_capability_read_word(pci_dev, PCI_EXP_SLTCTL, &ctrl);
>    228		pcie_capability_read_word(pci_dev, PCI_EXP_SLTSTA, &stat);
>    229		cobalt_info("PCIe slot capability 0x%08x\n", capa);
>    230		cobalt_info("PCIe slot control 0x%04x\n", ctrl);
>    231		cobalt_info("PCIe slot status 0x%04x\n", stat);
>    232	}
>    233	
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
>
