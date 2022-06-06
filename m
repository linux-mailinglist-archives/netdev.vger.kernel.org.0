Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F090153E7BE
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiFFQoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 12:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiFFQoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 12:44:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626DA158978
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 09:44:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A923B81A96
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 16:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E295C34115;
        Mon,  6 Jun 2022 16:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654533858;
        bh=Nh+HZJv+WnEr10S01xiMPagJz+zJLKD1hxByfrG1vic=;
        h=Date:From:To:Cc:Subject:From;
        b=peaShHFphwxE6S9W8gZILrDAIr+YA5pk4As3fGg8q8jXu8M7dT8lAGajizEeVDe5l
         QB19ET91NUckhgNDsd1Nqv+ttUhYeD2snz4Qt4GcX/uy78nclN9ShvA4OFv7pKp4HB
         aQd1i6oWG6bzIyDzCT1enCoXMmNg6Vx861xzboQ3xeDLwzlsimZk9jDiUAquSercUM
         hXln7lgbK3tFzKHqLtPyocL/1HmwBuetrMQSLgrEMHfx487Po2yk4lkyel3OpeAXn2
         iIeJ6nbZrR+kZH+++1sO9viqj5phkOEcpm5ilUEZd2fEfsogOQQVBSeKpRw321b4tv
         5r7W+OKVoBFPw==
Date:   Mon, 6 Jun 2022 09:44:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: net-next is OPEN
Message-ID: <20220606094414.0fa7183c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

net-next is now open and accepting patches.

As a side note I'd like to mention that there are no further
organizational changes planned, at the moment. As you may have
noticed we had grown the number of people who can apply patches
to 4 (2 in each time zone). This is purely for load sharing and
to allow each one of us to go on a vacation without impacting 
the patch flow.
