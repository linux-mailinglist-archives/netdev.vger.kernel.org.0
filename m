Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705E96F39A8
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 23:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbjEAVWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 17:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjEAVV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 17:21:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE5A26B2;
        Mon,  1 May 2023 14:21:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FD5361E5A;
        Mon,  1 May 2023 21:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B734C433D2;
        Mon,  1 May 2023 21:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682976116;
        bh=9HsdymGV1sK2ojGUOTxHJNmwghwVzwHoZ25OpPZoLYw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VJzVRleaelAyydWmGAeZDnlPdh3KMhcyyoLxbPE0u2HjaRzGQwJtodekskK6/XZqc
         cYxTfegpXQ1nFU+8qVfxeLZd1tezpro3AAVJFVl68oUWP0t7INntVZBPDi5uzGTeON
         3M6Sk/5oUWyvIeh0KlgOE9dAjQdgXIwPqWnaYwRoT3tcgYCLT6ScPa6Y/gJFm5dWmI
         VB5XCypXII9rP/+Akwh+pA7Sml495odhv2UCLMIGkfdocd8jIDn89b2+4XNp7z04d7
         0WT4ZxgooXtd9cBQBiL2nhdiucSrz6z5K785nuGZQVWInNfhorKYhuHB9ueJukMhOY
         +ISbO8ROh8a8A==
Date:   Mon, 1 May 2023 14:21:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, netdev-driver-reviewers@vger.kernel.org
Subject: Re: [ANN] netdev development stats for 6.4
Message-ID: <20230501142155.6b84a188@kernel.org>
In-Reply-To: <667f3a20-aaa3-edd6-8769-7096649c5737@amd.com>
References: <20230428135717.0ba5dc81@kernel.org>
        <667f3a20-aaa3-edd6-8769-7096649c5737@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Apr 2023 15:08:27 -0700 Shannon Nelson wrote:
> > On the "bad" side the only constants are   
> 
> Can you give a little more description of what is being measured in this 
> section - is this reviews versus submissions?  And what are some ways 
> for a company to get out of the wrong list?

As Andrew explained the way to get off the "negative" list is 
to comment on other peoples patches :)

> > Histograms!
> > -----------
> > 
> > I was wondering about the distribution of "tenure" in the community.
> > Are we relying on "old timers" to review the code? Are the "old timers"
> > still coding? Do we have any new participants at all?  
> 
> Is this relying on the .mailmap for finding longevity?  I probably need 
> to add a couple more entries here.

I was matching on name or email. Hopefully name would be good enough 
to catch most cases.
