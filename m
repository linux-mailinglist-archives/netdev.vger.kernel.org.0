Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F266ED804
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 00:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbjDXWfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 18:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbjDXWfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 18:35:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02819109;
        Mon, 24 Apr 2023 15:35:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F1F0629C7;
        Mon, 24 Apr 2023 22:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF969C433EF;
        Mon, 24 Apr 2023 22:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682375743;
        bh=QKeuUAG1J2pIGGhmD4cv5432uzStG6qjPWtpZa4nPrk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jMC/h3MfbFXM7gm2nNinn7fEcTsJZqRpz2h0ch6cNllg9nAM/1w8k/NCG1KuWqGCN
         9whwZ98Ru5US8y5faXiPmLkm8++IdCC/76/Oi8PdLwxnSfwT+yWpsBleIpmhUVXIzE
         CMsAJ+ETVCgJjmUhQpwFWjkaQ+DNnXcSQz6c1VrMftmdgLU28GVSZBajNLYfMCrHUI
         JOHXAHINGx9Q0tdotlOwLK6RobWEiLegUnXyee3ZkJcgjjNz6xGQRviaMZ8DG7TWL/
         Hz/O0O+OOPT1qh9fab9bVIdXqFVw6NxjKhM+ZmUMCcT4Mbh58FRi0Vdxb2n4dU0kYm
         x800M3lVPrYSA==
Date:   Mon, 24 Apr 2023 15:35:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2023-04-23
Message-ID: <20230424153541.74ee3619@kernel.org>
In-Reply-To: <20230424052742.3423468-1-luiz.dentz@gmail.com>
References: <20230424052742.3423468-1-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 23 Apr 2023 22:27:42 -0700 Luiz Augusto von Dentz wrote:
> bluetooth-next pull request for net-next:
> 
>  - Introduce devcoredump support
>  - Add support for Realtek RTL8821CS, RTL8851B, RTL8852BS
>  - Add support for Mediatek MT7663, MT7922
>  - Add support for NXP w8997
>  - Add support for Actions Semi ATS2851
>  - Add support for QTI WCN6855
>  - Add support for Marvell 88W8997

Looks pulled - 2efb07b5ced64 in net-next. Thanks!
