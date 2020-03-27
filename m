Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69E6E194FF5
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 05:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgC0EQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 00:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgC0EQv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 00:16:51 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC3A220675;
        Fri, 27 Mar 2020 04:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585282611;
        bh=Naok8AHuo1HFUwr0BgxNbqeJmVLfIw0RW6qjKU1l+94=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HqKnkBoIcrp+eM26kijP1cq706B+2QwMB3DgRmRtN1YET6qTPWMWsDQgs/r8Fklaz
         CANWaS4hyBIv+aF5ujWkbazfr4Ii46mUVB/w9ZgNtI3sGTWR95cJBUOINsQyAKyPir
         8GwCYcPPRu/h5hfve36la0UGjIJwdaNiwy3tVNZI=
Date:   Thu, 26 Mar 2020 21:16:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 04/12] ethtool: add COALESCE_NTF notification
Message-ID: <20200326211649.4930a80a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7e2783bcd535e793e4bb3b6045c3ff2d91dac49c.1585267388.git.mkubecek@suse.cz>
References: <cover.1585267388.git.mkubecek@suse.cz>
        <7e2783bcd535e793e4bb3b6045c3ff2d91dac49c.1585267388.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Mar 2020 01:12:07 +0100 (CET) Michal Kubecek wrote:
> Send ETHTOOL_MSG_COALESCE_NTF notification whenever coalescing parameters
> of a network device are modified using ETHTOOL_MSG_COALESCE_SET netlink
> message or ETHTOOL_SCOALESCE ioctl request.
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
