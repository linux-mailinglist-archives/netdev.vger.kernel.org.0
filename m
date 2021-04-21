Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8466A366F50
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240825AbhDUPjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:39:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49242 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236008AbhDUPjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 11:39:23 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13LFXbKm123385;
        Wed, 21 Apr 2021 11:38:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=dvgMPHsEW+XqEs095OpZi1BkGHPWycnAP71yEVMNlUg=;
 b=bSN3D6ZKH31NgJyiBxp3UPQabSwR7hkSLXZo7eux81QTWdODxpKelrFbp83gd01Pj0BW
 8vQ3VquThM/Ug2XUSJEZ/H+5GtMu3yANPZbITZ72DLrt83utHmybMf+/yMgWiAOD3Xun
 XaXF+NNlY/Rx/kg66rqSpjjYL+VZoSDefemfG8EWSVXpUH67WGqlGtawIqKzexmT8OTz
 XQEV4cdxyuTo5JEK4TDZvlk8k4Pz9jWWfPtq7W8g5ZzvrPbelTkZutckRYYKRIkYir0m
 AMBlbWZgdVuhBgn7KlpPzikc2mYkuAICVdJM+p38G8MKxn+f4IRgQpoBP8B1pEbQIPy7 Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 382jrmgntf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 11:38:42 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13LFYFQD125340;
        Wed, 21 Apr 2021 11:38:42 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 382jrmgnse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 11:38:42 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13LFIooN009455;
        Wed, 21 Apr 2021 15:38:39 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 380hbf12ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 15:38:39 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13LFcbAD46596568
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 15:38:37 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8ADB15204F;
        Wed, 21 Apr 2021 15:38:37 +0000 (GMT)
Received: from sig-9-145-20-41.uk.ibm.com (unknown [9.145.20.41])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 021C952050;
        Wed, 21 Apr 2021 15:38:36 +0000 (GMT)
Message-ID: <3b7f73bd9b9b2b0eec39e68df62c1bdecd20afec.camel@linux.ibm.com>
Subject: Re: [PATCH v3 3/3] asm-generic/io.h: Silence
 -Wnull-pointer-arithmetic warning on PCI_IOBASE
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     kernel test robot <lkp@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Vineet Gupta <vgupta@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Date:   Wed, 21 Apr 2021 17:38:36 +0200
In-Reply-To: <202104212319.40Zv8JEe-lkp@intel.com>
References: <20210421111759.2059976-4-schnelle@linux.ibm.com>
         <202104212319.40Zv8JEe-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-14.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jYgAGwHJ6YnjY4PAQvmH6tG437FLqH7-
X-Proofpoint-ORIG-GUID: yDCSwwq4MLiqfVtLjH8PNiGVYt9A4KQI
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_05:2021-04-21,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 clxscore=1011 mlxscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210116
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-04-21 at 23:19 +0800, kernel test robot wrote:
> Hi Niklas,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on soc/for-next]
> [also build test ERROR on asm-generic/master v5.12-rc8 next-20210421]
> [cannot apply to arc/for-next sparc-next/master]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/0day-ci/linux/commits/Niklas-Schnelle/asm-generic-io-h-Silence-Wnull-pointer-arithmetic-warning-on-PCI_IOBASE/20210421-192025
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/soc/soc.git for-next
> config: riscv-nommu_k210_defconfig (attached as .config)
> compiler: riscv64-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/05bc9b9b640336015712d139ebc42830d12a82da
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Niklas-Schnelle/asm-generic-io-h-Silence-Wnull-pointer-arithmetic-warning-on-PCI_IOBASE/20210421-192025
>         git checkout 05bc9b9b640336015712d139ebc42830d12a82da
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross W=1 ARCH=riscv 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from arch/riscv/include/asm/clint.h:10,
>                     from arch/riscv/include/asm/timex.h:15,
>                     from include/linux/timex.h:65,
>                     from include/linux/time32.h:13,
>                     from include/linux/time.h:60,
>                     from include/linux/stat.h:19,
>                     from include/linux/module.h:13,
>                     from init/main.c:17:
>    include/asm-generic/io.h: In function 'inb_p':
> > > arch/riscv/include/asm/io.h:55:65: error: 'PCI_IOBASE' undeclared (first use in this function)
>       55 | #define inb(c)  ({ u8  __v; __io_pbr(); __v = readb_cpu((void*)(PCI_IOBASE + (c))); __io_par(__v); __v; })

Interesting, it looks to me like RISC-V sets PCI_IOBASE to 
((void __iomem *)PCI_IO_START) if running with an MMU but leaves it
undefined without an MMU. It does then use its own (broken?) inb/w/l()
macros with PCI_IOBASE 0 from asm-generic/io.h. What a mess ;-(

