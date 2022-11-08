Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC665620C12
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 10:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbiKHJXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 04:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233827AbiKHJWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 04:22:45 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9833206C
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 01:22:42 -0800 (PST)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N62gT32sgz15MQr;
        Tue,  8 Nov 2022 17:22:29 +0800 (CST)
Received: from [10.174.178.165] (10.174.178.165) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 17:22:40 +0800
Message-ID: <01832208-5953-cb94-cc43-0f228ba74374@huawei.com>
Date:   Tue, 8 Nov 2022 17:22:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net] mctp: Fix an error handling path in mctp_init()
To:     Jakub Kicinski <kuba@kernel.org>,
        Wei Yongjun <weiyongjun@huaweicloud.com>
CC:     Matt Johnston <matt@codeconstruct.com.au>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20221107152756.180628-1-weiyongjun@huaweicloud.com>
 <20221107202624.5c6afcdd@kernel.org>
From:   Wei Yongjun <weiyongjun1@huawei.com>
In-Reply-To: <20221107202624.5c6afcdd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.165]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/11/8 12:26, Jakub Kicinski wrote:
> On Mon,  7 Nov 2022 15:27:56 +0000 Wei Yongjun wrote:
>> +	mctp_routes_exit();
> 
> This function is marked as __exit, build complains:
> 
> WARNING: modpost: vmlinux.o: section mismatch in reference: mctp_init (section: .init.text) -> mctp_routes_exit (section: .exit.text)

Sorry, it is my fault.

The warning message is flushed by BTF mesages, will fix in
next version.

Thanks,
Wei Yongjun
