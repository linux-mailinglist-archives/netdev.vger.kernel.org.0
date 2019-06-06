Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E10A837621
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 16:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbfFFOMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 10:12:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33188 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727522AbfFFOML (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 10:12:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UReGPUiK5F1pfBT+s00glqbVEGyqjU8Y2qcMkW1cswc=; b=y9nl5mMmaynCSfzjOG57M9nKO1
        hH9K8ePD5yWchIcUcgyMSVKeAms5Kv/0X5uBcJBHhlzqkKp4A+iFnzD20uW6Kfas5zy0ppyNZqFb2
        7YZq9+F7mysaxHEQPWbToaryFb1JJqx2KPU40dzoOkDMq6j+YIsk1VsND9ws/vWO7WHU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYt7h-0006lD-5m; Thu, 06 Jun 2019 16:12:09 +0200
Date:   Thu, 6 Jun 2019 16:12:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com
Subject: Re: [PATCH net-next v4 02/20] net: axienet: Use standard IO accessors
Message-ID: <20190606141209.GH19590@lunn.ch>
References: <1559767353-17301-1-git-send-email-hancock@sedsystems.ca>
 <1559767353-17301-3-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559767353-17301-3-git-send-email-hancock@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 02:42:15PM -0600, Robert Hancock wrote:
> This driver was using in_be32 and out_be32 IO accessors which do not
> exist on most platforms. Also, the use of big-endian accessors does not
> seem correct as this hardware is accessed over an AXI bus which, to the
> extent it has an endian-ness, is little-endian. Switch to standard
> ioread32/iowrite32 accessors.
> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
