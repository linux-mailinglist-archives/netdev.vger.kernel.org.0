Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EADB95293B5
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 00:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349713AbiEPWku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 18:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237069AbiEPWkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 18:40:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0AFA26DC
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 15:40:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C6FC60B32
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 22:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F962C385AA;
        Mon, 16 May 2022 22:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652740846;
        bh=XiuIaKRBMWXXrFbyP0haBeZ8QiD3tF4LpPdK2R8CiWI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oNzMH3gI7KUBTi4KIJ4yzh+kqDITn1RkL+GX4m7wvPTCqNAFlqeBSc4Abf8DnMcKT
         p98MFW1+v+ob8hxfcurUNghKqjuHf1zeguEREh0BTz2cGgMXhcu5BfwAONjKR7RjPk
         LOFlVGeH2h92ssEowF0859ses6iKFh1izWcfmkf3Q+upWGibQecy4iUAnLaMm/Xogm
         ffrwNeeDh6uAa68ewAlYeIC/70KCgRCeVNRJ0ZUsYvNLv9PUn78x5gwycQ1ERV77Uy
         r9SFzCgSGV+45vj/JYE5FzyW0JguuU3T85StCUaTeVv/8U4DQpLAUPl+Jb182Uivlf
         pII+p4/R+97Cw==
Date:   Mon, 16 May 2022 15:40:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Josua Mayer <josua@solid-run.com>
Cc:     Michael Walle <michael@walle.cc>, alexandru.ardelean@analog.com,
        alvaro.karsz@solid-run.com, davem@davemloft.net,
        edumazet@google.com, krzysztof.kozlowski+dt@linaro.org,
        michael.hennerich@analog.com, netdev@vger.kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org
Subject: Re: [PATCH v4 1/3] dt-bindings: net: adin: document phy clock
Message-ID: <20220516154044.29361acc@kernel.org>
In-Reply-To: <ab86220b-f583-4c77-0ddf-a3e25f5bc840@solid-run.com>
References: <20220510133928.6a0710dd@kernel.org>
        <20220511125855.3708961-1-michael@walle.cc>
        <20220511091136.34dade9b@kernel.org>
        <c457047dd2af8fc0db69d815db981d61@walle.cc>
        <20220511124241.7880ef52@kernel.org>
        <bfe71846f940be3c410ae987569ddfbf@walle.cc>
        <20220512154455.31515ead@kernel.org>
        <072a773c-2e42-1b82-9fe7-63c9a3dc9c7d@solid-run.com>
        <20220516104336.3a76579e@kernel.org>
        <ab86220b-f583-4c77-0ddf-a3e25f5bc840@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 May 2022 22:48:20 +0300 Josua Mayer wrote:
> So I can imagine to change the bindings as follows:
> 1. remove the -recovered variants
> 2. add an explicit note in the commit message that the recovered clock 
> is not implemented because we do not have infrastructure for SyncE
> 3. keep the -free-running suffix, we should imo only hide it on the day 
> SyncE can be toggled by another means.

SGTM, thanks!
