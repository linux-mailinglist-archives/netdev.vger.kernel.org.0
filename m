Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1181565E4BA
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjAEEkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjAEEkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:40:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4A4186D1;
        Wed,  4 Jan 2023 20:40:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC108615B7;
        Thu,  5 Jan 2023 04:40:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA2AC433D2;
        Thu,  5 Jan 2023 04:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672893631;
        bh=f+iQzE6l6rSWfBBT6wIQapxJUVJqRHBG3uJIB4KfyU0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pb87pvKCUNL+cZZ7sMFA6K/kzchl9NF7vrV36O/HLnMFUe6divxy5OchTV89G8+MI
         3a+q0r0TluqEb/yugOUpqyoN+amHhDR5qfnacqlwErjpNc1vviH1twjU+vsmQrDyoy
         D228O/Np+6JmCjddf37OTZkr9bLlbv05Wua30DqzIsVy9d41h/zb6aeRuaFhco24+2
         XmCYo/FgJ3GQw3YLlrigFmHxpRXtfGrGoSYVQDUL/uIj7KplSoXiBsr4aO2f+EdJIu
         ptSVHCYrSMHys9wriedjLugjeox+uzR9tAvoSWUttUZnhBhWucKHAWvmx4yIolSftA
         ZU9aSTjlQ5Aaw==
Date:   Wed, 4 Jan 2023 20:40:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        richardcochran@gmail.com, pv-drivers@vmware.com,
        davem@davemloft.net, srivatsab@vmware.com,
        Vivek Thampi <vivek@vivekthampi.com>,
        Deep Shah <sdeep@vmware.com>,
        Alexey Makhalov <amakhalov@vmware.com>
Subject: Re: [PATCH] MAINTAINERS: Update maintainers for ptp_vmw driver
Message-ID: <20230104204029.6b79124e@kernel.org>
In-Reply-To: <20230103220941.118498-1-srivatsa@csail.mit.edu>
References: <20230103220941.118498-1-srivatsa@csail.mit.edu>
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

On Tue,  3 Jan 2023 14:09:41 -0800 Srivatsa S. Bhat wrote:
> From: "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>
> 
> Vivek has decided to transfer the maintainership of the VMware virtual
> PTP clock driver (ptp_vmw) to Srivatsa and Deep. Update the
> MAINTAINERS file to reflect this change, and also add Alexey as a
> reviewer for the driver.
> 
> Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> Acked-by: Vivek Thampi <vivek@vivekthampi.com>
> Acked-by: Deep Shah <sdeep@vmware.com>
> Acked-by: Alexey Makhalov <amakhalov@vmware.com>

Applied, thanks!
