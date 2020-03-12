Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF827182886
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 06:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387826AbgCLFmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 01:42:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55880 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387758AbgCLFmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 01:42:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3ECC014BEB0F4;
        Wed, 11 Mar 2020 22:42:16 -0700 (PDT)
Date:   Wed, 11 Mar 2020 22:42:13 -0700 (PDT)
Message-Id: <20200311.224213.876954450613670264.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, fugang.duan@nxp.com, frank.li@nxp.com
Subject: Re: [PATCH net] net: fec: validate the new settings in
 fec_enet_set_coalesce()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200311033616.2103499-1-kuba@kernel.org>
References: <20200311033616.2103499-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Mar 2020 22:42:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Tue, 10 Mar 2020 20:36:16 -0700

> fec_enet_set_coalesce() validates the previously set params
> and if they are within range proceeds to apply the new ones.
> The new ones, however, are not validated. This seems backwards,
> probably a copy-paste error?
> 
> Compile tested only.
> 
> Fixes: d851b47b22fc ("net: fec: add interrupt coalescence feature support")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Applied and queued up for -stable, thanks.
