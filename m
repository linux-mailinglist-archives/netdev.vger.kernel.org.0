Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1327D8F525
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730834AbfHOTy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:54:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49416 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729818AbfHOTy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 15:54:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 55CA814014E75;
        Thu, 15 Aug 2019 12:54:58 -0700 (PDT)
Date:   Thu, 15 Aug 2019 12:54:57 -0700 (PDT)
Message-Id: <20190815.125457.142411641679942343.davem@davemloft.net>
To:     skalluru@marvell.com
Cc:     netdev@vger.kernel.org, mkalderon@marvell.com, aelior@marvell.com
Subject: Re: [PATCH net-next v4 0/2] qed*: Support for NVM config
 attributes.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190814081153.18889-1-skalluru@marvell.com>
References: <20190814081153.18889-1-skalluru@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 12:54:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Date: Wed, 14 Aug 2019 01:11:51 -0700

> The patch series adds support for managing the NVM config attributes.
> Patch (1) adds functionality to update config attributes via MFW.
> Patch (2) adds driver interface for updating the config attributes.
> 
> Changes from previous versions:
> -------------------------------
> v4: Added more details on the functionality and its usage.
> v3: Removed unused variable.
> v2: Removed unused API.
> 
> Please consider applying this series to "net-next".

Series applied.
