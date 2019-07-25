Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2652E75897
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 22:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfGYUDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 16:03:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38392 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbfGYUDc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 16:03:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nH6yc8Zp5FY2U7WPg4XUV7qVB1K6/CxJHvn/ucro7Qs=; b=5nThe/jedhO3mVM2+JjFOGIboP
        f5u6ShU3XK3XcKc35zvsYZ9kpnKiMu6r24jSwsF7iqkStNVkAmaATfSv2SCSFu64QAcc4Pw/CUdc0
        q5nO1hCdS+vZ4YplGm6w2VQLhelY0IctF8lpuvlB2Y3J/P61l6FtGyc4Ems1Qkygqq6w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hqjxa-0000b6-J0; Thu, 25 Jul 2019 22:03:30 +0200
Date:   Thu, 25 Jul 2019 22:03:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergej Benilov <sergej.benilov@googlemail.com>
Cc:     venza@brownhat.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sis900: add support for ethtool's EEPROM dump
Message-ID: <20190725200330.GB32542@lunn.ch>
References: <20190725194806.17964-1-sergej.benilov@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725194806.17964-1-sergej.benilov@googlemail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 09:48:06PM +0200, Sergej Benilov wrote:
> Implement ethtool's EEPROM dump command (ethtool -e|--eeprom-dump).
> 
> Thx to Andrew Lunn for comments.
> 
> Signed-off-by: Sergej Benilov <sergej.benilov@googlemail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
