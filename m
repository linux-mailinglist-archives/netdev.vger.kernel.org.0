Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C82A76CFB56
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 08:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbjC3GN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 02:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjC3GNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 02:13:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79DF2720;
        Wed, 29 Mar 2023 23:13:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C44F61EEA;
        Thu, 30 Mar 2023 06:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6AFC433D2;
        Thu, 30 Mar 2023 06:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680156833;
        bh=vL4aej4R/opKJsSnkgLmnAtiRe7vvW4uMcH3bXPgIHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mruZ8XTWbbNQBowGEATXDy8Ao+wu8u1wLE5XURkW6bBHhcyzOc264kyur9029DiFq
         +Wpr01quwEjlAJ+o+hOh1XWD9YxZLoygaUmSrnrdIcYiAKD0BTsHHfqJra0w3s6Xnp
         NGNWySh5f9zz+b6Ij2mGThiIdzMJNM7t5HMM7oQM=
Date:   Thu, 30 Mar 2023 08:13:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Rob Herring <robh@kernel.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Marc Zyngier <maz@kernel.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 0/5] Remove acpi.h implicit include of of.h
Message-ID: <ZCUon17pXpgBr0eQ@kroah.com>
References: <20230329-acpi-header-cleanup-v1-0-8dc5cd3c610e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329-acpi-header-cleanup-v1-0-8dc5cd3c610e@kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 04:20:41PM -0500, Rob Herring wrote:
> In the process of cleaning up DT includes, I found that some drivers 
> using DT functions could build without any explicit DT include. I traced 
> the include to be coming from acpi.h via irqdomain.h.
> 
> I was pleasantly surprised that there were not 100s or even 10s of 
> warnings when breaking the include chain. So here's the resulting 
> series.
> 
> I'd suggest Rafael take the whole series. Alternatively,the fixes can be 
> applied in 6.4 and then the last patch either after rc1 or the 
> following cycle.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>

Nice cleanup, all are:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

