Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5997B5FE0A7
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 20:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbiJMSM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 14:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbiJMSMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 14:12:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DDB3152C6A;
        Thu, 13 Oct 2022 11:09:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 404B661A22;
        Thu, 13 Oct 2022 18:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B921C433B5;
        Thu, 13 Oct 2022 18:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665684079;
        bh=D89wMLS34tRkLylC6ga6yuysValRd7Y0/YSyFDeBwYA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a5FO9jRP3YC20dKMwIB/BtggGGHLaTXNAiDVk0sWxPKoWQJoWK5b3nR46i9inF/2r
         rZIgHSg+vzzYGjaNUopGf+dPxus+whFTPH+YceZngboiLJu1ChHsINLwx4oxpe9/9h
         Lo++8W69qn1QCgMxhMrR7jw6+wGeQLsphjeP8qi+Vl7Gph3LTVzXTC0/CQ5K4Xj4zD
         0J7bg/qGzXOi9GSQ32jZKzx5Z6A3cMimRTt/pf1e2SCOQPDaGTlAObP+6E8wihApEw
         xkFDLwcVMv6YDB7oGURAT14utjSB7LMfImC1knb9S4e63Qv4ogcBobh6DXbWiAblSQ
         Ix9GxLUGopzMA==
Date:   Thu, 13 Oct 2022 14:01:18 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 54/77] net: sfp: move Alcatel Lucent
 3FE46541AA fixup
Message-ID: <Y0hSbohDAqB3IGEk@sashalap>
References: <20221009220754.1214186-1-sashal@kernel.org>
 <20221009220754.1214186-54-sashal@kernel.org>
 <Y0PG28IJN9z1iqSo@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y0PG28IJN9z1iqSo@shell.armlinux.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 08:16:43AM +0100, Russell King (Oracle) wrote:
>On Sun, Oct 09, 2022 at 06:07:31PM -0400, Sasha Levin wrote:
>> From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
>>
>> [ Upstream commit 275416754e9a262c97a1ad6f806a4bc6e0464aa2 ]
>>
>> Add a new fixup mechanism to the SFP quirks, and use it for this
>> module.
>
>NAK.
>
>There is absolutely no point in stable picking up this commit. On its
>own, it doesn't do anything beneficial. It isn't a fix for anything.
>It isn't stable material.

I'll drop it, thanks.

-- 
Thanks,
Sasha
