Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5563A52D966
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239786AbiESPwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238806AbiESPwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:52:49 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BDC62129;
        Thu, 19 May 2022 08:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1652975567; x=1684511567;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ezlFNIw1YV6/IbC1LgUXiEe8pIzsUQQCD7W/6KfdQOQ=;
  b=ygvkjK/p9ql3ncXECqxnuOJTWK5JE7oqDpBcL6TRyCXtLhxUQsvJtk8H
   ocYyBR6MgjkXUkUjNB/bzoHLOVHC74cIru8mLJ5nFOrcE2s6PTWGFpCVx
   outXibwSHJhk9bh/Cn13AiQPils1sVTh6dcjmKkLuKNckrmP44WHiP/oo
   0=;
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 19 May 2022 08:52:46 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 08:52:46 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 19 May 2022 08:52:45 -0700
Received: from [10.110.66.23] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 19 May
 2022 08:52:44 -0700
Message-ID: <b68d6586-20ef-7409-6496-5dd81b54bc32@quicinc.com>
Date:   Thu, 19 May 2022 08:52:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] mwifiex: Fix potential dereference of NULL pointer
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>, Yongzhi Liu <lyz_cs@pku.edu.cn>
CC:     <amitkarwar@gmail.com>, <ganapathi017@gmail.com>,
        <sharvari.harisangam@nxp.com>, <huxinming820@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <arend.vanspriel@broadcom.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <fuyq@stu.pku.edu.cn>
References: <1652957839-127949-1-git-send-email-lyz_cs@pku.edu.cn>
 <87r14p1qkw.fsf@kernel.org>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <87r14p1qkw.fsf@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/19/2022 8:37 AM, Kalle Valo wrote:
> Yongzhi Liu <lyz_cs@pku.edu.cn> writes:
> Format is wrong, it should be:
> 
> Fixes: 21c5c83ce833 ("mwifiex: support sysfs initiated device coredump")

And no blank line between the Fixes tag and the Signed-off-by tag

