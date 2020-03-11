Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E9C182557
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731423AbgCKW4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731369AbgCKW4f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 18:56:35 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7C8520749;
        Wed, 11 Mar 2020 22:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583967395;
        bh=0hcCwLr76Y1HrvSf0R8uI0eUyHi0rxL8GhpK18dgQEo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tPnsfiDyJsW5WEF+WkzlAvGp57GzDEn/TDYqZBZ3gTLb/qSlNOHKYVHPzTPMBApJ/
         QZa0LyrM9NUFT47l7Q6v/KzMMSW2s+mZuWYC2TINpdwWT1HAN75hWY4PtQ3DjL3SS4
         YSebbhUJmj8KOx68C1iWfC9FpGM/2ZutN18Vx4v4=
Date:   Wed, 11 Mar 2020 15:56:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 05/15] ethtool: set netdev features with
 FEATURES_SET request
Message-ID: <20200311155632.4521c71b@kicinski-fedora-PC1C0HJN>
In-Reply-To: <4fda0f27da984254c3df3c9e58751134967036c9.1583962006.git.mkubecek@suse.cz>
References: <cover.1583962006.git.mkubecek@suse.cz>
        <4fda0f27da984254c3df3c9e58751134967036c9.1583962006.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020 22:40:28 +0100 (CET) Michal Kubecek wrote:
> +	if (!(req_info.flags & ETHTOOL_FLAG_OMIT_REPLY)) {
> +		bool compact = req_info.flags & ETHTOOL_FLAG_COMPACT_BITSETS;

is req_info->flags validated anywhere to make sure users get an error
when they set a bit unrecognized by the kernel? :S
