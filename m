Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F135654FAFE
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 18:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236101AbiFQQYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 12:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiFQQYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 12:24:42 -0400
X-Greylist: delayed 1422 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 17 Jun 2022 09:24:41 PDT
Received: from gateway24.websitewelcome.com (gateway24.websitewelcome.com [192.185.50.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC206B498
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 09:24:41 -0700 (PDT)
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 5B199FE78F
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 11:00:59 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 2EP5o2AIPdLf52EP5otImW; Fri, 17 Jun 2022 11:00:59 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XIUdXgSJfyypocXoP+z+UuLIxDgaB0TXJ/fPyZNcNIg=; b=P5j8AhGnfAdyUsMzJ6Lm721pN7
        cgeOoD/IXjKgoXRqym6UmVAhmAfZBtQ6dz+cK7ACc7nO/yZqVjH4gYR7nJJ6f6smxhTX1Ux45RyvG
        tLCXpbjCQR3BvLNu/V4D29KbYB99Qktx2XD1VdPjZVHWRuqAuw6dPsWcAvgv/U3fO7W0qqWEch/R8
        HGB3/V3QrwMGW5KcW2gRdgY092+Q9mo6JzQo8IUHUF63k5eMVyGQyOaLgVyEppEN5JhKgdS2QR/Oc
        mK3OOfxNxOkHC6gKZtPxx7bymjo7cbHTKOZ+DvljkLi7NF8ljmlra/DpT1j8OFgw0SnUyUZe96MSW
        NBIzVUnA==;
Received: from 193.254.29.93.rev.sfr.net ([93.29.254.193]:47192 helo=[192.168.0.101])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <gustavo@embeddedor.com>)
        id 1o2EP4-000UST-MR;
        Fri, 17 Jun 2022 11:00:58 -0500
Message-ID: <ee2c8631-6e3f-c113-cc8e-29834bcc348e@embeddedor.com>
Date:   Fri, 17 Jun 2022 18:00:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [Intel-wired-lan] [PATCH][next] iavf: Replace one-element array
 in struct virtchnl_iwarp_qvlist_info and iavf_qvlist_info
Content-Language: en-US
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210525230429.GA175658@embeddedor>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20210525230429.GA175658@embeddedor>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 93.29.254.193
X-Source-L: No
X-Exim-ID: 1o2EP4-000UST-MR
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 193.254.29.93.rev.sfr.net ([192.168.0.101]) [93.29.254.193]:47192
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Friendly ping (after more than a year after I sent this patch :O):

Who can review and/or take this patch, please?

Thanks
--
Gustavo

On 5/26/21 01:04, Gustavo A. R. Silva wrote:
> There is a regular need in the kernel to provide a way to declare having a
> dynamically sized set of trailing elements in a structure. Kernel code
> should always use “flexible array members”[1] for these cases. The older
> style of one-element or zero-length arrays should no longer be used[2].
> 
> Refactor the code according to the use of a flexible-array member in struct
> virtchnl_iwarp_qvlist_info and iavf_qvlist_info instead of one-element array,
> and use the flex_array_size() helper.
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Link: https://github.com/KSPP/linux/issues/79
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>   drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 2 +-
>   drivers/net/ethernet/intel/iavf/iavf_client.c      | 2 +-
>   drivers/net/ethernet/intel/iavf/iavf_client.h      | 2 +-
>   include/linux/avf/virtchnl.h                       | 8 ++++----
>   4 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> index c0afac8cf33b..6c55fe9cc132 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> @@ -515,7 +515,7 @@ static int i40e_config_iwarp_qvlist(struct i40e_vf *vf,
>   
>   	kfree(vf->qvlist_info);
>   	vf->qvlist_info = kzalloc(struct_size(vf->qvlist_info, qv_info,
> -					      qvlist_info->num_vectors - 1),
> +					      qvlist_info->num_vectors),
>   				  GFP_KERNEL);
>   	if (!vf->qvlist_info) {
>   		ret = -ENOMEM;
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_client.c b/drivers/net/ethernet/intel/iavf/iavf_client.c
> index 0c77e4171808..e70da05ef322 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_client.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_client.c
> @@ -470,7 +470,7 @@ static int iavf_client_setup_qvlist(struct iavf_info *ldev,
>   
>   	v_qvlist_info = (struct virtchnl_iwarp_qvlist_info *)qvlist_info;
>   	msg_size = struct_size(v_qvlist_info, qv_info,
> -			       v_qvlist_info->num_vectors - 1);
> +			       v_qvlist_info->num_vectors);
>   
>   	adapter->client_pending |= BIT(VIRTCHNL_OP_CONFIG_IWARP_IRQ_MAP);
>   	err = iavf_aq_send_msg_to_pf(&adapter->hw,
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_client.h b/drivers/net/ethernet/intel/iavf/iavf_client.h
> index 9a7cf39ea75a..b14a82b65626 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_client.h
> +++ b/drivers/net/ethernet/intel/iavf/iavf_client.h
> @@ -53,7 +53,7 @@ struct iavf_qv_info {
>   
>   struct iavf_qvlist_info {
>   	u32 num_vectors;
> -	struct iavf_qv_info qv_info[1];
> +	struct iavf_qv_info qv_info[];
>   };
>   
>   #define IAVF_CLIENT_MSIX_ALL 0xFFFFFFFF
> diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
> index 85a687bc6096..15b982911321 100644
> --- a/include/linux/avf/virtchnl.h
> +++ b/include/linux/avf/virtchnl.h
> @@ -658,10 +658,10 @@ VIRTCHNL_CHECK_STRUCT_LEN(12, virtchnl_iwarp_qv_info);
>   
>   struct virtchnl_iwarp_qvlist_info {
>   	u32 num_vectors;
> -	struct virtchnl_iwarp_qv_info qv_info[1];
> +	struct virtchnl_iwarp_qv_info qv_info[];
>   };
>   
> -VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_iwarp_qvlist_info);
> +VIRTCHNL_CHECK_STRUCT_LEN(4, virtchnl_iwarp_qvlist_info);
>   
>   /* VF reset states - these are written into the RSTAT register:
>    * VFGEN_RSTAT on the VF
> @@ -1069,8 +1069,8 @@ virtchnl_vc_validate_vf_msg(struct virtchnl_version_info *ver, u32 v_opcode,
>   				err_msg_format = true;
>   				break;
>   			}
> -			valid_len += ((qv->num_vectors - 1) *
> -				sizeof(struct virtchnl_iwarp_qv_info));
> +			valid_len += flex_array_size(qv, qv_info,
> +						     qv->num_vectors);
>   		}
>   		break;
>   	case VIRTCHNL_OP_CONFIG_RSS_KEY:
