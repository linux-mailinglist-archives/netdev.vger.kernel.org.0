Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1108A182591
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 00:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731464AbgCKXIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 19:08:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgCKXH7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 19:07:59 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6BDD2074A;
        Wed, 11 Mar 2020 23:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583968079;
        bh=mIDvbT395T9PcLGcQ6KRb4uh0b+8YxZmC7DZ0lz0z9k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cjI4HeSPHugHZPP4u8BtUuVscx+iaCimCG5vpifg3sFUC8yIxuMmk53S4Cpirdh/Y
         SrvVfsMEqR+h4z/ZSfPwLBw3WStOFe7YaBALAt+QJ4OiRP86iqrjH4TWFjjRpUvK6L
         wB/L3Ma0QPsvxge2MVzzJuqPcv/EXbkdFOrw24OU=
Date:   Wed, 11 Mar 2020 16:07:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 08/15] ethtool: set device private flags with
 PRIVFLAGS_SET request
Message-ID: <20200311160757.3e5c1395@kicinski-fedora-PC1C0HJN>
In-Reply-To: <ee141a0bfbe5f6fe1ada537e0f0f1001100eaee5.1583962006.git.mkubecek@suse.cz>
References: <cover.1583962006.git.mkubecek@suse.cz>
        <ee141a0bfbe5f6fe1ada537e0f0f1001100eaee5.1583962006.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020 22:40:43 +0100 (CET) Michal Kubecek wrote:
> Implement PRIVFLAGS_SET netlink request to set private flags of a network
> device. These are traditionally set with ETHTOOL_SPFLAGS ioctl request.
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
