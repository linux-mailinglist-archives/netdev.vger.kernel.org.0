Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7605D64DF96
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 18:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiLORZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 12:25:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiLORZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 12:25:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2B828E15
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 09:25:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11F7C61E6A
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 17:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C649C433EF;
        Thu, 15 Dec 2022 17:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671125132;
        bh=+cex+Ay8Pv0V/ovQ2SGMzmkmPUSZh6H4EcMHKYSIOIY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HXV9gu2J/zDSvq5Fili2LSvcutv43dsxFWkqv3B21x+xt2AjytY1Zho9sSsMnZPy5
         aJI/6oHhKc2faQdnne1uLj3T5cwT7SRyGvdOM5koa7jYGwUvutnWpqMovfClVlh/1X
         EjnNP1g3dpHf6eNyVwtZXDn0K3bN7acyRNfGk29Ft691VHO62GCPwd/7T84hsuY2TT
         TOuI69jyHsJBToGjESShUxobJVUTeKEMZRkT/LkTaXb1dg10GCMaiV7BRz2sYFDXqq
         SQalIBVQo0SMdj6k4hzWxlTOITH2+8wtHiY4tA/wOORbIkbMYgvVliXFgUouFWwcvg
         8wJloX6JmMCcQ==
Date:   Thu, 15 Dec 2022 09:25:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [ANN]  net-next remains closed until January
Message-ID: <20221215092531.133ce653@kernel.org>
In-Reply-To: <20221214091341.6a6a381b@kernel.org>
References: <20221214091341.6a6a381b@kernel.org>
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

On Wed, 14 Dec 2022 09:13:41 -0800 Jakub Kicinski wrote:
> The merge window is coinciding with the end-of-year festivities 
> for many. Some of the experts and reviewers we depend on day-to-day 
> to get patches reviewed may be away all the way until New Year.
> 
> It seems to us that keeping net-next closed until January 1st/2nd
> may be a good idea, so that people can take time off and relax.
> 
> Thoughts, concerns?
> 
> Here's a poll to express your opinion without typing:
> 
> https://poll-maker.com/poll4630178x899a594D-145

Looks like the poll is overwhelmingly in favor:
 - 15 for
 -  3 don't care
 -  1 against

So it's official, net-next will reopen on Jan 2nd.

Happy holidays!
