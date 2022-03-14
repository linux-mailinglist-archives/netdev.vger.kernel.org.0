Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615B54D8C15
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 20:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241562AbiCNTLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 15:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238927AbiCNTLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 15:11:49 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6C531DD5
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 12:10:39 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 8E9FB3201F7B;
        Mon, 14 Mar 2022 15:10:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 14 Mar 2022 15:10:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Cd9upb1DbLZxQlyaD
        23feLoTc3LYvNE+vPS9//nFmoI=; b=eIMNhe3BXvOCvlP5Pmki6hdpFhkIj2Fye
        8lZ+u8YxXDjevmUWnmyJvuGYCOgiP2T8JDV9CGuWSXWrdTLXdX3XLntcQS/tmJPy
        4Sk/8sTwh2/QQQgrRjUAuCCY2If5nTkscMYmoMOeASz3F8wZ34hTlCs/t90f/zYv
        DBMhg7YKpFJh981+jybjvwx6ELDS/Ixgl2tJfb8t91VgZzl3Gyz6qf3LqJuhpEjc
        6eHn05X2+JmaxpDb+qxAjLtf4iOFG2z0XO97zJKTKHvlI6Hr5FDvzRHcBZvyVK25
        Evg7pPcBV4puKB5c3xQI+/aAnxRmdNif1FhLoDyp3hAvQ8SimFd3g==
X-ME-Sender: <xms:K5MvYnrg-vDn-5YPSnWb1fQJbfsjA94twsyR03KskQXCQFlFCzCjRw>
    <xme:K5MvYhpM7QQ-EHzLkbbYfbyJcArxUB-LLoccEdbmew_PLLG50v7p9h-JbjjUG-ovz
    lUxVDPf8GiRWtY>
X-ME-Received: <xmr:K5MvYkMbwfbpDB1ZJDk-R88ldSSsulxIf3G2BP8w5EzJjkPe3G5eI6QugZK_u1dzeI7WwpgLC_o3oN5R6rbHHLmxRM4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddvkedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:K5MvYq45Xg-8inhVaLDCsDEffpEPUeuSJYwwMUbSZpMMWNB4IfUvGw>
    <xmx:K5MvYm6nnH86kTJ0NAlkP5YK1YoAjPAGKBxEqQt-HWzxk-VpoDRTTA>
    <xmx:K5MvYii6blJasXcwYvWM5BpagkV9gpY_v1R3ajQ4dLh0vH9cUXN74g>
    <xmx:LJMvYoTbjSfaR6i95BXO0-2fGPboxVrmzYqgtQisLF_KdX6DaCC37Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Mar 2022 15:10:34 -0400 (EDT)
Date:   Mon, 14 Mar 2022 21:10:31 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        netdev@vger.kernel.org, leonro@nvidia.com, jiri@resnulli.us,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [RFT net-next 0/6] devlink: expose instance locking and simplify
 port splitting
Message-ID: <Yi+TJ5X27Esi4NWz@shredder>
References: <20220310001632.470337-1-kuba@kernel.org>
 <Yim9aIeF8oHG59tG@shredder>
 <Yipp3sQewk9y0RVP@shredder>
 <20220314114645.5708bf90@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314114645.5708bf90@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 11:46:45AM -0700, Jakub Kicinski wrote:
> On Thu, 10 Mar 2022 23:13:02 +0200 Ido Schimmel wrote:
> > Went over the patches and they look good to me. Thanks again. Will run a
> > full regression with them on Sunday.
> 
> Hi Ido, no news?

Sorry, forgot to update you. All the tests passed :)

> 
> Do you have a preference for these patches getting merged for 5.18 
> or waiting after the merge window? IOW I'm wondering if it's more
> beneficial for potential backports / out-of-tree builds to have the
> ability to lock the devlink instance in 5.18 already or to do as much
> of the conversions as possible in a single release (that'd mean waiting
> for 5.19)?
> 
> If there's no clear preference I'll go for 5.18.

5.18 is fine by me.

Thanks!
