Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750D565A29F
	for <lists+netdev@lfdr.de>; Sat, 31 Dec 2022 04:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiLaDwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 22:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiLaDwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 22:52:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC498BC25;
        Fri, 30 Dec 2022 19:52:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62C31B8162C;
        Sat, 31 Dec 2022 03:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFBDC433EF;
        Sat, 31 Dec 2022 03:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672458740;
        bh=Tj4N3caOmABWnzFQQNKb1QdIGP3DpXnPK+bgNni6jqg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DBdlTjVx4dFrA9t6sMHjq30Td2Agb3wDFSKebwjTdjZzU612mq0Ep6XCak7Y8t8yt
         cmBXx+aJaWmN/9mXUM03uhr1g+VaR1hAs63CoN4q4NUANMzd2ysjHl7fMTgP0oJUcJ
         IJ2wO7AkDLevVTjw4piR8hN5++ikV3G+gkxNemx8EH8ZTPLztQQA1vw+iG9eaF5MjF
         FmjowkBh1n3o/GShuLJjkhzoGy3JHtLOCWmtJdZSQe9rVLgLJrAV41SdfCXUbNsje7
         5GyccI6bOkmoSf6kPYyGyDeR2Ry2LfNw9p8kNGbKVLCNkZ59ktk32qp6oMZfWeKAZD
         cpZ1ZgCIZS5wA==
Date:   Fri, 30 Dec 2022 19:52:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] net: ipa: simplify IPA interrupt handling
Message-ID: <20221230195218.65eaaf92@kernel.org>
In-Reply-To: <20221230232230.2348757-1-elder@linaro.org>
References: <20221230232230.2348757-1-elder@linaro.org>
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

On Fri, 30 Dec 2022 17:22:24 -0600 Alex Elder wrote:
> [PATCH net-next 0/6] net: ipa: simplify IPA interrupt handling

We kept net-next closed for an extra week due to end-of-the-year
festivities, back in business next week, sorry.
