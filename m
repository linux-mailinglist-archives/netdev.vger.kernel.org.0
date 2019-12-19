Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16575125978
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 03:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfLSCGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 21:06:37 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:53720 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726463AbfLSCGh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 21:06:37 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 438F537EFDE5E5790483;
        Thu, 19 Dec 2019 10:06:35 +0800 (CST)
Received: from [127.0.0.1] (10.67.103.228) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 19 Dec 2019
 10:06:20 +0800
Subject: Re: [PATCH v3] net: hisilicon: Fix a BUG trigered by wrong
 bytes_compl
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
References: <1576635093-60466-1-git-send-email-xiaojiangfeng@huawei.com>
 <20191218093750.2c9f1aa1@cakuba.netronome.com>
CC:     <davem@davemloft.net>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <zhangfei.gao@linaro.org>,
        <arnd@arndb.de>, <dingtianhong@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <leeyou.li@huawei.com>, <nixiaoming@huawei.com>
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Message-ID: <3e7db503-993d-fbc9-d4cf-e05a39d5cb7a@huawei.com>
Date:   Thu, 19 Dec 2019 10:06:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20191218093750.2c9f1aa1@cakuba.netronome.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.228]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/12/19 1:37, Jakub Kicinski wrote:
> On Wed, 18 Dec 2019 10:11:33 +0800, Jiangfeng Xiao wrote:
>> Fixes: a41ea46a9 ("net: hisilicon: new hip04 ethernet driver")
> 
> Thanks for providing the fixes tag, for quoting commits please always
> use 12 characters of the hash.
> 
Thanks for your guidance. I will fix this in v4.

