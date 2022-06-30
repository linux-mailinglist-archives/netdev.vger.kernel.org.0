Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE90562217
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 20:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236686AbiF3Sdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 14:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbiF3Sdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 14:33:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EAC240B8
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 11:33:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17B02B82A19
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 18:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8363CC34115;
        Thu, 30 Jun 2022 18:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656614008;
        bh=HiU6WgUymxPS3q4a2owHpM7XhE4QydjHGnBkmwQMQgI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NAVQdLuNNzTF0qxDB9cL58kQSerVOosoNhcaMQwb1eQ6vhmjzOYKQ0g4cqq0noYqb
         5fZXe60gKN2MuZzDebtlRWqpqj1fiIZG7632JB+RdOiw6/7L9B3vkpVawikiMd70ul
         r8OX7npWRLGf4fGAEqTvTkmOcYeCpzfvsFirYuvfIrw19eihN80nGy9UvEPTbfJJr+
         n9S8UGl7CBS08+3Z8sptmvUg47iH3TguGPS/mimHnWBbLOrkfpka3ORWb6yyhim7/0
         aRuJ/rrDKzRe7CRlpxu4/mJPWp6gv2xZKaIvpZEYaqhpkQPjQ+93pmC2JS02WA8yXo
         DKBAWY2AuCjAA==
Date:   Thu, 30 Jun 2022 11:33:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Eric Dumazet <edumazet@google.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: sparx5: mdb add/del handle non-sparx5 devices
Message-ID: <20220630113327.44ba92f6@kernel.org>
In-Reply-To: <20220630122226.316812-1-casper.casan@gmail.com>
References: <20220630122226.316812-1-casper.casan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jun 2022 14:22:26 +0200 Casper Andersson wrote:
> Fixes: 3bacfccdcb2d

Please note the correct format includes the title, so:

Fixes: 3bacfccdcb2d ("net: sparx5: Add mdb handlers")

Also you should have kept the review tags you already received.

I'll fix when applying, thanks.
