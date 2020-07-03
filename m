Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC3621400C
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 21:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgGCTfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 15:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgGCTfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 15:35:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24FCBC061794;
        Fri,  3 Jul 2020 12:35:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9D780154936C1;
        Fri,  3 Jul 2020 12:35:12 -0700 (PDT)
Date:   Fri, 03 Jul 2020 12:35:12 -0700 (PDT)
Message-Id: <20200703.123512.2001590063008584485.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, opendmb@gmail.com, kuba@kernel.org,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: bcmgenet: Allow changing carrier from
 user-space
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200703045701.18996-1-f.fainelli@gmail.com>
References: <20200703045701.18996-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Jul 2020 12:35:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu,  2 Jul 2020 21:57:00 -0700

> The GENET driver interfaces with internal MoCA interface as well as
> external MoCA chips like the BCM6802/6803 through a fixed link
> interface. It is desirable for the mocad user-space daemon to be able to
> control the carrier state based upon out of band messages that it
> receives from the MoCA chip.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thanks.
