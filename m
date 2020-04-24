Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9C21B828E
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 01:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgDXXtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 19:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgDXXtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 19:49:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951CAC09B049;
        Fri, 24 Apr 2020 16:49:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4A0B914F48D82;
        Fri, 24 Apr 2020 16:49:33 -0700 (PDT)
Date:   Fri, 24 Apr 2020 16:49:32 -0700 (PDT)
Message-Id: <20200424.164932.1533021429412470341.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     opendmb@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: bcmgenet: suppress warnings on failed Rx
 SKB allocations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <519fe72a-53b1-8e46-8c1a-834b91c717c1@gmail.com>
References: <1587682931-38636-1-git-send-email-opendmb@gmail.com>
        <519fe72a-53b1-8e46-8c1a-834b91c717c1@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Apr 2020 16:49:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 23 Apr 2020 16:10:07 -0700

> It seems to me this should be the default behavior for all network
> device drivers, but I am fine with this being a driver decision if
> people think differently.

Yeah I think the behavior should be consistent and default across
drivers too.
