Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 295026A63A6
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 00:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjB1XHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 18:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjB1XHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 18:07:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3109173B;
        Tue, 28 Feb 2023 15:07:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52221B80ED5;
        Tue, 28 Feb 2023 23:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DEBFC433EF;
        Tue, 28 Feb 2023 23:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677625633;
        bh=54yKfDrAPw/6BH2MmunSbRxmmEf0zhqVZNQurNFOM9o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YVVp9SCHyr82zKH5Wg3y4c2V4vQJncgdT0bO7yiCrLP0+4mQl17a794PFOQ+eEvzG
         fzyFl5I0rxz9XwCEXwANTIyvqlmflXp8XCYqYDOaE5+L2jE/uoqOTsdj8I/JO80wei
         VNbxh3OpO+1KZpZbpnH3wzfAdq0/B1e67/q+K/CYtaruDPSjGdbrJzuVrxoQo1d2zk
         VCckT7lS+jx60KRWO9qiZy++RSyuZkOzxg82UY31+8Ehky6OoqmMgdRW+zhRaaKGF1
         tPvJUz4XtpzYOGOorAXz0K426yO4OXVCIKPkvguBJ4DHyFniCcrQrPEjQrHz7COZv7
         Mx4Xi1Y1zsLJg==
Date:   Tue, 28 Feb 2023 15:07:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2 2/2] iavf: fix non-tunneled IPv6 UDP packet type
 and hashing
Message-ID: <20230228150711.1291793e@kernel.org>
In-Reply-To: <f45c1cbf-3dc1-5075-feea-1613b059bf71@intel.com>
References: <20230228164613.1360409-1-aleksander.lobakin@intel.com>
        <20230228164613.1360409-3-aleksander.lobakin@intel.com>
        <f45c1cbf-3dc1-5075-feea-1613b059bf71@intel.com>
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

On Tue, 28 Feb 2023 17:52:56 +0100 Alexander Lobakin wrote:
> > [PATCH net v2 2/2] iavf: fix non-tunneled IPv6 UDP packet type and hashing
> > v2  
> 
> How this got here ._.
> Lemme know if I should resend (it's probably okay for Git, but may broke
> Patchwork, dunno).

Also patch 1 is not versioned and patch 2 is v2 :S

I think repost would be good, and please put on the To: line the
person/group who you expect to apply the patch - either netdev
maintainers or Tony.
