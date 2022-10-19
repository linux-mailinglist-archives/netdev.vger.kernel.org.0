Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205FA6046F8
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbiJSNZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiJSNZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:25:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174D41C920;
        Wed, 19 Oct 2022 06:11:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 487BBB822E1;
        Wed, 19 Oct 2022 10:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7CBC4347C;
        Wed, 19 Oct 2022 10:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666176288;
        bh=kl0ijNy6HVR3MPGmSrRAj0zI4LWHkUmgGqE65nXmWJI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j3o4dkBv+IkJhqlWsdU2SVzSj/pOdjsFKWFPv3KlJJXCNLpArZbQ6ryPfBMPEkU3y
         nGg2YoUxEvTRsrSx4+TtUBF3fQdb4GC1pKClqotRCkDwA+EeT/3dDquG9kpt991slJ
         D/hTP/vaJLcyns0+bVAqxe9kDyf0yjkEEMtXK0kP42geEAEC66PNHcNZ880Mn/fHl4
         UG6XEH4Y42Hsa3yHsEoz6r+5hS7cAkf2wynraw9DMfv/j12Q7R8P+DoyhlNVp3EoT9
         WYFIsdZUSQyZWKC0XBwdnJZmIkKUja9pk/XRc8+ApmTQ/LnF8/S2lW6fBraY6GV4y2
         QLg5hKzbIFesQ==
Date:   Wed, 19 Oct 2022 12:44:42 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH RFC 0/3] net: phy: marvell10g: Add host speed setting by
 an ethernet driver
Message-ID: <20221019124442.4ab488b2@dellmb>
In-Reply-To: <20221019085052.933385-1-yoshihiro.shimoda.uh@renesas.com>
References: <20221019085052.933385-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-pc-linux-gnu)
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

On Wed, 19 Oct 2022 17:50:49 +0900
Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com> wrote:

> R-Car S4-8 environment board requires to change the host interface
> as SGMII and the host speed as 1000 Mbps because the strap pin was
> other mode, but the SoC/board cannot work on that mode. Also, after
> the SoC initialized the SERDES once, we cannot re-initialized it
> because the initialized procedure seems all black magic...

Can you tell us which exact mode is configured by the strapping pins?
Isn't it sufficient to just set the MACTYPE to SGMII, without
configuring speed?

Marek
