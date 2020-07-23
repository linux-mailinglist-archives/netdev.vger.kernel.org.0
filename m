Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7A722A46B
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 03:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387550AbgGWBOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 21:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgGWBOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 21:14:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2668C0619DC;
        Wed, 22 Jul 2020 18:14:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 86B2E126B59C7;
        Wed, 22 Jul 2020 17:57:52 -0700 (PDT)
Date:   Wed, 22 Jul 2020 18:14:36 -0700 (PDT)
Message-Id: <20200722.181436.414462601873878102.davem@davemloft.net>
To:     navid.emamdoost@gmail.com
Cc:     vishal@chelsio.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, emamd001@umn.edu
Subject: Re: [PATCH v2] cxgb4: add missing release on skb in uld_send()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722185722.3580-1-navid.emamdoost@gmail.com>
References: <20200720.183113.2100585349998522874.davem@davemloft.net>
        <20200722185722.3580-1-navid.emamdoost@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 17:57:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>
Date: Wed, 22 Jul 2020 13:57:21 -0500

> In the implementation of uld_send(), the skb is consumed on all
> execution paths except one. Release skb when returning NET_XMIT_DROP.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---
> changes in v2:
> 	- using kfree_skb() based on David Miller suggestion.

This doesn't apply to any of my networking GIT trees.

Please base this on either 'net' or 'net-next' as appropriate,
and indicate this in your Subject line f.e. "[PATCH net v2] ..."

Thank you.
