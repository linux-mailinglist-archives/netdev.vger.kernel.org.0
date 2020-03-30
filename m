Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 309E81976D7
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 10:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729664AbgC3IoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 04:44:18 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:49776 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729416AbgC3IoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 04:44:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=iXwotPXZgVUOmolhzVMyOlsFs53BIkJcVFdnTmTZs6g=; b=ZovF1LRPwxPBmJL5sb43Vpmwr
        AQTfPi6Ly4FzUzyLfOHIyTmlK2Zf/ZIgqnTvcseDi8RagN00clOKDRpOUkix6nB5lM6XJOI5FZhwx
        Z0zL9uIjPlQKa2X8AWxHHpI7xiWPViqImYBtsnkNgoAmysPsSc24FYlePQmBw0tvAqOJjVKOWnjvS
        raeXCYXtK4hKifv29IjigkaEOIT7/E+yqK/IPCMONOtRnJiINqgs9JczqVgxtrRvwOhVAlXJlSedb
        5LHyDpLfZwDVu2XKv73WMdbwX3xiJFGBPFcxwFxIbqAFN+YxSUDs8n9JoG0IccLbq372Tq5APtkrc
        RueyA27IA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:39124)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jIq1j-0001GU-84; Mon, 30 Mar 2020 09:44:11 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jIq1h-0006zN-7D; Mon, 30 Mar 2020 09:44:09 +0100
Date:   Mon, 30 Mar 2020 09:44:09 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] split phylink PCS operations and add PCS
 support for dpaa2
Message-ID: <20200330084409.GD25745@shell.armlinux.org.uk>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
 <20200326151404.GB25745@shell.armlinux.org.uk>
 <20200329.215703.1788464189000179821.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200329.215703.1788464189000179821.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 29, 2020 at 09:57:03PM -0700, David Miller wrote:
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Date: Thu, 26 Mar 2020 15:14:04 +0000
> 
> > This series splits the phylink_mac_ops structure so that PCS can be
> > supported separately with their own PCS operations, separating them
> > from the MAC layer.  This may need adaption later as more users come
> > along.
> 
> It looks like there will be a respin of this based upon Andrew's
> feedback.

FYI, it's been through two more respins already, this series has
already been superseded.  The most recent series is:

"[PATCH net-next v2 0/3] split phylink PCS operations and add PCS
 support for dpaa2"

which I still need to fix the cover message subject line.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
