Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF6C37625
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 16:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbfFFOMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 10:12:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33198 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728010AbfFFOMx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 10:12:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uxU1VRmgP0T/fZdIwcFCzsulAf3i6BnuFu2f/XkYx0U=; b=lwFRA/DcbebDIlT6/tHWO93NVE
        H/MEleYlO918TWDugoPuUQUl8yr6sM+NLPomC1qs61/CPD7q8YNtGJk9iCwjzl00Wdo+KinUKguzC
        F+UIkiZ3xz62HcKYjE7Ld8lUq6MnCSuPstm9yp7HnUPqjIpV8+AkaQlNYXWGTlXiqg2Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYt8O-0006mS-19; Thu, 06 Jun 2019 16:12:52 +0200
Date:   Thu, 6 Jun 2019 16:12:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com
Subject: Re: [PATCH net-next v4 03/20] net: axienet: fix MDIO bus naming
Message-ID: <20190606141252.GI19590@lunn.ch>
References: <1559767353-17301-1-git-send-email-hancock@sedsystems.ca>
 <1559767353-17301-4-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559767353-17301-4-git-send-email-hancock@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 02:42:16PM -0600, Robert Hancock wrote:
> The MDIO bus for this driver was being named using the result of
> of_address_to_resource on a node which may not have any resource on it,
> but the return value of that call was not checked so it was using some
> random value in the bus name. Change to name the MDIO bus based on the
> resource start of the actual Ethernet register block.
> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
