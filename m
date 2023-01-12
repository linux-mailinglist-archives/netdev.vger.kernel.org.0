Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72078666AE5
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 06:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236483AbjALFhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 00:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236584AbjALFhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 00:37:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEB44D707
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 21:37:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B47CB81DBE
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 05:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4B1C433EF;
        Thu, 12 Jan 2023 05:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673501861;
        bh=wduHFmSddmsD6ora5UU/pzL1LMWtRVWA6DKWeInV2Jk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NFL74zkyaIj7w8/ogYrDw53n9c91V2wkqo1nkgEDe5TXjaN7haSikHRsi4qXIkAYn
         2dCjQHHYkEvrDCxp/aVCXSDB7Fr+dq7BoyZObzyFsUxIeg+yVS/y03/EJC+lK4BQqW
         IATonDvMAa3dVK++fZA/ySsA5U/+7LpBcLS+i14hso3ZvFFW12/N+5XdFgVnny0zIQ
         rV2wis9OaC/pWhu2jrVJ20piirbwUF/3Pi00QI9qnn/H0JW1kUvXiPuHJ0TrTzprUR
         n9EHcTZ/Vy4uCM3mpXItxhDLNVRPC043y1BtvdJVeoa3P87LfpjbcBENEyKMBMhFid
         oV4/0XhOCbt6Q==
Date:   Wed, 11 Jan 2023 21:37:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com
Subject: Re: [PATCH net-next] net: ethernet: mtk_wed: get rid of queue lock
 for tx queue
Message-ID: <20230111213739.3e3e24a9@kernel.org>
In-Reply-To: <61c985987cae6571bd25b51d414b09496d80dbe5.1673457839.git.lorenzo@kernel.org>
References: <61c985987cae6571bd25b51d414b09496d80dbe5.1673457839.git.lorenzo@kernel.org>
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

On Wed, 11 Jan 2023 18:26:29 +0100 Lorenzo Bianconi wrote:
> This patch is based on the following patch not applied yet:

The patchwork automation does not support any sort of patch dependency
tracking (it's probably quite doable, some special tag pointing at a
series ID in patchwork, but I ain't got the time..)
You'll have to repost.
