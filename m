Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B33F312AAF
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 07:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhBHG3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 01:29:52 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:37959 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229526AbhBHG3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 01:29:50 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 771DC580215;
        Mon,  8 Feb 2021 01:29:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 08 Feb 2021 01:29:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=/JE/fdBn0uHAF
        /reuWXJArsbuxbUtZ2QdHblap0c0Ec=; b=V4+kTVDehERedfBAbuBzg+5vEeJgL
        FCmnVx5Xtye+gYA1EPp6jxQz8B0K0lWljaqEkU+SKxeSJSPWLs0+aSotDIsm/UG0
        s/Wg/GQqY+7y+PGZ5zpj7XeCcXPvCYAQnID7b9L/1N5aM7RTQdalVSCTvdo0ffsc
        +iojPpBhmkBWEVCWpmpbxTqdojR+vZrGrQxWRnr1jYscyg8Nulruuriv6NtococK
        yL4Eoow29OuH+UDqRzxru8AEgoPSVneSL/W3Chzq/qJ2LwyPJPk7gIxw9xfEZtB2
        Fl8p0LdrpRVZCKO0CBK22z6U9Wm5W/54Ihmtb0ArTO9yYb6D9uC6/pqbQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=/JE/fdBn0uHAF/reuWXJArsbuxbUtZ2QdHblap0c0Ec=; b=KO/92gda
        BROjMtWC7Qpzb/AGn1f2gh3UUa9vxOh7lHpQf4rjpwKL8O2FDed6KKQPIiyCJB1p
        ufRsZrNI7ARqdfBAgcqumCsfp47SFY7O/98k/zdD2pATznfFURpCT9+ohpsJE7cH
        +Td8wfT/ylih/XrR3xxQvwCTizEgtMD57G3O+mXgLAAj0hE8m6ZIyG4pCJPoLgSf
        Sf91DBOMrENas8JsbBTbRuSSt3/3i7lcKyax6WLKog83RSO5D2WPtKmpHF+Pc0Ih
        Uqt8/F+e0+fA0HKt2HcabXrBbv5epBhcpQqrjlOqTyYW202rUebZpSqZ5nLW94fT
        ikadsH8mG/vBEQ==
X-ME-Sender: <xms:LdogYFgZLOu0sfhh0F_29IqvIsjG80XjweZFNya2UmcVptknGWHBuw>
    <xme:LdogYKD2obWltlxmq_nCp1c6fh9vZx3yfxhUz2_u3V1MQsVPmeXuPPwpdytYtkxGb
    JcNmF11LAZoFAFA5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrhedvgdelgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghl
    ucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrf
    grthhtvghrnhepudfhjeefvdfhgfefheetgffhieeigfefhefgvddvveefgeejheejvdfg
    jeehueeinecukfhppeejtddrudefhedrudegkedrudehudenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghmuhgvlhesshhhohhllhgrnhgu
    rdhorhhg
X-ME-Proxy: <xmx:LdogYFEaauwWlPUGIMf8SNX8h9QQTkIv4Y3yvDHcwCxiSudbaENGeg>
    <xmx:LdogYKRmYcJwe8ziItg4lCiM1jpyiYJkdEGEL5A-9VIXEBzWn_TFeQ>
    <xmx:LdogYCzQI1l5NIJCSHi_eCPE7Zx9iUclfZ9xQmp9TvxYiqbBxV9WMA>
    <xmx:L9ogYGjt_Jzupb92RGvHyK048oj8dwZsnXv5lov3N-5NbAW4qo9C8g>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id E77B6108005F;
        Mon,  8 Feb 2021 01:29:00 -0500 (EST)
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
        linux-sunxi@googlegroups.com, Samuel Holland <samuel@sholland.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] i2c: mv64xxx: Fix check for missing clock
Date:   Mon,  8 Feb 2021 00:28:54 -0600
Message-Id: <20210208062859.11429-2-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210208062859.11429-1-samuel@sholland.org>
References: <20210208062859.11429-1-samuel@sholland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit e5c02cf54154 ("i2c: mv64xxx: Add runtime PM support"), error
pointers to optional clocks were replaced by NULL to simplify the resume
callback implementation. However, that commit missed that the IS_ERR
check in mv64xxx_of_config should be replaced with a NULL check. As a
result, the check always passes, even for an invalid device tree.

Fixes: e5c02cf54154 ("i2c: mv64xxx: Add runtime PM support")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/i2c/busses/i2c-mv64xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index b03c344323d1..c590d36b5fd1 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -813,7 +813,7 @@ mv64xxx_of_config(struct mv64xxx_i2c_data *drv_data,
 	 * need to know tclk in order to calculate bus clock
 	 * factors.
 	 */
-	if (IS_ERR(drv_data->clk)) {
+	if (!drv_data->clk) {
 		rc = -ENODEV;
 		goto out;
 	}
-- 
2.26.2

