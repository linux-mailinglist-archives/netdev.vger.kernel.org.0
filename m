Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A344E2F69
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 18:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349796AbiCURz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 13:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234522AbiCURz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 13:55:26 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EFB17E34
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 10:54:01 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 792465C01CE;
        Mon, 21 Mar 2022 13:53:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 21 Mar 2022 13:53:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=CCUp+hCJjR+enuEro
        OMnZ50dSZQItkrMUi2JalMjgps=; b=MWEJn/tsXPToX3rIWdQn2BZjz2GFBZ75Y
        WMC1N8bbcwhjejCWZPc/bppynUYY92inVwSAYs4Z6QD7AgO5VtS7CftJlSgk8p3a
        15BK02s3stVekwvXhqNRUYHqq9CNbhgQllVlfojf4LdnGE8LXtJtIkvjMzTKGiEb
        dRCalL0c5YAjMZU9R8SAM8tCWW7RmEjHC2EcmzNVXqdS76L8LOtCdcDyvRBdo2UT
        zGpeGnAHUbDF7s9GMqI5HKyE9Lh+si35xNjf/fucXb7ivD4lZRmINtInR58N/3B/
        xWcoFhs9KUrEfT/H+hH/E8KyEIsWcMicYg7AgjxDHq0Y9qcaRCI+Q==
X-ME-Sender: <xms:trs4YlgHQ3xyKlInfhh-q4vWEinPMUr2WxnuvBqwI8IHKRcYuzrRDQ>
    <xme:trs4YqBMOX7E_jLaBjSVkEFMrW8IEN5xt6vjJjUXOqPHLf33bde8YIr7Jmozl_fsE
    nwZisaFRSKhXQo>
X-ME-Received: <xmr:trs4YlG4HZRtrkRuUkB0HmxBxiqKWjFKNvdTFnX4Kvs221DPuf1sb2EO518h>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudegfedguddtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpedtffekkeefudffveegueejffejhf
    etgfeuuefgvedtieehudeuueekhfduheelteenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:trs4YqSszzFupthuJjiW40CGw7lolESbmSjSua0lGN5rFQ7hjp9whg>
    <xmx:trs4Yiye-2U_eCQuEg9UGYLCiv-2NFuV6XV8aVLUFXlkTMu4ber_kw>
    <xmx:trs4Yg59tPVJOp4U-McfmmlWpMxje0-4OJ-PRlfbHjIEIY0g13Kj_w>
    <xmx:trs4YsuGLGHPXP4RWoCdMBzZS03u_Wk7SZ_D-3TTPRXEufKNd5g3ag>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Mar 2022 13:53:57 -0400 (EDT)
Date:   Mon, 21 Mar 2022 19:53:55 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        schultz.hans@gmail.com, razor@blackwall.org, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 0/2] selftests: forwarding: Locked bridge port
 fixes
Message-ID: <Yji7s4qjjEy/SSXx@shredder>
References: <20220321175102.978020-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321175102.978020-1-idosch@nvidia.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 07:51:00PM +0200, Ido Schimmel wrote:
> Two fixes for the locked bridge port selftest.

Jakub, I'm aware that net-next is closed, but these are fixes for code
in net-next. If you prefer, I can resubmit later this week after you
merge master to net.
