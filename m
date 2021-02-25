Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1A3324E2F
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 11:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhBYK2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 05:28:23 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:30956 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229752AbhBYKYB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 05:24:01 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614248630; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=OnrGOA7+vtKJaM77uUe4Y7LYAd/8kech7ZlLX5tFEs0=; b=iLCmvJvoEcIE1UEGyuvk67+TYQubKZ3Ri6ZiZl1138r8TbCuJxMXJn++duXPgch3QqTpdVXp
 jBZ1GBIwupOGcbISmi07wCU/xfAR8yMmKt7yXiLyDIq7g4VTdUSuVWl4VIo+mjqCoh3kOrwO
 vYZH/Dv4b8ysu+Y+u9n64vOA+IE=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 60377a86cc1f7d7e95a066c0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 25 Feb 2021 10:23:02
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 30A44C433ED; Thu, 25 Feb 2021 10:23:02 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C14B4C433C6;
        Thu, 25 Feb 2021 10:22:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C14B4C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     kernel test robot <lkp@intel.com>
Cc:     samirweng1979 <samirweng1979@163.com>, imitsyanko@quantenna.com,
        geomatsi@gmail.com, davem@davemloft.net, kuba@kernel.org,
        colin.king@canonical.com, kbuild-all@lists.01.org,
        clang-built-linux@googlegroups.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: Re: [PATCH] qtnfmac: remove meaningless goto statement and labels
References: <20210225064842.36952-1-samirweng1979@163.com>
        <202102251757.V6qESTrL-lkp@intel.com>
Date:   Thu, 25 Feb 2021 12:22:54 +0200
In-Reply-To: <202102251757.V6qESTrL-lkp@intel.com> (kernel test robot's
        message of "Thu, 25 Feb 2021 18:04:03 +0800")
Message-ID: <875z2gfnup.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel test robot <lkp@intel.com> writes:

> Hi samirweng1979,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on wireless-drivers-next/master]
> [also build test ERROR on wireless-drivers/master sparc-next/master v5.11 next-20210225]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/samirweng1979/qtnfmac-remove-meaningless-goto-statement-and-labels/20210225-145714
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
> config: x86_64-randconfig-a001-20210225 (attached as .config)
> compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project a921aaf789912d981cbb2036bdc91ad7289e1523)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install x86_64 cross compiling tool for clang build
>         # apt-get install binutils-x86-64-linux-gnu
>         # https://github.com/0day-ci/linux/commit/d18bea1fd25dee219ae56343ff9caf9cb6eb1519
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review samirweng1979/qtnfmac-remove-meaningless-goto-statement-and-labels/20210225-145714
>         git checkout d18bea1fd25dee219ae56343ff9caf9cb6eb1519
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=x86_64 
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>>> drivers/net/wireless/quantenna/qtnfmac/commands.c:1901:8: error: use of undeclared label 'out'
>                    goto out;

Do you compile test your patches? This error implies that not.
Compilation test is a hard requirement for patches.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
