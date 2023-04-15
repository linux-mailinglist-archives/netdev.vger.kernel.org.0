Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B72F6E2E2D
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 03:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjDOBYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 21:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDOBYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 21:24:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830473A8E;
        Fri, 14 Apr 2023 18:24:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 067DB63290;
        Sat, 15 Apr 2023 01:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B340C433EF;
        Sat, 15 Apr 2023 01:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681521878;
        bh=1ppzM5yRG+5p7GQO+qJ6HCeHM5L0Q6OkhH04K1MKJUk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pb+CmEquCwHUZxjaoDLP7TX0ayTF/Vkc+jEQbLv7wG/o31Gu8xCb9HMrnOCCRTPxX
         GV0V/NUGw8tnmXWHmpxO3zTePIT7PdA1DJNITivZmQL+t7xkqLOebCrv9BN2vh/fnZ
         hYad2uIV4h43q/IA0/ZDfQ8J3aoHA7pKThWrnAGgL4Cwq6oP5pOnJyiOGRxr7su+8q
         M8kioSpvo+Hb377g7E7961GbEr4RhGmfe+I3098hemlvrz1IXJgivhxYxIzUfh/j5v
         dcOtRZ2KEondr0q1zg/Q2Ay8gSlKha1x+Cxno3UQtLwyYioIkTL1FWUx8rguPDl8VB
         w/lMNJGkdiXJA==
Date:   Fri, 14 Apr 2023 18:24:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rajur@chelsio.com
Subject: Re: [PATCH net] cxgb4: fix use after free bugs caused by circular
 dependency problem
Message-ID: <20230414182437.7dca1933@kernel.org>
In-Reply-To: <20230414122621.68269-1-duoming@zju.edu.cn>
References: <20230414122621.68269-1-duoming@zju.edu.cn>
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

On Fri, 14 Apr 2023 20:26:21 +0800 Duoming Zhou wrote:
> The flower_stats_timer can schedule flower_stats_work and
> flower_stats_work can also arm the flower_stats_timer. The
> process is shown below:

Please wait 24h for any comments, and if none arrive repost it with
_correctly_ populated CC list. Run get_maintiner on the patch.
