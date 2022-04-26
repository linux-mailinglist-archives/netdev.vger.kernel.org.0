Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D95DF510343
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 18:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352964AbiDZQ0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 12:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352959AbiDZQ0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 12:26:35 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E25C161EAE;
        Tue, 26 Apr 2022 09:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1650990208; x=1682526208;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=PxGFIsnivia5pwhtxt5J1B5lDPKd5/rsAL1tVlJO14g=;
  b=teEBEsSrc6Gl79Ln/+FbWbGlFH3MnMN8GDNjeZogKSEWcpCu8OEtid8z
   fW57UXw/+DUUX7L/7QIJYzGGCT1FYlPAPMKB/PhnuRgV3ma0rpaE6PmaL
   oEOyuxEywIM3cxMoJFl5/oMM2AisiOaquaQ2CkC92fRJ9sI8yaijKKgMf
   Q=;
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 26 Apr 2022 09:23:28 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg01-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 09:23:27 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 26 Apr 2022 09:23:27 -0700
Received: from [10.110.124.35] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 26 Apr
 2022 09:23:26 -0700
Message-ID: <71858a31-4667-b358-194c-95a2ffc0c593@quicinc.com>
Date:   Tue, 26 Apr 2022 09:23:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] ath10k: skip ath10k_halt during suspend for driver state
 RESTARTING
Content-Language: en-US
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
To:     Abhishek Kumar <kuabhs@chromium.org>, <kvalo@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <briannorris@chromium.org>, <ath10k@lists.infradead.org>,
        <netdev@vger.kernel.org>, Wen Gong <quic_wgong@quicinc.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220425021442.1.I650b809482e1af8d0156ed88b5dc2677a0711d46@changeid>
 <f429219f-e5e5-6107-473f-a4566f4e7ee1@quicinc.com>
In-Reply-To: <f429219f-e5e5-6107-473f-a4566f4e7ee1@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(sorry for the 2nd message with no content -- operator error)
