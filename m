Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 433931799DB
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgCDUeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:34:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:36818 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbgCDUeR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 15:34:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5619BB2A2;
        Wed,  4 Mar 2020 20:34:16 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id F2ED9E037F; Wed,  4 Mar 2020 21:34:15 +0100 (CET)
Date:   Wed, 4 Mar 2020 21:34:15 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     John Linville <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH ethtool v2 00/25] initial netlink interface
 implementation for 5.6 release
Message-ID: <20200304203415.GL4264@unicorn.suse.cz>
References: <cover.1583347351.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1583347351.git.mkubecek@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John,

If you would prefer that, feel free to use v1 and I'll send the later
updates as a shorter follow-up series.

Michal
