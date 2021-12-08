Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8197D46D016
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 10:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhLHJcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 04:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhLHJcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 04:32:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A396C061746;
        Wed,  8 Dec 2021 01:28:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EABDFB81FFB;
        Wed,  8 Dec 2021 09:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9BCAC00446;
        Wed,  8 Dec 2021 09:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638955718;
        bh=wPLoCgEiGSFzZaa084ljFEQkOegpE0+U9VnbZ8HMw0M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LuJrgbpgPLbIgIWCE1a0PvHDcB/xlrNqQOi0zfmZSruQTKn8m5BXD25ByikS3TIaB
         3+j9MAoUf+fnf5zEEr9uMKC/SU62f9LoHn2SYDsSyAB6v3tjzkhfloxQ6Wmsfnq8V4
         E8ITvnTd4C3kxB5vWMgp/ZC7NRY5xAipewdGpvXzz6s1SnWrDJBRFpskcrTrgJxuDH
         zarM0/6a6tbwy8d/lucdqyCMd7Bg0LVdf2nLeHrAHyE+1MIjFDRh77X3FkSvwMs8uR
         RQn9rgWA7O2Y+gc3sDB0NSFJwLVQI8fg3AY4dw/wQH3ILO7Pal8OhvLpbFCgpM+73e
         eXbfSGAAFbaww==
Date:   Wed, 8 Dec 2021 11:28:34 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Leo Yan <leo.yan@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, coresight@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, codalist@coda.cs.cmu.edu,
        linux-audit@redhat.com
Subject: Re: [PATCH v2 1/7] pid: Introduce helper task_is_in_init_pid_ns()
Message-ID: <YbB6wpKO/0icFx9b@unreal>
References: <20211208083320.472503-1-leo.yan@linaro.org>
 <20211208083320.472503-2-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208083320.472503-2-leo.yan@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 04:33:14PM +0800, Leo Yan wrote:
> Currently the kernel uses open code in multiple places to check if a
> task is in the root PID namespace with the kind of format:
> 
>   if (task_active_pid_ns(current) == &init_pid_ns)
>       do_something();
> 
> This patch creates a new helper function, task_is_in_init_pid_ns(), it
> returns true if a passed task is in the root PID namespace, otherwise
> returns false.  So it will be used to replace open codes.
> 
> Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  include/linux/pid_namespace.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
