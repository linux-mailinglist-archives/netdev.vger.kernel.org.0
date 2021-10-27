Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD0043C575
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239578AbhJ0Isj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:48:39 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:47731 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232108AbhJ0Isi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 04:48:38 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id BA3A2580486;
        Wed, 27 Oct 2021 04:46:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 27 Oct 2021 04:46:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=u+7XaP
        jQejLORDBuH8lX/epmIzdZkl8oF8IahU1dL2U=; b=CcFZcnJLemndJRaKXk8SJn
        7I1VbaeEvUtZtpSWRQ9BzT8zcxZIFpTzObdobzI2kQkFDitTHKGsj9JC6k4fZfo8
        /gUD7Yu2xHshSurcT2pwmHjdwbrByc0JqaV4Tqof2ML/qmYEzcjrGL3o/ODrGOlu
        vzBbYrexhje7+KcRFDQnfjDMg7Lo048Wg273V0qcisS59YeJo5erjtHY5c9KED+A
        iITqkrhbHtX8pdZQOvJvKBCL8q60q4zRRKaABn4SnX0WMt++ktgn5PqfAFtWGGUk
        YD7sAVf8/28PlGkZuqAmB5nt0FJXMVNZP1aJikJFd5nQcCt0TKZ90ADyraeNcgug
        ==
X-ME-Sender: <xms:1BF5Ycd4Q84SvOx6VzvpKONPbSQDDVgKWOzas2g3Q7yNjsfP6trGTg>
    <xme:1BF5YeNSp6JNEUj5SkrGD8ECeCMQs2fCo2z5UsJ53dEUfitXuAWs2mZmInhZ2Z4WN
    QKpz29yLrQXH58>
X-ME-Received: <xmr:1BF5YdiUWtC9GaiDZEbUbhhVFy1_j7Y1y12UyFGFZcukAHSpXhH1QcoFTVt2Fo0z4YlGmoeb885XL2b2SmJXZKglkhgWBw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdegtddgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:1BF5YR_cTuStkseMBSaccxQFprg1--phf9e93l-05E8Xd6U_LNhyNw>
    <xmx:1BF5YYtXLxplcfMHeOalfK1AcRCRQHx10o1VyTXfiKm2HqK9ffZJQQ>
    <xmx:1BF5YYHE2W1lE8tCmD2OtwdWqhpQmkVVR5O93W8rIvIVHYWwGrNzww>
    <xmx:1BF5YaJC3xBKC_f99CR5421AqklfdM7I80_-igeGGzC1z2QyOWrV8A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 04:46:11 -0400 (EDT)
Date:   Wed, 27 Oct 2021 11:46:08 +0300
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
Subject: Re: [PATCH net-next 8/8] net: switchdev: merge
 switchdev_handle_fdb_{add,del}_to_device
Message-ID: <YXkR0NCj1OyEwycZ@shredder>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
 <20211026142743.1298877-9-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026142743.1298877-9-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 05:27:43PM +0300, Vladimir Oltean wrote:
> To reduce code churn, the same patch makes multiple changes, since they
> all touch the same lines:
> 
> 1. The implementations for these two are identical, just with different
>    function pointers. Reduce duplications and name the function pointers
>    "mod_cb" instead of "add_cb" and "del_cb". Pass the event as argument.
> 
> 2. Drop the "const" attribute from "orig_dev". If the driver needs to
>    check whether orig_dev belongs to itself and then
>    call_switchdev_notifiers(orig_dev, SWITCHDEV_FDB_OFFLOADED), it
>    can't, because call_switchdev_notifiers takes a non-const struct
>    net_device *.

Regarding 2, I don't mind about the code change itself, but can you
expand on the motivation? Is this required for a subsequent patchset you
plan to submit?

> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
