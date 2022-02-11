Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC154B311C
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 00:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238182AbiBKXAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 18:00:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiBKXAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 18:00:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA41C63
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 15:00:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA505B82ACE
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 22:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F89DC340E9;
        Fri, 11 Feb 2022 22:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644620398;
        bh=hI1vlV9wmTRg48UFvCZXEoKZq1G5HYfIAc1QCHFkI+M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZS94Z/zg2+3kEeiiiLMbDyrzumTYJE0aJNuTiKOzBui2qNCfBVB9aFiE9g6wBEfbK
         XoSy4MEs8t46BhCCtmb6XgRSeFyRcBphgx/brIdc2FFrFYBCsBkt/sioQlWr7uQIuf
         2vb09pHJoHaWtTaeOldkSW3u9O7Uepr5Mhazd2p7J+ZL5aTN3QGKQERMPzRFGkf6TV
         sHoADJN8Xmc3XYE8pDteEtn+3cPcMr6nePUPYnZnOTRLSVdWglUWK4dzfpKGx8npL/
         Txaqetkb0/zYoaN5GQ5hSOOzspTwHEsReH8GsvRJM3on8WErruJ75V8cfqopNyK0fs
         k/XTkWe8JST4Q==
Date:   Fri, 11 Feb 2022 14:59:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>
Subject: Re: [PATCH net-next v2 0/5] Add support for locked bridge ports
 (for 802.1X)
Message-ID: <20220211145957.5680d99b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
References: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
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

On Wed,  9 Feb 2022 14:05:32 +0100 Hans Schultz wrote:
> The most common approach is to use the IEEE 802.1X protocol to take
> care of the authorization of allowed users to gain access by opening
> for the source address of the authorized host.

noob question - this is 802.1x without crypto? I'm trying to understand
the system you're describing.
