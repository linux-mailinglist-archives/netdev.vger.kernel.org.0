Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D273392223
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 23:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbhEZVgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 17:36:04 -0400
Received: from gateway33.websitewelcome.com ([192.185.145.33]:19268 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233477AbhEZVgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 17:36:03 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 921F713CFB9
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 16:34:27 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id m1AYlZNd9AEP6m1AZl6Ft8; Wed, 26 May 2021 16:34:27 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AVftKSHQScIRK8be+dU0JJK0i8MExIzulGIQ7Lt68hQ=; b=hXXj4RoQgzHnVE78yp975cleDa
        HrxSn9+oN9PI8XKXdFnJ3DoO4tePmCGV/jcjaCOvVOYnbbnUhnBL+NUNpo3Q6QFGObmNDdfjexIK8
        7LJtxOzqIlq1UlZgn/YVpbSf1gJYJTyy26aWjZNDDi4Mh9y1tAMy5FOSPlg4O57uGjfHJOZG/ifCc
        STvK0PHs3PcUQDE2ZgL31kpHRveisbF6w0iq2ri1Jbr2/2VLqBpQJZiaa8QOpNWjrJNWxkJG9Fm98
        8AFk+KailfXWtTWPyOg8G7fCp/OV/dMIH1qkxqIVKiNOsLFxUAuHRVb+WJC/b1ht4kWvKhc99ptca
        FvGIcXwA==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:46830 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lm1AT-003fxT-AA; Wed, 26 May 2021 16:34:21 -0500
Subject: Re: [Intel-wired-lan] [PATCH][next] i40e: Replace one-element array
 with flexible-array member
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Latif, Faisal" <faisal.latif@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
References: <20210525230038.GA175516@embeddedor>
 <bf46b428deef4e9e89b0ea1704b1f0e5@intel.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <79c3c00d-c364-9db1-b8de-7ed0686ca8dc@embeddedor.com>
Date:   Wed, 26 May 2021 16:35:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <bf46b428deef4e9e89b0ea1704b1f0e5@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lm1AT-003fxT-AA
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:46830
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 12
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/26/21 16:29, Saleem, Shiraz wrote:
>> Subject: [PATCH][next] i40e: Replace one-element array with flexible-array member
>>
>> There is a regular need in the kernel to provide a way to declare having a
>> dynamically sized set of trailing elements in a structure. Kernel code should always
>> use “flexible array members”[1] for these cases. The older style of one-element or
>> zero-length arrays should no longer be used[2].
>>
>> Refactor the code according to the use of a flexible-array member in struct
>> i40e_qvlist_info instead of one-element array, and use the struct_size() helper.
>>
>> [1] https://en.wikipedia.org/wiki/Flexible_array_member
>> [2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-
>> and-one-element-arrays
>>
>> Link: https://github.com/KSPP/linux/issues/79
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> This looks ok to me.
> Acked-by: Shiraz Saleem <shiraz.saleem@intel.com>
> 
> It seems we should add this to the new irdma driver submission as well which replaces i40iw.
> I will fold it into v7 of the rdma portion of the series
> https://lore.kernel.org/linux-rdma/20210520200326.GX1096940@ziepe.ca/

OK. Just please, when you fold it, add my Signed-off-by tag like this:

[flexible array transformation]
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
--
Gustavo

> Additionally we will add this patch when we resend this PR on iwl-next.
> https://lore.kernel.org/linux-rdma/62555c6de641e10cb4169653731389a51d086345.camel@intel.com/
> 
> 
>> ---
>>  drivers/infiniband/hw/i40iw/i40iw_main.c      | 5 ++---
>>  drivers/net/ethernet/intel/i40e/i40e_client.c | 2 +-
>>  include/linux/net/intel/i40e_client.h         | 2 +-
>>  3 files changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c
>> b/drivers/infiniband/hw/i40iw/i40iw_main.c
>> index b496f30ce066..364f69cd620f 100644
>> --- a/drivers/infiniband/hw/i40iw/i40iw_main.c
>> +++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
>> @@ -1423,7 +1423,7 @@ static enum i40iw_status_code
>> i40iw_save_msix_info(struct i40iw_device *iwdev,
>>  	struct i40e_qv_info *iw_qvinfo;
>>  	u32 ceq_idx;
>>  	u32 i;
>> -	u32 size;
>> +	size_t size;
>>
>>  	if (!ldev->msix_count) {
>>  		i40iw_pr_err("No MSI-X vectors\n");
>> @@ -1433,8 +1433,7 @@ static enum i40iw_status_code
>> i40iw_save_msix_info(struct i40iw_device *iwdev,
>>  	iwdev->msix_count = ldev->msix_count;
>>
>>  	size = sizeof(struct i40iw_msix_vector) * iwdev->msix_count;
>> -	size += sizeof(struct i40e_qvlist_info);
>> -	size +=  sizeof(struct i40e_qv_info) * iwdev->msix_count - 1;
>> +	size += struct_size(iw_qvlist, qv_info, iwdev->msix_count);
>>  	iwdev->iw_msixtbl = kzalloc(size, GFP_KERNEL);
>>
>>  	if (!iwdev->iw_msixtbl)
>> diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c
>> b/drivers/net/ethernet/intel/i40e/i40e_client.c
>> index 32f3facbed1a..63eab14a26df 100644
>> --- a/drivers/net/ethernet/intel/i40e/i40e_client.c
>> +++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
>> @@ -579,7 +579,7 @@ static int i40e_client_setup_qvlist(struct i40e_info *ldev,
>>  	u32 v_idx, i, reg_idx, reg;
>>
>>  	ldev->qvlist_info = kzalloc(struct_size(ldev->qvlist_info, qv_info,
>> -				    qvlist_info->num_vectors - 1), GFP_KERNEL);
>> +				    qvlist_info->num_vectors), GFP_KERNEL);
>>  	if (!ldev->qvlist_info)
>>  		return -ENOMEM;
>>  	ldev->qvlist_info->num_vectors = qvlist_info->num_vectors; diff --git
>> a/include/linux/net/intel/i40e_client.h b/include/linux/net/intel/i40e_client.h
>> index f41387a8969f..fd7bc860a241 100644
>> --- a/include/linux/net/intel/i40e_client.h
>> +++ b/include/linux/net/intel/i40e_client.h
>> @@ -48,7 +48,7 @@ struct i40e_qv_info {
>>
>>  struct i40e_qvlist_info {
>>  	u32 num_vectors;
>> -	struct i40e_qv_info qv_info[1];
>> +	struct i40e_qv_info qv_info[];
>>  };
>>
>>
>> --
>> 2.27.0
> 
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
> 
