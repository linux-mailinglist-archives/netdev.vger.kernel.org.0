Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC60575CA2
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 09:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbiGOHrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 03:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiGOHrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 03:47:09 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D27376E87;
        Fri, 15 Jul 2022 00:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1657871228; x=1689407228;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gvvUpSNEdrF8U7FzrEDBpK1R21Jli10yJG67LcVmV5Q=;
  b=BQM5jOQB98zyorvfBhgjocrG+XrM1/0OJav4EJxN53uoLqZ5hapYCgJb
   mKdFTG6YjsWUrJf3+D0frU1bRjsXh1LNPoBTiUwEb28W7r9Hw1gfLgqfO
   WNIf8sXqdEGP3R1jzBsSyM/FfJKjoMrZQKG4XRU2lnTokbAIVVrHKe8xM
   I=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 15 Jul 2022 00:47:08 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 00:47:08 -0700
Received: from [10.253.39.163] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 15 Jul
 2022 00:47:05 -0700
Message-ID: <b2e97620-bdad-a323-cd07-20e667a8acc6@quicinc.com>
Date:   Fri, 15 Jul 2022 15:47:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] Bluetooth: hci_sync: Remove redundant func definition
Content-Language: en-US
To:     Paul Menzel <pmenzel@molgen.mpg.de>
CC:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <luiz.von.dentz@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <1657858487-29052-1-git-send-email-quic_zijuhu@quicinc.com>
 <afbf4b73-29b9-1bca-e5f5-85b7bfdcf568@molgen.mpg.de>
From:   quic_zijuhu <quic_zijuhu@quicinc.com>
In-Reply-To: <afbf4b73-29b9-1bca-e5f5-85b7bfdcf568@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/2022 3:34 PM, Paul Menzel wrote:
> Dear Zijun,
> 
> 
> Thank you for the patch.
> 
> Am 15.07.22 um 06:14 schrieb Zijun Hu:
>> both hci_request.c and hci_sync.c have the same definition
>> for disconnected_accept_list_entries(), so remove a redundant
>> copy.
> 
> Please use 75 characters per line for Linux commit message bodies. That way, only two instead of three lines are needed.
thanks for your suggestion, correct within v4 sent. could you code review again?
>> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
>> ---
>> v1->v2
>>     -remove the func copy within hci_request.c instead of hci_sync.c
>>   net/bluetooth/hci_request.c | 18 ------------------
>>   net/bluetooth/hci_request.h |  2 ++
>>   net/bluetooth/hci_sync.c    |  2 +-
>>   3 files changed, 3 insertions(+), 19 deletions(-)
> 
> […]
> 
> 
> Kind regards,
> 
> Paul

