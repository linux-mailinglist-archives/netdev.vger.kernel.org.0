Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAEE05111FD
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 09:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358563AbiD0HKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 03:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353855AbiD0HJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 03:09:58 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AECF28E08
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 00:06:45 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id u3so1147598wrg.3
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 00:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vwRPX50lEvroOebHllBXd4aowQytW2AtEPaQabDS3xg=;
        b=zLyPuu0aY1vy75at3uBB3XOmjLCUMqFdfLOZYraRcj1qYI5VZmvHRTabxzv4P9aRNG
         bJZ3yasuv1CKii1xaycLZAOEE531O39Nv/zQDfHx+ficvsjmKMfNiQfoy7jofPzXt/Bw
         +O3ovHog/MaEHpddxRfr2evFuJsZHBXcgvf9T/M64Nn/q0F4nB+I74BWkUDiN0+4/+ms
         6rpX+6fnkGmk2tlmCzMlQvYEN+QnrOLUxHSDdmcpkpnpEVOqBI9EMoEAdtzs5tHL1iXu
         yWG/UMgMekspgfQVyDTHM42PSUcWLJonx7582B3/tdrrBZVZ3m4ONLxzcr310mtTNfcF
         C7nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vwRPX50lEvroOebHllBXd4aowQytW2AtEPaQabDS3xg=;
        b=P9YqJeOEOiCNFb14vHqofsIriD9fcO3df5WyvgbjS/p5Ou/CTfNK1M4Tt0qi+oxyN4
         XmR2qDw/b/1b3PaxDOyxSGarHne+jFhwEvD066BYnRtpt+1B+uab9jGeLX+DBvG3PHJZ
         OV+Ts5l/AnZMmALUUppbri07ugxsAbOr1qX4jUqe9o2WHhNoNGFdbksY6i/VaC/JmSzr
         Oj8fCZbuE6blWprFZ/y1KTrb12pF9EFv1cowUp87+zYFommZ+pA/eUwjUqZBe0kML06b
         Ch7eXkGOUrRR+CMHYtN3NqUE5rLo5CisEid8cWhnbWRNloqWjDJ/X5aHAa6AcN3GO8Oa
         TuYw==
X-Gm-Message-State: AOAM531YnH0C9qNul7CKKwKx/0pdZPXlqJRfOKVdr0YUWiy48J0JaOMX
        i9h/eVFgpjzZLBmlX7deljMQRMY1XcVyUs0SAj4=
X-Google-Smtp-Source: ABdhPJwgaXOzBBMcDwDB3ZzzVV6uOy5oaPdurI5SUDUdVBupZpeFIYSqQY2I4PFEt/OetOSpfTDwcw==
X-Received: by 2002:a5d:5690:0:b0:20a:d24b:ad12 with SMTP id f16-20020a5d5690000000b0020ad24bad12mr15793643wrv.280.1651043203634;
        Wed, 27 Apr 2022 00:06:43 -0700 (PDT)
Received: from [192.168.17.225] (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id j24-20020adfa558000000b0020ae9eafef9sm2191249wrb.92.2022.04.27.00.06.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 00:06:42 -0700 (PDT)
Message-ID: <651b6fce-cf2a-439f-7454-533bf830a048@solid-run.com>
Date:   Wed, 27 Apr 2022 10:06:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 2/3] net: phy: adin: add support for clock output
Content-Language: en-US
To:     kernel test robot <lkp@intel.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, alvaro.karsz@solid-run.com,
        Michael Hennerich <michael.hennerich@analog.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220419102709.26432-3-josua@solid-run.com>
 <202204211324.qgcPMycQ-lkp@intel.com>
From:   Josua Mayer <josua@solid-run.com>
In-Reply-To: <202204211324.qgcPMycQ-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

\o/

I am going to fix this by using NULL in v3.
Is there any other feedback I should take into account on this patch?

- Josua Mayer

Am 21.04.22 um 09:45 schrieb kernel test robot:
> Hi Josua,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on robh/for-next]
> [also build test WARNING on net/master net-next/master v5.18-rc3 next-20220420]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Josua-Mayer/dt-bindings-net-adin-document-phy-clock-output-properties/20220419-192719
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git for-next
> config: openrisc-randconfig-s032-20220420 (https://download.01.org/0day-ci/archive/20220421/202204211324.qgcPMycQ-lkp@intel.com/config)
> compiler: or1k-linux-gcc (GCC) 11.2.0
> reproduce:
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # apt-get install sparse
>          # sparse version: v0.6.4-dirty
>          # https://github.com/intel-lab-lkp/linux/commit/74d856f1c89a6534fd58889f20ad4b481b8191c9
>          git remote add linux-review https://github.com/intel-lab-lkp/linux
>          git fetch --no-tags linux-review Josua-Mayer/dt-bindings-net-adin-document-phy-clock-output-properties/20220419-192719
>          git checkout 74d856f1c89a6534fd58889f20ad4b481b8191c9
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=openrisc SHELL=/bin/bash drivers/net/phy/
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
>
> sparse warnings: (new ones prefixed by >>)
>>> drivers/net/phy/adin.c:448:27: sparse: sparse: Using plain integer as NULL pointer
> vim +448 drivers/net/phy/adin.c
>
>     444	
>     445	static int adin_config_clk_out(struct phy_device *phydev)
>     446	{
>     447		struct device *dev = &phydev->mdio.dev;
>   > 448		const char *val = 0;
>     449		u8 sel = 0;
>     450	
>     451		device_property_read_string(dev, "adi,phy-output-clock", &val);
>     452		if(!val) {
>     453			/* property not present, do not enable GP_CLK pin */
>     454		} else if(strcmp(val, "25mhz-reference") == 0) {
>     455			sel |= ADIN1300_GE_CLK_CFG_25;
>     456		} else if(strcmp(val, "125mhz-free-running") == 0) {
>     457			sel |= ADIN1300_GE_CLK_CFG_FREE_125;
>     458		} else if(strcmp(val, "125mhz-recovered") == 0) {
>     459			sel |= ADIN1300_GE_CLK_CFG_RCVR_125;
>     460		} else if(strcmp(val, "adaptive-free-running") == 0) {
>     461			sel |= ADIN1300_GE_CLK_CFG_HRT_FREE;
>     462		} else if(strcmp(val, "adaptive-recovered") == 0) {
>     463			sel |= ADIN1300_GE_CLK_CFG_HRT_RCVR;
>     464		} else {
>     465			phydev_err(phydev, "invalid adi,phy-output-clock\n");
>     466			return -EINVAL;
>     467		}
>     468	
>     469		if(device_property_read_bool(dev, "adi,phy-output-reference-clock"))
>     470			sel |= ADIN1300_GE_CLK_CFG_REF_EN;
>     471	
>     472		return phy_modify_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_GE_CLK_CFG_REG,
>     473				      ADIN1300_GE_CLK_CFG_MASK, sel);
>     474	}
>     475	
>
