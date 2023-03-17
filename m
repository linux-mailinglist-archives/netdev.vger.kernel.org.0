Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013FC6BDDC7
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 01:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjCQAnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 20:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCQAnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 20:43:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA3892269
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 17:43:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5304C6215B
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 00:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4BFC4339B;
        Fri, 17 Mar 2023 00:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679013823;
        bh=YyCfKbxjgvWybnR8bIFObbOCoHv2+Y/xZgI58GUqC5A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qH+xAzcBy354ixBDRfQORl9eALx9vRbkTBGmRRxBNHyBmycLT5KQ/aqcboWIGKHLE
         YqG6Tlm2BOvUp8W8kfC98WOVVGimW2U5VM2Xd6yAbVhYA/nOT/xBtDaURvoI2CFUCI
         cdsp6AgsahCq3ntnx7bFOVBOmgilfYZeK47Mw12IwHhtzsgB/TvDc4ifxhgwxNSJ3z
         +MN9AtOgQAMZXjb/EigFNXXd+snWfaSZCoHN1EWkNw1V5dszx0TcJZa/oAzfY6L79E
         Xs2cryFI5cczCTvyCQrayDDUl+SmPd8SNxlGIErXMqA8ev8/vjvFYQ1ilKM9/dbLLb
         pGnpq+UC12iIA==
Date:   Thu, 16 Mar 2023 17:43:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     joshwash@google.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net] gve: Cache link_speed value from device
Message-ID: <20230316174342.3ca1d2bc@kernel.org>
In-Reply-To: <20230316174227.6f38803a@kernel.org>
References: <20230315174016.4193015-1-joshwash@google.com>
        <20230316174227.6f38803a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Mar 2023 17:42:27 -0700 Jakub Kicinski wrote:
> If it needs to go in as a fix / to stable we need a bit more info about
> the nature of the problem. What user-visible (or hypervisor-visible)
> impact will be?  What entity needs link info so often that it becomes
> a problem?
> 
> The code looks fine as an optimization, i.e. for net-next, but you say
> "PATCH net" and there's a Fixes tag...

Hm, actually it doesn't apply to either tree..
