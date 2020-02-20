Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35BE3166B30
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 00:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbgBTXts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 18:49:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60390 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729298AbgBTXts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 18:49:48 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4502B15BDA72C;
        Thu, 20 Feb 2020 15:49:47 -0800 (PST)
Date:   Thu, 20 Feb 2020 15:49:46 -0800 (PST)
Message-Id: <20200220.154946.233139739563491001.davem@davemloft.net>
To:     rjones@gateworks.com
Cc:     sgoutham@marvell.com, rrichter@marvell.com, kuba@kernel.org,
        maciej.fijalkowski@intel.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tharvey@gateworks.com
Subject: Re: [PATCH net v3] net: thunderx: workaround BGX TX Underflow issue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200219231936.5531-1-rjones@gateworks.com>
References: <20200219231936.5531-1-rjones@gateworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Feb 2020 15:49:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Jones <rjones@gateworks.com>
Date: Wed, 19 Feb 2020 15:19:36 -0800

> From: Tim Harvey <tharvey@gateworks.com>
> 
> While it is not yet understood why a TX underflow can easily occur
> for SGMII interfaces resulting in a TX wedge. It has been found that
> disabling/re-enabling the LMAC resolves the issue.
> 
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
> Reviewed-by: Robert Jones <rjones@gateworks.com>

Applied.
