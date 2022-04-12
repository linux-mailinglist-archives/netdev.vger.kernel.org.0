Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C394FEB64
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 01:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiDLXTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 19:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiDLXTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 19:19:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282947D001;
        Tue, 12 Apr 2022 15:07:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 457C661BF7;
        Tue, 12 Apr 2022 21:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF93C385A5;
        Tue, 12 Apr 2022 21:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649800696;
        bh=wsFEfXn4bF3iEHlWDSeLE2owd2SEktr/oPW2eXu2Q40=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U3VUZxyy1aU2QxOLqU3Qudmh4IDLA8gc6XngDK2MsFzkTI/gL5P3oBUzFOjF3YPto
         f8Tq9HtMAShW83LJjNtZXMzedwnlYszWbtK0wBqZOYOfNBFbsC85Y3NfFuXWbo2O1W
         HT7g+cZmI54TlvZnxdVn0D0ObYU52PHaJdfW24siAF6gHETuBofCqX7BAxFFTtBbGb
         66k/EsAVwQSBpXnq9VDx5435tg4tHcIDWEe40HzmHeKq/HO33i8JIu0CyjVenAkk/v
         /EUkKUJDJ3Dg6OF86WS8f8TJSwrRwMxujxd6Jjm9Pt1Qi85CsNZkO9NcATM1hC6bIY
         jiSxde4rd+OeQ==
Date:   Tue, 12 Apr 2022 14:58:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <pabeni@redhat.com>, <mkubecek@suse.cz>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <wangjie125@huawei.com>
Subject: Re: [PATCH net-next v2 0/3] net: ethool: add support to get/set tx
 push by ethtool -G/g
Message-ID: <20220412145814.6ddebc85@kernel.org>
In-Reply-To: <20220412020121.14140-1-huangguangbin2@huawei.com>
References: <20220412020121.14140-1-huangguangbin2@huawei.com>
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

On Tue, 12 Apr 2022 10:01:18 +0800 Guangbin Huang wrote:
> From: Jie Wang <wangjie125@huawei.com>
> 
> These three patches add tx push in ring params and adapt the set and get APIs
> of ring params.

Acked-by: Jakub Kicinski <kuba@kernel.org>
