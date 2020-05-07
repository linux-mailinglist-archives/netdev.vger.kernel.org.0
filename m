Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8BE1C7E92
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 02:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgEGAbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 20:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgEGAbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 20:31:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E244EC061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 17:31:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 994231277CC88;
        Wed,  6 May 2020 17:31:02 -0700 (PDT)
Date:   Wed, 06 May 2020 17:31:02 -0700 (PDT)
Message-Id: <20200506.173102.454539068184748067.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] net: dsa: remove duplicate assignment in
 dsa_slave_add_cls_matchall_mirred
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200504195856.12340-1-olteanv@gmail.com>
References: <20200504195856.12340-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 17:31:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon,  4 May 2020 22:58:56 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This was caused by a poor merge conflict resolution on my side. The
> "act = &cls->rule->action.entries[0];" assignment was already present in
> the code prior to the patch mentioned below.
> 
> Fixes: e13c2075280e ("net: dsa: refactor matchall mirred action to separate function")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thanks.
