Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C0B4E3024
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 19:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352261AbiCUSkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 14:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352258AbiCUSkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 14:40:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2C09D4C7;
        Mon, 21 Mar 2022 11:39:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12D9CB81998;
        Mon, 21 Mar 2022 18:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C9DC340E8;
        Mon, 21 Mar 2022 18:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647887947;
        bh=fUvJ2hhE0WQUQNvYNfGGWsfMMszjJy+OLYvtmBvNdfU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q332j3iCD6SOcZkVDa6v7lOsIqxw0eWSEsvZf+awFyLjyMS+0eOFKnmLsQDHRudNY
         Mxq9YIE1nydObZiZoZ7oR2R6aTqSqBGNTbvU0RcH/ZnWYy2oO49TzX6lijB6wgdrLA
         ZZNRtJ2uavkTA3iLYNZ+cVMVLflsbzvCsDBU54bQX4sHRa0bFIau4Bi+iSeF8+NkRW
         A2t1xjTiCbTntQC6EbPl6Dn39f2r/dHAcJcn5NUJmLrpEnqFFcPqtbOirdXWE+b0Qe
         Ls52d+1PTwDvXi4zoxeLVepcy/lTJDaPfjZQbMJCHe2H+SbYQjtGc7k/crl+ZEG84I
         rLNKk+18BYhvg==
Date:   Mon, 21 Mar 2022 11:39:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, brouer@redhat.com,
        pabeni@redhat.com, toke@redhat.com, andrii@kernel.org, nbd@nbd.name
Subject: Re: [PATCH bpf-next] net: xdp: introduce XDP_PACKET_HEADROOM_MIN
 for veth and generic-xdp
Message-ID: <20220321113905.151608c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <Yjhs73opbYZtALO9@lore-desk>
References: <039064e87f19f93e0d0347fc8e5c692c789774e6.1647630686.git.lorenzo@kernel.org>
        <20220318123323.75973f84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YjTji4qgDbrXg4D+@lore-desk>
        <20220318140153.592ac996@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <Yjhs73opbYZtALO9@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Mar 2022 13:17:51 +0100 Lorenzo Bianconi wrote:
> Do you mean set dev->needed_headroom based on XDP_HEADROOM if the device is
> running in xdp mode, right? I guess this is doable for veth, but what is
> the right value for generic-xdp?

#define XDP_PACKET_HEADROOM	256

What am I missing? :)
