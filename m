Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47288A4B50
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 21:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbfIATMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 15:12:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49560 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728930AbfIATMg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Sep 2019 15:12:36 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5C1133082A49;
        Sun,  1 Sep 2019 19:12:36 +0000 (UTC)
Received: from localhost (ovpn-112-7.rdu2.redhat.com [10.10.112.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1ACE1600CE;
        Sun,  1 Sep 2019 19:12:33 +0000 (UTC)
Date:   Sun, 01 Sep 2019 12:12:32 -0700 (PDT)
Message-Id: <20190901.121232.2071064498490409022.davem@redhat.com>
To:     colin.king@canonical.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        tanhuazhong@huawei.com, liuzhongzhu@huawei.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: hns3: remove redundant assignment to
 pointer reg_info
From:   David Miller <davem@redhat.com>
In-Reply-To: <20190831072949.7505-1-colin.king@canonical.com>
References: <20190831072949.7505-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Sun, 01 Sep 2019 19:12:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Sat, 31 Aug 2019 08:29:49 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> Pointer reg_info is being initialized with a value that is never read and
> is being re-assigned a little later on. The assignment is redundant
> and hence can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
