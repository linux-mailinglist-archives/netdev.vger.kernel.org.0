Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720FB389687
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 21:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhESTWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 15:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbhESTWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 15:22:46 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD618C06175F;
        Wed, 19 May 2021 12:21:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id DBAA54D2CF702;
        Wed, 19 May 2021 12:21:23 -0700 (PDT)
Date:   Wed, 19 May 2021 12:21:20 -0700 (PDT)
Message-Id: <20210519.122120.1068759496237252420.davem@davemloft.net>
To:     ljp@linux.vnet.ibm.com
Cc:     tanghui20@huawei.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/20] net: ethernet: remove leading spaces before tabs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7D679E0A-DEBE-4F84-945F-86E63F031754@linux.vnet.ibm.com>
References: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
        <7D679E0A-DEBE-4F84-945F-86E63F031754@linux.vnet.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 19 May 2021 12:21:24 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lijun Pan <ljp@linux.vnet.ibm.com>
Date: Wed, 19 May 2021 01:06:28 -0500

> It should be targeting net-next, I believe.

That's where I applied this series, so no worries.
