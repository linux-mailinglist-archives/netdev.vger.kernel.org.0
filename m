Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1A743C49C
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236073AbhJ0IHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:07:39 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:52177 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234508AbhJ0IHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 04:07:38 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 2468D58047F;
        Wed, 27 Oct 2021 04:05:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 27 Oct 2021 04:05:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=7RHCmL
        itQyq7XByE8Hq1LG9ZsvriMgZ5rMzG2FR7UcQ=; b=To2jZx9z3vScULwaZ+ZhdZ
        2xO4x+YRNEDUYgMLRJKNBRoaclo65orPKe+FamAxmxVqGYUuv9tq4H8Jqea6BtcC
        Mb4TWllUG9kzO9oVttxAB0qmYBfeoZ+ZUaHTHm4AKVWmrBhKGQSzQAVko86gnAsd
        SUdFRgOqKUvxBmcm8tWbiblQTPFa0TJku20E/KbuGIipCnfJLV4pvHScupKWYXrB
        CQOPMDJojWEHxmzJZgxIsWsvmxeU/WN0nNwNuRXUDAmqm1UOmZszSQjDQYIEqhRy
        kkz3KILxTpvfEKW2LeqeJ31xWoUf0/+SAkvC4TDimzcwKtkh3exolrczzJ6UO62A
        ==
X-ME-Sender: <xms:OAh5YWyQrKJQkDCR4U-hKi-Ccx90KOgZ7Z1OWvagyZpSZSpXABJUWw>
    <xme:OAh5YSSiwGCR31QqacmyX7IDlRyTBmnZheU_MnIyJc0pbcyR_ji8UzCFLMT6MBBDs
    v4gHYEG48R3DPY>
X-ME-Received: <xmr:OAh5YYW5Qewb3FGfWiQMcLJx39m-yeVKLVFVwd-LS7lPSUUGrHiq9tWlE9TJ3I-ggd8RFBksAhAAZezJnyEH_Emfb9AK7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefledguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:OAh5YcjnKEb9UDlotHUlmt1dpXQNx6Ed6sG_QVWaD9d49k2xBEkLfw>
    <xmx:OAh5YYAkTPiOBsR5XcUjPavyniDVwJ_zNlRv00KwhDvmnOA40oD2mw>
    <xmx:OAh5YdImHUhkN7PFGJbGcwnUOecOvDdYUEL1fW0vkxRgcADl-kgm8Q>
    <xmx:OQh5YYuK50UEGr8v-n9p-bYVURfaoaXEyXEfavBeXYyCYGPe0ptjlw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 04:05:11 -0400 (EDT)
Date:   Wed, 27 Oct 2021 11:05:09 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 5/8] net: bridge: reduce indentation level in
 fdb_create
Message-ID: <YXkINdrq/042XJ0B@shredder>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
 <20211026142743.1298877-6-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026142743.1298877-6-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 05:27:40PM +0300, Vladimir Oltean wrote:
> We can express the same logic without an "if" condition as big as the
> function, just return early if the kmem_cache_alloc() call fails.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
