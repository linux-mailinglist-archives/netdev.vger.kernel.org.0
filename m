Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83EC24A9B4
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 00:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgHSWwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 18:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgHSWwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 18:52:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648D5C061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 15:52:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3903611E4576A;
        Wed, 19 Aug 2020 15:35:23 -0700 (PDT)
Date:   Wed, 19 Aug 2020 15:52:07 -0700 (PDT)
Message-Id: <20200819.155207.713791050216186108.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     dev@openvswitch.org, netdev@vger.kernel.org, pshelar@ovn.org
Subject: Re: [PATCH net-next v1 2/3] net: openvswitch: refactor flow free
 function
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200818100923.46840-3-xiangxia.m.yue@gmail.com>
References: <20200818100923.46840-1-xiangxia.m.yue@gmail.com>
        <20200818100923.46840-3-xiangxia.m.yue@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Aug 2020 15:35:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiangxia.m.yue@gmail.com
Date: Tue, 18 Aug 2020 18:09:22 +0800

> Decrease table->count and ufid_count unconditionally,

You don't explain why this is a valid transformation.

Is it a bug fix?

Can it never happen?

What are the details and how did you determine this?
