Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E754EDDCD
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 17:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238662AbiCaPs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 11:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239941AbiCaPsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 11:48:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6274A3A9;
        Thu, 31 Mar 2022 08:46:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 173FDB81B7F;
        Thu, 31 Mar 2022 15:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40105C340ED;
        Thu, 31 Mar 2022 15:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648741609;
        bh=hiwngJ/tEvf+cZOHAUZeS2nj7bIbpDJdxWUISWNpTvo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d0yDW+1fCXEfQzsqgq0cpK6YiiVHyxtDuZp07VQD+Ukdh/dw7K0S3YtyO9/FkoqSQ
         su39AWF9ntRt5wI5UKlJ+VIOljQZtFyacZAgVH/kDzBfkN9Aa7NoqNCM7lE1zJ8tap
         KI8aHdxEMzjIc2NnAfOVqki+q4y4geHApCqdiezeLbpB2H2xmtwQEYE+FJtFcHvbjU
         yDXUmtQ+viC+KbE66nc6o8dAC7DuGXVde5Taa4/NNrUW6ft45wSY2ILoSHMa2Lxa0X
         wPSQxVlhWGCbdRqcRM/gdLubfalVcF2nR/TT9nEeI5IMK40rPjpfXKSbXtrAtkAbDs
         qAzxfJ1BZeq/A==
Date:   Thu, 31 Mar 2022 08:46:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Qing Wang <wangqing@vivo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: xilinx: use of_property_read_bool()
 instead of of_get_property
Message-ID: <20220331084647.679aaaa5@kernel.org>
In-Reply-To: <1648728535-37436-1-git-send-email-wangqing@vivo.com>
References: <1648728535-37436-1-git-send-email-wangqing@vivo.com>
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

On Thu, 31 Mar 2022 05:08:55 -0700 Qing Wang wrote:
> From: Wang Qing <wangqing@vivo.com>
> 
> "little-endian" has no specific content, use more helper function
> of_property_read_bool() instead of of_get_property()
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>

# Form letter - net-next is closed

We have already sent the networking pull request for 5.18
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 5.18-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
