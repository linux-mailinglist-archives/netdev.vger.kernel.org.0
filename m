Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121A22C0066
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 08:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgKWG70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 01:59:26 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:45771 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726282AbgKWG7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 01:59:25 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6B10258044C;
        Mon, 23 Nov 2020 01:59:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 23 Nov 2020 01:59:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=AIrBU9
        /FX/0TfVPIhpEOYqgy+ufqoF18Wr1y3cYhAyw=; b=DWq1+p2Y9VP8+vqYyjJLr9
        MIgW/7ohP/saeaMVsnSbvY0xF7b8AT+bZ0+8hU40GUfcV1KPkZ8xb1hzXb72H4/d
        qiNK5kzKf3zI/E1BPeoJS6AHx9GuA1bhTT+jAXqPjnuAYWiTpLcBwPfmUmFDpvuF
        T0MuZrdkoVmou9DNflZtaGBxVj6ADATJFPz3cwJigH+YYtc+/jiFzoSCV1tcpTnb
        5/TMiEipsJPMf4n8psGUwvsL8xRSBdY6aKZatcSCjZgCt8aOcgiYBvbbOt5eleMK
        2TYcXS0nsi9tn73UZwITbRAGlmtgxIKVUM+JRK9Rlq/gN4RS/kaAXQFoVRes6lkQ
        ==
X-ME-Sender: <xms:yl27XwlT3VYJ_HMb_3Ezy_9C-uCynBzCnYpbLJeOcVTrnQ5aR7oHJA>
    <xme:yl27X_2MGHfIBFjEz-EmXkdEGZtRQpEgY67i8teGxDUwb5PFFwADTSXykhWQP2VRb
    2tIXz4upQMIMOU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeghedgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheegrddugeejnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:yl27X-qtuxqfAp0WeGdltTNgngdfyFfoQ01ZoYfodD0b7mGqOLH17w>
    <xmx:yl27X8m0xIQZ205PSSJRbr5UBNk6IyheYv9EZjPgj9-Bi66f5HLMdQ>
    <xmx:yl27X-1TvXVyh5jTQXxtuWYbchYNHYmnLeWZBEPNYxaWoX6TUIpX6g>
    <xmx:zF27X3u7hNcLEmub9Ly4ThS3hiD0g81COVkFpTp4zexZc-TFqSHTOw>
Received: from localhost (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3CBFE3280063;
        Mon, 23 Nov 2020 01:59:22 -0500 (EST)
Date:   Mon, 23 Nov 2020 08:59:19 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christian Eggers <ceggers@gmx.de>,
        Petr Machata <petrm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 2/3] mlxsw: spectrum_ptp: use PTP wide message
 type definitions
Message-ID: <20201123065919.GA674954@shredder.lan>
References: <20201122082636.12451-1-ceggers@arri.de>
 <20201122082636.12451-3-ceggers@arri.de>
 <20201122143555.GA515025@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201122143555.GA515025@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 22, 2020 at 04:35:58PM +0200, Ido Schimmel wrote:
> Anyway, I added all six patches to our regression as we have some PTP
> tests. Will let you know tomorrow.

Looks good
