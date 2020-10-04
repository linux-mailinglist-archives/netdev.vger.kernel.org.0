Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B09282DCC
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 23:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgJDVlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 17:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgJDVlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 17:41:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7668C0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 14:41:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7246C1277FE94;
        Sun,  4 Oct 2020 14:24:35 -0700 (PDT)
Date:   Sun, 04 Oct 2020 14:41:22 -0700 (PDT)
Message-Id: <20201004.144122.991179919537466779.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: Re: [PATCH net-next 00/11] bnxt_en: net-next updates.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1601839381-10446-1-git-send-email-michael.chan@broadcom.com>
References: <1601839381-10446-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 04 Oct 2020 14:24:35 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Sun,  4 Oct 2020 15:22:50 -0400

> This series starts off with the usual update of the firmware interface
> spec.  A new firmware status bit in the interface will be used in patch
> #4 to perform recovery on some SoC platforms.  Patches #2 and #3 first
> add the infrastructure to read the firmware status very early during
> driver probe and this will allow patch #4 to do the recovery if needed.
> 
> The rest of the patches add improvements to the current RX reset
> logic by localizing the reset to the affected RX ring only and to
> reset only if firmware has determined that the RX ring is in permanent
> error state.

Series applied, thank you.
