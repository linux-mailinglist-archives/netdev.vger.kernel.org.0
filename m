Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0484B64E1AD
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 20:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiLOTTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 14:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiLOTS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 14:18:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F3C50D7E
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 11:18:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93E6A61E19
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 19:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7255C433EF;
        Thu, 15 Dec 2022 19:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671131934;
        bh=/lqV/uF0BAaVEjxxiVPO/FWUjNs4jxahfmnxRORsnJM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mCtqIS7QvLQYxI8Et091UE/Tdbou6mSRoUwn1TGz2oU78Q3bwHA4mBag8gKqsR4hR
         ea4Vh45em6LDMV2AIU1/kE+kYZSmBCTO04+d3HbpOr5nsypuA8wJnoTBt/CrxhIJKk
         0P43b9b4Azpq6SLeWAmUfvMU5IYtQan/cub0lL1TsumRQLpa7BLTkYDrDrGRJSM32P
         teZUR9+U0WeoUUor7NSaucvzLk30eg/L0VJ6a95Yg9tpl5thgChxM59zqdMPcck5k/
         N2JEl6wk1S+jF9zBvU9d7AAlFJgq92Mp7U7QqPtS/wE5Xnt4Ea1GumPLsIBP4rKKVT
         dPaVIJR56Hj9A==
Date:   Thu, 15 Dec 2022 11:18:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <jiri@resnulli.us>,
        <leon@kernel.org>
Subject: Re: [RFC net-next 06/15] devlink: use an explicit structure for
 dump context
Message-ID: <20221215111852.3b2a60ab@kernel.org>
In-Reply-To: <0f79a6ea-13cd-98d7-1f88-c4e6375ade3a@intel.com>
References: <20221215020155.1619839-1-kuba@kernel.org>
        <20221215020155.1619839-7-kuba@kernel.org>
        <0f79a6ea-13cd-98d7-1f88-c4e6375ade3a@intel.com>
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

On Thu, 15 Dec 2022 10:50:11 -0800 Jacob Keller wrote:
> And to be clear, the context is not ABI since its not exported outside 
> the kernel. Thus, these changes don't break compatibility with user space.

Yes, indeed.
