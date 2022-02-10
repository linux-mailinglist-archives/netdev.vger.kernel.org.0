Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E9B4B0332
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbiBJCRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 21:17:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiBJCRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 21:17:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032B2261A;
        Wed,  9 Feb 2022 18:17:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B08C4B823DD;
        Thu, 10 Feb 2022 02:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086CEC340E7;
        Thu, 10 Feb 2022 02:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644459432;
        bh=HHToa6/fTkupOGCWJ7mpmWaM+9FIcDhOYrxvlOtc1TI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ojhF1+Ss+KFb1GImsC1OiPfPJp4x3pWFHZ9TjBl2r139Zv/ytatX0KDIvbcwIKSti
         Abg5LffX5zw09hu0zo+68oloYLPhe+GPTnxBYDo323r5Kw5dASH2BM5uL/4iW/QjHZ
         V8d6GvhT/hK6NEBZ/X4p6S2kXMPFcQ2RMxUZGK7actOnl7O/mbrKY9uMCW8WnxRzUs
         /yb7w8E6qV6/np2u565hUvNJmtxddYJZFJA6RwkrwQ0KPzYBQjspXY5GvQ0I6FjUM7
         3UT5yHz2t0DRG0KYB0f0EhAROjpVm13+SvzVTVYE71NI9RA2UCL3ndQsAhZ0G/d+1M
         lkXsneC+kVAHw==
Date:   Wed, 9 Feb 2022 18:17:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>,
        Willem Bruijn <willemb@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next 02/11] net: ping6: support packet timestamping
Message-ID: <20220209181710.50a45069@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANP3RGfqsFNOvtGk6e_3sia0esEknNr2gT-PmcbhRV+S2MEaUA@mail.gmail.com>
References: <20220210003649.3120861-1-kuba@kernel.org>
        <20220210003649.3120861-3-kuba@kernel.org>
        <CANP3RGfqsFNOvtGk6e_3sia0esEknNr2gT-PmcbhRV+S2MEaUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Feb 2022 16:44:18 -0800 Maciej =C5=BBenczykowski wrote:
> probably deserves a fixes tag?

I went with a "never worked + unlikely a generic app (which depends
on TS) will use ICMP6 sockets" classification. Let's see if we get=20
another vote to make this a fix.

> otherwise looks fine to me

Thanks!
