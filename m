Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4E818079B
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 20:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgCJTFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 15:05:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbgCJTFV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 15:05:21 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F17BE20637;
        Tue, 10 Mar 2020 19:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583867121;
        bh=byeCBm3ZJ4cZfWN44p0Z8+sK6BKWEdEpSc9CE3NbKC4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ubOoGeuDFOx6rh7YrqC3wRkN7gyr3KZ/h8HKlPElKKQ+U/VkYSn9h6g2IAnHpG6qe
         Anz6H3FkzwPhHEkvTsA29DAZfZpp74+NSk31noBANneTyi6WTesVAck/ExytfR/ZwS
         dp94TEvlHhtSmBT6ocRS8ZxyZL77OkB16eyC0jms=
Date:   Tue, 10 Mar 2020 12:05:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        pablo@netfilter.org, ecree@solarflare.com
Subject: Re: [patch net-next 0/3] flow_offload: follow-ups to HW stats type
 patchset
Message-ID: <20200310120519.10bffbfe@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200310154909.3970-1-jiri@resnulli.us>
References: <20200310154909.3970-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Mar 2020 16:49:06 +0100 Jiri Pirko wrote:
> This patchset includes couple of patches in reaction to the discussions
> to the original HW stats patchset. The first patch is a fix,
> the other two patches are basically cosmetics.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

This problem already exists, but writing a patch for nfp I noticed that
there is no way for this:

	if (!flow_action_hw_stats_types_check(flow_action, extack,
					      FLOW_ACTION_HW_STATS_TYPE_DELAYED_BIT))
		return -EOPNOTSUPP;

to fit on a line for either bit, which kind of sucks.

I may send a rename...
