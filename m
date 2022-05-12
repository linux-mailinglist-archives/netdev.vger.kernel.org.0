Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA07752470C
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 09:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343519AbiELHdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 03:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237649AbiELHdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 03:33:53 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D4244A22
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 00:33:52 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id b19so5930820wrh.11
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 00:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VJgiP3JRpo82lgLLITvlw0SadokFXlQXqrzQP/PcIVM=;
        b=V3NAfn8NjL+SSwG0q2RB1Mg4d+ZG8CkEpm7fqYJpzwaYpu24OpJW6/K+iAWupNywBK
         pEtgDro1oPFjxgX1mZEZ12ZIUz70yKKKDJYfJa3lX3OSr5iMh8R/A3CbPtsL2lnBATxc
         ByoiPRhGirNu0fWZI8vORXTCvrgo1XoKHYZL+CDzHt40gDrSiYIvPtv2EVgSfJVJ2eT7
         BHFKYWnWwAFV/bYrqzX0llyn5GlV86naOo7rbY0sXCmb4GJRdjBDPdnRhGR3NfR+Anp1
         2Mh9LoeZV64QimFBLimkz1bumLvPhtzUhKDlhb+W8sepjoSYUmRB6UGD5k044uFw+Jwr
         lC0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=VJgiP3JRpo82lgLLITvlw0SadokFXlQXqrzQP/PcIVM=;
        b=YnRQoQi87jS8LHTQC+oWZ/jRgitmtomXVqDHb3d3hI2kyLI84vcch+rIQjGOvhcvB1
         GLSlZKIVJb6u1xEzqx8X2JicHEOC5PWCNDJmCSaPFdChqKtBWmwIBvCRTvoKPLzp8MNL
         92y96UPZD/TU+h1kvl7ddRZ4B1xUnTa7tQv+QzldxGmgAK8BLTxh8xbYhT0oy50+gBdM
         KouTgu9shiC9EI9jqbycuGgQNfceqfezzjP+++0jORukGfcfhomvgtLn6tB2qNp6oXPM
         3nTHrLHusbGinEl8rMgk4vZBDmzAVuiXQGc4/EPujAIxH3fJCo9ZL+QHgt0H7ep+yTkd
         rHPA==
X-Gm-Message-State: AOAM533mOmgB9f4Noc40MtHsKZyhoQrk2yNpCLoSWF6fqiizNf9S2Dad
        7JkNO4dMD9+125311fZ2vtNPUoAw6vs=
X-Google-Smtp-Source: ABdhPJx1XKNXNOwztaS1ggKJAFeowZUSnvqgBBcW/al6icdOYk1P3hxIFP141RmQYec7FfreGhrxVw==
X-Received: by 2002:adf:f18e:0:b0:20c:e053:ef4e with SMTP id h14-20020adff18e000000b0020ce053ef4emr4842691wro.360.1652340830737;
        Thu, 12 May 2022 00:33:50 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id bh8-20020a05600c3d0800b003942a244f45sm1917662wmb.30.2022.05.12.00.33.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 12 May 2022 00:33:49 -0700 (PDT)
Date:   Thu, 12 May 2022 08:33:47 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, Jakub Kicinski <kuba@kernel.org>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Erik Ekman <erik@kryo.se>,
        netdev@vger.kernel.org
Subject: Re: [linux-next:master 10569/11094]
 drivers/net/ethernet/sfc/siena/siena_sriov.c:1578:5: sparse: sparse: symbol
 'efx_init_sriov' was not declared. Should it be static?
Message-ID: <20220512073347.36go3nikzf6m4du2@gmail.com>
Mail-Followup-To: kernel test robot <lkp@intel.com>,
        kbuild-all@lists.01.org, Jakub Kicinski <kuba@kernel.org>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
        Erik Ekman <erik@kryo.se>, netdev@vger.kernel.org
References: <202205120012.rvs9fZKN-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202205120012.rvs9fZKN-lkp@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will be fixed by:

https://patchwork.kernel.org/project/netdevbpf/patch/165228602579.696.13026076797222373028.stgit@palantir17.mph.net/

Martin

On Thu, May 12, 2022 at 01:07:55AM +0800, kernel test robot wrote:
> Hi Martin,
> 
> First bad commit (maybe != root cause):
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   6107040c99d5dfc920721c198d45ed2d639b113a
> commit: c5a13c319e10e795850b61bc7e3447b08024be2e [10569/11094] sfc: Add a basic Siena module
> config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20220512/202205120012.rvs9fZKN-lkp@intel.com/config)
> compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.4-dirty
>         # https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=c5a13c319e10e795850b61bc7e3447b08024be2e
>         git remote add linux-next https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>         git fetch --no-tags linux-next master
>         git checkout c5a13c319e10e795850b61bc7e3447b08024be2e
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/ethernet/sfc/siena/
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> 
> sparse warnings: (new ones prefixed by >>)
> >> drivers/net/ethernet/sfc/siena/siena_sriov.c:1578:5: sparse: sparse: symbol 'efx_init_sriov' was not declared. Should it be static?
> >> drivers/net/ethernet/sfc/siena/siena_sriov.c:1590:6: sparse: sparse: symbol 'efx_fini_sriov' was not declared. Should it be static?
> 
> Please review and possibly fold the followup patch.
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://01.org/lkp
