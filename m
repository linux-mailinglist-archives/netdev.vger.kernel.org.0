Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A886AC0021
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 09:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbfI0Hk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 03:40:59 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39178 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725842AbfI0Hk6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 03:40:58 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A8FC9557BDC17811BB43;
        Fri, 27 Sep 2019 15:40:54 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Fri, 27 Sep 2019
 15:40:48 +0800
To:     <jiri@mellanox.com>, <valex@mellanox.com>
CC:     <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Subject: [question] About triggering a region snapshot through the devlink cmd
Message-ID: <f1436c35-e8be-7b9d-c2f5-b6403348f87a@huawei.com>
Date:   Fri, 27 Sep 2019 15:40:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Jiri & Alex

    It seems that a region' snapshot is only created through the
driver when some error is detected, for example:
mlx4_crdump_collect_fw_health() -> devlink_region_snapshot_create()

    We want to trigger a region' snapshot creation through devlink
cmd, maybe by adding the "devlink region triger", because we want
to check some hardware register/state when the driver or the hardware
does not detect the error sometimes.

Does about "devlink region triger" make sense?

If yes, is there plan to implement it? or any suggestion to implement
it?

