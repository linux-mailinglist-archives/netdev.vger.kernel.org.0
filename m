Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B5363B160
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbiK1Scc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233980AbiK1ScC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:32:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D5221E2A
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 10:28:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB6BEB80F88
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 18:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AA0C433C1;
        Mon, 28 Nov 2022 18:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669660109;
        bh=YBY6ryyav7L7VCwc6eMVqO/5hBt59nTW8yJJhiONUMo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h3IvbhWpt0MgZbbdcZlmbw5KsJ2C8QT7z64igoq0KdPelY9QimM5pr51BmC3r2mLZ
         ZjfV84wgG3sWhUkn4XDbtZmtvuii5yxjm8ZmEjEH8PcNFE94Pyqcg8nC+FSC9z7ns3
         GNkd2nVVlXgsiHh1+GAeOOxXCQIvf0ZX+lasSLOB93OHcvbuXqFPtOnX8Wl/j/jhvB
         zd5iQa0bpBFfm0PFcHOebP2Lwd1TSRr5szaJvfF7hy/z93EkJfkNEfRjKEIu914qsQ
         d6dh56TNzlL9X8qKcoBxSRcPPpMVFP6qZqiaGMVjgGUUOpMe4vs4Jk6w3SXVQrmw2a
         jJygpJMKbZJLg==
Date:   Mon, 28 Nov 2022 10:28:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        drivers@pensando.io
Subject: Re: [RFC PATCH net-next 08/19] pds_core: initial VF configuration
Message-ID: <20221128102828.09ed497a@kernel.org>
In-Reply-To: <20221118225656.48309-9-snelson@pensando.io>
References: <20221118225656.48309-1-snelson@pensando.io>
        <20221118225656.48309-9-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Nov 2022 14:56:45 -0800 Shannon Nelson wrote:
> +	.ndo_set_vf_vlan	= pdsc_set_vf_vlan,
> +	.ndo_set_vf_mac		= pdsc_set_vf_mac,
> +	.ndo_set_vf_trust	= pdsc_set_vf_trust,
> +	.ndo_set_vf_rate	= pdsc_set_vf_rate,
> +	.ndo_set_vf_spoofchk	= pdsc_set_vf_spoofchk,
> +	.ndo_set_vf_link_state	= pdsc_set_vf_link_state,
> +	.ndo_get_vf_config	= pdsc_get_vf_config,
> +	.ndo_get_vf_stats       = pdsc_get_vf_stats,

These are legacy, you're adding a fancy SmartNIC (or whatever your
marketing decided to call it) driver. Please don't use these at all.
