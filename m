Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A8F27A417
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgI0Ugm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 16:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgI0Ugm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 16:36:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D311C0613CE
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 13:36:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ECE9A13BB09E2;
        Sun, 27 Sep 2020 13:19:53 -0700 (PDT)
Date:   Sun, 27 Sep 2020 13:36:40 -0700 (PDT)
Message-Id: <20200927.133640.442632785749386897.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next 00/11] bnxt_en: Update for net-next.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1601228540-20852-1-git-send-email-michael.chan@broadcom.com>
References: <1601228540-20852-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 27 Sep 2020 13:19:54 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Sun, 27 Sep 2020 13:42:09 -0400

> This patch series adds 2 main features to the bnxt_en driver: 200G
> link speed support and FEC support with some refactoring of the
> link speed logic.  The firmware interface is updated to have proper
> support for these 2 features.  The ethtool preset max channel value
> is also adjusted properly to account for XDP and TCs.

Series applied, thanks Michael.
