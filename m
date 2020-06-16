Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA351FA596
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 03:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgFPBXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 21:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgFPBXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 21:23:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8A3C061A0E;
        Mon, 15 Jun 2020 18:23:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 125EE123C069B;
        Mon, 15 Jun 2020 18:23:44 -0700 (PDT)
Date:   Mon, 15 Jun 2020 18:23:43 -0700 (PDT)
Message-Id: <20200615.182343.221546986577273426.davem@davemloft.net>
To:     mayflowerera@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] macsec: Support 32bit PN netlink attribute for XPN
 links
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200615154114.13184-1-mayflowerera@gmail.com>
References: <20200615154114.13184-1-mayflowerera@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 18:23:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Era Mayflower <mayflowerera@gmail.com>
Date: Tue, 16 Jun 2020 00:41:14 +0900

> +	if (tb_sa[MACSEC_SA_ATTR_PN]) {

validate_add_rxsa() requires that MACSET_SA_ATTR_PN be non-NULL, so
you don't need to add this check here.

