Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18452E8BF5
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 12:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbhACL1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 06:27:07 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:47401 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726015AbhACL0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 06:26:52 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id C4FDF554;
        Sun,  3 Jan 2021 06:25:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 03 Jan 2021 06:25:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=pYIU/bNlwl71ZPjSR5y6yudlNI
        SbrAe6/N0/ESUhW80=; b=nO5mgbsPG6SkQDqK72PKk210fNIijZAe24M6cw7cLO
        OipWap2mStWiVaQmstlmMnocGWb7BdgCrNM3lmjBo7TyizSY7c3sYMf6GAionMy2
        FnWjWszIBGv1rTA5sWUcB+ARNPeShKazceBIgxCb/wcjeMbjjWGgK1ppYrBYkt6I
        wKUCn8+E+6j72lNyvinRoVK9YC1w/W5npf7lFi+UaJHR7ZYP4QrNpQXaOHWorG4Z
        Mnb0bBJJCQxy5nw2zuJeyJMjoeqSH4WBBUqLnKABzlNTleQcFThsryzSxuIC0YZr
        FC6gbzeWS2IlxPL2AYJhnwjwYRkHm5OQSS9PMn756HGw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=pYIU/bNlwl71ZPjSR
        5y6yudlNISbrAe6/N0/ESUhW80=; b=PNM/qsbnH3rP5BcUr61OLnLH0crsZK9Gh
        wUpsmZM2e8WnvPQOKk0vyg6WLOTZpJH8fVXbiFADpJPB5Nwo/i9ZvORxCfLAKH10
        /dNlJJWiZtGDlxMfZ6s6/ssCKnkvwSIo7sPPVnfJ21U2zb7QxVJlekUmL8Pmd23e
        0iXf1r8gmQFLYO6Y6SXXkfh0mAysoCfwhiKqnUXcuhvpobqib33N1rCGCeBDSMhJ
        8mmDZWInKa9V/emqYVxzg9AQ2vnGCZ69uqdYVsNKOFs/7uZefTy3nDzuNzHFdvT+
        JrcvGuS2Tr5OYIDLT+Hkkd30dNd+zvDK+D/GD5IwSR0H+pFRBiHwA==
X-ME-Sender: <xms:t6nxX0vj0H3k0O7MoLQkZdpxOxCH5Cf35vFi9osz1Nfro46E_Dttsg>
    <xme:t6nxXxdFQBkkoraDDAxbfBlf8El2u4uDZ1-cpRjjYl8fcDynxNHNh6gsXprnM0CEw
    PpYaKosZVpHHIB3BA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefuddgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefurghmuhgvlhcu
    jfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtffrrg
    htthgvrhhnpeeiteekhfehuddugfeltddufeejjeefgeevheekueffhffhjeekheeiffdt
    vedtveenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghnugdr
    ohhrgh
X-ME-Proxy: <xmx:t6nxX_xsBBkyZRMn_ypL7q--UDVX159fhG6qwbaOPr2uM3mD88DLzg>
    <xmx:t6nxX3M7AOaWmyvIj3WZU5zTUY7hRLbcx0y8zW_sK4ym6E0Jbl6cVg>
    <xmx:t6nxX09myucdZYMKzeY8rWDXOn3djrknMmL-4XpsYAaRysY38vqPMw>
    <xmx:uanxX_W8-jwb2G5rx2GKfS5o3OFbnwMBwsNg2mmibHspsgf3KTUJOsaBwTE>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 840EF1080059;
        Sun,  3 Jan 2021 06:25:42 -0500 (EST)
From:   Samuel Holland <samuel@sholland.org>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Corentin Labbe <clabbe@baylibre.com>
Cc:     Ondrej Jirman <megous@megous.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Samuel Holland <samuel@sholland.org>
Subject: [PATCH net-next 0/5] dwmac-sun8i cleanup and shutdown hook
Date:   Sun,  3 Jan 2021 05:25:37 -0600
Message-Id: <20210103112542.35149-1-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches clean up some things I noticed while fixing suspend/resume
behavior. The first four are minor code improvements. The last one adds
a shutdown hook to minimize power consumption on boards without a PMIC.

Samuel Holland (5):
  net: stmmac: dwmac-sun8i: Return void from PHY unpower
  net: stmmac: dwmac-sun8i: Remove unnecessary PHY power check
  net: stmmac: dwmac-sun8i: Use reset_control_reset
  net: stmmac: dwmac-sun8i: Minor probe function cleanup
  net: stmmac: dwmac-sun8i: Add a shutdown callback

 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 31 ++++++++++++-------
 1 file changed, 19 insertions(+), 12 deletions(-)

-- 
2.26.2

