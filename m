Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC2F66E49B
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 18:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbjAQRPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 12:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235095AbjAQROw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 12:14:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBFC46724;
        Tue, 17 Jan 2023 09:13:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49D3661265;
        Tue, 17 Jan 2023 17:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9EFC433F0;
        Tue, 17 Jan 2023 17:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673975623;
        bh=TIZ+O5b7frteXaaqfxXllbxfr11ug7kqgv9wyeyD25I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UWGRtW76pZg2PyJ9Q52S2aSX5GeELyndoHjNwLLcWBeRLF0gdj61wlK/VKCR2jDWv
         tZmv+ZlEMy9AGfcHf0uKdbgHFWWzIj4vsJksiHt4T8DsP8BVQiEBWfvLjceKGvzP79
         KJpRWB1JlCrKe3fMP8i28vvgxqKqLzeECNoTKiYOjIKAnz/IRCg+JHJZ3H/JQ2bWr/
         jCkVrTNh/h6j6h1799O6XbSm9mPZi4EcfFAeTKTKWz/Tw5F8IkPwqmkhB6rQDz+f53
         Q7PpDac4EFfXMyOck6N7FUzr3Ba2/r27DTBtHIhYUEL5rLU01DB5S/1tKAA5WuqkMM
         WyDFUuXaZZAGg==
Date:   Tue, 17 Jan 2023 09:13:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Min Li <min.li.xe@renesas.com>
Cc:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/2] ptp: idt82p33: Add PTP_CLK_REQ_EXTTS support
Message-ID: <20230117091342.6900a275@kernel.org>
In-Reply-To: <OS3PR01MB659319B48D522B615D21E35FBAC19@OS3PR01MB6593.jpnprd01.prod.outlook.com>
References: <20221123195207.10260-1-min.li.xe@renesas.com>
        <OS3PR01MB659319B48D522B615D21E35FBAC19@OS3PR01MB6593.jpnprd01.prod.outlook.com>
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

On Mon, 16 Jan 2023 16:21:55 +0000 Min Li wrote:
> Any progress for this review? Thanks

It was applied:

https://lore.kernel.org/all/166937341938.11224.8741791396889501029.git-patchwork-notify@kernel.org/
