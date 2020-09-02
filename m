Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C7125B730
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 01:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgIBXQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 19:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgIBXQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 19:16:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D911BC061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 16:16:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C877015751F32;
        Wed,  2 Sep 2020 15:59:58 -0700 (PDT)
Date:   Wed, 02 Sep 2020 16:16:44 -0700 (PDT)
Message-Id: <20200902.161644.1325056661404881358.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2 00/15] net: bridge: mcast: initial IGMPv3
 support (part 1)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <22c022da-4b1d-b0fe-b701-ce2163b3c3c0@cumulusnetworks.com>
References: <20200902.125846.1328960907241014780.davem@davemloft.net>
        <16ed8f8a-2040-5546-5cea-09a8a5b0bd7b@cumulusnetworks.com>
        <22c022da-4b1d-b0fe-b701-ce2163b3c3c0@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 02 Sep 2020 15:59:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Wed, 2 Sep 2020 23:17:46 +0300

> i. e. this doesn't exclude IPv6 or makes it worse for it, on the
> contrary the ops needed to
> implement MLDv2 state transitions are in this set, they just need to
> be extended for v6.
> The new br_ip src group field contains also a field for an IPv6
> address.

Great, then implement those parts and resubmit and we'll all be happy
:-)
