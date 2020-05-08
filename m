Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917361C9FB4
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 02:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgEHAft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 20:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726470AbgEHAft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 20:35:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1447FC05BD43;
        Thu,  7 May 2020 17:35:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5FC551193B1BD;
        Thu,  7 May 2020 17:35:48 -0700 (PDT)
Date:   Thu, 07 May 2020 17:35:47 -0700 (PDT)
Message-Id: <20200507.173547.292658666015125038.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        youri.querry_1@nxp.com, leoyang.li@nxp.com
Subject: Re: [PATCH net] soc: fsl: dpio: properly compute the consumer index
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200505201429.24360-1-ioana.ciornei@nxp.com>
References: <20200505201429.24360-1-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 17:35:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Tue,  5 May 2020 23:14:29 +0300

> Mask the consumer index before using it. Without this, we would be
> writing frame descriptors beyond the ring size supported by the QBMAN
> block.
> 
> Fixes: 3b2abda7d28c ("soc: fsl: dpio: Replace QMAN array mode with ring mode enqueue")
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Applied to net-next, thanks.
