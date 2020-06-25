Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E0620A88D
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407672AbgFYXD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 19:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407656AbgFYXD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:03:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCBEC08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 16:03:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 30828153B3E55;
        Thu, 25 Jun 2020 16:03:56 -0700 (PDT)
Date:   Thu, 25 Jun 2020 16:03:55 -0700 (PDT)
Message-Id: <20200625.160355.1619119153777904936.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] dpaa2-eth: small updates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200624113421.17360-1-ioana.ciornei@nxp.com>
References: <20200624113421.17360-1-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 16:03:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Wed, 24 Jun 2020 14:34:16 +0300

> This patch set adds some updates to the dpaa2-eth driver: trimming of
> the frame queue debugfs counters, cleanup of the remaining sparse
> warnings and some other small fixes such as a recursive header include.

Series applied, thank you.
