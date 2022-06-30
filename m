Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB890560F91
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 05:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbiF3DWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 23:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiF3DWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 23:22:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D7C40919
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 20:22:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D8AF62022
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 03:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDEEC3411E;
        Thu, 30 Jun 2022 03:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656559367;
        bh=u9BeMhWYbKPKxo1d3LknhQ0DR+Kh4kNJ0HpCeaZPWQw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jxecyD2M1ZztYUYIpTjSt49ACVzGYhm2rNbFeLJUonLGruMl8PtiJ20MQ2fR6Hmt2
         Zjf6Nzs1rwPS3YAcOgbReouen7hf7P4+0KELa7vBWpzl1CI9q9dZtmcpfGoRsBIMaR
         3sPsQX6vzWPwXQhXQYd9Z58GZ+cPsIV8tvQ24uPB4lMNl1T9VHVlsdaYaxC0yr7v8L
         mUDOPhVEQTsl4SKCKGYVFu5BmM54zIfkt/0mPNOkedx3P3or4l6UfgWOyxnS/dNwjC
         t1UTJEO2ig0k291YTBRpDW99ILqUTKgoObTaW3XkG+n5+z56jHUqCwe6yIuf3bu3jK
         fcsVcirdAV5xw==
Date:   Wed, 29 Jun 2022 20:22:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Casper Andersson <casper.casan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: sparx5: mdb add/del handle non-sparx5
 devices
Message-ID: <20220629202246.3a9d8705@kernel.org>
In-Reply-To: <195d9aeee538692a3a630bfe7ce5c040396c507b.camel@microchip.com>
References: <20220628075546.3560083-1-casper.casan@gmail.com>
        <195d9aeee538692a3a630bfe7ce5c040396c507b.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jun 2022 14:55:22 +0200 Steen Hegelund wrote:
> On Tue, 2022-06-28 at 09:55 +0200, Casper Andersson wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > When adding/deleting mdb entries on other net_devices, eg., tap
> > interfaces, it should not crash.
> > 
> > Signed-off-by: Casper Andersson <casper.casan@gmail.com>
>
> Reviewed-by: Steen Hegelund <Steen.Hegelund@microchip.com>

We need a Fixes tag here, when did it start crashing?
