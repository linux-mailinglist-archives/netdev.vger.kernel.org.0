Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E985271921
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 04:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgIUCFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 22:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgIUCFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 22:05:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A62C061755
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 19:05:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CBE4313D6D6F5;
        Sun, 20 Sep 2020 18:48:59 -0700 (PDT)
Date:   Sun, 20 Sep 2020 19:05:46 -0700 (PDT)
Message-Id: <20200920.190546.661380146835440890.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net 0/6] bnxt_en: Bug fixes.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1600650539-19967-1-git-send-email-michael.chan@broadcom.com>
References: <1600650539-19967-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 20 Sep 2020 18:48:59 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Sun, 20 Sep 2020 21:08:53 -0400

> A series of small driver fixes covering VPD length logic,
> ethtool_get_regs on VF, hwmon temperature error handling,
> mutex locking for EEE and pause ethtool settings, and
> parameters for statistics related firmware calls.

Series applied.

> Please queue patches 1, 2, and 3 for -stable.  Thanks.

Queued up, thanks.
