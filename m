Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944FF48E45C
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 07:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbiANGrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 01:47:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiANGrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 01:47:43 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A8BC061574
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 22:47:43 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id b17so5958889ils.4
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 22:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=coIPDcnV+HnWEv56bf027+mB1pYRbPlLmW3kBkxW2fM=;
        b=WTDBSACAqrj6H5Q3fjs7kqd/ZTCyi11zUQICyqiSTy9EfTsV3bTQBKiA04wgyQsD5/
         zHwbNCCHXGHK1dHJugJOsIpD6Z2gAV+8aPEQO32v9jd3dY3ITbezrmE1UQn0sIYkoXW3
         5S44cluqV1GBW41hfEEZaxFjOYPwfaDVTlH3E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=coIPDcnV+HnWEv56bf027+mB1pYRbPlLmW3kBkxW2fM=;
        b=EBsYVZTFQzr4B7aLNEO49WUZGRfeJbTYf9gOSrWCLPUfSjop7/nwYGCzUlADbx1yMg
         nHE/V6ddLcw0lMXuNH2swNAtCpiBVcQ7xSksRLyj2lJ63ZLw0AQ6pL4YX6Xhuut9Pcbs
         43BDgrnkvOlOVqYUiTmbbB5GfGIwtR6qJVCxnQw/qr8xOVIzRTz1CDdJWQhXf2NLs+sh
         J6dUrvkralKdcSl1Gd5M7GMNsZwWkS3hMkfL2dAH3piKsm+rjfAmvi3YoZWeTn2C2LqI
         rG8afX5Abb/eFRrowzHcyKXXQ49ykHHkm3zdboaa3NwpUdJmsdt/ZKE5hD5+ulPZkMJa
         Fy+w==
X-Gm-Message-State: AOAM530utTLpuntHvL7AlcJ3n6C+dpUD72VX05EsXI8hHnPAFfrNz9IO
        18SPa4AWE5VPHlwyq/0Qh/MYZCDtk7k0oDzzoSSavH999hs=
X-Google-Smtp-Source: ABdhPJyiXF3NuvXrV68vVsq5L3Bld5EeEj25jQd9Mtca7hCVahuYe+O27eWAcP8UIkj/Bd9C7mmPGoXxfQSoA3vkI3Y=
X-Received: by 2002:a05:6e02:1786:: with SMTP id y6mr4099914ilu.99.1642142862486;
 Thu, 13 Jan 2022 22:47:42 -0800 (PST)
MIME-Version: 1.0
References: <20220110231255.v2.1.Ie4dcc45b0bf365077303c596891d460d716bb4c5@changeid>
 <202201110851.5qAxfQJj-lkp@intel.com>
In-Reply-To: <202201110851.5qAxfQJj-lkp@intel.com>
From:   Abhishek Kumar <kuabhs@chromium.org>
Date:   Thu, 13 Jan 2022 22:47:31 -0800
Message-ID: <CACTWRwtCjXbpxkixAyRrmK5gRjWW7fMv5==9j=YcsdN-mnYhJw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ath10k: search for default BDF name provided in DT
To:     kernel test robot <lkp@intel.com>
Cc:     kvalo@codeaurora.org, ath10k@lists.infradead.org,
        kbuild-all@lists.01.org, pillair@codeaurora.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        dianders@chromium.org, Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Reviewers,

On this patch I have a kernel bot warning, which I intend to fix along
with all the comments and discussion and push out V3. So, any
comments/next steps are appreciated.

Thanks
Abhishek

On Mon, Jan 10, 2022 at 5:08 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Abhishek,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on kvalo-ath/ath-next]
> [also build test WARNING on kvalo-wireless-drivers-next/master kvalo-wireless-drivers/master v5.16 next-20220110]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Abhishek-Kumar/ath10k-search-for-default-BDF-name-provided-in-DT/20220111-071636
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git ath-next
> config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20220111/202201110851.5qAxfQJj-lkp@intel.com/config)
> compiler: arceb-elf-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/50c4c7cb02cc786afcd9aff27616a6e20296c703
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Abhishek-Kumar/ath10k-search-for-default-BDF-name-provided-in-DT/20220111-071636
>         git checkout 50c4c7cb02cc786afcd9aff27616a6e20296c703
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arc SHELL=/bin/bash drivers/net/wireless/ath/ath10k/
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>    drivers/net/wireless/ath/ath10k/core.c: In function 'ath10k_core_parse_default_bdf_dt':
> >> drivers/net/wireless/ath/ath10k/core.c:1103:116: warning: format '%ld' expects argument of type 'long int', but argument 4 has type 'unsigned int' [-Wformat=]
>     1103 |                             "default board name is longer than allocated buffer, board_name: %s; allocated size: %ld\n",
>          |                                                                                                                  ~~^
>          |                                                                                                                    |
>          |                                                                                                                    long int
>          |                                                                                                                  %d
>     1104 |                             board_name, sizeof(ar->id.default_bdf));
>          |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~
>          |                                         |
>          |                                         unsigned int
>
>
> vim +1103 drivers/net/wireless/ath/ath10k/core.c
>
>   1083
>   1084  int ath10k_core_parse_default_bdf_dt(struct ath10k *ar)
>   1085  {
>   1086          struct device_node *node;
>   1087          const char *board_name = NULL;
>   1088
>   1089          ar->id.default_bdf[0] = '\0';
>   1090
>   1091          node = ar->dev->of_node;
>   1092          if (!node)
>   1093                  return -ENOENT;
>   1094
>   1095          of_property_read_string(node, "qcom,ath10k-default-bdf",
>   1096                                  &board_name);
>   1097          if (!board_name)
>   1098                  return -ENODATA;
>   1099
>   1100          if (strscpy(ar->id.default_bdf,
>   1101                      board_name, sizeof(ar->id.default_bdf)) < 0)
>   1102                  ath10k_warn(ar,
> > 1103                              "default board name is longer than allocated buffer, board_name: %s; allocated size: %ld\n",
>   1104                              board_name, sizeof(ar->id.default_bdf));
>   1105
>   1106          return 0;
>   1107  }
>   1108  EXPORT_SYMBOL(ath10k_core_parse_default_bdf_dt);
>   1109
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
