Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31A49A4B52
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 21:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbfIATNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 15:13:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46972 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728930AbfIATNV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Sep 2019 15:13:21 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CF182C057F31;
        Sun,  1 Sep 2019 19:13:20 +0000 (UTC)
Received: from localhost (ovpn-112-7.rdu2.redhat.com [10.10.112.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6A9460BF4;
        Sun,  1 Sep 2019 19:13:17 +0000 (UTC)
Date:   Sun, 01 Sep 2019 12:13:16 -0700 (PDT)
Message-Id: <20190901.121316.444864364160353651.davem@redhat.com>
To:     yuehaibing@huawei.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        linyunsheng@huawei.com, liuzhongzhu@huawei.com,
        huangguangbin2@huawei.com, lipeng321@huawei.com,
        tanhuazhong@huawei.com, shenjian15@huawei.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        hulkci@huawei.com
Subject: Re: [PATCH net-next] net: hns3: remove set but not used variable
 'qos'
From:   David Miller <davem@redhat.com>
In-Reply-To: <20190831122911.181336-1-yuehaibing@huawei.com>
References: <20190831122911.181336-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Sun, 01 Sep 2019 19:13:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Sat, 31 Aug 2019 12:29:11 +0000

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c: In function 'hclge_restore_vlan_table':
> drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c:8016:18: warning:
>  variable 'qos' set but not used [-Wunused-but-set-variable]
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 70a214903da9 ("net: hns3: reduce the parameters of some functions")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
