Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99CDA1C4330
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730328AbgEDRqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729667AbgEDRqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:46:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7AAC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 10:46:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 53C1515C1C4A8;
        Mon,  4 May 2020 10:46:16 -0700 (PDT)
Date:   Mon, 04 May 2020 10:46:15 -0700 (PDT)
Message-Id: <20200504.104615.1617086695508759290.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/15] bnxt_en: Updates for net-next.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
References: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 May 2020 10:46:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Mon,  4 May 2020 04:50:26 -0400

> This patchset includes these main changes:
> 
> 1. Firmware spec. update.
> 2. Context memory sizing improvements for the hardware TQM block.
> 3. ethtool chip reset improvements and fixes for correctness.
> 4. Improve L2 doorbell mapping by mapping only up to the size specified
> by firmware.  This allows the RoCE driver to map the remaining doorbell
> space for its purpose, such as write-combining.
> 5. Improve ethtool -S channel statistics by showing only relevant ring
> counters for non-combined channels.

Series applied, thanks Michael.
