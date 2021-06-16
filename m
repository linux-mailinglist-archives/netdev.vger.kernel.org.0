Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0663A9DFE
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 16:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbhFPOrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 10:47:43 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40799 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233854AbhFPOrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 10:47:41 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id B835F5C00F3;
        Wed, 16 Jun 2021 10:45:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 16 Jun 2021 10:45:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=sYpgCz
        WHYl66W6Ocpn+vjd08IOtt1QAuugKpx0HgzHo=; b=ZdCoJ0UlQEf924MZj8zpgd
        WHfwsddsmDnzDhIXcXy7Q53xWc9QuLjKJZr2F2YJ82iJLQlA243dWSuLt6NVBqJc
        XzWK/Agku1ij0hbtud6+DsdfD8BooUbzNlvQo3RGf7ftk+X0aPlw/ahw4GVHiaUq
        mLFJNRW6dfhVrZkbvQVxf/uXo688pGqB15RA8yWYFAZAO2mC7UbJbk01usU6PY5f
        nj4jYdqimxB5I/qRJbvS0xppEV8iQjNlD63JwfiJFCS/csjYJLXNv6/nlhVK/2Wi
        KAWC3uxg0HqS7zUscKPeG/7g7UnfDV97b3ZHhQ07zj/xrz5Du6lKXv/hB32YAbxQ
        ==
X-ME-Sender: <xms:jg7KYDls9JrEo2QQ9T-l8BGwWdXnZ6z8nZNTkQbomW40aJF7EydebQ>
    <xme:jg7KYG1mzw0yDRUy98m41K6bXGNeHw-LIHERXMHYeJSd5jX1kp1aQ_Wk2BQ54xTId
    UGsCquPfxub9qk>
X-ME-Received: <xmr:jg7KYJriMCFTKrxoc9BZyUAoLMfNHH5X4KWWf8QbsXHS7zY_NcABRVYWJHl95iZ-7Jex4NQB3kCp5uA0n9IuVXxsyID8GA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvledgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpefgjeevhfdvgeeiudekteduveegueejfefffeefteekkeeuueehjeduledtjeeu
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:jg7KYLlDQsTpoFkfwYj13SmmgK2yeJWYoJWTYB2WZ7HXKLLP9W330A>
    <xmx:jg7KYB3Q3jGRoD6Dcf5wisdbQWDjLJmVO9S8yv0tBNsqitjDb-wrng>
    <xmx:jg7KYKtGe-xkbNhRPPrQdNV6TZwXi4Xgx4nSXxqaW3JvGewrTbDL6A>
    <xmx:jg7KYJ-3xKlKYsxsof6UQN_VMAcy-NhKZ43jZLaXnNEgtE0gs2W1Dg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Jun 2021 10:45:33 -0400 (EDT)
Date:   Wed, 16 Jun 2021 17:45:29 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlxsw: spectrum_router: remove redundant continue
 statement
Message-ID: <YMoOiXEJJvvknbIJ@shredder>
References: <20210616130258.9779-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616130258.9779-1-colin.king@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 02:02:58PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The continue statement at the end of a for-loop has no effect,
> remove it.
> 
> Addresses-Coverity: ("Continue has no effect")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

For net-next:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Thanks
