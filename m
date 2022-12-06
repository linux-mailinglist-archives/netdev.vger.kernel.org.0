Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6AA644D1A
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 21:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiLFUOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 15:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiLFUNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 15:13:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC7B2A940
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 12:12:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BC35618A8
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 20:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE6DC433C1;
        Tue,  6 Dec 2022 20:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670357547;
        bh=5/ieL6eAHo3YGxr12oDJpw7jyVnHOAFW1tmu5LdQBc0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PzaEsFEg0Y82wlvdjcs3DDecNBm/Wj9KK2lclefjgEAVBs5dJZCSpXKu/At+gN7i0
         7SyOTBoRKQJ8+CHsY1KBsBCygR18bddyExDC6TnnjindXeJCQe+SkNbN6pflIhtOhL
         MpJ2hE3MPrAQ5jYyqhnTd7gyQ7WSg6GRQLthv/EEqnvCBpRLQMZMFN6XSHlQalxpr5
         QiC7JHLcDuJsczukaYNbPyHAaXF2PIzbc5fhV6V1TMbClZtpbqr5zRCM8mJ87b+sXB
         /OeGnnNSt9dMzWtUBqwXvEKmA8B2B2dTh/jlOLFKc8WULTU9YopGjJq+3FxzxTe6VL
         yT2nPiDeXuPvg==
Date:   Tue, 6 Dec 2022 12:12:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        ioana.ciornei@nxp.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tchornyi@marvell.com, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, simon.horman@corigine.com,
        shannon.nelson@amd.com, brett.creeley@amd.com
Subject: Re: [patch net-next 0/8] devlink: make sure devlink port
 registers/unregisters only for registered instance
Message-ID: <20221206121226.21de7ca3@kernel.org>
In-Reply-To: <Y47y0FZQxPDK3B5X@nanopsycho>
References: <20221205152257.454610-1-jiri@resnulli.us>
        <20221205170826.17c78e90@kernel.org>
        <Y47y0FZQxPDK3B5X@nanopsycho>
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

On Tue, 6 Dec 2022 08:44:16 +0100 Jiri Pirko wrote:
>> I didn't reply because I don't have much to add beyond what 
>> I've already said too many times. I prefer to move to my
>> initial full refcounting / full locking design. I haven't posted 
>> any patches because I figured it's too low priority and too risky
>> to be doing right before the merge window.  
> 
> I'm missing how what you describe is relevant to this patchset and to
> the issue it is trying to solve :/ 
> 
>> I agree that reordering is a good idea but not as a fix, and hopefully  
> 
> I don't see other way to fix the netdev/devlink events ordering problem
> I described above. Do you?

Just hold off with your patches until I post mine. Which as I said will
be during/after the merge window. I've been explaining this for a year now.
