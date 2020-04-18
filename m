Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BF81AF581
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 00:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgDRWjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 18:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgDRWjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 18:39:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91BEC061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 15:39:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 86B611277CEB4;
        Sat, 18 Apr 2020 15:39:44 -0700 (PDT)
Date:   Sat, 18 Apr 2020 15:39:43 -0700 (PDT)
Message-Id: <20200418.153943.1379994854481808534.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     pshelar@ovn.org, azhou@ovn.org, blp@ovn.org, u9012063@gmail.com,
        netdev@vger.kernel.org, dev@openvswitch.org
Subject: Re: [PATCH net-next v2 0/5] expand meter tables and fix bug
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1587032223-49460-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
        <1587032223-49460-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Apr 2020 15:39:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiangxia.m.yue@gmail.com
Date: Thu, 16 Apr 2020 18:16:58 +0800

> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> The patch set expands or shrink the meter table when necessary.
> and other patch fixes bug or improve codes.

Pravin et al. please review this series.

Thank you.
