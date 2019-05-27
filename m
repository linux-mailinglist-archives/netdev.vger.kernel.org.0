Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 891D42B956
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 19:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbfE0RM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 13:12:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59746 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbfE0RM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 13:12:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 27BBC1500623A;
        Mon, 27 May 2019 10:12:29 -0700 (PDT)
Date:   Mon, 27 May 2019 10:12:28 -0700 (PDT)
Message-Id: <20190527.101228.1754400926697668977.davem@davemloft.net>
To:     yangbo.lu@nxp.com
Cc:     netdev@vger.kernel.org, claudiu.manoil@nxp.com
Subject: Re: [PATCH] enetc: fix le32/le16 degrading to integer warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190527035653.7552-1-yangbo.lu@nxp.com>
References: <20190527035653.7552-1-yangbo.lu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 May 2019 10:12:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Y.b. Lu" <yangbo.lu@nxp.com>
Date: Mon, 27 May 2019 03:55:20 +0000

> Fix blow sparse warning introduced by a previous patch.
> - restricted __le32 degrades to integer
> - restricted __le16 degrades to integer
> 
> Fixes: d39823121911 ("enetc: add hardware timestamping support")
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

Applied, thank you.
