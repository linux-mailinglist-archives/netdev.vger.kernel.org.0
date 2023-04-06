Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28016D9BF7
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 17:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239316AbjDFPQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 11:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238411AbjDFPQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 11:16:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671691BC1;
        Thu,  6 Apr 2023 08:16:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D89496464F;
        Thu,  6 Apr 2023 15:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFFAC433EF;
        Thu,  6 Apr 2023 15:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680794178;
        bh=/zw9Cq0L7EZS1gWujjycmwtNiHVPQqukc5NHVJ+u1HY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cGUPTKFAUsyOlfeM6iYKlr5b3RyvSh+w7w1WTP+1bLPxpKTnX08Ij24+FI8nt9n/P
         0lTZPscQBk1Hsw1xrv61zFxGvwOMfhU4VhwxHfeOhiAdK5sSAU66kKq4tkk4ICldPU
         I7Hj8TIKVZhif1CjlV8dVL+I89cxo14obMw5VAlHYen+00StiPf8eY5J1AZrP8oNxC
         TbaaMDL9BZZOUMlq9t0uge7Xk9yWUzJU3wBI1x6Py/z+2XKC5r7sF65FW/VWyeGyq2
         EjoP+ok7XhCwADAHRFDW8vCxugvDxCGF9y8fMf+BPzsUJL3kl6w4vInEzN7cvjcTTd
         fqOOecEtPTqWw==
Date:   Thu, 6 Apr 2023 08:16:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Networking for 6.3-rc6
Message-ID: <20230406081616.264f97d3@kernel.org>
In-Reply-To: <20230406115058.896104-1-pabeni@redhat.com>
References: <20230406115058.896104-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Apr 2023 13:50:58 +0200 Paolo Abeni wrote:
>       net: stmmac: check if MAC needs to attach to a PHY

There is a follow up to this one on the list which I have a gut feeling
we should include before shipping. I can't get hold of Paolo to confirm
that I'm wrong so I'll go with my gut. Let me send a v2 (or a small
follow up if you already pulled).
