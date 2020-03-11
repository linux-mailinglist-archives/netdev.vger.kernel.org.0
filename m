Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC6E1825C5
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 00:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387514AbgCKXYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 19:24:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgCKXYo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 19:24:44 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 281A220752;
        Wed, 11 Mar 2020 23:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583969083;
        bh=Xe3+utizm2DX4qDLlvFgX01U1SgkrAqUuVQC50qAl58=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aAZjfiqInE2wvfB40bdhGHRmPV0R0kVm83zGoPLOit0VAfBgR72YeYAgGb8R3PgGb
         k+EGHEW/Wy8vNrCe3skj6t+6/TasUKt+fbumf79wVsfoteotx4kDnmmjOyHO+cWTfq
         dJcChBCaIpRFAAl1Q5mX+RIlrsGsykIylmA/dRhM=
Date:   Wed, 11 Mar 2020 16:24:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 13/15] ethtool: provide channel counts with
 CHANNELS_GET request
Message-ID: <20200311162441.230a6907@kicinski-fedora-PC1C0HJN>
In-Reply-To: <316d090cdc05a905d761b10e607e19a3060be878.1583962006.git.mkubecek@suse.cz>
References: <cover.1583962006.git.mkubecek@suse.cz>
        <316d090cdc05a905d761b10e607e19a3060be878.1583962006.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020 22:41:08 +0100 (CET) Michal Kubecek wrote:
> Implement CHANNELS_GET request to get channel counts of a network device.
> These are traditionally available via ETHTOOL_GCHANNELS ioctl request.
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

My ring comments apply to channels patches as well, it seems.
