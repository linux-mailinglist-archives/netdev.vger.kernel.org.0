Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E77647C4C
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 03:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiLICdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 21:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiLICd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 21:33:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54439275D9;
        Thu,  8 Dec 2022 18:33:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11D85B82607;
        Fri,  9 Dec 2022 02:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A734C433D2;
        Fri,  9 Dec 2022 02:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670553206;
        bh=hMnS+yISNCWUm5hsAqcKumTTe3dDNAMtpRlRMUFYoLc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TJIjT6wQzZWjZFqwX9/IpIrZbkfNEvL5C2i7LWM0y7PLaE0GRW4nBhWeRBzmH0AVi
         S0p5fj8O8Qp79Byu5pbcUBd2vlh1Z52DPfaBsmXjwBARBeKmswIuH9SwfNOsj8I3em
         to9+pRdOoJEmTRiE+DxfWHz0cU0+Aji+UtZ1FBP7zmaExAcUCoTAC6rhbnr/xyMRtH
         5eeZhU0TXJAmK8wdL0kTSLdRMH5MqcMnz9Wo1z5PtiB5y3PaRLpHw2OzpHBNy1o4Ug
         SzzOqia/yo6i6XCgH1lqwz5lQxhO5xIe2G5Pyr63fAj+BSwVw0EBI2uw/+qP/GPLLN
         gLgiKTH6DxNVQ==
Date:   Thu, 8 Dec 2022 18:33:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <ehakim@nvidia.com>
Cc:     <linux-kernel@vger.kernel.org>, <raeds@nvidia.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <sd@queasysnail.net>,
        <atenart@kernel.org>, <jiri@resnulli.us>
Subject: Re: [PATCH net-next v4 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Message-ID: <20221208183325.3abe9104@kernel.org>
In-Reply-To: <20221208183244.0365f63b@kernel.org>
References: <20221208115517.14951-1-ehakim@nvidia.com>
        <20221208183244.0365f63b@kernel.org>
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

On Thu, 8 Dec 2022 18:32:44 -0800 Jakub Kicinski wrote:
> I think you're just moving this code, but still.

And by "by still" I mean - it's still a bug, so it needs to be fixed
first.
