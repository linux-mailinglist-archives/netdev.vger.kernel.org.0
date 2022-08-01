Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159C1586F7A
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 19:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbiHARWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 13:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbiHARWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 13:22:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984AF118
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 10:22:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E02CB815A0
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 17:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80FFC433D6;
        Mon,  1 Aug 2022 17:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659374538;
        bh=yD046OvlOvYT1e0iPfvnaQXfvc1lPDjlOMe/TdgeVHU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CdTroRsX/j4FlPJo24qHh8JfPDIaqpOadG0g4UtkKZO4bqReTwF+h47/IlbqaE29j
         4ntBBaFSjj2jzPJ5JgVuVaTiM8rIceknCnbMwKMYdPNopzm0Dt1X/tDZIhDwBwbdQ0
         nCs5DhPn/X0vDxKN5rvH9MklGI7SMPazWSvXAZrZI+j0bgY/4VvkzjW9izKVMBO8kx
         sB75pxOyvTjMKsgpQpC2bunISzT6wCcJMKS3hxe0VH1N7DSOWOnzJU3bcBxdulO3Km
         EgXLDd+p74jAiWxKk/tRH0+lJtu8EqLNokuT3TCLbqgEt1NpjYRsZGBFxeut3pXqna
         Ghih2Y1e540wA==
Date:   Mon, 1 Aug 2022 10:22:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <richardcochran@gmail.com>,
        <jacob.e.keller@intel.com>
Subject: Re: [PATCH net-next 0/7][pull request] 1GbE Intel Wired LAN Driver
 Updates 2022-07-28
Message-ID: <20220801102216.340ffae8@kernel.org>
In-Reply-To: <46909de8-3555-5bc6-2e2b-e139941f640f@intel.com>
References: <20220728181836.3387862-1-anthony.l.nguyen@intel.com>
        <46909de8-3555-5bc6-2e2b-e139941f640f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Aug 2022 09:56:27 -0700 Tony Nguyen wrote:
> I'm seeing this as "Accepted" on Patchworks [1], but I haven't seen a 
> patchwork bot notification or am I seeing it on the tree. I think it may 
> have accidentally been marked so just wanted to get it back on the radar.

Ack, back to the queue it goes, sorry about that.
