Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297AC511050
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 06:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357755AbiD0E6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 00:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357747AbiD0E6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 00:58:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A476765B;
        Tue, 26 Apr 2022 21:55:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE3C9B820BF;
        Wed, 27 Apr 2022 04:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19094C385AC;
        Wed, 27 Apr 2022 04:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651035309;
        bh=vNsSGro3tjsLEvCKJAV7pF1cLp48nJjmb/iNK//5bW4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=NYe0vbMsYoaFOoRIo0HrU6ZP2w8namY75HbZQG7RNH4daaccJfQK2rCDD2Fflxh5w
         d8Xcb3CBNqZLLVJ7osrtro3T7ndZDU609GWHcIzYWIzQprcsbp3o9Fnf2H5+91V1AA
         1I2mWKWA1EVrsfFBMjEN93HX5oK0J60OkzjvwAutArp7YKLkiyYWncTjGXR87D9fbg
         xBFiq/2izmnaRCU8LoCO7iXCFScd5fAFvPsJnovyqLxCnZuo1mKQVqV9g8hxwMJxls
         KAat0gZfV998flrK+K78RyAbLsHnJ0CBrSaitt2NwXNeeQoANwfJj8BSH/GfxKzYYL
         XNZZZ7CXFQN3Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v22 1/2] wireless: Initial driver submission for pureLiFi
 STA
 devices
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220224182042.132466-3-srini.raju@purelifi.com>
References: <20220224182042.132466-3-srini.raju@purelifi.com>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165103530291.18987.16551168313134772063.kvalo@kernel.org>
Date:   Wed, 27 Apr 2022 04:55:07 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivasan Raju <srini.raju@purelifi.com> wrote:

> This driver implementation has been based on the zd1211rw driver
> 
> Driver is based on 802.11 softMAC Architecture and uses
> native 802.11 for configuration and management
> 
> The driver is compiled and tested in ARM, x86 architectures and
> compiled in powerpc architecture
> 
> Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>

Applied with my changes to wireless-next:

68d57a07bfe5 wireless: add plfxlc driver for pureLiFi X, XL, XC devices

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220224182042.132466-3-srini.raju@purelifi.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

