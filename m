Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4D8228672
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 18:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbgGUQt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 12:49:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728268AbgGUQt2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 12:49:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACB6F20720;
        Tue, 21 Jul 2020 16:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595350167;
        bh=2p5mdnruKxxO3UmbMbTBw1mJF1uBMXkgjOtcOdDR8es=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L6Mw19khBIidVk/szjeZG9T/mMxCH4sjYA34/kpgayDWt+WXNVjSa0FEWHP7MjqLs
         5d6cywL2tBYjm2H+OX3b/jB26+ppdYmLmEfhCCU9ZARV40IPTUBJTgIszLJz8FiQ7l
         fmOWwMeYRbYgIVhZdhU6AigdjrPfcHraAC/8dQow=
Date:   Tue, 21 Jul 2020 09:49:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vishal Kulkarni <vishal@chelsio.com>, netdev@vger.kernel.org,
        davem@davemloft.net, nirranjan@chelsio.com
Subject: Re: [PATCH net-next 0/4] cxgb4: add ethtool self_test support
Message-ID: <20200721094926.3497aaf1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200721134145.GB1472201@lunn.ch>
References: <20200717134759.8268-1-vishal@chelsio.com>
        <20200717180251.GC1339445@lunn.ch>
        <20200720062837.GA22415@chelsio.com>
        <20200720133554.GQ1383417@lunn.ch>
        <20200721133754.GB20312@chelsio.com>
        <20200721134145.GB1472201@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jul 2020 15:41:45 +0200 Andrew Lunn wrote:
> > Hi Andrew,
> > 
> > Our requirement is to get overall adapter health from single tool and command.
> > Using devlink and ip will require multiple tools and commands.  
> 
> That is not a good reason to abuse the Kernel norms and do odd things.

+1 

You should probably build your own tool if you have this single tool
requirement. This single tool fallacy leads to very bad outcomes, like
people trying to report system state in device dumps, 'cause they want
system state in their customer bug reports :/
