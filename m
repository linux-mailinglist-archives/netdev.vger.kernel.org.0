Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8400F603399
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 21:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiJRTzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 15:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiJRTzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 15:55:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F89E8B2F6;
        Tue, 18 Oct 2022 12:55:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A4E9B82103;
        Tue, 18 Oct 2022 19:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B45C433D6;
        Tue, 18 Oct 2022 19:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666122921;
        bh=OaDjCOWKuNIkAJ/6kceQCxuLFQt2loml8+5D9ErNmKo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m9a3i5F3nFrtucy+oxyoXpp6SisFCIV2lezzcnrQnHJVGsW/vp7DYE4RlS2fD8wpU
         +A2TP9uY+KUBb6xTFsydktk20xxiXnoXF1p6XuWxsaZJC+1M+hb5N69nxhPySttWdw
         n4aTrYAnL/CPVRGoYhLa8nopJNtWUCypj3trrlaXlaQyeNqj5jgONQw994gQRyKpG4
         0IRntG13jcooyEr/mbhMewkxnniDAraAK9kdrCZmxcinLNRSyEhaRxx/ukiwNz3qR/
         F6D2Js2BIqrTpmIDRyLnWNU44rjWlxHKTaVfsI1Yh8E/uXbH+lDmrwpAOpF5my8X6C
         ZKFOcNazVeD1w==
Date:   Tue, 18 Oct 2022 12:55:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v2 net-next 5/6] bitops: make BYTES_TO_BITS()
 treewide-available
Message-ID: <20221018125520.37eb9cda@kernel.org>
In-Reply-To: <20221018140027.48086-6-alexandr.lobakin@intel.com>
References: <20221018140027.48086-1-alexandr.lobakin@intel.com>
        <20221018140027.48086-6-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Oct 2022 16:00:26 +0200 Alexander Lobakin wrote:
> Avoid open-coding that simple expression each time by moving
> BYTES_TO_BITS() from the probes code to <linux/bitops.h> to export
> it to the rest of the kernel.
> Do the same for the tools ecosystem as well (incl. its version of
> bitops.h).

This needs to be before patch 4?
