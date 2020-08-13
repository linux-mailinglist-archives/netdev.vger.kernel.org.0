Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58919243792
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 11:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgHMJYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 05:24:07 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:40099 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726106AbgHMJYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 05:24:07 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4A2855803D6;
        Thu, 13 Aug 2020 05:24:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 13 Aug 2020 05:24:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=W630GV
        7ui2/hkTmbjxGwCT8hexFFpv2lFKcSnPeWDoY=; b=swKWN87NjnPLCS4FU5Ntjq
        26N4klYVNc1qt8pzFtANrik6ByWjMqyg0lat5aNcZPvSP8CFj9Bb4f2XXgZ6Xjti
        06BPRlaqo0WmyfIyInMxMo+f8/QFwaEEvETeVToA8zGhp7iS6VBhHGZK/T7D/Q4N
        s9HWt0F60eFHjpSKKtqwiX6HwaHmchRisHO6f7XmbbFKjhvb2w75i4ynuTV6SIQa
        SYEaueIjY1OAZc8HoaGzIK6E+//t/1u34GuFg8WFUP56stuuP+36tpPkmtXl64YD
        PCy882iOz0l+RnKrWaXQuP8S1QbocVQ+1yEBdH6wACUrLocu7Jk2WX0X94TUBjjQ
        ==
X-ME-Sender: <xms:tQY1X5cUoZj5PElUOqEudDENcBuj3BpzkJa_nJAT9E1DiThPMSE0-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrleeggdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeejledrudekvddrieefrdegvdenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:tQY1X3OKP-pmAG-n59fvrWj-r6t7B8kJxmLxfUu9IKiC5-7_ZXKcaw>
    <xmx:tQY1Xyid1Sbo2jlMyJDTis25OuONBxtNluMEHUF2-7ZS8QcSRXEEKQ>
    <xmx:tQY1Xy9G6Uks1WBzaUAiep48ViYSJxSRMqibnD6ThBUpGXUNGfgEMw>
    <xmx:tgY1X5jN6KIVI2LepDOQX1L0tmMxsLy3iNWlnw_tABzWlRvNZQdCGQ>
Received: from localhost (bzq-79-182-63-42.red.bezeqint.net [79.182.63.42])
        by mail.messagingengine.com (Postfix) with ESMTPA id 58DF830600A3;
        Thu, 13 Aug 2020 05:24:05 -0400 (EDT)
Date:   Thu, 13 Aug 2020 12:24:02 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Adrian Pop <popadrian1996@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, vadimp@mellanox.com, andrew@lunn.ch,
        mlxsw@mellanox.com, idosch@mellanox.com, roopa@nvidia.com,
        paschmidt@nvidia.com
Subject: Re: [PATCH ethtool v3] Add QSFP-DD support
Message-ID: <20200813092402.GA3426088@shredder>
References: <20200813071735.7970-1-popadrian1996@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813071735.7970-1-popadrian1996@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 13, 2020 at 10:17:35AM +0300, Adrian Pop wrote:
> The Common Management Interface Specification (CMIS) for QSFP-DD shares
> some similarities with other form factors such as QSFP or SFP, but due to
> the fact that the module memory map is different, the current ethtool
> version is not able to provide relevant information about an interface.
> 
> This patch adds QSFP-DD support to ethtool. The changes are similar to
> the ones already existing in qsfp.c, but customized to use the memory
> addresses and logic as defined in the specifications document.
> 
> Several functions from qsfp.c could be reused, so an additional parameter
> was added to each and the functions were moved to sff-common.c.
> 
> Changelog (diff from v2):
> * Remove functions assuming the existance of page 0x10 and 0x11
> * Remove structs and constants related to the page 0x10 and 0x11

Adrian, you're missing diff from v1 and Signed-off-by tag.

Please send v4 with these changes.

And please CC Michal Kubecek <mkubecek@suse.cz> on ethtool patches since
he maintains the tool.

Thanks

> ---
