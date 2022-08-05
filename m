Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD61B58B0BF
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 22:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241528AbiHEUMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 16:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiHEUMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 16:12:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E62A1A3AC;
        Fri,  5 Aug 2022 13:12:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEDE561A66;
        Fri,  5 Aug 2022 20:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4D5C433C1;
        Fri,  5 Aug 2022 20:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659730319;
        bh=pCPMu2nCELLS8A9lqVXZI1SYp1IvxBKceIs3wLIF7ck=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bmM8ATUPtEiKkoqCFsfJwPmNyQ3cDG9cFQMZWQG34aGijwRi2DvZ7QIHWtQTHEoj9
         AeQDgIR5KWYmUEgqVHXYunIrqU3WUaoSSfpAF/qAnKh9+bXfAMOZlrPxYKKoA1IUzO
         6YkBLFr1SQwKD3dkuf2aruxY8Cc03G8/kvJHvJcY9ui42BL13AjVBciob4jZ8DAzRi
         S1corMTSdHku0dtxrp+POFoTktImx9KY07WUKxmfFadTI361SnBjfCM6GMR9gdKW5T
         1B9n824QE+EgEjgNtFMzoHA+cSug+O53uKeoFnQSxUYu8b45eBsxOYCWN60WlMcKyQ
         dQSL8BIed8gPA==
Date:   Fri, 5 Aug 2022 13:11:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     rafael@kernel.org, rui.zhang@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev@vger.kernel.org (open list:CXGB4 ETHERNET DRIVER (CXGB4))
Subject: Re: [PATCH v1 24/26] thermal/drivers/cxgb4: Use generic
 thermal_zone_get_trip() function
Message-ID: <20220805131157.08f6a50f@kernel.org>
In-Reply-To: <20220805145729.2491611-25-daniel.lezcano@linaro.org>
References: <20220805145729.2491611-1-daniel.lezcano@linaro.org>
        <20220805145729.2491611-25-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  5 Aug 2022 16:57:27 +0200 Daniel Lezcano wrote:
> Subject: [PATCH v1 24/26] thermal/drivers/cxgb4: Use generic thermal_zone_get_trip() function

s@thermal/drivers/@net/ethernet/@

Are you targeting 6.0 with these or should we pick it up for 6.1 via
netdev? I didn't see any notes on merging in the cover letter.
