Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3242AE0F9E
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 03:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732328AbfJWBW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 21:22:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58818 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbfJWBW2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 21:22:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VJMiCz/GfLbtl/u8EZLcB1pZ0l4mj/o2CoOzazcwDIY=; b=O9OwttbBfRwsL628vgvgYpVXLl
        fvfY2lUcPRJUz/nDN5MWi1lWZU9URaUYtSILObA4uC25obY9E1pQzoPfIJHK7KY6upT2u+X05Uars
        OFO2GDTntxj9fYTDVBLcz75hQi1XhQoO2ZymJHm+//sD5HkcjWn7thc4lOHCYZqaLrVY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iN5M1-0004V9-Ai; Wed, 23 Oct 2019 03:22:25 +0200
Date:   Wed, 23 Oct 2019 03:22:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 2/6] ionic: reverse an interrupt coalesce
 calculation
Message-ID: <20191023012225.GJ5707@lunn.ch>
References: <20191022203113.30015-1-snelson@pensando.io>
 <20191022203113.30015-3-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022203113.30015-3-snelson@pensando.io>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 01:31:09PM -0700, Shannon Nelson wrote:
> Fix the initial interrupt coalesce usec-to-hw setting
> to actually be usec-to-hw.
> 
> Fixes: 780eded34ccc ("ionic: report users coalesce request")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Hi Shannon

How bad is this? Should it be backported? If so, you should send it as
a separate patch for net.

  Andrew
