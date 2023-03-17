Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C3E6BE150
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 07:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjCQGeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 02:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjCQGef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 02:34:35 -0400
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD27462D8A;
        Thu, 16 Mar 2023 23:34:19 -0700 (PDT)
Received: from localhost.localdomain (unknown [124.16.138.125])
        by APP-03 (Coremail) with SMTP id rQCowAB3fCTcCRRk5qELEQ--.5205S2;
        Fri, 17 Mar 2023 14:34:05 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     kuba@kernel.org
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: Re: Re: [PATCH] octeontx2-vf: Add missing free for alloc_percpu
Date:   Fri, 17 Mar 2023 14:34:03 +0800
Message-Id: <20230317063403.17970-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: rQCowAB3fCTcCRRk5qELEQ--.5205S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKw4fGFy7ur4fAF15Gw18Grg_yoWxtrc_Ca
        yDXasrGrn8A3W0g3W7Gr4UCFWUWF1DGrsYqrZYkr9rGry5XrZ3ZrsxJr1Syry8Jan3KF9F
        q3s8X34rA3W0vjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbx8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
        0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
        IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
        AFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
        6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHU
        DUUUUU=
X-Originating-IP: [124.16.138.125]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 12:24:46AM +0800, Jakub Kicinski wrote:
> On Thu, 16 Mar 2023 10:39:11 +0800 Jiasheng Jiang wrote:
>> +	if (vf->hw.lmt_info)
>> +		free_percpu(vf->hw.lmt_info);
>>  	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
>>  		qmem_free(vf->dev, vf->dync_lmt);
>>  	otx2_detach_resources(&vf->mbox);
>> @@ -762,6 +764,8 @@ static void otx2vf_remove(struct pci_dev *pdev)
>>  	otx2_shutdown_tc(vf);
>>  	otx2vf_disable_mbox_intr(vf);
>>  	otx2_detach_resources(&vf->mbox);
>> +	if (vf->hw.lmt_info)
>> +		free_percpu(vf->hw.lmt_info);
> 
> No need for the if () checks, free_percpu() seems to handle NULL just
> fine.

I will submit a v2 removing the checks.

Thanks,
Jiang

