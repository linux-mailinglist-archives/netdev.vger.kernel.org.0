Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B41D214025
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 21:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgGCTv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 15:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgGCTv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 15:51:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BE8C061794
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 12:51:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E87F115503C3B;
        Fri,  3 Jul 2020 12:51:27 -0700 (PDT)
Date:   Fri, 03 Jul 2020 12:51:27 -0700 (PDT)
Message-Id: <20200703.125127.2177597267314387636.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next v2 0/8] bnxt_en: Driver update for net-next.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1593760787-31695-1-git-send-email-michael.chan@broadcom.com>
References: <1593760787-31695-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Jul 2020 12:51:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Fri,  3 Jul 2020 03:19:39 -0400

> This patchset implements ethtool -X to setup user-defined RSS indirection
> table.  The new infrastructure also allows the proper logical ring index
> to be used to populate the RSS indirection when queried by ethtool -x.
> Prior to these patches, we were incorrectly populating the output of
> ethtool -x with internal ring IDs which would make no sense to the user.
> 
> The last 2 patches add some cleanups to the VLAN acceleration logic
> and check the firmware capabilities before allowing VLAN acceleration
> offloads.
> 
> v2: Some RSS indirection table changes requested by Jakub Kicinski.

Jakub, please review.
