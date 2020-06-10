Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F99B1F5ECF
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 01:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgFJXjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 19:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbgFJXjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 19:39:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A08C03E96B;
        Wed, 10 Jun 2020 16:39:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 64C4C11F5F667;
        Wed, 10 Jun 2020 16:39:32 -0700 (PDT)
Date:   Wed, 10 Jun 2020 16:39:31 -0700 (PDT)
Message-Id: <20200610.163931.654886299556569303.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, vladimir.oltean@nxp.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net] docs: networkng: fix lists and table in sja1105
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200610230906.418826-1-kuba@kernel.org>
References: <20200610230906.418826-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Jun 2020 16:39:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 10 Jun 2020 16:09:06 -0700

> We need an empty line before list stats, otherwise first point
> will be smooshed into the paragraph. Inside tables text must
> start at the same offset in the cell, otherwise sphinx thinks
> it's a new indented block.
> 
> Documentation/networking/dsa/sja1105.rst:108: WARNING: Block quote ends without a blank line; unexpected unindent.
> Documentation/networking/dsa/sja1105.rst:112: WARNING: Definition list ends without a blank line; unexpected unindent.
> Documentation/networking/dsa/sja1105.rst:245: WARNING: Unexpected indentation.
> Documentation/networking/dsa/sja1105.rst:246: WARNING: Block quote ends without a blank line; unexpected unindent.
> Documentation/networking/dsa/sja1105.rst:253: WARNING: Unexpected indentation.
> Documentation/networking/dsa/sja1105.rst:254: WARNING: Block quote ends without a blank line; unexpected unindent.
> 
> Fixes: a20bc43bfb2e ("docs: net: dsa: sja1105: document the best_effort_vlan_filtering option")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Also applied, thank you.
