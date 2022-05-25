Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F176F53365C
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 07:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243566AbiEYFUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 01:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236574AbiEYFUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 01:20:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EA51D337;
        Tue, 24 May 2022 22:20:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 37D0BCE1DEB;
        Wed, 25 May 2022 05:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454C9C385B8;
        Wed, 25 May 2022 05:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653456043;
        bh=Ax7SXV8AbCEPJQ0FyfMaUKPPB7QiTryTXgGkV2IOmoQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bHBQH0lLy+51bYky1vvejahr0d5UTgGUnv5tXk8I7NEdRAYEEb1o4RTpcHsGuOzLy
         fLV1qiTgxEOnyUz71g++l11EYAa60g8yXPMtaHYnqjOTJA8IEsN1NqRSKGwi0ZJQnZ
         N0tC6OKY4PPSuMDQtmQwY64wCu/nQAtM87zAxoBScLyh12Wp7K661d/J7P+GUqKttU
         z9MFFIH6ZkSJwBMnJ3qdmV5f+0OwWWNuFKqPtw8soimQO6DR0LBukwYV3Udx1RBjbA
         FXWqRobr/Vrn5D7r7VloLszFh81p6qb58UwzGJbJISQRO+i4s99d00dE//D0fLeOFU
         lDhEt+s/k2XYQ==
Date:   Tue, 24 May 2022 22:20:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thomas Bartschies <thomas.bartschies@cvk.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.17 08/12] net: af_key: check encryption module
 availability consistency
Message-ID: <20220524222042.40557dbb@kernel.org>
In-Reply-To: <20220524110908.7a237987@kernel.org>
References: <20220524155929.826793-1-sashal@kernel.org>
        <20220524155929.826793-8-sashal@kernel.org>
        <20220524110908.7a237987@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 May 2022 11:09:08 -0700 Jakub Kicinski wrote:
> On Tue, 24 May 2022 11:59:22 -0400 Sasha Levin wrote:
> > From: Thomas Bartschies <thomas.bartschies@cvk.de>
> > 
> > [ Upstream commit 015c44d7bff3f44d569716117becd570c179ca32 ]
> > 
> > Since the recent introduction supporting the SM3 and SM4 hash algos for IPsec, the kernel
> > produces invalid pfkey acquire messages, when these encryption modules are disabled. This
> > happens because the availability of the algos wasn't checked in all necessary functions.
> > This patch adds these checks.
> > 
> > Signed-off-by: Thomas Bartschies <thomas.bartschies@cvk.de>
> > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>  
> 
> I don't see anyone else complaining yet so let me step up.
> 
> Please drop this, it's getting reverted.

I take that back, sorry, it's a different patch.
I meant not to backport 4dc2a5a8f6754492180741facf2a8787f2c415d7.
