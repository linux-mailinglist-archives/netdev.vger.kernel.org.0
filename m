Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C7E5F47EB
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 18:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiJDQwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 12:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiJDQwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 12:52:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FAB4D240;
        Tue,  4 Oct 2022 09:52:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB3B860F04;
        Tue,  4 Oct 2022 16:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909E7C433D6;
        Tue,  4 Oct 2022 16:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664902367;
        bh=H/kqk6/7AqbB9wsKQ6qgwDPXIp5+pPlqmcvwBFolxPY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QjLhDul457gNLr7pTKrNOboviSc3RuXbj9WtRFYiwh42u8exuS1MIMCHO99VWozkk
         6mQSzioh2pKBRanOFWZhyBoymECNBeaTMzaDDeA8H3Hhrel3+itL6zZzZrHG9BOYXG
         sGbKlMrSoYmGiQrKxXLwal8ompiamKGoUMKe/DOKvZ788Ttto+1L4GeMDAi4VYRR+l
         f+67oxTTk00XFt0CXEByIsOiqds1yDHUma+kaPjUBVECIFgaJmBnOB3MGLEmidS2tC
         tMYmx5aiH/tGBpBvfCFSS+B8wLG8FVNH6EsWJvScgECtFN+2Kzwq7gPD1EjnAtZcNt
         6aYSvVxVdrviA==
Date:   Tue, 4 Oct 2022 09:52:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v6 0/9] [RFT] net: dpaa: Convert to phylink
Message-ID: <20221004095245.1e9918bf@kernel.org>
In-Reply-To: <0b47fd86-f775-e6ad-4e5f-e40479f2d301@seco.com>
References: <20220930200933.4111249-1-sean.anderson@seco.com>
        <0b47fd86-f775-e6ad-4e5f-e40479f2d301@seco.com>
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

On Tue, 4 Oct 2022 11:28:19 -0400 Sean Anderson wrote:
> I noticed that this series was marked "RFC" in patchwork.

Because the cover letter has RTF in the subject, presumably.

> I consider this series ready to apply. I am requesting *testing*, in
> particular on 10gec/dtsec boards (P-series). Since no one seems to
> have tried that over the past 4 months that I've been working on this
> series, perhaps the best way for it to get tested is to apply it...

You know the situation the best as the author, you should make 
a clear call on the nature of the posting. It's either RFC/RFT 
or a ready-to-go-in posting.

Maybe in smaller subsystems you can post an RFC/RTF and then it 
gets applied after some time without a repost but we don't do that.
The normal processing time for a patch is 1-3 days while we like
to give people a week to test. So the patches would have to rot in 
the review queue for extra half a week. At our patch rate this is
unsustainable.
