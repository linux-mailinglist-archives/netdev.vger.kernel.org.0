Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E262D21FFDA
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 23:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgGNVRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 17:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727935AbgGNVRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 17:17:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0976C061755;
        Tue, 14 Jul 2020 14:17:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5B15C15E2EDE6;
        Tue, 14 Jul 2020 14:17:07 -0700 (PDT)
Date:   Tue, 14 Jul 2020 14:17:06 -0700 (PDT)
Message-Id: <20200714.141706.1932980943764190362.davem@davemloft.net>
To:     fido_max@inbox.ru
Cc:     claudiu.manoil@nxp.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gianfar: Use random MAC address when none is given
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200714120104.257819-1-fido_max@inbox.ru>
References: <20200714120104.257819-1-fido_max@inbox.ru>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jul 2020 14:17:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Kochetkov <fido_max@inbox.ru>
Date: Tue, 14 Jul 2020 15:01:04 +0300

> If there is no valid MAC address in the device tree,
> use a random MAC address.
> 
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>

Looks good, patch applied, thanks.
