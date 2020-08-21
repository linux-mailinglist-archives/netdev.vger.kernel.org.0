Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAFF924E0C3
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 21:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgHUTkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 15:40:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:61612 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725831AbgHUTkG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 15:40:06 -0400
IronPort-SDR: +P6NMTUkneZj9KDVD1VyhiIClrhUIus+f/sdqpmv4+XKUChf8+P9nhpZ+smoHb7Z/y8jCa4xVy
 L3O6pZLZfaug==
X-IronPort-AV: E=McAfee;i="6000,8403,9720"; a="156675575"
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="156675575"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 12:40:06 -0700
IronPort-SDR: edfcIL4xn3b/WjdvPb1x7qTWAE3rl/iKXL8jlFbd+lbid6HuNDnstWZ15BNrIn8D/TIPT94DiR
 c+9IZn2km4mw==
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="473156335"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.38.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 12:40:05 -0700
Date:   Fri, 21 Aug 2020 12:40:04 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: Re: [PATCH v6 net-next 09/10] qed: align adjacent indent
Message-ID: <20200821124004.000026b5@intel.com>
In-Reply-To: <20200820185204.652-10-irusskikh@marvell.com>
References: <20200820185204.652-1-irusskikh@marvell.com>
        <20200820185204.652-10-irusskikh@marvell.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Igor Russkikh wrote:

> Fix indent on some of adjacent declarations.
> 
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
> ---
>  include/linux/qed/qed_if.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
> index 1297726f2b25..b8fb80c9be80 100644
> --- a/include/linux/qed/qed_if.h
> +++ b/include/linux/qed/qed_if.h
> @@ -897,14 +897,14 @@ struct qed_common_ops {
>  
>  	void		(*simd_handler_clean)(struct qed_dev *cdev,
>  					      int index);
> -	int (*dbg_grc)(struct qed_dev *cdev,
> -		       void *buffer, u32 *num_dumped_bytes);
> +	int		(*dbg_grc)(struct qed_dev *cdev,
> +				   void *buffer, u32 *num_dumped_bytes);
>  
> -	int (*dbg_grc_size)(struct qed_dev *cdev);
> +	int		(*dbg_grc_size)(struct qed_dev *cdev);
>  
> -	int (*dbg_all_data) (struct qed_dev *cdev, void *buffer);
> +	int		(*dbg_all_data)(struct qed_dev *cdev, void *buffer);
>  
> -	int (*dbg_all_data_size) (struct qed_dev *cdev);
> +	int		(*dbg_all_data_size)(struct qed_dev *cdev);
>  
>  	int		(*report_fatal_error)(struct devlink *devlink,
>  					      enum qed_hw_err_type err_type);

Was there a reason to do the indenting? I would just replace this patch
with unindenting everything. In general over time the time indent thing
is unmaintainable and just generates inconsistency over time.
