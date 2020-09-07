Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3389D25F6BF
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 11:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgIGJlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 05:41:03 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10789 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728079AbgIGJlD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 05:41:03 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 01C48D58268E14FF66DC;
        Mon,  7 Sep 2020 17:41:01 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.108) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Mon, 7 Sep 2020
 17:40:57 +0800
Subject: Re: [PATCH] mwifiex: pcie: Fix -Wunused-const-variable warnings
To:     Kalle Valo <kvalo@codeaurora.org>
References: <20200902140933.25852-1-yuehaibing@huawei.com>
 <0101017467b37012-2cad5962-8995-49d0-bf12-37c96107742a-000000@us-west-2.amazonses.com>
CC:     <amitkarwar@gmail.com>, <ganapathi.bhat@nxp.com>,
        <huxinming820@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <christophe.jaillet@wanadoo.fr>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <ae128bf3-fd9b-ee88-1c61-54a4a604a6cf@huawei.com>
Date:   Mon, 7 Sep 2020 17:40:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <0101017467b37012-2cad5962-8995-49d0-bf12-37c96107742a-000000@us-west-2.amazonses.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


commit 77dacc8fc64c ("mwifiex: pcie: Move tables to the only place they're used")

do the same things.

On 2020/9/7 16:34, Kalle Valo wrote:
> YueHaibing <yuehaibing@huawei.com> wrote:
> 
>> These variables only used in pcie.c, move them to .c file
>> can silence these warnings:
>>
>> In file included from drivers/net/wireless/marvell/mwifiex/main.h:57:0,
>>                  from drivers/net/wireless/marvell/mwifiex/init.c:24:
>> drivers/net/wireless/marvell/mwifiex/pcie.h:310:41: warning: mwifiex_pcie8997 defined but not used [-Wunused-const-variable=]
>>  static const struct mwifiex_pcie_device mwifiex_pcie8997 = {
>>                                          ^~~~~~~~~~~~~~~~
>> drivers/net/wireless/marvell/mwifiex/pcie.h:300:41: warning: mwifiex_pcie8897 defined but not used [-Wunused-const-variable=]
>>  static const struct mwifiex_pcie_device mwifiex_pcie8897 = {
>>                                          ^~~~~~~~~~~~~~~~
>> drivers/net/wireless/marvell/mwifiex/pcie.h:292:41: warning: mwifiex_pcie8766 defined but not used [-Wunused-const-variable=]
>>  static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
>>                                          ^~~~~~~~~~~~~~~~
>>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> 
> Failed to build:
> 
> drivers/net/wireless/marvell/mwifiex/pcie.c:191:43: error: redefinition of 'mwifiex_reg_8766'
>   191 | static const struct mwifiex_pcie_card_reg mwifiex_reg_8766 = {
>       |                                           ^~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex/pcie.c:36:43: note: previous definition of 'mwifiex_reg_8766' was here
>    36 | static const struct mwifiex_pcie_card_reg mwifiex_reg_8766 = {
>       |                                           ^~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex/pcie.c:223:43: error: redefinition of 'mwifiex_reg_8897'
>   223 | static const struct mwifiex_pcie_card_reg mwifiex_reg_8897 = {
>       |                                           ^~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex/pcie.c:68:43: note: previous definition of 'mwifiex_reg_8897' was here
>    68 | static const struct mwifiex_pcie_card_reg mwifiex_reg_8897 = {
>       |                                           ^~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex/pcie.c:260:43: error: redefinition of 'mwifiex_reg_8997'
>   260 | static const struct mwifiex_pcie_card_reg mwifiex_reg_8997 = {
>       |                                           ^~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex/pcie.c:105:43: note: previous definition of 'mwifiex_reg_8997' was here
>   105 | static const struct mwifiex_pcie_card_reg mwifiex_reg_8997 = {
>       |                                           ^~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex/pcie.c:297:35: error: redefinition of 'mem_type_mapping_tbl_w8897'
>   297 | static struct memory_type_mapping mem_type_mapping_tbl_w8897[] = {
>       |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex/pcie.c:142:35: note: previous definition of 'mem_type_mapping_tbl_w8897' was here
>   142 | static struct memory_type_mapping mem_type_mapping_tbl_w8897[] = {
>       |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex/pcie.c:308:35: error: redefinition of 'mem_type_mapping_tbl_w8997'
>   308 | static struct memory_type_mapping mem_type_mapping_tbl_w8997[] = {
>       |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex/pcie.c:153:35: note: previous definition of 'mem_type_mapping_tbl_w8997' was here
>   153 | static struct memory_type_mapping mem_type_mapping_tbl_w8997[] = {
>       |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex/pcie.c:312:41: error: redefinition of 'mwifiex_pcie8766'
>   312 | static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
>       |                                         ^~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex/pcie.c:157:41: note: previous definition of 'mwifiex_pcie8766' was here
>   157 | static const struct mwifiex_pcie_device mwifiex_pcie8766 = {
>       |                                         ^~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex/pcie.c:320:41: error: redefinition of 'mwifiex_pcie8897'
>   320 | static const struct mwifiex_pcie_device mwifiex_pcie8897 = {
>       |                                         ^~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex/pcie.c:165:41: note: previous definition of 'mwifiex_pcie8897' was here
>   165 | static const struct mwifiex_pcie_device mwifiex_pcie8897 = {
>       |                                         ^~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex/pcie.c:330:41: error: redefinition of 'mwifiex_pcie8997'
>   330 | static const struct mwifiex_pcie_device mwifiex_pcie8997 = {
>       |                                         ^~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex/pcie.c:175:41: note: previous definition of 'mwifiex_pcie8997' was here
>   175 | static const struct mwifiex_pcie_device mwifiex_pcie8997 = {
>       |                                         ^~~~~~~~~~~~~~~~
> make[5]: *** [drivers/net/wireless/marvell/mwifiex/pcie.o] Error 1
> make[4]: *** [drivers/net/wireless/marvell/mwifiex] Error 2
> make[3]: *** [drivers/net/wireless/marvell] Error 2
> make[2]: *** [drivers/net/wireless] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
> 
> Patch set to Changes Requested.
> 

