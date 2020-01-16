Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3159B13F722
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437076AbgAPTJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:09:38 -0500
Received: from mga06.intel.com ([134.134.136.31]:31244 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387531AbgAPTJg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 14:09:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jan 2020 11:09:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,327,1574150400"; 
   d="scan'208";a="274116750"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.86]) ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jan 2020 11:09:35 -0800
Subject: Re: [PATCH net-next] Documentation: Fix typo in devlink documentation
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20200116175944.1958052-1-idosch@idosch.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <ce8dc098-cef7-8484-cf19-abec286741a0@intel.com>
Date:   Thu, 16 Jan 2020 11:09:34 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200116175944.1958052-1-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/2020 9:59 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> The driver is named "mlxsw", not "mlx5".
> 
> Fixes: d4255d75856f ("devlink: document info versions for each driver")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  Documentation/networking/devlink/mlxsw.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/networking/devlink/mlxsw.rst b/Documentation/networking/devlink/mlxsw.rst
> index ccba9769c651..5f9bb0a0616a 100644
> --- a/Documentation/networking/devlink/mlxsw.rst
> +++ b/Documentation/networking/devlink/mlxsw.rst
> @@ -40,7 +40,7 @@ The ``mlxsw`` driver supports reloading via ``DEVLINK_CMD_RELOAD``
>  Info versions
>  =============
>  
> -The ``mlx5`` driver reports the following versions
> +The ``mlxsw`` driver reports the following versions
>  
>  .. list-table:: devlink info versions implemented
>     :widths: 5 5 90
> 

Ah yep. Lot of files being changed/updated here. Makes sense to me.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
