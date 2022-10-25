Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA33B60D74A
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 00:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbiJYWl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 18:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbiJYWlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 18:41:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BD0D73CA;
        Tue, 25 Oct 2022 15:41:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48E4FB81F4D;
        Tue, 25 Oct 2022 22:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708D9C433D6;
        Tue, 25 Oct 2022 22:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666737711;
        bh=3ReAlpbuxb1p9jUT1Tt05lQ1bFQXcNMX2FBhJvCl64U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CHENs7+Jm2JhwnGqKVG6LBdPWTr/zoY37HBmpX5axP8gH4//7lYRP+SI07XpMe+Ca
         D+C2b5iwFp3jS6wY9M7rNui0VaCv79pxRRSE1Rm51kMzFUJuvUcQfXsSF841ZP7lpu
         ys88kwX5Dn80rrnzny+sciuwoa9xxwFWymnQhvJ2s8bsH2UH6ZS/uWF2ffOy8rxhMg
         uJ+dXnvYzzgkN+UA1k5mPdKPPoONNgo8MMI4SsB/9jnTLlN4op6rN4GANBGakjbQZ5
         ybr0sZXx/kuN6dfeRXD/w4TpWBuY4CNTBobf5u92SrIEZWC0kPkQdB9MD5mG3ut2gh
         e5+V9qhiJrpPw==
Date:   Tue, 25 Oct 2022 15:41:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     kernel test robot <lkp@intel.com>, Doug Berger <opendmb@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, ntfs3@lists.linux.dev,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [linux-next:master] BUILD REGRESSION
 89bf6e28373beef9577fa71f996a5f73a569617c
Message-ID: <20221025154150.729bbbd0@kernel.org>
In-Reply-To: <63581a3c.U6bx8B6mFoRe2pWN%lkp@intel.com>
References: <63581a3c.U6bx8B6mFoRe2pWN%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Oct 2022 01:17:48 +0800 kernel test robot wrote:
> drivers/net/ethernet/broadcom/genet/bcmgenet.c:1497:5-13: ERROR: invalid reference to the index variable of the iterator on line 1475

CC Doug 
