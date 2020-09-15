Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B57E26A456
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 13:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgIOLob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 07:44:31 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34595 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726324AbgIOLm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 07:42:26 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 72CBE5C00F2;
        Tue, 15 Sep 2020 07:41:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 15 Sep 2020 07:41:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=hD+laVjBmaNwq1jET6SPWcNQAtZSxT6WC0wrTEqBKwk=; b=r/jLVbF2
        V1o4p934ZS27YCT6Q5I+EyPWBfQic3cskblkfOdn3ydrjAksO3qpfru1PRGECHKo
        TfwPmoy+vhDNsU6I5SSB1z3lGjxfqxUA0uAQYVo1IwOKItluPV8yrwGMMVxJXz9t
        09DIbzQYhrfOZdwreEXOHhTKIE00HzGIN9nxLADnekUhqQzvjQ0Si+zIiyoHsV4z
        DcKqCOFt5l+AAdjqQgEMD8Sv4XbMziIuuDERRgVO6Se90KDZPV+SS+BOO/Qs0BCg
        WZmeRYvcYQc1iydRIW1q+gE5NcdnwLYUPF/PqmS5ogddDjEze5oBGnLnm3kf5YNX
        TkMOHdbphvj4sw==
X-ME-Sender: <xms:gahgX75zLU83CreV14p_z4Sm-ZcvrZfAWr_o4dJmUpjMyOhqpy47cw>
    <xme:gahgXw4YdUt_2qBxTM5hdErGjhvIR4UZMLnClsQd8k478WCeRkcn7WGgvlWtom5RO
    ffRhOsI_s4QvMc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddtgdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefiedrkedvnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:gahgXycqwJxfRL1dBbX9sTlQxHTOyhqg6TnQ-gw9_WLZRcOhoToYXQ>
    <xmx:gahgX8JoiFY2sDcqH7Z1Lg5li6GkduBIYaTPxp5LPqvMniZjs6sjCA>
    <xmx:gahgX_KqTnHobUAsupRR_2cebhyE1x20b_8NdnDg2RNwiNEelkf1kg>
    <xmx:gahgX2VkFTcptwgMJRJ9uVgk4AKpQ6FMJivmRIWgB7TKdMf7hA0CDw>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id ECFCF306467D;
        Tue, 15 Sep 2020 07:41:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/5] nexthop: Remove NEXTHOP_EVENT_ADD
Date:   Tue, 15 Sep 2020 14:41:00 +0300
Message-Id: <20200915114103.88883-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915114103.88883-1-idosch@idosch.org>
References: <20200915114103.88883-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Not used anywhere.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Suggested-by: David Ahern <dsahern@gmail.com>
---
 include/net/nexthop.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 2e44efe5709b..2fd76a9b6dc8 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -105,7 +105,6 @@ struct nexthop {
 };
 
 enum nexthop_event_type {
-	NEXTHOP_EVENT_ADD,
 	NEXTHOP_EVENT_DEL
 };
 
-- 
2.26.2

