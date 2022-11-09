Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE186229FA
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 12:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiKILPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 06:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiKILPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 06:15:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FA12E9F0;
        Wed,  9 Nov 2022 03:14:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7418E619FA;
        Wed,  9 Nov 2022 11:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DD8C433B5;
        Wed,  9 Nov 2022 11:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667992441;
        bh=8fVsvvaNGj3y/jPyL1qz0mFE/iwEAcYJO3n8p9cc0Lk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=eVlgrmUzCNOXPPw2lGCQVe5SK14nZtTGpJ+4IMELINPp+QfbUukL6cic5VvHclJUK
         0SKoFAsh3nufqLsT8dqPOLgX9wilfILenbZoq11hm8M6rQ9LOzs+eJWIKCcwFU2aj+
         q33I4H3IULsuE7Tmfq5cYOOxuGoG0HhLZXXjdXIIWSKmbOAwuFe0HhnvFvMMpf98n3
         Wx/xPR9+nT+MZkpycWbYa46hE4AQOVHVQv5Ds/6jRSOvasjQLvQVNZv9/XzX0NK9dw
         YmclLtTGnxSBBGLsb2gzJ0iX39s1EO7lj+M/ixN6Qe4HMmD+NMv1uF2loAwDxglBLN
         ReMoVK3LCyJpQ==
Message-ID: <21d373bc-c69b-866a-b6c2-58966f274eea@kernel.org>
Date:   Wed, 9 Nov 2022 12:13:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 3/7] arm64: dts: fsd: add sysreg device node
Content-Language: en-US
To:     Vivek Yadav <vivek.2311@samsung.com>, rcsekar@samsung.com,
        wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pankaj.dubey@samsung.com, ravi.patel@samsung.com,
        alim.akhtar@samsung.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sriranjani P <sriranjani.p@samsung.com>
References: <20221021095833.62406-1-vivek.2311@samsung.com>
 <CGME20221021102628epcas5p1ecf91523d9db65b066bc4f2cb693ea45@epcas5p1.samsung.com>
 <20221021095833.62406-4-vivek.2311@samsung.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <20221021095833.62406-4-vivek.2311@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/10/2022 11:58, Vivek Yadav wrote:
> From: Sriranjani P <sriranjani.p@samsung.com>
> 
> Add SYSREG controller device node, which is available in PERIC and FSYS0
> block of FSD SoC.
> 
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> Signed-off-by: Pankaj Kumar Dubey <pankaj.dubey@samsung.com>
> Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>

You sent a v2 with correct CC list but I still would like to express
here my disappointment that you ignored kernel CC rules. You are pushing
SoC stuff bypassing SoC maintainers, so let's make it explicit for
Patchwork:

NAK.

Best regards,
Krzysztof

