Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4AB122462
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 20:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbfERSE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 14:04:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39037 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728283AbfERSE0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 May 2019 14:04:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EamXuXRf8C8VugpDQZfo1yXC6WBa01lWzmt8JR/aU3A=; b=viU181nRdae4GmN860gGcr7KuE
        XEXcTn7e0oY2ybdkPErIU7OJBBBViYGWNEAr0jqsG9wETpN9TfkQOW3yRmHGm0oE1WEEsK/kya9vY
        pcHj/7txY13vG9ug6ZJKLKFCYJrBdVNtIDz8U7BXLL+pnfioWAdR366KZy3DRTl5/1fM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hS3h0-0007Pn-LQ; Sat, 18 May 2019 20:04:22 +0200
Date:   Sat, 18 May 2019 20:04:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, sfr@canb.auug.org.au
Subject: Re: [PATCH v2] net: phy: rename Asix Electronics PHY driver
Message-ID: <20190518180422.GA28414@lunn.ch>
References: <20190514105649.512267cd@canb.auug.org.au>
 <1558142095-20307-1-git-send-email-schmitzmic@gmail.com>
 <20190518142010.GL14298@lunn.ch>
 <cebbb214-c79f-ab7c-8238-0bc0576ddfbd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cebbb214-c79f-ab7c-8238-0bc0576ddfbd@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> My apologies - I had hoped that as a bugfix. this could go straight to net.

Ah, O.K. You then need to put "PATCH net" to make it clear this is for
net.

	Andrew
