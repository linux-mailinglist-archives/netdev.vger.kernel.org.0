Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F07F142F9B
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 17:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbgATQ2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 11:28:50 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:32886 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727573AbgATQ2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 11:28:49 -0500
Received: by mail-pf1-f193.google.com with SMTP id z16so16109785pfk.0;
        Mon, 20 Jan 2020 08:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GR1APR+Wyd2YLYbRnsV0u2x1C6uwTZZ2OEWNdjnqjo4=;
        b=S6+Ui0Ryg93xsfEPW/3lRMkkxdRzUj5Lj4DWAsydzFghegwFbHnFn4k4+y4g+3n72x
         aLHNWwUI48bhXguZbAg7T8bRrfqn+CD+jmkVdCFXplLf/ZegqNFp+Ew4+PciPqsf8fXO
         2BPK9SKgxQpIhyNCP5UxRci1fAXsIj7TQHQ5KiBuZidvYnf8hRi/jZcgxyg+W8ckdvO+
         yDKLUjJN5owNIXL43AP60swXX9MhAGAB8/9rcgWpoOfctWcx1kBj+csXRrMnOgfoFyqu
         AEhRqyShDMoqtf8kGVGOvM20fPC/reJw4pAWJJZB2jh+qVq2w9eb1He8yJ32mbzTIzKi
         WwEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GR1APR+Wyd2YLYbRnsV0u2x1C6uwTZZ2OEWNdjnqjo4=;
        b=mNskvxqOWJ5iP9bubcdUuFdHhkMOR6db/7CpHNbH3sui4URrSDGp/AWc4Z1dnmfKG2
         wPux+1PjC1OyjLYK1CtDP0vcdSfeLToHHh2gQ+rjuWKI2QtyQlS6HhS1Z39bwaHI7kKC
         0zxAvcJNsIpAht+8Md0YeVmseryUd3LBpT33YKq71kA6RPX56HiGTKKGBDdqlV7gOuCJ
         BM/IhN5YGE6G6flAE5cQkafVbB3TnYFbft+VgIIglpOZJqecFdPQ+Lkg8r/sBgryAfH9
         OMrj9js3ZsfE/qR0f8eqBez9iJNvRvO+uuO6pxmCD/bGlEsX3y9BzNpL7cZSBly609Ij
         GLfA==
X-Gm-Message-State: APjAAAV2sawsrNSigsHieFIkLko6FsfAHBfKeLMSuOdE1wgtFnKLKKbu
        9JAAhsin+Jg95q2wjJ0G9/g=
X-Google-Smtp-Source: APXvYqwsolQ7KdarCdpFxI9kDgOcqi9S5elKUvLwcvNAHuPL+EqeFJc3kZAVTtrTKnyWkVXKShj07w==
X-Received: by 2002:a63:3dc6:: with SMTP id k189mr453630pga.396.1579537728723;
        Mon, 20 Jan 2020 08:28:48 -0800 (PST)
Received: from localhost (64.64.229.47.16clouds.com. [64.64.229.47])
        by smtp.gmail.com with ESMTPSA id w11sm38347342pfn.4.2020.01.20.08.28.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 Jan 2020 08:28:48 -0800 (PST)
Date:   Tue, 21 Jan 2020 00:28:45 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, martin.blumenstingl@googlemail.com,
        treding@nvidia.com, andrew@lunn.ch, weifeng.voon@intel.com,
        tglx@linutronix.de, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] net: stmmac: remove the useless member phy_mask
Message-ID: <20200120162845.GA11480@nuc8i5>
References: <20200108072550.28613-3-zhengdejin5@gmail.com>
 <202001181542.rImVkJEi%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202001181542.rImVkJEi%lkp@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 18, 2020 at 03:51:11PM +0800, kbuild test robot wrote:
> Hi Dejin,
> 
> Thank you for the patch! Yet something to improve:
>

Thanks for reminding, This patch has been dropped, the patch V3 that replaced
it no longer contains this content, Please refer to
https://patchwork.ozlabs.org/patch/1219694/ for details. It should be fine after
giving up this commit.

Finally, Thanks a lot for Jose's help (Jose.Abreu@synopsys.com), he told me 
that the phy_mask is useful and should be kept when I submit this commit.

BR,
Dejin

> [auto build test ERROR on net-next/master]
> [also build test ERROR on net/master linus/master v5.5-rc6]
> [cannot apply to sparc-next/master next-20200117]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> 
> url:    https://github.com/0day-ci/linux/commits/Dejin-Zheng/net-stmmac-remove-useless-code-of-phy_mask/20200110-011131
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git daea5b4dc16c3edc90392a512492dae504f1a37a
> config: mips-randconfig-a001-20200118 (attached as .config)
> compiler: mipsel-linux-gcc (GCC) 5.5.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         GCC_VERSION=5.5.0 make.cross ARCH=mips 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
> >> arch/mips//loongson32/common/platform.c:82:2: error: unknown field 'phy_mask' specified in initializer
>      .phy_mask = 0,
>      ^
> 
> vim +/phy_mask +82 arch/mips//loongson32/common/platform.c
> 
> f29ad10de6c345 arch/mips/loongson1/common/platform.c Kelvin Cheung 2014-10-10  79  
> ca585cf9fb818b arch/mips/loongson1/common/platform.c Kelvin Cheung 2012-07-25  80  /* Synopsys Ethernet GMAC */
> f29ad10de6c345 arch/mips/loongson1/common/platform.c Kelvin Cheung 2014-10-10  81  static struct stmmac_mdio_bus_data ls1x_mdio_bus_data = {
> f29ad10de6c345 arch/mips/loongson1/common/platform.c Kelvin Cheung 2014-10-10 @82  	.phy_mask	= 0,
> f29ad10de6c345 arch/mips/loongson1/common/platform.c Kelvin Cheung 2014-10-10  83  };
> f29ad10de6c345 arch/mips/loongson1/common/platform.c Kelvin Cheung 2014-10-10  84  
> 
> :::::: The code at line 82 was first introduced by commit
> :::::: f29ad10de6c345c8ae4cb33a99ba8ff29bdcd751 MIPS: Loongson1B: Some fixes/updates for LS1B
> 
> :::::: TO: Kelvin Cheung <keguang.zhang@gmail.com>
> :::::: CC: Ralf Baechle <ralf@linux-mips.org>
> 
> ---
> 0-DAY kernel test infrastructure                 Open Source Technology Center
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation


