Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 609293045D
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 23:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfE3V55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 17:57:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60906 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfE3V55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 17:57:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 34AFF14DB8589;
        Thu, 30 May 2019 14:57:57 -0700 (PDT)
Date:   Thu, 30 May 2019 14:57:56 -0700 (PDT)
Message-Id: <20190530.145756.1997834415586073195.davem@davemloft.net>
To:     xuechaojing@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoshaokai@huawei.com, cloud.wangxiaoyun@huawei.com,
        chiqijun@huawei.com, wulike1@huawei.com
Subject: Re: [net-next]hinic: add LRO support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190530013920.16544-1-xuechaojing@huawei.com>
References: <20190530013920.16544-1-xuechaojing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 14:57:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


All of these module params are a non-starter.
