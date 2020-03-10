Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4B0180BDB
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgCJWtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:49:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43498 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727804AbgCJWtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:49:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2DC6F14BEB0D5;
        Tue, 10 Mar 2020 15:49:14 -0700 (PDT)
Date:   Tue, 10 Mar 2020 15:49:13 -0700 (PDT)
Message-Id: <20200310.154913.1801025642825118571.davem@davemloft.net>
To:     claudiu.manoil@nxp.com
Cc:     netdev@vger.kernel.org, vladimir.oltean@nxp.com, yangbo.lu@nxp.com
Subject: Re: [PATCH net-next 0/4] Support extended BD rings at runtime,
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1583844684-28202-1-git-send-email-claudiu.manoil@nxp.com>
References: <1583844684-28202-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Mar 2020 15:49:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>
Date: Tue, 10 Mar 2020 14:51:20 +0200

> First two patches are just misc code cleanup.
> The 3rd patch prepares the Rx BD processing code to be extended
> to processing both normal and extended BDs.
> The last one adds extended Rx BD support for timestamping
> without the need of a static config. Finally, the config option
> FSL_ENETC_HW_TIMESTAMPING can be dropped.
> Care was taken not to impact non-timestamping usecases.

Looks good, series applied, thanks.
