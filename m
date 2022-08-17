Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970DA5975A5
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 20:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238224AbiHQSVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 14:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238086AbiHQSVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 14:21:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FA69083A;
        Wed, 17 Aug 2022 11:21:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D81156135B;
        Wed, 17 Aug 2022 18:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA562C433D6;
        Wed, 17 Aug 2022 18:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660760472;
        bh=d6qBdoWqbEKXFEgasNcljFvQ1Je4AVn5MuO4AhwNO34=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q1OiLfelgmnN5aV2tqTvoI6SXCspCglFvEFnCcuh1JTYseR4chNkyKD6N5JGytcsv
         4HAA1Jpx0tzpQUfQWbi9C+tp5L32XEpqR7morUagNYCc0FH8Z6O14mSKV8FeaSU8yK
         cmbLNN+BKl8lzCX2hLf2BncDr0EZ3eAgxrKAyT/f052P3niJ/NIal4RwGNPTARKWza
         oGIOCe8YlM7zVUTeIwL7zJr/VUHNvVspC03gWC1hBrIeHljzlddzICQmU/KbETHe09
         H+WKEo5yAPPwpFzSS2WFhNXJ+uizUqf64XruE44ZjBVpV5PhP/sn4G/wSrVdIBq1dW
         YODLt1Ssk9MkQ==
Date:   Wed, 17 Aug 2022 11:21:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>, rafael@kernel.org,
        linux-pm@vger.kernel.org, vadimp@mellanox.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vadimp@nvidia.com, petrm@nvidia.com, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH v4] Revert "mlxsw: core: Add the hottest thermal zone
 detection"
Message-ID: <20220817112110.6ad4c3ef@kernel.org>
In-Reply-To: <Yv0TIH0LsjFJwV0L@shredder>
References: <20220817153040.2464245-1-daniel.lezcano@linaro.org>
        <Yv0TIH0LsjFJwV0L@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Aug 2022 19:11:12 +0300 Ido Schimmel wrote:
> Jakub, Daniel wants to route this patch via his tree. Do you mind?
> I spoke with Vadim earlier this week and we do not expect changes to
> this file during the current cycle.

I don't understand why this couldn't have gotten in during the merge
window for 6.0, avoiding the risk of conflicts. But yeah, you said
conflicts are unlikely here anyway, so no objections:

Acked-by: Jakub Kicinski <kuba@kernel.org>
