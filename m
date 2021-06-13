Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31EF23A5903
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 16:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbhFMOW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 10:22:28 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37395 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231755AbhFMOW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 10:22:27 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 398B75C0139;
        Sun, 13 Jun 2021 10:20:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 13 Jun 2021 10:20:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=2FQGJvpsmo59Q6mFDomE5LV/huAUCemMLMXnMIEXC
        EQ=; b=fy5OKX47QWl5CxI04X00kletorCqapC+TU03ItlxadFG0NUJGYWHlOQcJ
        l2g0zjq0M/7JUCCF4GRpqxpaUV4QJr2ckreRZcW/fSdjxsHnrb08xDsRqgO6VseH
        5nOqwJP9ZKBaae/vb4Ac6brrv2ZNFZ+d484jmG0k/tsDfzvMHNr3OiIC0ZGfaJCz
        olMZW5RQpXilv9qpO0J/c8pC9Mf0GKtS6xEQa3M8ZgHpOXN4AgbkdCIzGWMhDjzs
        445jbxj35maDX0SdnME9S4PJzGYD0p4Doa5k9qNkLDVV2/r7Z2/idZkuBobB85zd
        Gph51t2q6xaOtP5wlW98ci+a+ling==
X-ME-Sender: <xms:JhTGYBi8e5dSrIs1UDW9MhPzTKnFyvEzXj-_VkX0U84CKClSI5aBbA>
    <xme:JhTGYGDCwihkbC4FnemZDGpXI1ENHFYsKjQCluldyd7pwchCfgcZqNgKKybdNDlHj
    grm7i3uBIMp2ko>
X-ME-Received: <xmr:JhTGYBFbb72g8vALniE-Sev2DctRaKSQgVAuWwFgkmtjEwkKZgjX98A2L3dS>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepuefgjeefveeivdektdfggefhgeevudegvefgtedugfetveevuedtgffhkefg
    gefgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:JhTGYGR4yqoMuoYI493_i0mrRLMCW47fZ2c_VRzphqh6yJnTiYsxlA>
    <xmx:JhTGYOze0pCHyHGkAN9evBniI6LxjCxmUpM6NFTUgGUs3CQRucNA1A>
    <xmx:JhTGYM6Oh8hAdUGjfwz8hDsqHwk9gfPdHlPpWAOpbvLKp2pHx89AmQ>
    <xmx:KBTGYIutCDiur6Aldc7gyLghrA8AbOGemgXrE9lDXwbsA_HlB_ogIQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 10:20:22 -0400 (EDT)
Date:   Sun, 13 Jun 2021 17:20:19 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Don Bollinger <don@thebollingers.org>, netdev@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: Re: [PATCH ethtool v3 3/4] ethtool: Rename QSFP-DD identifiers to
 use CMIS
Message-ID: <YMYUI164vtDYCOhP@shredder>
References: <1623148348-2033898-1-git-send-email-moshe@nvidia.com>
 <1623148348-2033898-4-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1623148348-2033898-4-git-send-email-moshe@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 01:32:27PM +0300, Moshe Shemesh wrote:
> +void cmis_show_all(const struct ethtool_module_eeprom *page_zero,
> +		   const struct ethtool_module_eeprom *page_one)
> +{
> +	const __u8 *page_zero_data = page_zero->data;
> +
> +	cmis_show_identifier(page_zero_data);
> +	cmis_show_power_info(page_zero_data);
> +	cmis_show_connector(page_zero_data);
> +	cmis_show_cbl_asm_len(page_zero_data);
> +	cmis_show_sig_integrity(page_zero_data);
> +	cmis_show_mit_compliance(page_zero_data);
> +	cmis_show_mod_lvl_monitors(page_zero_data);
> +
> +	if (page_one)
> +		cmis_show_link_len_from_page(page_one->data - 0x80);
> +
> +	cmis_show_vendor_info(page_zero_data);
> +	cmis_show_rev_compliance(page_zero_data);
> +}
> diff --git a/cmis.h b/cmis.h
> new file mode 100644
> index 0000000..5b7ac38
> --- /dev/null
> +++ b/cmis.h
> @@ -0,0 +1,128 @@

[...]

> +void cmis4_show_all(const struct ethtool_module_eeprom *page_zero,
> +		    const struct ethtool_module_eeprom *page_one);

Should be cmis_show_all():

netlink/module-eeprom.c:335:17: warning: implicit declaration of function ‘cmis_show_all’; did you mean ‘cmis4_show_all’? [-Wimplicit-function-declaration]
  335 |                 cmis_show_all(page_zero, page_one);
      |                 ^~~~~~~~~~~~~
      |                 cmis4_show_all
