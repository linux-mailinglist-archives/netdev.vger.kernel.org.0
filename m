Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62CA71F847
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 18:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfEOQOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 12:14:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42658 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfEOQOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 12:14:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 685A414E3340B;
        Wed, 15 May 2019 09:14:43 -0700 (PDT)
Date:   Wed, 15 May 2019 09:14:40 -0700 (PDT)
Message-Id: <20190515.091440.1561216610210355915.davem@davemloft.net>
To:     claudiu.manoil@nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 1/3] enetc: Fix NULL dma address unmap for Tx BD
 extensions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1557936538-23691-1-git-send-email-claudiu.manoil@nxp.com>
References: <1557936538-23691-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 May 2019 09:14:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>
Date: Wed, 15 May 2019 19:08:56 +0300

> For the unlikely case of TxBD extensions (i.e. ptp)
> the driver tries to unmap the tx_swbd corresponding
> to the extension, which is bogus as it has no buffer
> attached.
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Applied.
