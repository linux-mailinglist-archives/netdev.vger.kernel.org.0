Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2498D22A3E8
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 02:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387422AbgGWAwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 20:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgGWAwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 20:52:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE24EC0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 17:52:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ADAF412662B54;
        Wed, 22 Jul 2020 17:36:05 -0700 (PDT)
Date:   Wed, 22 Jul 2020 17:52:50 -0700 (PDT)
Message-Id: <20200722.175250.1225782080439859831.davem@davemloft.net>
To:     vishal@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com
Subject: Re: [PATCH net-next v2] cxgb4: add loopback ethtool self-test
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722135844.7432-1-vishal@chelsio.com>
References: <20200722135844.7432-1-vishal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 17:36:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>
Date: Wed, 22 Jul 2020 19:28:44 +0530

> In this test, loopback pkt is created and sent on default queue.
> 
> v2:
> - Add only loopback self-test.
> 
> Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>

Please answer Andrew's question, thank you.
