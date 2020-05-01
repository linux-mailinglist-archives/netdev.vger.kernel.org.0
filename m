Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2071C0C91
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgEAD0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:26:38 -0400
Received: from gateway21.websitewelcome.com ([192.185.45.91]:42623 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728008AbgEAD0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:26:37 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 421D0400C3EFF
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 22:26:36 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id UMJwjKkU3Sl8qUMJwjjKCj; Thu, 30 Apr 2020 22:26:36 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sLNiod4wWyNf3MxlJD5dqytFHvgWQv3WzDsXbMGio2g=; b=IAI2Ts2h2qtCrTplwOxN/QN5rD
        RwH2QnSsTQZaxIofKJdpu0T8huasxbDlei/nA4PLib3acmiQOTiNl0onCWa4hUzVxnwLffMyO84HM
        pJRwQGoGGJd2jmMkG5NRCp058ON1jD1OHFuvfm7SiJGKLES28FDisBS6DxFsjiP/2TLfHNvaqF/gM
        3rEWgBLJ7bT78Yhc9ARfQMYnANltiU4AwfTn6Qyv2P4ldqJA6aTLi0k2ugEmReMsrsPmqIjsTuVp6
        F2a8uAvR3tj1S+iOIayfVyqEpaBlZfTGXc5bfLtqOO2dki9gd+Us2iZTgDEqF35UwVwLr82NDvWUP
        PJPLIwJA==;
Received: from [189.207.59.248] (port=58366 helo=[192.168.15.9])
        by gator4166.hostgator.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1jUMJv-002ZWy-RM; Thu, 30 Apr 2020 22:26:35 -0500
Subject: Re: linux-next: manual merge of the mlx5-next tree with the
 kspp-gustavo tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Huy Nguyen <huyn@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Raed Salem <raeds@mellanox.com>
References: <20200429120625.2b5bb507@canb.auug.org.au>
 <20200501131230.58835994@canb.auug.org.au>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Autocrypt: addr=gustavo@embeddedor.com; keydata=
 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
 VtSixD1uOgytAP7RWS474w==
Message-ID: <32eb40f0-a17b-5a7f-41e0-0f30a507fc31@embeddedor.com>
Date:   Thu, 30 Apr 2020 22:30:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501131230.58835994@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.207.59.248
X-Source-L: No
X-Exim-ID: 1jUMJv-002ZWy-RM
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.15.9]) [189.207.59.248]:58366
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On 4/30/20 22:12, Stephen Rothwell wrote:
> Hi all,
> 
> On Wed, 29 Apr 2020 12:06:25 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> Today's linux-next merge of the mlx5-next tree got a conflict in:
>>
>>   include/linux/mlx5/mlx5_ifc.h
>>
>> between commit:
>>
>>   3ba225b506a2 ("treewide: Replace zero-length array with flexible-array member")
>>
>> from the kspp-gustavo tree and commit:
>>
>>   d65dbedfd298 ("net/mlx5: Add support for COPY steering action")
>>
>> from the mlx5-next tree.
>>
>> I fixed it up (see below) and can carry the fix as necessary. This
>> is now fixed as far as linux-next is concerned, but any non trivial
>> conflicts should be mentioned to your upstream maintainer when your tree
>> is submitted for merging.  You may also want to consider cooperating
>> with the maintainer of the conflicting tree to minimise any particularly
>> complex conflicts.
>>
>> -- 
>> Cheers,
>> Stephen Rothwell
>>
>> diff --cc include/linux/mlx5/mlx5_ifc.h
>> index 8d30f18dcdee,fb243848132d..000000000000
>> --- a/include/linux/mlx5/mlx5_ifc.h
>> +++ b/include/linux/mlx5/mlx5_ifc.h
>> @@@ -5743,7 -5771,7 +5771,7 @@@ struct mlx5_ifc_alloc_modify_header_con
>>   	u8         reserved_at_68[0x10];
>>   	u8         num_of_actions[0x8];
>>   
>> - 	union mlx5_ifc_set_action_in_add_action_in_auto_bits actions[];
>>  -	union mlx5_ifc_set_add_copy_action_in_auto_bits actions[0];
>> ++	union mlx5_ifc_set_add_copy_action_in_auto_bits actions[];
>>   };
>>   
>>   struct mlx5_ifc_dealloc_modify_header_context_out_bits {
>> @@@ -9677,9 -9705,32 +9705,32 @@@ struct mlx5_ifc_mcda_reg_bits 
>>   
>>   	u8         reserved_at_60[0x20];
>>   
>>  -	u8         data[0][0x20];
>>  +	u8         data[][0x20];
>>   };
>>   
>> + enum {
>> + 	MLX5_MFRL_REG_RESET_TYPE_FULL_CHIP = BIT(0),
>> + 	MLX5_MFRL_REG_RESET_TYPE_NET_PORT_ALIVE = BIT(1),
>> + };
>> + 
>> + enum {
>> + 	MLX5_MFRL_REG_RESET_LEVEL0 = BIT(0),
>> + 	MLX5_MFRL_REG_RESET_LEVEL3 = BIT(3),
>> + 	MLX5_MFRL_REG_RESET_LEVEL6 = BIT(6),
>> + };
>> + 
>> + struct mlx5_ifc_mfrl_reg_bits {
>> + 	u8         reserved_at_0[0x20];
>> + 
>> + 	u8         reserved_at_20[0x2];
>> + 	u8         pci_sync_for_fw_update_start[0x1];
>> + 	u8         pci_sync_for_fw_update_resp[0x2];
>> + 	u8         rst_type_sel[0x3];
>> + 	u8         reserved_at_28[0x8];
>> + 	u8         reset_type[0x8];
>> + 	u8         reset_level[0x8];
>> + };
>> + 
>>   struct mlx5_ifc_mirc_reg_bits {
>>   	u8         reserved_at_0[0x18];
>>   	u8         status_code[0x8];
> 
> This is now a conflict between the net-next and kspp-gustavo trees.
> 

Thanks for reporting this. I think the best solution, for now, is to remove the
changes from my tree. I'll do it right away.

Thanks
--
Gustavo

