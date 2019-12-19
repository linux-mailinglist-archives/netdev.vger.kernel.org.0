Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3AC12665D
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 17:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfLSQFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 11:05:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33556 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbfLSQFq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 11:05:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IaGxRhDW1sFamH1CbhCP9ZpYf0Q8281Vz+4JiCX3/Ic=; b=CYqcWR1vXFNLed0Epssfv18qhx
        8qTuOa8IT8mVpDlYPzox7qts0uDQCovkvTKjNv4ZPPKd7N9BSYnupTVl8eIUiN5isIEKMkmlWIESs
        2A+IzDXHl3s1VjVNC2/TeQI6a1AJgjXJ0slGzwiMGVNIco7+cSq96FdrpzQxRPGXDheA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ihyIz-00025I-1o; Thu, 19 Dec 2019 17:05:37 +0100
Date:   Thu, 19 Dec 2019 17:05:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     madalin.bucur@nxp.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk,
        f.fainelli@gmail.com, hkallweit1@gmail.com, shawnguo@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 2/6] arm64: dts: ls104xardb: set correct PHY interface
 mode
Message-ID: <20191219160537.GI17475@lunn.ch>
References: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1576768881-24971-3-git-send-email-madalin.bucur@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1576768881-24971-3-git-send-email-madalin.bucur@oss.nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 05:21:17PM +0200, Madalin Bucur wrote:
> From: Madalin Bucur <madalin.bucur@nxp.com>
> 
> The DPAA 1 based LS1043ARDB and LS1046ARDB boards are using
> XFI for the 10G interfaces. Since at the moment of the addition
> of the first DPAA platforms the only 10G PHY interface type used
> was XGMII, although the boards were actually using XFI, they were
> wrongly declared as xgmii. This has propagated along the DPAA
> family of SoCs, all 10G interfaces being declared wrongly as
> XGMII. This patch addresses the problem for the ARM based DPAA
> SoCs. After the introduction of XFI PHY interface type we can
> address this issue.

Hi Madalin

This patch should come at the end, after you have added support for
these new modes. Otherwise anybody doing a git bisect could land on
code which has broken ethernet.

     Andrew
