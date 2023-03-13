Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08A06B84D3
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjCMWfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjCMWfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:35:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E02429162;
        Mon, 13 Mar 2023 15:35:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 588D5CE125B;
        Mon, 13 Mar 2023 22:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B29C433D2;
        Mon, 13 Mar 2023 22:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678746933;
        bh=/yHInFqeJPGy5sF++iHNAFdKA8mEkzBuADbjREfy4Pw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sjh43UMZdm0xbWKYGy6hOIBadc9oYAx72XYR1AcltIGVRY78TVS5LG6VY1BBbey1y
         V5H9+mSRwJf0sVqjSNuOByEGDNMQYBkDq1jQobxKlzIn5GSNNy2lh8q6V9c/NvL8Wu
         L7TDrXsalwt2QmhHsUwVqk3kYYzAZhd2FY/erLoD59KYB4ruiaP1bJ4zadJR+ST9HU
         TE0tTjSskz9XlNGQcY0Nz4i90lYScte+kK7oVbf4WkWeFE56WTYivQdrY3aNRR7jaa
         nG3Wn6qCJcB2tLIvEUNHZ78j3vBWzz4383923M5EbUb2p+OdiPSI1+oSdIz9cRNq1Q
         IFJcwuBoYoCOQ==
Date:   Mon, 13 Mar 2023 15:35:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>
Cc:     Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yangbo.lu@nxp.com>, <radhey.shyam.pandey@amd.com>,
        <anirudha.sarangi@amd.com>, <harini.katakam@amd.com>, <git@amd.com>
Subject: Re: [PATCH net-next V3] dt-bindings: net: ethernet-controller: Add
 ptp-hardware-clock
Message-ID: <20230313153532.2ed45ddf@kernel.org>
In-Reply-To: <20230308054408.1353992-2-sarath.babu.naidu.gaddam@amd.com>
References: <20230308054408.1353992-1-sarath.babu.naidu.gaddam@amd.com>
        <20230308054408.1353992-2-sarath.babu.naidu.gaddam@amd.com>
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

On Wed, 8 Mar 2023 11:14:08 +0530 Sarath Babu Naidu Gaddam wrote:
> There is currently no standard property to pass PTP device index
> information to ethernet driver when they are independent.
> 
> ptp-hardware-clock property will contain phandle to PTP clock node.
> 
> Its a generic (optional) property name to link to PTP phandle to
> Ethernet node. Any future or current ethernet drivers that need
> a reference to the PHC used on their system can simply use this
> generic property name instead of using custom property
> implementation in their device tree nodes."
> 
> Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
> Acked-by: Richard Cochran <richardcochran@gmail.com>

Rob, Krzysztof, any thoughts on this one?
Looks like the v2 discussion was a bit inconclusive.
