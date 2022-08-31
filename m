Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762075A7637
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 08:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiHaGII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 02:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiHaGIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 02:08:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE63BC11F;
        Tue, 30 Aug 2022 23:08:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B2CEB81EE0;
        Wed, 31 Aug 2022 06:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2E3C433D6;
        Wed, 31 Aug 2022 06:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661926083;
        bh=HFwl/0Cowjv+KnLltLI9O5Nl+E6DY0XyDKHWc3c3gog=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sJm2AZvkXScUbF+jKGHKK3vn4s84HZTmDs7oSdjev+xfcCdfuD55fTZVTN6giC+8K
         auPJGT2nqXu9DKINHssl/lcB1U1Vwx+yoGmdPTQjE4DhUBvDf2W/IptKE5pW2ToW9O
         0MvakCLGHbu/IcPwuyr1Cqv2AYEcAbEanc3xD0HJLEq3Bj5Z6Qd+NAguWh2HK68gWm
         W2JIcsvvKYN384bWlTZV4DuVxi1nhlHYcXt8WJSYUgiJDiHtfHuFOTUq91QgyCoxbL
         mD3jXIhx8Z2NauasAUKbF8WSpRlfhXijbG1rAQhB2kDdcdYD5iXq7UBXElunRd6a4o
         M2Pm1XUk4r/KA==
Date:   Wed, 31 Aug 2022 09:07:59 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: linux-next: Tree for Aug 30 (net/ieee802154/nl802154.c:)
Message-ID: <Yw76v3oYQtPDbwiz@unreal>
References: <20220830170121.74e5ed54@canb.auug.org.au>
 <3d308d17-1c00-39ab-eb47-8fe1f62f9e7f@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3d308d17-1c00-39ab-eb47-8fe1f62f9e7f@infradead.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 30, 2022 at 11:29:31AM -0700, Randy Dunlap wrote:
> 
> 
> On 8/30/22 00:01, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20220829:
> > 
> 
> on i386 or x86_64:
> 
> when # CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
> 
> ../net/ieee802154/nl802154.c:2503:26: error: ‘NL802154_CMD_DEL_SEC_LEVEL’ undeclared here (not in a function); did you mean ‘NL802154_CMD_SET_CCA_ED_LEVEL’?
>  2503 |         .resv_start_op = NL802154_CMD_DEL_SEC_LEVEL + 1,
>       |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~
>       |                          NL802154_CMD_SET_CCA_ED_LEVEL
> 

https://lore.kernel.org/all/20220830101237.22782-1-gal@nvidia.com

> 
> -- 
> ~Randy
