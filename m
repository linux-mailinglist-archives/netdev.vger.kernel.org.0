Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E013E27F4BE
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 00:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbgI3WBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 18:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730967AbgI3WB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 18:01:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4CCC061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 15:01:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8BD4513C70F72;
        Wed, 30 Sep 2020 14:44:38 -0700 (PDT)
Date:   Wed, 30 Sep 2020 15:01:23 -0700 (PDT)
Message-Id: <20200930.150123.1032572640658857587.davem@davemloft.net>
To:     anthony.l.nguyen@intel.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Subject: Re: [net v2 0/2][pull request] Intel Wired LAN Driver Updates
 2020-09-30
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200930154923.2069200-1-anthony.l.nguyen@intel.com>
References: <20200930154923.2069200-1-anthony.l.nguyen@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 30 Sep 2020 14:44:38 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>
Date: Wed, 30 Sep 2020 08:49:21 -0700

> This series contains updates to ice driver only.
> 
> Jake increases the wait time for firmware response as it can take longer
> than the current wait time. Preserves the NVM capabilities of the device in
> safe mode so the device reports its NVM update capabilities properly
> when in this state.
> 
> v2: Added cover letter

Pulled, thanks Tony.
