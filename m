Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C7647F83A
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 17:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhLZQbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 11:31:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42018 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229987AbhLZQbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Dec 2021 11:31:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tqxFJrJljB1kqyk/N5FaSMDpZcdL4cs0/nzQZ9PGaeY=; b=Q42/cEGADbmfQ3Xq0Bm9Hc67xc
        nJ4R+ipSUbCSr/1JuEjrQ0gokWl7+NXfqDY+0iX+DvzyynI5dUWrY5Ep6EAXYgw5XTpu3QNC5XOT3
        y7PGTFz4gLhFJ6Es6nEvJduF3s3baAYeEcdgWyCCEBK/9Vc6gH0C9CU4uteXFw5pcSoo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n1WQz-00HW4N-VV; Sun, 26 Dec 2021 17:31:45 +0100
Date:   Sun, 26 Dec 2021 17:31:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias-Christian Ott <ott@mirix.org>
Cc:     Petko Manolov <petkan@nucleusys.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: usb: pegasus: Do not drop long Ethernet frames
Message-ID: <YciY8Useao5hfIAF@lunn.ch>
References: <20211226132930.7220-1-ott@mirix.org>
 <YciMrJBDk6bA5+Nv@lunn.ch>
 <a87c4ea5-72ef-8dd3-de98-01f799d627ef@mirix.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a87c4ea5-72ef-8dd3-de98-01f799d627ef@mirix.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I've nothing against this patch, but if you are working on the driver,
> > it would be nice to replace these hex numbers with #defines using BIT,
> > or FIELD. It will make the code more readable.
> 
> Replacing the constants with macros is on my list of things that I want
> to do. In this case, I did not do it because I wanted to a have small
> patch that gets easily accepted and allows me to figure out the current
> process to submit patches after years of inactivity.

Agreed, keep fixes simple.

A few other hints. If you consider this a fix which should be back
ported, please add a Fixes: tag, where the issue started. This can be
back as far as the first commit for the driver. Fixes should also be
sent to the net tree, not net-next. See the netdev FAQ about the two
different trees.

	  Andrew
