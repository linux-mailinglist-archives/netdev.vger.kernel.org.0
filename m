Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76DAD5E5771
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 02:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiIVAjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 20:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiIVAjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 20:39:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CDF140BB
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 17:39:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F0B66332E
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 00:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945CFC433D6;
        Thu, 22 Sep 2022 00:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663807177;
        bh=RnxghSsyR7p6n+NigGPdvr2ZxMOKIQhGjrKKJq+Iu/0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=la0Gbos5WqVQOqbSXnKxUVyli8ftT2Pnet3YpOCZXR96t10P9hyd3XC4q6TsCtXMO
         uPYxhLT9YfINgs+Ad5cRLh8WuA1APLtZYScemoqtubSxJ6yVl7msFKQhIBpGP2sLJ+
         MBloN8M6FpzkC/slW6/37yqRYQD9VWzCy3UYoljPnXTIIVlDa6SLihOOxekFx65qfS
         DlLYad1jaPiZsxtxg2MrOQWbDkyrtV7+byWBgGYBJEEQHotra0DcdzHTOKTXBBY4RQ
         CtkSInRZATbnQvopC73TRaw5njQQG4kxibGkFFM8YM8O862Fb5Ww7/Ozlr8BroH+EM
         rfjaYoIP4SZyQ==
Date:   Wed, 21 Sep 2022 17:39:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net v2] bnxt_en: replace reset with config timestamps
Message-ID: <20220921173936.5032ac62@kernel.org>
In-Reply-To: <20220921224430.20395-1-vfedorenko@novek.ru>
References: <20220921224430.20395-1-vfedorenko@novek.ru>
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

On Thu, 22 Sep 2022 01:44:30 +0300 Vadim Fedorenko wrote:
> Fixes: 11862689e8f1 ("bnxt_en: Configure ptp filters during bnxt open")

Also, I'd re-target at net-next, unfortunately resetting a NIC 
on random config changes is fairly common, we can't claim it's 
a bug :(
