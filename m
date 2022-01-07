Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CA9487D9B
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 21:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiAGUVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 15:21:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43358 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiAGUVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 15:21:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB7CB61758
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 20:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C6FC36AE0;
        Fri,  7 Jan 2022 20:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641586914;
        bh=QRcHlbdddNVfcI+cwh/bNlDLPByLokX/QGfVl7LeBNA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OyO38jO+e8WJyzSiUzd7IHDa+CuKemdxAXqjfCCjXeBWSB1pBw2vJ8ZmdnOeGdKFC
         zgq0zkk4cgI3EZ3nbDd4UPGeU5VOeSJnU+7u0UceiMtI7mUiA66y6hvQcLPdQhQrtU
         VhmcXZUnQ0EtcjTUQxNtPqOMlW5eoMPB2xMSOGIOa8CtfcdcNB6o3R0DjY9S51HUNA
         Nvc8e6/v7Onh7aSzGnj11TS3FHG3efWEoZ2SCYQd/wNdf67zU7eav2lkThKkcRFlX4
         GrCmeBl5w72GrhtlYYomaV5fl4Q3IBd4jnGwIY6e66/394niw3azbLU5A+4VaJPgMy
         ja1UNwSawLeAA==
Date:   Fri, 7 Jan 2022 12:21:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Kiyanovski, Arthur" <akiyano@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Koler, Nethanel" <nkoler@amazon.com>
Subject: Re: [PATCH V1 net-next 10/10] net: ena: Extract recurring driver
 reset code into a function
Message-ID: <20220107122152.58a5bf71@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1a60d9f7b4784eae85cfbd278ada319c@EX13D22EUA004.ant.amazon.com>
References: <20220106192915.22616-1-akiyano@amazon.com>
        <20220106192915.22616-11-akiyano@amazon.com>
        <20220106190026.7b98d791@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1a60d9f7b4784eae85cfbd278ada319c@EX13D22EUA004.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Jan 2022 20:12:26 +0000 Kiyanovski, Arthur wrote:
> Sorry about that, v2 of this patchset will fix the "mixing different enum types" warning
> Will address the clang warning in the next patchset.

Sgtm, thanks!
