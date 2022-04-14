Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A415009F6
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 11:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241837AbiDNJgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 05:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236286AbiDNJgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 05:36:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B51670CFE;
        Thu, 14 Apr 2022 02:33:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3392461C63;
        Thu, 14 Apr 2022 09:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F4DC385A1;
        Thu, 14 Apr 2022 09:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649928819;
        bh=jTIUzjbdV7h8x5vIfOqDj2x53PgaPyUTnAJjaxgTh0E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pQK2F9GGc2jWxnX6+Ck/5OHrw5Uod/5IY4Jdi1yDm9RxH4z0KdD9Bqy0AqxkqJA37
         ebkZkTQisZo5Cf0GxOwQENoj71NWoCVDTN7JssQm5iYw5uClYsRgL94ME7S0+cMnJy
         d2B41755sQxabR67WwMdzWlqII1dauGQoSZgAr3MHOLB6xGhZobXkUzvh1hP2CkVeN
         +2Ahf0/xHB18gnQ5D292fBDG0MjAm292aBMv90qJ9EK/D8zzehlZf29vEPGgGeponp
         S0HDMljx/EnkjiUI+oeYS8D0EetFK9vbfxEKtmIU9Oj4JJSqpavJbTHPwZjUzRdpHz
         OU/XXZc5iXn5Q==
Date:   Thu, 14 Apr 2022 11:33:30 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arun Ajith S <aajith@arista.com>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, pabeni@redhat.com, corbet@lwn.net,
        prestwoj@gmail.com, gilligan@arista.com, noureddine@arista.com,
        gk@arista.com
Subject: Re: [PATCH net-next v4] net/ipv6: Introduce accept_unsolicited_na
 knob to implement router-side changes for RFC9131
Message-ID: <20220414113330.2bf46b14@kernel.org>
In-Reply-To: <CAOvjArTBoxSnX_ck_pW9Fq1cVXtT1sQ9zVHL207fdwj5v5iygQ@mail.gmail.com>
References: <20220414025609.578-1-aajith@arista.com>
        <0bf37720-870a-9dde-d825-92e12633ce38@gmail.com>
        <CAOvjArTBoxSnX_ck_pW9Fq1cVXtT1sQ9zVHL207fdwj5v5iygQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Apr 2022 14:29:01 +0530 Arun Ajith S wrote:
> Do I have to post a v5 with the fixup ?

Yup, please wait 24h between posting but yes, v5 will be needed.
