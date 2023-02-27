Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6BAE6A4B4C
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 20:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjB0Tkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 14:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjB0Tkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 14:40:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D1C2823D;
        Mon, 27 Feb 2023 11:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4A016CE1162;
        Mon, 27 Feb 2023 19:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20A1C433EF;
        Mon, 27 Feb 2023 19:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677526797;
        bh=HyQUWpv7AKNNecMiGl2C+m8Ot0s9w9RIc1Oi1DOncEs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qZVusjyMCvbvpX/5oZ1K49cfH3OeJBVx/2vKkvRm5Q++tKcvcDYNyQn7VM3GstrE5
         XnQWM1eDfBTWUGp6KDhEdDNr0uCO+7+9/4YC2hQAt6zkqgpDEGR7tyRY3HTbw7N2xs
         RkYKiXsnGyA72R1w1nYGCgioOJxWd1DNM9Nng1WQ6jgUqnSNHr6NsDicauQTkOqNVT
         Sga8Aa5PBgVWIrjzBXs5Cue+k0cQKwhMdh/G9pbUm9i4ewrAI2awRa40t79t9R9lUD
         O/6rR1LpShpKjZc76X5+/A23eDBs4kmmAFXgeq377s5WLbG6qGnITe8ZpZg92ppH63
         8BtAxqeGmO32Q==
Date:   Mon, 27 Feb 2023 11:39:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Alcock <nick.alcock@oracle.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, mcgrof@kernel.org,
        linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hitomi Hasegawa <hasegawa-hitomi@fujitsu.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 27/27] lib: packing: remove MODULE_LICENSE in
 non-modules
Message-ID: <20230227113955.2c92f361@kernel.org>
In-Reply-To: <20230224152214.qb2ro3uvf7th5ctj@skbuf>
References: <20230224150811.80316-1-nick.alcock@oracle.com>
        <20230224150811.80316-28-nick.alcock@oracle.com>
        <20230224152214.qb2ro3uvf7th5ctj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Feb 2023 17:22:14 +0200 Vladimir Oltean wrote:
> Is this a bug fix? Does it need a Fixes: tag? How is it supposed to be
> merged? lib/packing.c is maintained by netdev, and I believe that netdev
> maintainers would prefer netdev patches to be submitted separately.

As Vladimir said, if you repost just patches 13 and 27 of this series
to netdev - we can take them in right away.
