Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F17413737
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 06:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbfEDEFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 00:05:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55710 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbfEDEFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 00:05:32 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8095614D7C2D1;
        Fri,  3 May 2019 21:05:20 -0700 (PDT)
Date:   Sat, 04 May 2019 00:04:58 -0400 (EDT)
Message-Id: <20190504.000458.148037825427290469.davem@davemloft.net>
To:     lipeng321@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com
Subject: Re: [PATCH V2 net-next 0/3] net: hns3: enhance capabilities for
 fibre port
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1556877039-1692-1-git-send-email-lipeng321@huawei.com>
References: <1556877039-1692-1-git-send-email-lipeng321@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 21:05:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>
Date: Fri, 3 May 2019 17:50:36 +0800

> From: Jian Shen <shenjian15@huawei.com>
> 
> This patchset enhances more capabilities for fibre port,
> include multipe media type identification, autoneg,
> change port speed and FEC encoding.

Series applied.
