Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A6D69D782
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 01:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbjBUA17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 19:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjBUA16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 19:27:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA72B46C;
        Mon, 20 Feb 2023 16:27:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4924160F4D;
        Tue, 21 Feb 2023 00:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BE9C433EF;
        Tue, 21 Feb 2023 00:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676939276;
        bh=gbHZ978urUh4BCOpTCJ4aoTOK5teLdTDqKFvw+p5j40=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c9n68R4btvPKcadtX4eVParZASntvAtn6qWVr1GC6PI21DaK0cLMWVARZ5krk0fcI
         0FaRx8iG7arFvk+5cQSg/bTGCrSxzKQ6WzUdDjQodRckngiObH1vu0nmjlMxMEvxE8
         xrdXeBpWsextOBW7kpKvM6b2s7ScrBtUa7TKs3iJ0x1G3Wjpd/14RkB1c5SszNUoMM
         QwQOix1banxDWfrT19sL0cwATcfosOaoQsgUzGrwnTKdlIQzP/e5ROQdTGW5U4veC2
         LokqsVNKAjXs2OngrK/vLjJLmmuSMoZ/FsqLiNf7HCTIqN0bjkRPWsT09p/9ATkFU1
         jcZCnZx3dxljw==
Date:   Mon, 20 Feb 2023 16:27:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bo Liu <liubo03@inspur.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ethtool: pse-pd: Fix double word in comments
Message-ID: <20230220162755.264c162c@kernel.org>
In-Reply-To: <20230217071609.2776-1-liubo03@inspur.com>
References: <20230217071609.2776-1-liubo03@inspur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Feb 2023 02:16:09 -0500 Bo Liu wrote:
> Remove the repeated word "for" in comments.
> 
> Signed-off-by: Bo Liu <liubo03@inspur.com>

Please resend with appropriate CC as instructed by Andrew.
