Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEF21E94C4
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 02:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbgEaAlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 20:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729361AbgEaAlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 20:41:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494D2C03E969;
        Sat, 30 May 2020 17:41:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A31EE128DA2F7;
        Sat, 30 May 2020 17:41:43 -0700 (PDT)
Date:   Sat, 30 May 2020 17:41:39 -0700 (PDT)
Message-Id: <20200530.174139.953829473337248326.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, kuba@kernel.org
Subject: Re: [PATCH net-next 0/6] net: hns3: adds some cleanups for -next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1590800912-52467-1-git-send-email-tanhuazhong@huawei.com>
References: <1590800912-52467-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 May 2020 17:41:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Sat, 30 May 2020 09:08:26 +0800

> There are some cleanups for the HNS3 ethernet driver, fix an
> incorrect print format, an incorrect comment and some coding
> style issues, also remove some unused codes and macros.

Series applied, thanks.
