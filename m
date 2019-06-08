Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53A313A163
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 21:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfFHTEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 15:04:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38570 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727410AbfFHTEe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 15:04:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vGb6sZ8KzALHYl3lM6vd0PUiqJnRuuX8STw3Ib1xY/M=; b=BEpOq8YMasG53wDCwWFQN16iHr
        2t/1n4TM3UhKvCDV2qLMxqoli+e+V2JlYUXmhmXog+EMDPoKzP8A98pBixp6vRlqPSofV015jFFyv
        +CuYz5UWZO1Gt48rhLiP8YDWvv8RJJ+xVVeiv7mGNN8tAE6HemgeeSCMZxFdKrdrmc8Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hZgde-0006JP-Cd; Sat, 08 Jun 2019 21:04:26 +0200
Date:   Sat, 8 Jun 2019 21:04:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Santos <daniel.santos@pobox.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        openwrt-devel <openwrt-devel@lists.openwrt.org>,
        netdev@vger.kernel.org, Vitaly Chekryzhev <13hakta@gmail.com>
Subject: Re: Using ethtool or swconfig to change link settings for mt7620a?
Message-ID: <20190608190426.GG22700@lunn.ch>
References: <5316c6da-1966-4896-6f4d-8120d9f1ff6e@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5316c6da-1966-4896-6f4d-8120d9f1ff6e@pobox.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 08, 2019 at 04:06:54AM -0500, Daniel Santos wrote:
> Hello,

Hi Daniel

As Daniel Golle pointed out, swconfig is an openwrt only
thing. Mainline people on netdev are unlikely to help you much. If you
do however decide to work on the mainline DSA driver, people here will
offer help, answers to questions, etc. The DSA driver will give you
full control of the per port PHY configuration via ethtool.

      Andrew
