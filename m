Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7BB6A71CD
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 18:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjCARHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 12:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCARHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 12:07:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F1D43474;
        Wed,  1 Mar 2023 09:07:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 04DF0CE1D92;
        Wed,  1 Mar 2023 17:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805A5C433D2;
        Wed,  1 Mar 2023 17:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677690435;
        bh=jzjLr5/qWU15ZYJ6YpVaRJDW02mx5TS1OMRDKKAH43U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mlG5Bjguppw9s49A4MlIO9yubZW/4Dh66jNwM6aQ1v+0+uBO7/LMGSlE8mR3mmY9l
         SDrHQ9PG1wyoTiT4t3r33SUINEtMiH2JN0que32UcYiWZIlJZJSOSRqxlDIh4xQovO
         9npGcG3E5bVnG909dxhY6iFDac40FvJmzHQS1Xj7i2TGVLsPmyBj64tygYzbRRpKD4
         r08AdnVGDUEC50p9jZbnQYZLV+DdeKLTVUuybMYP8ZqIHQ1WCLwv5qiPybGKrKuTsQ
         ON4L4ebtqSWCcxN2YHjiXREKTN00aYqXn3AvZ0C9Oi22xBhFKwLkqtdVBX4wLExIbw
         qA+c+G/TuYapA==
Date:   Wed, 1 Mar 2023 09:07:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     lizhe <sensor1010@163.com>
Cc:     "Wei Wang" <weiwan@google.com>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Eric Dumazet" <edumazet@google.com>, davem@davemloft.net,
        pabeni@redhat.com, imagedong@tencent.com, kuniyu@amazon.com,
        petrm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] net/dev.c : Remove redundant state settings after
 waking up
Message-ID: <20230301090713.071e77c4@kernel.org>
In-Reply-To: <706ea669.7a09.1869dce0851.Coremail.sensor1010@163.com>
References: <20230110091409.2962-1-sensor1010@163.com>
        <CANn89iL0EYuGASWaXPwKN+E6mZvFicbDKOoZVA8N+BXFQV7e2A@mail.gmail.com>
        <20230110163043.069c9aa4@kernel.org>
        <CAEA6p_AdUL-NgX-C9j0DRNbwnc+nKPnwKRY8dXNCEZ4_pnTOXQ@mail.gmail.com>
        <Y75mGsoe5XUVtqqa@linutronix.de>
        <20230111102058.144dbb11@kernel.org>
        <CAEA6p_AsyhQbGPrj71iKaScAHbrEBCDLeLyZE1kcT59GS=anzg@mail.gmail.com>
        <706ea669.7a09.1869dce0851.Coremail.sensor1010@163.com>
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

On Wed, 1 Mar 2023 23:32:50 +0800 (CST) lizhe wrote:
> HI : 
>       if want to merge this patch into the main line, what should i do ?

Stop sending HTML emails please, the list only accepts plain text.

Read this:

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html

Improve the commit message and the subject line (look at other related
commits to find examples). Repost when appropriate (net-next is closed).
