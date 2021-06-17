Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6773ABA2E
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 19:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhFQRFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 13:05:20 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36481 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229714AbhFQRFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 13:05:19 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id E65B65C00DA;
        Thu, 17 Jun 2021 13:03:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 17 Jun 2021 13:03:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=SG/wjR
        EXc8BaNicjIGxOchjI9PU6hMiLkZ1+/qLVuL0=; b=mdLcxJ4Xo/fbLgCPBZOQsv
        kBSZwpNWG/xeRm9ScfQFLYYahI/amT1IkJo3PWId1pWP8HRoYkoMMS2oKEe7rzFt
        yddV+ne6hi31cZxtrkw1G+hA2JI/R0BZW/BcXzVLctsbcK+jiI389empe+zniu4P
        qvPQ3tZ/2jjjwFUroqT4dHf5qL15+qEfuGB8sKpQ+TplsdvS3ah3TtSlzWeRQyGF
        D33sJSR5IePgpCEpfpDGlqpkFoXhOagmeRKa9UzyNgfUVQALQ23h9CGCUl21dQt1
        sGXXXqZO+UWgVk5yH0wBzjQdt2GJVLCtv5qrvvgoHxegSq8CDy0Q6UfRpjegCLZg
        ==
X-ME-Sender: <xms:ToDLYO_dTOJf6Bnq0Liu3jHYywDbgc6uWEkIdqfNLI6Vs5MQP3m1Dw>
    <xme:ToDLYOtUaYwVhSxdNf043nAUGwZsuCIKn0fAKp9dEPryseuVv_Rbrku6wVcGmQCY3
    7s0DCRr9WY9mvg>
X-ME-Received: <xmr:ToDLYECiKHWjHba3gLBm05KTzmRwltlqLiLkGtUI8MtdoHKoy7abKTOuL5QC021vvIYawUF9poVWOfgr8B_xjgvoeUaqvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefuddguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ToDLYGcB9rvRxQV86tWSu5hwSLla0ehfwSdqwBwwz7VmDlha6gdF1Q>
    <xmx:ToDLYDPnOOYqMKURz3BWbJ-NrIb48SnP6_wK2QJ3FPR2ffKGv_Z4gw>
    <xmx:ToDLYAnf3APEs2Ei50z7Z5l3p8TaWEikPaDdsTnrzhDfH-l8FejPkg>
    <xmx:ToDLYIp9ncbvUThPNcOjGUKNC9gVmZCarstdfSPBZx0J2JRmTib-jw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Jun 2021 13:03:10 -0400 (EDT)
Date:   Thu, 17 Jun 2021 20:03:07 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     jiri@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadym Kochan <vadym.kochan@plvision.eu>
Subject: Re: [PATCH net-next v2] drivers: net: netdevsim: fix devlink_trap
 selftests failing
Message-ID: <YMuAS++AH6DknYPA@shredder>
References: <20210617113632.21665-1-oleksandr.mazur@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617113632.21665-1-oleksandr.mazur@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 02:36:32PM +0300, Oleksandr Mazur wrote:
> devlink_trap tests for the netdevsim fail due to misspelled
> debugfs file name. Change this name, as well as name of callback
> function, to match the naming as in the devlink itself - 'trap_drop_counter'.
> 
> Test-results:
> selftests: drivers/net/netdevsim: devlink_trap.sh
> TEST: Initialization                                                [ OK ]
> TEST: Trap action                                                   [ OK ]
> TEST: Trap metadata                                                 [ OK ]
> TEST: Non-existing trap                                             [ OK ]
> TEST: Non-existing trap action                                      [ OK ]
> TEST: Trap statistics                                               [ OK ]
> TEST: Trap group action                                             [ OK ]
> TEST: Non-existing trap group                                       [ OK ]
> TEST: Trap group statistics                                         [ OK ]
> TEST: Trap policer                                                  [ OK ]
> TEST: Trap policer binding                                          [ OK ]
> TEST: Port delete                                                   [ OK ]
> TEST: Device delete                                                 [ OK ]
> 
> Fixes: a7b3527a43fe ("drivers: net: netdevsim: add devlink trap_drop_counter_get implementation")
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
