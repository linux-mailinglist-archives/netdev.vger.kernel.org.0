Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB979B230
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 16:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395361AbfHWOh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 10:37:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55234 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395343AbfHWOh0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 10:37:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=85+g8r/87Gl6rz/13I7lQBuILwhzvTeolNUackSyhdE=; b=DLE5dtkNXj21pg9xWey0gj5lv3
        gVeu8vMRHsdpwHRljny1Sy6ofa4Axmf/RUICa0JRaqZkPTJWgnRLcleFHwv/kvjmPIkGC+RR6tkim
        RUGJ2Jdf4/qiNS5jSfD34HLB2QFWQiBBLRQ3oS4dJXrQH1HKK2oPNekSqA+58D+vqXAw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i1Ags-0004X4-Ru; Fri, 23 Aug 2019 16:37:22 +0200
Date:   Fri, 23 Aug 2019 16:37:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/2] r8152: save EEE
Message-ID: <20190823143722.GE21295@lunn.ch>
References: <1394712342-15778-304-Taiwan-albertk@realtek.com>
 <1394712342-15778-311-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394712342-15778-311-Taiwan-albertk@realtek.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 23, 2019 at 03:33:39PM +0800, Hayes Wang wrote:
> v4:
> For patch #2, remove redundant calling of "ocp_reg_write(tp, OCP_EEE_ADV, 0)".
> 
> v3:
> For patch #2, fix the mistake caused by copying and pasting.
> 
> v2:
> Adjust patch #1. The EEE has been disabled in the beginning of
> r8153_hw_phy_cfg() and r8153b_hw_phy_cfg(), so only check if
> it is necessary to enable EEE.

Hi Hayes

That was 3 revisions of the patches in less than 30 minutes. Slow
down, take your time, review your work yourself before posting it,
etc.

Aim for no more than one revision, posted to the list, per day.

    Andrew
