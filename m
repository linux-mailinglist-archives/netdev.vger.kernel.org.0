Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C697813DC39
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgAPNiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:38:09 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41036 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbgAPNiJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 08:38:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BPcB9MGk7kUXJP/Ul4HOkVF460b2og50jxczTkqHf24=; b=CzctOx1EHTacrM4nMUp/UO6EEe
        AMY7p4pwWfmHpC1wxNMy8j7aOTXZW2ZwRSyvn1titKj08pBSfpeKeq4OObfZ25TxdLaTqhTIuvzyo
        hJkU6zrgSPQD1ZXkRsMWI3b+FFr47o7GqyG6aAH4yd/nHcUy46fHg3WNxwxUR+bHA25E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1is5LZ-0005AU-Ob; Thu, 16 Jan 2020 14:38:05 +0100
Date:   Thu, 16 Jan 2020 14:38:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH 2/4] net: phy: adin: rename struct adin_hw_stat ->
 adin_map
Message-ID: <20200116133805.GC19046@lunn.ch>
References: <20200116091454.16032-1-alexandru.ardelean@analog.com>
 <20200116091454.16032-3-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116091454.16032-3-alexandru.ardelean@analog.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 11:14:52AM +0200, Alexandru Ardelean wrote:
> The structure format will be re-used in an upcoming change. This change
> renames to have a more generic name.

NACK.

Defining a new structure does not cost you anything. And you get type
checking, so if you were to pass a adin_map adin_ge_io_pins to a stats
function, the compiler will warn.

	  Andrew
