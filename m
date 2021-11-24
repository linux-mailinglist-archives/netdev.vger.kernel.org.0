Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAF245CB59
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349823AbhKXRrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:47:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:42104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242750AbhKXRry (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 12:47:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1410600EF;
        Wed, 24 Nov 2021 17:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637775884;
        bh=VaQhs43eeuZWIrzxCZ96Ne0dah0tkA03YkQO1iVf3QA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U7/6y3Om/CYqRsXRosaBeoEhvCNMw1BkhMddz+F9rYEuiQYfP40FI1EVuWkCRZy9T
         VKp8mUeWDtqqRmxvQ4gXH2WKXn6yKHprVueYF6pZHw8JknxJnGyX+G8Bhw9EyvqDY/
         c9kqfswFmSMwe1XBD55IMVXqpixFVPdaCRgb5GH01cl5ntmIJGUoh5DMLctXXnzRk9
         lhOOgx9IKMWh6kUGr+r0r8a8tcR71knddq71cRDB2ZeJzuxK8iXV+jN2RGA23fGuCK
         rhLUCwcaptVIL5RTRGhqTrOXFqSl2tOqdAvCk5Sbw+osoiGYimRLOIUlDyctRS95gF
         Ol7CWnXaZN78A==
Date:   Wed, 24 Nov 2021 09:44:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gilad Naaman <gnaaman@drivenets.com>
Cc:     dsahern@gmail.com, lschlesinger@drivenets.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] rtnetlink: Support fine-grained netdevice bulk
 deletion
Message-ID: <20211124094443.409ab643@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124165942.2514302-1-gnaaman@drivenets.com>
References: <20211124061507.09fccc97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211124165942.2514302-1-gnaaman@drivenets.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 18:59:42 +0200 Gilad Naaman wrote:
> > I'm sorry I don't understand. Please provide a clear use case.
> > I've never heard of "factory default on a large server".  
> 
> Our company is developing a core-router that is supposed to support thousands
> of links, both physical and virtual. (e.g. loopbacks, tunnels, vrfs, etc)
> 
> At times we are required to configure massive amounts of interfaces at once,
> such as when a factory reset is performed on the router (causing a deletion
> of all links), a configuration is restored after an upgrade,
> or really whenever the system reboots.
> 
> The significant detail in Lahav's benchmark is not "deleting 10K loopbacks",
> it's "deleting 10K interfaces", which *is* a good representation of what we're
> trying to do.

Alright, no fundamental objections here if you do in fact need this.
Please address the review comments.
