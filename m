Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCEAC570D55
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 00:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbiGKWaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 18:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiGKWaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 18:30:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F79B52DF2;
        Mon, 11 Jul 2022 15:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2C42611DD;
        Mon, 11 Jul 2022 22:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED27C34115;
        Mon, 11 Jul 2022 22:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657578615;
        bh=AqoF7oG+3hQCjgK9xkimeWrxU38vvykK7tP9nJjq+T8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VKGyFD/4ZpTHphyZfLdANPUW/xRogXg8ULvHOznfKpgYYKTTDxuBySkAVlldO4AkP
         aafiz4lrMywWJDnzxKk5rs6k6EpbvZv6yTATtiFIY8Y2vdqHdtNE+elJ4XumQReWSi
         YJAtc/8AItxUyeQdUEn8V/fHage5J8p3+OICfneKA2w/pmmCiSyg5nJvhq2PoK3oAG
         EbnmtbEfZb6gHn2157dhMti/ogPromUMbZz2GyyEy2x+pSz7DWKQEi6Yta4CaEHI8b
         41BEKOLgsa4zPpOU46pSovrKb4IAJ1plhZ7FzymUZpQ2mQvjfjg0ZrEtYFgvlPBLMi
         theLIW6uUhDrA==
Date:   Mon, 11 Jul 2022 15:30:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     linux@armlinux.org.uk
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/4] dt-bindings: net: convert sff,sfp to
 dtschema
Message-ID: <20220711153005.315eaa2b@kernel.org>
In-Reply-To: <20220707091437.446458-1-ioana.ciornei@nxp.com>
References: <20220707091437.446458-1-ioana.ciornei@nxp.com>
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

On Thu,  7 Jul 2022 12:14:33 +0300 Ioana Ciornei wrote:
> This patch set converts the sff,sfp to dtschema.
> 
> The first patch does a somewhat mechanical conversion without changing
> anything else beside the format in which the dt binding is presented.
> 
> In the second patch we rename some dt nodes to be generic. The last two
> patches change the GPIO related properties so that they uses the -gpios
> preferred suffix. This way, all the DTBs are passing the validation
> against the sff,sfp.yaml binding.

Looks ready for applying to net-next, if anyone wants to take 
the dts changes please speak up now..
