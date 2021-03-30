Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5FE34EDCF
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 18:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbhC3Q2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 12:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbhC3Q2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 12:28:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B88C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 09:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=Uighgp27IXI3+jPwruWl1v6QDE5IK3L6Ln7c4R+DdPY=; b=kTbSF0VsgTmoYCxEW7bGG+cRsJ
        Qm6IRupVUOgTY2ArwEBoAvfT08NwGXzDBxaXYcCwXUEtUIDH0JP9Y/fEGoGn1Ah4TbIjSysLhdFtH
        vzEz2Mnhu48w1k9xA732Rti3BpaKpD0kaYN5FywgGCFOD7hoVc1rvpGROCsZjiDnyQ0m96+ujcGZH
        114fsj0NOiF0SAC1WsJzXzYuIWfzSnl/d18RcbnlHMSViyP7QTsGN7+KwhV9BrgtMoyneH/gY9K/Z
        W4d7+qFHEAsiiNVw0308fdz0DD0uuEs0M+lxPwCBgDIXxRRBAhg83bUNVYE8fws/9zYs+3Z+P/WoZ
        1gJ/ShcA==;
Received: from [2601:1c0:6280:3f0::4557]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lRHDN-003I11-Uc; Tue, 30 Mar 2021 16:27:39 +0000
Subject: Re: [RESEND net-next 1/4] net: i40e: remove repeated words
To:     Huazhong Tan <tanhuazhong@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, jesse.brandeburg@intel.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andrew@lunn.ch, elder@kernel.org
Cc:     netdev@vger.kernel.org, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, huangdaode@huawei.com,
        linuxarm@openeuler.org, linuxarm@huawei.com,
        Peng Li <lipeng321@huawei.com>
References: <1617089276-30268-1-git-send-email-tanhuazhong@huawei.com>
 <1617089276-30268-2-git-send-email-tanhuazhong@huawei.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <33a08449-b5d4-bb0b-aefc-8c03fc7a238d@infradead.org>
Date:   Tue, 30 Mar 2021 09:27:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <1617089276-30268-2-git-send-email-tanhuazhong@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/30/21 12:27 AM, Huazhong Tan wrote:
> From: Peng Li <lipeng321@huawei.com>
> 
> Remove repeated words "to" and "try".
> 
> Signed-off-by: Peng Li <lipeng321@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>\

Hi,

> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index 0f84ed0..1555d60 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -7339,7 +7339,7 @@ static void i40e_vsi_set_default_tc_config(struct i40e_vsi *vsi)
>  	qcount = min_t(int, vsi->alloc_queue_pairs,
>  		       i40e_pf_get_max_q_per_tc(vsi->back));
>  	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++) {
> -		/* For the TC that is not enabled set the offset to to default
> +		/* For the TC that is not enabled set the offset to default

I think that                                              offset to the default
would be clearer. IMO.

>  		 * queue and allocate one queue for the given TC.
>  		 */
>  		vsi->tc_config.tc_info[i].qoffset = 0;


thanks.
-- 
~Randy

