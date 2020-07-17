Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F752244D3
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 22:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgGQUAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 16:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728878AbgGQUAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 16:00:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF326C0619D2;
        Fri, 17 Jul 2020 13:00:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2430411E4592D;
        Fri, 17 Jul 2020 13:00:45 -0700 (PDT)
Date:   Fri, 17 Jul 2020 13:00:44 -0700 (PDT)
Message-Id: <20200717.130044.2129549310998584713.davem@davemloft.net>
To:     opendmb@gmail.com
Cc:     f.fainelli@gmail.com, kuba@kernel.org,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/3] net: bcmgenet: fix WAKE_FILTER resume from
 deep sleep
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1594942697-37954-1-git-send-email-opendmb@gmail.com>
References: <1594942697-37954-1-git-send-email-opendmb@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 13:00:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>
Date: Thu, 16 Jul 2020 16:38:14 -0700

> The WAKE_FILTER logic can only wake the system from the standby
> power state. However, some systems that include the GENET IP
> support deeper power saving states and the driver should suspend
> and resume correctly from those states as well.
> 
> This commit set squashes a few issues uncovered while testing
> suspend and resume from these deep sleep states.

Series applied, thank you.
