Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55300251D4B
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 18:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgHYQhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 12:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgHYQhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 12:37:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807A4C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 09:37:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A8582134A0E48;
        Tue, 25 Aug 2020 09:20:51 -0700 (PDT)
Date:   Tue, 25 Aug 2020 09:37:37 -0700 (PDT)
Message-Id: <20200825.093737.498387792119845500.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     pshelar@ovn.org, xiyou.wangcong@gmail.com, dev@openvswitch.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/3] net: openvswitch: improve codes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200825050636.14153-1-xiangxia.m.yue@gmail.com>
References: <20200825050636.14153-1-xiangxia.m.yue@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Aug 2020 09:20:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiangxia.m.yue@gmail.com
Date: Tue, 25 Aug 2020 13:06:33 +0800

> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> This series patches are not bug fix, just improve codes.

Pravin, please review this patch series.

Thank you.
