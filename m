Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754A9207F02
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 23:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390093AbgFXV55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 17:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729463AbgFXV54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 17:57:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B148FC061573;
        Wed, 24 Jun 2020 14:57:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 378511273DEC1;
        Wed, 24 Jun 2020 14:57:56 -0700 (PDT)
Date:   Wed, 24 Jun 2020 14:57:55 -0700 (PDT)
Message-Id: <20200624.145755.1271879668840297330.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        kuba@kernel.org, michal.kalderon@marvell.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qed: add missing error test for
 DBG_STATUS_NO_MATCHING_FRAMING_MODE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200624101302.8316-1-colin.king@canonical.com>
References: <20200624101302.8316-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jun 2020 14:57:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Wed, 24 Jun 2020 11:13:02 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The error DBG_STATUS_NO_MATCHING_FRAMING_MODE was added to the enum
> enum dbg_status however there is a missing corresponding entry for
> this in the array s_status_str. This causes an out-of-bounds read when
> indexing into the last entry of s_status_str.  Fix this by adding in
> the missing entry.
> 
> Addresses-Coverity: ("Out-of-bounds read").
> Fixes: 2d22bc8354b1 ("qed: FW 8.42.2.0 debug features")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thank you.
