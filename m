Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04875BFEB1
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiIUNLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiIUNLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:11:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B406A82D16;
        Wed, 21 Sep 2022 06:11:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51CB462B54;
        Wed, 21 Sep 2022 13:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBEBCC433D6;
        Wed, 21 Sep 2022 13:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663765873;
        bh=lJ3jomivZA07x4+crqVYAYiJ4JPuWwg7XxM8GfHh5Ek=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ekElD55gmm4KH5Z6CdE8SxizwhDiq/Pj7FmOB8coZPFO49qclsVSDzDtmPAuiDkwB
         DHvUJBrwmolYQ9acEs9VA+UTJY/TRJE4ChJ6Eiqs/2uyjXOLviVCcs4doDcV7DBeDx
         hXtLClP0xdCYXl4cf/90ezwrLrW/thv26D8nJgnq0b76QygfswQUNSpAvysuEVmUcm
         89mfwFGPXNRn5X+XzixNkgCPAgRceGRwbpl7QKvY8XFqPssYmi7grutTk18JbfDuBG
         5MbckeUfAXzCLOLxnyfshj4vYm2s9XXiTdPmZm2ZLCAgMXkmsjiutOhTYJuzG7zJej
         4s61gWqp72llw==
Date:   Wed, 21 Sep 2022 06:11:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     <idosch@nvidia.com>, <petrm@nvidia.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>, <nbd@nbd.name>,
        <lorenzo@kernel.org>, <ryder.lee@mediatek.com>,
        <shayne.chen@mediatek.com>, <sean.wang@mediatek.com>,
        <kvalo@kernel.org>, <matthias.bgg@gmail.com>, <amcohen@nvidia.com>,
        <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH 2/5] mt76: Remove unused inline function
 mt76_wcid_mask_test()
Message-ID: <20220921061111.6d960cc3@kernel.org>
In-Reply-To: <20220921090455.752011-3-cuigaosheng1@huawei.com>
References: <20220921090455.752011-1-cuigaosheng1@huawei.com>
        <20220921090455.752011-3-cuigaosheng1@huawei.com>
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

On Wed, 21 Sep 2022 17:04:52 +0800 Gaosheng Cui wrote:
> All uses of mt76_wcid_mask_test() have
> been removed since commit 8950a62f19c9 ("mt76: get rid of
> mt76_wcid_hw routine"), so remove it.

This should go via the wireless tree, please take it out of this series
and send it to linux-wireless separately.
