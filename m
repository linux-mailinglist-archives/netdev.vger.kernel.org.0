Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9691443C464
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 09:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237155AbhJ0Hy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 03:54:28 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:39671 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231572AbhJ0Hy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 03:54:27 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3DE37580472;
        Wed, 27 Oct 2021 03:52:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 27 Oct 2021 03:52:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=46SfnC
        WYpTdqhhFXKhK3em5Y/cBOBdl3mYB57Y+Ia78=; b=SnmBRNNneTw8AAmWUFLZCT
        0jlJgJZ/kHqZ+oyj9qLkhBf7MUEw0AQr9CWS2OLOMAlMFjJYpQ/cTxgpn0ZUy5sj
        AsBkTEz4C7G/676dck1eBt0KQnOVC7on10iCkCEToSFBcxlyS9EFP3YKYmPzmmiw
        ha0PTrQW92V9KmFeHzIPoDVjKgtqjQ3htKsu1gxhdHP2S7eNvER1wsvMJrg7PaTt
        P86IYeZ1cMIZ8t2/8qU2lPPbDakQU838cej8UyLvVOqPD02Up8xG4CtZtPLOFaMm
        n8TjVjZ3QpGD/MsH1hEpgd0nTVmu67U7m8tqifJHjUdRFRmCvtGdMzikldabkQhw
        ==
X-ME-Sender: <xms:IQV5YZarB_TdzK4Ni6NpeGyokhkO5nciHdNVRD7bPQq43cAn7SFTJg>
    <xme:IQV5YQbvqlU_PxhMNIqy67kwY4HFsioFbWNRzqAfpmak1S0H98_OKtbLtwjMtW9QW
    TUdTuI2YQPb4Lk>
X-ME-Received: <xmr:IQV5Yb-Bb5G0GZBrEa5WtOGxuWscHLVHwJePjbat3QSuMOcUQ0RvFLd9QkkeRYCIfuhrgjoSQ9-I3i8ikC2esUNmZ8AoBA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefledguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:IQV5YXpEA56Uqis5FNDsqeQtYNzGV2GJdAcDVFQM-nug6-j4quUPaA>
    <xmx:IQV5YUqIpV-v0V4-Z873Un2YVAV_1ONTEOc--yV9LoomDevr8HmWdA>
    <xmx:IQV5YdQfDMP-AOH5Z-noHuAJAJefniYbs6QtUoLQc6k2q-ZXqmgwlg>
    <xmx:IgV5Yb13ugk-0ha6tI9KQmlZwIx9nIC2aqCkdwv_f-Vbjxw4kYQ90w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 03:52:01 -0400 (EDT)
Date:   Wed, 27 Oct 2021 10:51:57 +0300
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
Subject: Re: [PATCH net-next 3/8] net: bridge: rename fdb_insert to
 fdb_add_local
Message-ID: <YXkFHRhzTYt+915r@shredder>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
 <20211026142743.1298877-4-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026142743.1298877-4-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 05:27:38PM +0300, Vladimir Oltean wrote:
> fdb_insert() is not a descriptive name for this function, and also easy
> to confuse with __br_fdb_add(), fdb_add_entry(), br_fdb_update().
> Even more confusingly, it is not even related in any way with those
> functions, neither one calls the other.
> 
> Since fdb_insert() basically deals with the creation of a BR_FDB_LOCAL
> entry and is called only from functions where that is the intention:
> 
> - br_fdb_changeaddr
> - br_fdb_change_mac_address
> - br_fdb_insert
> 
> then rename it to fdb_add_local(), because its removal counterpart is
> called fdb_delete_local().

Good commit message

> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
