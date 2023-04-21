Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4905E6EAC36
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbjDUOBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbjDUOBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:01:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46021BC0;
        Fri, 21 Apr 2023 07:01:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FBDE64899;
        Fri, 21 Apr 2023 14:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA74C433D2;
        Fri, 21 Apr 2023 14:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682085669;
        bh=ZCLw9ZzS5vGJQ3YdbBTBrFoiSskRJvAISNADqjyW6m0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UtfY9FSLHm4biHR9vLZnnZzDhnOXVyyjbR3w2D9sQg9Omt2n336N7rC9Bzk/HBDlv
         GIn3jS837Sc8zbUyCNPkp1JRLWFCDJmDSuzYRlr3aTvM8lGb6PfyovB8bVTeiKBG7z
         ZfLNp9HPfvQL8YTNIRxJsAi9/O5k+8r1JIMHWxhAi+1/G+zALkWSM7cwVItv5xtrld
         Ev6yRGtRrl1NWytR6TO9NOqHIXykWf+R3CZ+CWRNPHhQ/1WQvCKG8ZS8hNoBDCF3Sy
         2VToRoETH6oAjQ3fO4l6A+JH5I+pE0Zgjib4SkEzzjFP/2+KC3CRxjA+XbtyXFq7/l
         kzdo+E8lYEPAA==
Date:   Fri, 21 Apr 2023 07:01:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tejun Heo <tj@kernel.org>
Cc:     jiangshanlai@gmail.com, linux-kernel@vger.kernel.org,
        kernel-team@meta.com, Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH 06/22] net: thunderx: Use alloc_ordered_workqueue() to
 create ordered workqueues
Message-ID: <20230421070108.638cce01@kernel.org>
In-Reply-To: <20230421025046.4008499-7-tj@kernel.org>
References: <20230421025046.4008499-1-tj@kernel.org>
        <20230421025046.4008499-7-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Apr 2023 16:50:30 -1000 Tejun Heo wrote:
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Sunil Goutham <sgoutham@marvell.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: netdev@vger.kernel.org

You take this via your tree directly to Linus T?
