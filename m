Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEAC220461D
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 02:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732300AbgFWArJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 20:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732211AbgFWArI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 20:47:08 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993DFC061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 17:47:08 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x22so9265022pfn.3
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 17:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=RwYZlGlVYIFuB//WFjEFQ4/CjI8KSx51e9eOMZkT0Z0=;
        b=gPQkzE8rW637IzZWuOXaYCtrtsA+Fg1hIPlX5Xu+99Wyjk+nWYjUUu3moY6xrMQDpB
         j7uolAGKXosmpDFOTy/1wvHKZUWDV8RiLkQ2HiwMWt2vJ2nWM/WGqfz6UesnHXqfLoT+
         ijvEaXuw/hr0ma1+UHnr65xV/7dp+LxjeX/ztwyFjg+0TFR8McPF0eNbDvaf6bqJkgzM
         zwt3RzvFGphkBb+IHGBM50aRPU+8Lf1G1G0lwwpDKdL1/uBofoIBgMOYIF6d66NsJti2
         Z69UKQK0rUjVZ/2TY982ISp8YRBOaBrwhj3QM/Zd+65uWZzTR1WmX4QxUCZ8RDXfag+X
         KTZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=RwYZlGlVYIFuB//WFjEFQ4/CjI8KSx51e9eOMZkT0Z0=;
        b=A5a4dLUnQPfC2UD0mvLQ+M7A146su1LpoA9xf4ifHYHHZjCpCOfIBXFEnZWozNYS5f
         r6cpKbIyjWy8E7X73OvazDGUFGobEMmSbkdRRSa/lub3EYUszushTJDetGOtXlZWnyCc
         2ptH+QQmof78kFEX9K8TpJdzrSfDiIETpKbdR0Rlye+2OIhKvU+aFAGcAQeV3HiFMy5J
         +DcDkAzXc8HUvNLzBNcPJnne2Nieh5HW2+u/w+UPflU0ha6dqHezwQmsymSBI1qvl+Os
         Lc7Ca4IZZ2u+nv6WfnNtVuSHh7/AsCtoXIOHTqpYO4Ic5LAjRYCQErvHxGHKHlrgNIW/
         5VIA==
X-Gm-Message-State: AOAM531vE04w2S1V8mBcTofvfWS+kzkm4nKlBodmRmIK5ROGvJ3ryD80
        /tyabaHbOwFbZcrGJHFyh1ahGA==
X-Google-Smtp-Source: ABdhPJzXRkmyu7N0qihxWEAK4JzyIC5XtQEg4ztbuLhJil2fUIkNMGFjDGu8IOe+I8mChtdOEb1QNA==
X-Received: by 2002:a63:8949:: with SMTP id v70mr14912441pgd.256.1592873228155;
        Mon, 22 Jun 2020 17:47:08 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id c9sm15149979pfp.100.2020.06.22.17.47.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 17:47:07 -0700 (PDT)
Subject: Re: [net-next 2/9] i40e: remove unused defines
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
References: <20200622221817.2287549-1-jeffrey.t.kirsher@intel.com>
 <20200622221817.2287549-3-jeffrey.t.kirsher@intel.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <0beccbf6-7a29-0545-604a-8e61a86b40a6@pensando.io>
Date:   Mon, 22 Jun 2020 17:47:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622221817.2287549-3-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/20 3:18 PM, Jeff Kirsher wrote:
> From: Jesse Brandeburg <jesse.brandeburg@intel.com>
>
> Remove all the unused defines as they are just dead weight.
>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>   drivers/net/ethernet/intel/i40e/i40e.h        |   20 -
>   .../net/ethernet/intel/i40e/i40e_adminq_cmd.h |  482 +-
>   drivers/net/ethernet/intel/i40e/i40e_common.c |    4 -
>   drivers/net/ethernet/intel/i40e/i40e_dcb.h    |    5 -
>   .../net/ethernet/intel/i40e/i40e_debugfs.c    |    1 -
>   drivers/net/ethernet/intel/i40e/i40e_devids.h |    3 -
>   drivers/net/ethernet/intel/i40e/i40e_hmc.h    |    1 -
>   drivers/net/ethernet/intel/i40e/i40e_main.c   |    3 -
>   drivers/net/ethernet/intel/i40e/i40e_osdep.h  |    1 -
>   .../net/ethernet/intel/i40e/i40e_register.h   | 4656 -----------------
>   drivers/net/ethernet/intel/i40e/i40e_txrx.h   |   25 -
>   drivers/net/ethernet/intel/i40e/i40e_type.h   |   81 -
>   .../ethernet/intel/i40e/i40e_virtchnl_pf.h    |    1 -
>   include/linux/net/intel/i40e_client.h         |    5 -
>   14 files changed, 1 insertion(+), 5287 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
> index 5ff0828a6f50..e8a42415531a 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e.h
> @@ -60,17 +60,14 @@
>   		(((pf)->hw_features & I40E_HW_RSS_AQ_CAPABLE) ? 4 : 1)
>   #define I40E_DEFAULT_QUEUES_PER_VF	4
>   #define I40E_MAX_VF_QUEUES		16
> -#define I40E_DEFAULT_QUEUES_PER_TC	1 /* should be a power of 2 */
>   #define i40e_pf_get_max_q_per_tc(pf) \
>   		(((pf)->hw_features & I40E_HW_128_QP_RSS_CAPABLE) ? 128 : 64)
> -#define I40E_FDIR_RING			0
>   #define I40E_FDIR_RING_COUNT		32
>   #define I40E_MAX_AQ_BUF_SIZE		4096
>   #define I40E_AQ_LEN			256
>   #define I40E_AQ_WORK_LIMIT		66 /* max number of VFs + a little */
>   #define I40E_MAX_USER_PRIORITY		8
>   #define I40E_DEFAULT_TRAFFIC_CLASS	BIT(0)
> -#define I40E_DEFAULT_MSG_ENABLE		4
>   #define I40E_QUEUE_WAIT_RETRY_LIMIT	10
>   #define I40E_INT_NAME_STR_LEN		(IFNAMSIZ + 16)
>   
> @@ -93,8 +90,6 @@
>   #define I40E_OEM_RELEASE_MASK		0x0000ffff
>   
>   /* The values in here are decimal coded as hex as is the case in the NVM map*/
> -#define I40E_CURRENT_NVM_VERSION_HI	0x2
> -#define I40E_CURRENT_NVM_VERSION_LO	0x40

The related comments should get removed as well, as they'll only cause 
future confusion if left lying around.  There are a few more instances 
of this in the patch that you'll want to hunt down.

I think there are a bunch of AQ field and bit defines and other similar 
that are useful to have around, if nothing else but to help document the 
values.  I'd prefer to see most of them left in place, but that's more 
my opinion that a demand of any kind.

But all that crap in i40e_register.h - yeah, that makes some sense to go 
away.

sln

