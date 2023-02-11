Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A047E692C95
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 02:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjBKBpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 20:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjBKBpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 20:45:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3329D84B82
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 17:45:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F7A861EF2
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 01:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB9AC433D2;
        Sat, 11 Feb 2023 01:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676079939;
        bh=V5FUc8qMs+88WiNYMEc/BsyqUC0VPV096DrTFKqM8/w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kO9Rw5Xw0OoKv4ux7J3ehSGPDgvKgnLp10aoK0auASCpEGuwJyew8shNwxiK6dRyI
         uS3efbind3HcSiWlSKW+MafGhG4mWzGluWV/ggiBlUslscFAkdOZemw/7bque53uKe
         j2JTd7ZrmYvJBWdVDQd6q7gBlNRU28UO/1Mem+EvxjYjenp0PSYn+EYiYP0S54EODE
         bgmpbm/JKKwwqBMWLHosnLM8ycQUI0cCCqMTf/csPd1Ec24aoAXcGUDTGct7vcjXx3
         jmCvQsalIUlI9Z0QYlAQdu+f2TETNGdFAVBddFRi5jkcdT9Xr8OVLf/cz0Li+9dmB9
         1mQ8OKAj8LRvQ==
Date:   Fri, 10 Feb 2023 17:45:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <drivers@pensando.io>
Subject: Re: [PATCH v4 net-next 0/4] ionic: on-chip descriptors
Message-ID: <20230210174537.66eec78d@kernel.org>
In-Reply-To: <20230211005017.48134-1-shannon.nelson@amd.com>
References: <20230211005017.48134-1-shannon.nelson@amd.com>
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

On Fri, 10 Feb 2023 16:50:13 -0800 Shannon Nelson wrote:
> v4: added rx-push attributes to ethtool netlink
>     converted CMB feature from using a priv-flag to using ethtool tx/rx-push

Neat, so it is close enough to how hns3 uses it? 
Or at least the behavior of the knob as documented?
