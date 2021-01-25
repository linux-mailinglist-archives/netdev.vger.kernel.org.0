Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867F0302A72
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 19:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbhAYSjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 13:39:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:57368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726787AbhAYSjb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 13:39:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF5AE20679;
        Mon, 25 Jan 2021 18:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611599931;
        bh=lBLhD3WMHc10SsE5CL7DUivMK6DXaRphLyPprGVAUZA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B+UvR+u2sO/b0RXQXJ+Yvlc2P03QVa1rdYZLzR4M7266czlQrCUo6e+ZPyLUQExjm
         k9jLHU2/AJssF7tpe0zPhW9ukNDj7D/NF7yFbff/9fwFIizGPcw1qychmirNY1bnD4
         1SIZVqT/hcL/Hxvg83mnWq4FpX/JQxLC7ILBzB7K2xogabRJbaKPVVC/Q3lRO9ZuyB
         dpeJZg1kBUM+Rcz783mSQlOeX/EMAKQbZ4DwtdZdXU/jeMMVV9QxIH1uNjzTsmvUnZ
         ZruRwxbYAJx8EjP0qAmfDAoK1lXpgkNUA7/S8XlTQ0s8nMdgy2i1Mwl1iI1cMlluc7
         VznBcW/tz1Rhw==
Date:   Mon, 25 Jan 2021 10:38:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH V2 net 0/6] ethernet: fixes for stmmac driver
Message-ID: <20210125103849.04770681@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <DB8PR04MB67954786B4359A020C76D2ACE6BD0@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210112113345.12937-1-qiangqing.zhang@nxp.com>
        <DB8PR04MB67954786B4359A020C76D2ACE6BD0@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 04:53:00 +0000 Joakim Zhang wrote:
> Gentle Ping...

Please fix the build issue pointed out by kbuild bot, ensure there is no
other build problem and repost.
