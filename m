Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4699324F09
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 12:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234952AbhBYLUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 06:20:36 -0500
Received: from m12-15.163.com ([220.181.12.15]:33128 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234641AbhBYLU3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 06:20:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Message-ID:MIME-Version; bh=+rDCj
        q0m6hwtvTdNVQgL34+Esctp41E0VVnWVS4CZW8=; b=YSdoLxhABbZsTLPMs+meL
        X6jBw4idCdgl4dqLe7J8PlKUYBmZ+M+ea7xWfQSc2GjtucfGetkWOPCUDPrxct9x
        ikWYv+ioyikSaJihmeTVxrq/EjHcYBnFR+8rDlSQLnI5FVj+2YXKdq45W0YSCNm6
        uUJINkxydrujL3lC8LwR68=
Received: from localhost (unknown [119.137.54.222])
        by smtp11 (Coremail) with SMTP id D8CowAD3_BBjezdgLaOFCw--.77S2;
        Thu, 25 Feb 2021 18:26:48 +0800 (CST)
Date:   Thu, 25 Feb 2021 18:26:42 +0800
From:   wengjianfeng <samirweng1979@163.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     kernel test robot <lkp@intel.com>, imitsyanko@quantenna.com,
        geomatsi@gmail.com, davem@davemloft.net, kuba@kernel.org,
        colin.king@canonical.com, kbuild-all@lists.01.org,
        clang-built-linux@googlegroups.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: Re: [PATCH] qtnfmac: remove meaningless goto statement and labels
Message-ID: <20210225182642.00002519@163.com>
In-Reply-To: <875z2gfnup.fsf@codeaurora.org>
References: <20210225064842.36952-1-samirweng1979@163.com>
        <202102251757.V6qESTrL-lkp@intel.com>
        <875z2gfnup.fsf@codeaurora.org>
Organization: yulong
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: D8CowAD3_BBjezdgLaOFCw--.77S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WrykJF1UGFWDKrWfWFW5GFg_yoW8KF47p3
        y8Xa15Ka18X3y8AFZ7Kay8ZayFqws5Jr9rGas8Jw1rZa42vr1xtrn2grW5X3srWrs7CFW3
        ArWUX3sYg3ZxAaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jbKsUUUUUU=
X-Originating-IP: [119.137.54.222]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiRQlEsVl91SaGtgAAse
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Feb 2021 12:22:54 +0200
Kalle Valo <kvalo@codeaurora.org> wrote:

> kernel test robot <lkp@intel.com> writes:
> 
> > Hi samirweng1979,
> >
> > Thank you for the patch! Yet something to improve:
> >
> > [auto build test ERROR on wireless-drivers-next/master]
> > [also build test ERROR on wireless-drivers/master sparc-next/master
> > v5.11 next-20210225] [If your patch is applied to the wrong git
> > tree, kindly drop us a note. And when submitting patch, we suggest
> > to use '--base' as documented in
> > https://git-scm.com/docs/git-format-patch]
> >
> > url:
> > https://github.com/0day-ci/linux/commits/samirweng1979/qtnfmac-remove-meaningless-goto-statement-and-labels/20210225-145714
> > base:
> > https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git
> > master config: x86_64-randconfig-a001-20210225 (attached
> > as .config) compiler: clang version 13.0.0
> > (https://github.com/llvm/llvm-project
> > a921aaf789912d981cbb2036bdc91ad7289e1523) reproduce (this is a W=1
> > build): wget
> > https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross
> > -O ~/bin/make.cross chmod +x ~/bin/make.cross # install x86_64
> > cross compiling tool for clang build # apt-get install
> > binutils-x86-64-linux-gnu #
> > https://github.com/0day-ci/linux/commit/d18bea1fd25dee219ae56343ff9caf9cb6eb1519
> > git remote add linux-review https://github.com/0day-ci/linux git
> > fetch --no-tags linux-review
> > samirweng1979/qtnfmac-remove-meaningless-goto-statement-and-labels/20210225-145714
> > git checkout d18bea1fd25dee219ae56343ff9caf9cb6eb1519 # save the
> > attached .config to linux build tree
> > COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross
> > ARCH=x86_64 
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > All errors (new ones prefixed by >>):
> >
> >>> drivers/net/wireless/quantenna/qtnfmac/commands.c:1901:8: error:
> >>> use of undeclared label 'out'
> >                    goto out;
> 
> Do you compile test your patches? This error implies that not.
> Compilation test is a hard requirement for patches.
> 

Hikvalo,
  I'm sorry for make this mistake, and I will compile success before
  send patch later. thanks.


