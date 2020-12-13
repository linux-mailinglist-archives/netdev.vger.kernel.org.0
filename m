Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB752D8AC2
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 02:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgLMBBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 20:01:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:51372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbgLMBBv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 20:01:51 -0500
Date:   Sat, 12 Dec 2020 17:01:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607821270;
        bh=TjjJnFAHpjE43x5O2wyYUi+2iV+3ePeMYO5Fs9lnrb0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=p66WcL0RAqv5s8anlXqWt4s/SjYTBR65TokUDUOOmUaLLt3VHrY1PeZE3O/s2P4mN
         LiVv0XvZDzLD+UUOhv+0XUBjM8DoSsuRTWsn7Ch0ZhWEj7fMmiEFoFMlYC4FR9R7q9
         vywoWWCULTTdxO/Zp/cLUu3Vobdbch+MVDpVe2j51NmZCQIs6c4x81y5PqjODG+28N
         iryN3Gs53E8qyePrUhcIfKjiZ1Z1FvHQnjxavlCAckivbq9Q9alxGaKPH6fbX5P836
         hI1g+DMPzDlxkxWu7UHDagYGqfOJGtRK7TxHxz/YJRcILLVh8oI79CRrRT8PUhIM70
         Rz6siGJCElkOw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next] net: dsa: mt7530: enable MTU normalization
Message-ID: <20201212170109.311791a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201210170322.3433-1-dqfext@gmail.com>
References: <20201210170322.3433-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 01:03:22 +0800 DENG Qingfang wrote:
> MT7530 has a global RX length register, so we are actually changing its
> MRU.
> Enable MTU normalization for this reason.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Applied, thanks and thanks for the reviews.
