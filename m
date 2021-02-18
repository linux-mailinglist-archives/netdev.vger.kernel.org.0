Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098A831E79E
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 09:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhBRIpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 03:45:50 -0500
Received: from mx4.wp.pl ([212.77.101.11]:21860 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230112AbhBRIlj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 03:41:39 -0500
Received: (wp-smtpd smtp.wp.pl 24366 invoked from network); 18 Feb 2021 09:13:26 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1613636006; bh=KkhT7BbeRLyA5ExvuQyLE7bMC/m+gzQi2x9NC+J0cbQ=;
          h=From:To:Cc:Subject;
          b=LPB+gUEj6LbIGJPUu1hZUAqCz+UnTnwJ2T5bwHksOV13fZJR3yUr+TODYA95QZFxd
           j4f5aSUm5NgK5QjVdJJ/62lKu7iWuE0Snl5rDftCBjOuxWOmJNgA7/WvSsOFS+LYdK
           t38lz+4S9m94kwzhtWAg6ngo5GACNr+Kfy9LsgUs=
Received: from ip4-46-39-164-204.cust.nbox.cz (HELO localhost) (stf_xl@wp.pl@[46.39.164.204])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <jiapeng.chong@linux.alibaba.com>; 18 Feb 2021 09:13:26 +0100
Date:   Thu, 18 Feb 2021 09:13:24 +0100
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlegacy: 4965-mac: Simplify the calculation of variables
Message-ID: <20210218081324.GA68220@wp.pl>
References: <1613632814-37897-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613632814-37897-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-WP-MailID: 000f97803be0c567b530d0823ea2f9e0
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [obPE]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 03:20:14PM +0800, Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
> 
> ./drivers/net/wireless/intel/iwlegacy/4965-mac.c:2596:54-56: WARNING !A
> || A && B is equivalent to !A || B.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/wireless/intel/iwlegacy/4965-mac.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
> index 28675a4..52db532 100644
> --- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
> +++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
> @@ -2593,8 +2593,7 @@ struct il_mod_params il4965_mod_params = {
>  	 */
>  	if (ret != IL_INVALID_STATION &&
>  	    (!(il->stations[ret].used & IL_STA_UCODE_ACTIVE) ||
> -	     ((il->stations[ret].used & IL_STA_UCODE_ACTIVE) &&
> -	      (il->stations[ret].used & IL_STA_UCODE_INPROGRESS)))) {
> +	      (il->stations[ret].used & IL_STA_UCODE_INPROGRESS))) {
>  		IL_ERR("Requested station info for sta %d before ready.\n",
>  		       ret);
>  		ret = IL_INVALID_STATION;

This patch was already applied to wireless-drivers-next.

Stanislaw
