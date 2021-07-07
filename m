Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172B73BE579
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 11:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhGGJY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 05:24:26 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:14033 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbhGGJYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 05:24:25 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GKYkc3Lz7zZnf9;
        Wed,  7 Jul 2021 17:18:32 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 7 Jul 2021 17:21:44 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 7 Jul
 2021 17:21:29 +0800
Subject: Re: [RFC PATCH net-next 3/8] net: hns3: add support for devlink get
 info for PF
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>
References: <1625553692-2773-1-git-send-email-huangguangbin2@huawei.com>
 <1625553692-2773-4-git-send-email-huangguangbin2@huawei.com>
 <20210706161432.7196c6b4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <7a2b4cec-20b2-82c7-805c-0c849035f2bc@huawei.com>
Date:   Wed, 7 Jul 2021 17:21:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210706161432.7196c6b4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/7/7 7:14, Jakub Kicinski wrote:
> On Tue, 6 Jul 2021 14:41:27 +0800 Guangbin Huang wrote:
>> +	return devlink_info_version_running_put(req, "fw-version", version_str);
> 
> Please use one of the existing names instead of "fw-version",
> e.g. DEVLINK_INFO_VERSION_GENERIC_FW.
> .
> 
Ok, thanks.
