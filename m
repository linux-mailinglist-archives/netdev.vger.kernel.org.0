Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA96B183ADB
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 21:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgCLUuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 16:50:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbgCLUuE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 16:50:04 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52902206B7;
        Thu, 12 Mar 2020 20:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584046203;
        bh=0ESAIznOWga4wawTrvGnzWr/1q5biUSHC0niGOJhISE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lIckHMDzulL89kpqtlSUe6FDaaaHagCqfTj9f1FIiEiQMjiYN1p4A1vPWKc/stdTU
         U1o8Ph4iU0efkmodsDb26XU0sucDb521ao7Yr72BJ7neP2pUM4npHQ+VUcnA5T6hIU
         RSi0PhgeMeatGn4WFCbqMKifihzIQzZXo0GiIyTU=
Date:   Thu, 12 Mar 2020 13:50:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 11/15] ethtool: set device ring sizes with
 RINGS_SET request
Message-ID: <20200312135001.36703aac@kicinski-fedora-PC1C0HJN>
In-Reply-To: <c860bc9a0d6ba1be03ff9e1ed6322216559d11d0.1584043144.git.mkubecek@suse.cz>
References: <cover.1584043144.git.mkubecek@suse.cz>
        <c860bc9a0d6ba1be03ff9e1ed6322216559d11d0.1584043144.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Mar 2020 21:08:28 +0100 (CET) Michal Kubecek wrote:
> Implement RINGS_SET netlink request to set ring sizes of a network device.
> These are traditionally set with ETHTOOL_SRINGPARAM ioctl request.
> 
> Like the ioctl implementation, the generic ethtool code checks if supplied
> values do not exceed driver defined limits; if they do, first offending
> attribute is reported using extack.
> 
> v2:
>   - fix netdev reference leak in error path (found by Jakub Kicinsky)
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
