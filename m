Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCAF1C9E59
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 00:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgEGWVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 18:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgEGWVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 18:21:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED49C05BD09
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 15:15:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C757711942A67;
        Thu,  7 May 2020 15:15:38 -0700 (PDT)
Date:   Thu, 07 May 2020 15:15:35 -0700 (PDT)
Message-Id: <20200507.151535.889895250031586890.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, mingkai.hu@nxp.com
Subject: Re: [PATCH v3 net-next 0/4] Cross-chip bridging for disjoint DSA
 trees
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CA+h21hpmr9Wey7SV9wLhE--VCSO=vobkqNW_kOB8c+DHE_Zs6g@mail.gmail.com>
References: <20200503221228.10928-1-olteanv@gmail.com>
        <CA+h21hpmr9Wey7SV9wLhE--VCSO=vobkqNW_kOB8c+DHE_Zs6g@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 15:15:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Thu, 7 May 2020 19:07:32 +0300

> What does it mean that this series is "deferred" in patchwork?

I need it to be reviewed, nobody reviewed it for days so I just toss
it in the deferred state.

I don't feel comfortable applying this without Andrew/Florian's
review, but if that doesn't happen I don't want this series clogging
up my backlog so I toss it because you can always repost after
some time.

