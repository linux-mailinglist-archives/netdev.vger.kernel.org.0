Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49925512D36
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 09:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245367AbiD1HpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 03:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232526AbiD1HpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 03:45:02 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48040220CA;
        Thu, 28 Apr 2022 00:41:47 -0700 (PDT)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KpnWX2KPyzCsNn;
        Thu, 28 Apr 2022 15:37:12 +0800 (CST)
Received: from [10.174.178.165] (10.174.178.165) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 28 Apr 2022 15:41:45 +0800
Subject: Re: [PATCH bpf-next RESEND 0/2] bpf, docs: Fix typos in
 instruction-set.rst
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1651131344-24528-1-git-send-email-yangtiezhu@loongson.cn>
From:   "weiyongjun (A)" <weiyongjun1@huawei.com>
Message-ID: <a3105210-757e-b2f7-51d0-9ca7bec7e0cb@huawei.com>
Date:   Thu, 28 Apr 2022 15:41:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1651131344-24528-1-git-send-email-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.165]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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


ÔÚ 2022/4/28 15:35, Tiezhu Yang Ð´µÀ:
> Forget to add [PATCH bpf-next] subject prefix,
> sorry for that, just resend.
>
> Tiezhu Yang (2):
>    bpf, docs: Remove duplicated word "instructions"
>    bpf, docs: BPF_FROM_BE exists as alias for BPF_TO_BE
>
>   Documentation/bpf/instruction-set.rst | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)


Looks good to me


