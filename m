Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F7F6465B5
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 01:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiLHAKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 19:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiLHAKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 19:10:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5748C8BD2B
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 16:10:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 93128CE21D9
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 00:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F45C433D6;
        Thu,  8 Dec 2022 00:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670458227;
        bh=YRt8VffnfZvZ+zwNKn3HAJX7u182NmcTPmS8wxQNNJY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gquaWP1xdFL9xPGMaDqkNlI84GC92g/ycmyH6On6g9X/Gqkk2S1+orDJ2h3lUR94y
         r5bB09bdWHaINwsQ+jqD0XbJpM6qQNv6m5Syw5RYLyeToMVwkLCv8xj/dr78/x77pa
         2h+OeXOy8peG90oW8PQ4LzOuVSOuREpGMXtbt8mIHd/nUTxaS79/RlCLOmMWRPpqiq
         8iE0xlrZXhPSyAH220H0MPN412m2stltf0icoxjcjcuB8Qlfdzbdl019NRgDlkt37Y
         bAE+UJvPcQhFGFuoJSWNa3jq8KruQ/6G5U8VWKkvrtn+OVZPKY5Jav04tE/UUEpm8T
         ayfC8GsoqsQhA==
Date:   Wed, 7 Dec 2022 16:10:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        muhammad.husaini.zulkifli@intel.com
Subject: Re: [PATCH net-next 0/8][pull request] Intel Wired LAN Driver
 Updates 2022-12-05 (igc)
Message-ID: <20221207161026.5767e552@kernel.org>
In-Reply-To: <20221205212414.3197525-1-anthony.l.nguyen@intel.com>
References: <20221205212414.3197525-1-anthony.l.nguyen@intel.com>
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

On Mon,  5 Dec 2022 13:24:06 -0800 Tony Nguyen wrote:
> This patch series improves the Time-Sensitive Networking(TSN) Qbv Scheduling
> features. I225 stepping had some hardware restrictions; I226 enables us to
> further enhance the driver code and offer more Qbv capabilities.

I didn't apply this yesterday because it was unclear if any of these
patches are fixes. Could you confirm they are not?
