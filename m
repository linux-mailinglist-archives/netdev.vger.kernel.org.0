Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644F24C9138
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 18:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234223AbiCARNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 12:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234377AbiCARNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 12:13:47 -0500
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7ECD3B007;
        Tue,  1 Mar 2022 09:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1646154785; x=1677690785;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=k6CREB0TD0/8UF4IksukPBWP48bQZt3imPBwgI28Sps=;
  b=mz5abiRslc3BzkZyBHTbPrhwGGb8lwlczq3bnOAE6S7xGmdJjXcqRhfg
   xIRThIlKAMAP79r1V4AiWIZ2cfeCu10G51CMCaUp2umSN+K15VBbjigud
   +oLRWhltDXib+guWJQqdPiXis2fcL62SzyvfPrXs/Wo4/zcslTcBfnnzk
   o=;
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 01 Mar 2022 09:13:05 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg01-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 09:13:04 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Tue, 1 Mar 2022 09:13:04 -0800
Received: from [10.111.181.139] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15; Tue, 1 Mar 2022
 09:13:04 -0800
Message-ID: <4c3c55ac-1dda-410a-7125-ca0e2acee44d@quicinc.com>
Date:   Tue, 1 Mar 2022 09:13:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 03/10] staging: wfx: format comments on 100 columns
Content-Language: en-US
To:     Joe Perches <joe@perches.com>,
        Jerome Pouiller <Jerome.Pouiller@silabs.com>,
        <linux-wireless@vger.kernel.org>, Kalle Valo <kvalo@kernel.org>
CC:     <devel@driverdev.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20220225112405.355599-1-Jerome.Pouiller@silabs.com>
 <20220225112405.355599-4-Jerome.Pouiller@silabs.com>
 <fe3c21a9c0178a2f0fcea698b8e6405a99747dea.camel@perches.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <fe3c21a9c0178a2f0fcea698b8e6405a99747dea.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/28/2022 5:12 PM, Joe Perches wrote:
> On Fri, 2022-02-25 at 12:23 +0100, Jerome Pouiller wrote:
>> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
>>
>> A few comments were not yet formatted on 100 columns.
> 
> IMO, none of these changes are necessary or good changes.
> 
> 80 columns is preferred.
> 
> Really comments should most always use 80 columns, and
> only occasionally should code be more than 80 columns
> and almost never should code be more than 100 columns.

That was my reaction as well. Just because we've relaxed rules so that 
we *can* exceed 80 columns, it doesn't mean we *should*, and definitely 
doesn't mean we should *strive* to do so.
