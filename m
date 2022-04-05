Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0BB34F230E
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 08:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiDEG0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 02:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiDEG0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 02:26:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1454C402
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 23:24:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15446B81B7F
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 06:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0FCC340F3;
        Tue,  5 Apr 2022 06:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649139878;
        bh=KV7x+l2Kx//MPbX1KTTLbaOsXVsx4/9BS1JZ2ViNL2I=;
        h=Date:From:To:Cc:Subject:From;
        b=cURfP67JlRhPANb+Pkn3FeprFfZU73/wXNfz388dKGQ02y+s0rWac4SdPWoYJBKFz
         XGpzjIYPzK9oifr51im4a63dGwUnwMLrakYOSwVqooCVIfYIp8Plw8H0b0KvARrw6i
         ZiPdw3JdqPitkYTav5em/6TnVhhgaVNlX05txQtNBAXTnYXT+Jw/w7HuHfsgc6vBS5
         8Rml43n20PFCtQhHFGHtQCJkULVaXEU7p/lVnUsIsMqG436toPjkpdUsBlDo43Vk2M
         L6JZnO6/nptqvR/cGJF2SdLfYx0AMGxnaeEWBLIuOsvyyS7wDQ16k4fO9mBwj/aD9V
         W9krtIVWxtGgg==
Date:   Mon, 4 Apr 2022 23:24:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>
Subject: net-next is OPEN
Message-ID: <20220404232437.0c2e0067@kernel.org>
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

I was supposed to send this one out, but this time I was the one
traveling.

net-next is open for patches!
