Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0FE42E73
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbfFLSSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:18:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39524 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfFLSR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 14:17:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6820D1528382E;
        Wed, 12 Jun 2019 11:17:59 -0700 (PDT)
Date:   Wed, 12 Jun 2019 11:17:58 -0700 (PDT)
Message-Id: <20190612.111758.1098909954985761400.davem@davemloft.net>
To:     ruxandra.radulescu@nxp.com
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next v3 0/3] dpaa2-eth: Add support for MQPRIO
 offloading
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1560253803-6613-1-git-send-email-ruxandra.radulescu@nxp.com>
References: <1560253803-6613-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Jun 2019 11:17:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Date: Tue, 11 Jun 2019 14:50:00 +0300

> Add support for adding multiple TX traffic classes with mqprio. We can have
> up to one netdev queue and hardware frame queue per TC per core.

Series applied, thanks.
