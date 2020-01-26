Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44EE8149DE1
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 00:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgAZXwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 18:52:38 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55040 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgAZXwi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 18:52:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1sMrnh3SigC44z/XmPsI9gIHq4VNk82ikUxOnQh0bFs=; b=XzLY/OX8zrdJNDja97v1DvWKUQ
        /r74uzPRQjR4iXjU5wmvYvL7py+ti6UfezASwQExSkl4Pk3i/7haDTO0ziSVXvV/V9n5IHYPo4vm2
        j2EedibUzATs0+w8s3nYRvSnQB88oLJyG0dInIik2oXryOPEbmLYhCBQgaf0v7/nJW6s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ivrhf-0003b7-Fm; Mon, 27 Jan 2020 00:52:31 +0100
Date:   Mon, 27 Jan 2020 00:52:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/7] ethtool: provide message mask with
 DEBUG_GET request
Message-ID: <20200126235231.GB12816@lunn.ch>
References: <cover.1580075977.git.mkubecek@suse.cz>
 <9f81d98d866d538642696339d9ee5c08a399a384.1580075977.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f81d98d866d538642696339d9ee5c08a399a384.1580075977.git.mkubecek@suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 26, 2020 at 11:11:04PM +0100, Michal Kubecek wrote:
> Implement DEBUG_GET request to get debugging settings for a device. At the
> moment, only message mask corresponding to message level as reported by
> ETHTOOL_GMSGLVL ioctl request is provided. (It is called message level in
> ioctl interface but almost all drivers interpret it as a bit mask.)
> 
> As part of the implementation, provide symbolic names for message mask bits
> as ETH_SS_MSG_CLASSES string set.
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
