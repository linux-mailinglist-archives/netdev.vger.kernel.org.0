Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBF8132ED6
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 13:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbfFCLky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 07:40:54 -0400
Received: from mga17.intel.com ([192.55.52.151]:21921 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728476AbfFCLky (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 07:40:54 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jun 2019 04:40:53 -0700
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 03 Jun 2019 04:40:52 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hXlKe-0004uq-Bw; Mon, 03 Jun 2019 19:40:52 +0800
Date:   Mon, 3 Jun 2019 19:39:54 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org
Subject: [net-next:master 391/455] drivers/staging/isdn/avm/b1.c:163:49:
 sparse: sparse: incorrect type in argument 2 (different address spaces)
Message-ID: <201906031939.e6qlcBmD%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

First bad commit (maybe != root cause):

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   b33bc2b878e05c5dd4e20682328c3addb4787ac9
commit: 6d97985072dc270032dc7a08631080bfd6253e82 [391/455] isdn: move capi drivers to staging
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        git checkout 6d97985072dc270032dc7a08631080bfd6253e82
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/staging/isdn/avm/b1.c:163:49: sparse: sparse: incorrect type in argument 2 (different address spaces) @@    expected void const [noderef] <asn:1> *from @@    got  const [noderef] <asn:1> *from @@
>> drivers/staging/isdn/avm/b1.c:163:49: sparse:    expected void const [noderef] <asn:1> *from
>> drivers/staging/isdn/avm/b1.c:163:49: sparse:    got unsigned char *[assigned] dp
   drivers/staging/isdn/avm/b1.c:179:49: sparse: sparse: incorrect type in argument 2 (different address spaces) @@    expected void const [noderef] <asn:1> *from @@    got  const [noderef] <asn:1> *from @@
   drivers/staging/isdn/avm/b1.c:179:49: sparse:    expected void const [noderef] <asn:1> *from
   drivers/staging/isdn/avm/b1.c:179:49: sparse:    got unsigned char *[assigned] dp
   drivers/staging/isdn/avm/b1.c:211:49: sparse: sparse: incorrect type in argument 2 (different address spaces) @@    expected void const [noderef] <asn:1> *from @@    got  const [noderef] <asn:1> *from @@
   drivers/staging/isdn/avm/b1.c:211:49: sparse:    expected void const [noderef] <asn:1> *from
   drivers/staging/isdn/avm/b1.c:211:49: sparse:    got unsigned char *[assigned] dp
   drivers/staging/isdn/avm/b1.c:227:49: sparse: sparse: incorrect type in argument 2 (different address spaces) @@    expected void const [noderef] <asn:1> *from @@    got  const [noderef] <asn:1> *from @@
   drivers/staging/isdn/avm/b1.c:227:49: sparse:    expected void const [noderef] <asn:1> *from
   drivers/staging/isdn/avm/b1.c:227:49: sparse:    got unsigned char *[assigned] dp
--
>> drivers/staging/isdn/avm/c4.c:206:50: sparse: sparse: incorrect type in argument 2 (different address spaces) @@    expected void const [noderef] <asn:1> *from @@    got  const [noderef] <asn:1> *from @@
>> drivers/staging/isdn/avm/c4.c:206:50: sparse:    expected void const [noderef] <asn:1> *from
>> drivers/staging/isdn/avm/c4.c:206:50: sparse:    got unsigned char *[assigned] dp
   drivers/staging/isdn/avm/c4.c:223:50: sparse: sparse: incorrect type in argument 2 (different address spaces) @@    expected void const [noderef] <asn:1> *from @@    got  const [noderef] <asn:1> *from @@
   drivers/staging/isdn/avm/c4.c:223:50: sparse:    expected void const [noderef] <asn:1> *from
   drivers/staging/isdn/avm/c4.c:223:50: sparse:    got unsigned char *[assigned] dp
   drivers/staging/isdn/avm/c4.c:830:49: sparse: sparse: incorrect type in argument 2 (different address spaces) @@    expected void const [noderef] <asn:1> *from @@    got  const [noderef] <asn:1> *from @@
   drivers/staging/isdn/avm/c4.c:830:49: sparse:    expected void const [noderef] <asn:1> *from
   drivers/staging/isdn/avm/c4.c:830:49: sparse:    got unsigned char *[assigned] dp
   drivers/staging/isdn/avm/c4.c:843:50: sparse: sparse: incorrect type in argument 2 (different address spaces) @@    expected void const [noderef] <asn:1> *from @@    got  const [noderef] <asn:1> *from @@
   drivers/staging/isdn/avm/c4.c:843:50: sparse:    expected void const [noderef] <asn:1> *from
   drivers/staging/isdn/avm/c4.c:843:50: sparse:    got unsigned char *[assigned] dp
--
>> drivers/staging/isdn/hysdn/boardergo.c:402:21: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void volatile [noderef] <asn:2> *addr @@    got oderef] <asn:2> *addr @@
>> drivers/staging/isdn/hysdn/boardergo.c:402:21: sparse:    expected void volatile [noderef] <asn:2> *addr
>> drivers/staging/isdn/hysdn/boardergo.c:402:21: sparse:    got void *[usertype] dpram
>> drivers/staging/isdn/hysdn/boardergo.c:422:27: sparse: sparse: incorrect type in assignment (different address spaces) @@    expected void *[usertype] dpram @@    got void [nvoid *[usertype] dpram @@
>> drivers/staging/isdn/hysdn/boardergo.c:422:27: sparse:    expected void *[usertype] dpram
>> drivers/staging/isdn/hysdn/boardergo.c:422:27: sparse:    got void [noderef] <asn:2> *
--
>> drivers/staging/isdn/hysdn/hysdn_net.c:72:29: sparse: sparse: incorrect type in assignment (different address spaces) @@    expected struct in_device *in_dev @@    got struct in_device [struct in_device *in_dev @@
>> drivers/staging/isdn/hysdn/hysdn_net.c:72:29: sparse:    expected struct in_device *in_dev
>> drivers/staging/isdn/hysdn/hysdn_net.c:72:29: sparse:    got struct in_device [noderef] <asn:4> *ip_ptr

vim +163 drivers/staging/isdn/avm/b1.c

^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  150  
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  151  #define FWBUF_SIZE	256
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  152  int b1_load_t4file(avmcard *card, capiloaddatapart *t4file)
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  153  {
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  154  	unsigned char buf[FWBUF_SIZE];
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  155  	unsigned char *dp;
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  156  	int i, left;
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  157  	unsigned int base = card->port;
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  158  
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  159  	dp = t4file->data;
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  160  	left = t4file->len;
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  161  	while (left > FWBUF_SIZE) {
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  162  		if (t4file->user) {
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16 @163  			if (copy_from_user(buf, dp, FWBUF_SIZE))
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  164  				return -EFAULT;
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  165  		} else {
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  166  			memcpy(buf, dp, FWBUF_SIZE);
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  167  		}
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  168  		for (i = 0; i < FWBUF_SIZE; i++)
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  169  			if (b1_save_put_byte(base, buf[i]) < 0) {
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  170  				printk(KERN_ERR "%s: corrupted firmware file ?\n",
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  171  				       card->name);
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  172  				return -EIO;
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  173  			}
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  174  		left -= FWBUF_SIZE;
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  175  		dp += FWBUF_SIZE;
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  176  	}
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  177  	if (left) {
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  178  		if (t4file->user) {
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  179  			if (copy_from_user(buf, dp, left))
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  180  				return -EFAULT;
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  181  		} else {
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  182  			memcpy(buf, dp, left);
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  183  		}
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  184  		for (i = 0; i < left; i++)
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  185  			if (b1_save_put_byte(base, buf[i]) < 0) {
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  186  				printk(KERN_ERR "%s: corrupted firmware file ?\n",
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  187  				       card->name);
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  188  				return -EIO;
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  189  			}
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  190  	}
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  191  	return 0;
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  192  }
^1da177e drivers/isdn/hardware/avm/b1.c Linus Torvalds 2005-04-16  193  

:::::: The code at line 163 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
