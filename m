Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1305E6037E5
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 04:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiJSCJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 22:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiJSCJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 22:09:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018A312ABC
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 19:09:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEC65B82035
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 02:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F8AC433C1;
        Wed, 19 Oct 2022 02:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666145383;
        bh=1psKlUDxPEHUVdpxCvbxIlQJmKMRj1BX0OOiyvnMkhM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KRRGSx9WiGO7+5Pc98EmkiIFIHCDecNgLG2uLeBxnxzyS6E0UH6ocbwaKRRvviMhL
         0EdVOAELl7OMGMXaXkM9L9+udpRfTw/i+iej1l93Snc/M94xmyMTco+CHPHoweh1k6
         LGpYJsolKiVvWb4rXuy0SFuJuHQJtyHgr37iIekcDm6iExdhtqr3phoqnnEk3FHi8L
         aY6tKRzAkZhiPOlv7pezKtav58h4FOjeKEIVz9jxDtrPVXpwu1UWiWzpdOseUSha6A
         8voo9+6L2SLFqB9Zw89f4qufV1uOn+1jqiVpqO71en1iDclwzGy2brrnyTLuyutura
         hWUre+OvkRMsg==
Date:   Tue, 18 Oct 2022 19:09:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <edward.cree@amd.com>
Cc:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>,
        <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <habetsm.xilinx@gmail.com>, <johannes@sipsolutions.net>,
        <marcelo.leitner@gmail.com>, <jiri@resnulli.us>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH v3 net-next 1/3] netlink: add support for formatted
 extack messages
Message-ID: <20221018190941.39142f63@kernel.org>
In-Reply-To: <f6cdbbf29de087257201abd06ddaff0593236106.1666102698.git.ecree.xilinx@gmail.com>
References: <cover.1666102698.git.ecree.xilinx@gmail.com>
        <f6cdbbf29de087257201abd06ddaff0593236106.1666102698.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Oct 2022 15:37:27 +0100 edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Include an 80-byte buffer in struct netlink_ext_ack that can be used
>  for scnprintf()ed messages.  This does mean that the resulting string
>  can't be enumerated, translated etc. in the way NL_SET_ERR_MSG() was
>  designed to allow.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
