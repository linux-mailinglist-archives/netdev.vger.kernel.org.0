Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C795227F425
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730845AbgI3VXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgI3VXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 17:23:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCABC061755;
        Wed, 30 Sep 2020 14:23:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CAF8F13C6ADBB;
        Wed, 30 Sep 2020 14:06:27 -0700 (PDT)
Date:   Wed, 30 Sep 2020 14:23:14 -0700 (PDT)
Message-Id: <20200930.142314.43454679428749261.davem@davemloft.net>
To:     mchehab+huawei@kernel.org
Cc:     linux-doc@vger.kernel.org, corbet@lwn.net, alex.aring@gmail.com,
        kuba@kernel.org, stefan@datenfreihafen.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 25/52] docs: net: ieee802154.rst: fix C expressions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e1ef9c58d2aa10e3487dab6798706f48029d7dee.1601467849.git.mchehab+huawei@kernel.org>
References: <cover.1601467849.git.mchehab+huawei@kernel.org>
        <e1ef9c58d2aa10e3487dab6798706f48029d7dee.1601467849.git.mchehab+huawei@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 30 Sep 2020 14:06:28 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date: Wed, 30 Sep 2020 15:24:48 +0200

> There are some warnings produced with Sphinx 3.x:
> 
> 	Documentation/networking/ieee802154.rst:29: WARNING: Error in declarator or parameters
> 	Invalid C declaration: Expecting "(" in parameters. [error at 7]
> 	  int sd = socket(PF_IEEE802154, SOCK_DGRAM, 0);
> 	  -------^
> 	Documentation/networking/ieee802154.rst:134: WARNING: Invalid C declaration: Expected end of definition. [error at 81]
> 	  void ieee802154_rx_irqsafe(struct ieee802154_hw *hw, struct sk_buff *skb, u8 lqi):
> 	  ---------------------------------------------------------------------------------^
> 	Documentation/networking/ieee802154.rst:139: WARNING: Invalid C declaration: Expected end of definition. [error at 95]
> 	  void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb, bool ifs_handling):
> 	  -----------------------------------------------------------------------------------------------^
> 	Documentation/networking/ieee802154.rst:158: WARNING: Invalid C declaration: Expected end of definition. [error at 35]
> 	  int start(struct ieee802154_hw *hw):
> 	  -----------------------------------^
> 	Documentation/networking/ieee802154.rst:162: WARNING: Invalid C declaration: Expected end of definition. [error at 35]
> 	  void stop(struct ieee802154_hw *hw):
> 	  -----------------------------------^
> 	Documentation/networking/ieee802154.rst:166: WARNING: Invalid C declaration: Expected end of definition. [error at 61]
> 	  int xmit_async(struct ieee802154_hw *hw, struct sk_buff *skb):
> 	  -------------------------------------------------------------^
> 	Documentation/networking/ieee802154.rst:171: WARNING: Invalid C declaration: Expected end of definition. [error at 43]
> 	  int ed(struct ieee802154_hw *hw, u8 *level):
> 	  -------------------------------------------^
> 	Documentation/networking/ieee802154.rst:176: WARNING: Invalid C declaration: Expected end of definition. [error at 62]
> 	  int set_channel(struct ieee802154_hw *hw, u8 page, u8 channel):
> 	  --------------------------------------------------------------^
> 
> Caused by some bad c:function: prototypes. Fix them.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
