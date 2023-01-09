Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 051A9662F5C
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbjAISkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:40:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbjAISkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:40:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE97AC39
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:39:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9558B80F01
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 18:39:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D29C433D2;
        Mon,  9 Jan 2023 18:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673289582;
        bh=ZBOSvTRxldpZg/q5OKz28YyAGHTvg0pRb6oNJSQ6hsc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AJteZBvC154dhSOdxnACbPTQzC70zZdNxEZl8ZX/kmum00pgcRtJO//VV9V5gFn1L
         daQ9yssefV4fkqacyfWprPVcxDwLhT3N5xvM0In5fPH+ssXT1ixJYwj57a1zYpAA/d
         77hn+ZfOWQ1AHyD1oz8GG1rfnS+Zn+LPE1PeIzx7iG02S3whPBy6VFiI+r9lgZ/xG4
         cDNlexpzOqJ5bNPeuOpc5zSSYNYmZ06bADO/RkpGKGk76mVgc4y71OjvuB2H/DlCGN
         L+XJabDsaNX42o20h5GH/gvWzL9NaM//xgd/LMXq25s9ayJRnNipFf7I8Dj14m4wpW
         KUHm+Bvxb0Dng==
Date:   Mon, 9 Jan 2023 10:39:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>, xiyou.wangcong@gmail.com
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>, netdev@vger.kernel.org,
        jiri@resnulli.us, pabeni@redhat.com, wizhao@redhat.com,
        lucien.xin@gmail.com
Subject: Re: [RFC net-next 2/2] act_mirred: use the backlog for nested calls
 to mirred ingress
Message-ID: <20230109103940.52e6bf42@kernel.org>
In-Reply-To: <CAM0EoMkSqNAvuNSce=f5bmmy4ZRnteJ6CQZpSmUiZ+UKTUL27A@mail.gmail.com>
References: <ae44a3c9e42476d3a0f6edd87873fbea70b520bf.1671560567.git.dcaratti@redhat.com>
        <840dbfccffa9411a5e0f804885cbb7df66a22e78.1671560567.git.dcaratti@redhat.com>
        <CAM0EoMnJeb3QsfxgsggEMjTACdu0hq6mb3O+uGOfVzG2RZ-hkw@mail.gmail.com>
        <20230105170812.zeq6fd2t2iwwr3fj@t14s.localdomain>
        <CAM0EoMkSqNAvuNSce=f5bmmy4ZRnteJ6CQZpSmUiZ+UKTUL27A@mail.gmail.com>
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

On Mon, 9 Jan 2023 10:59:49 -0500 Jamal Hadi Salim wrote:
> Sorry, I thought it was addressing the issue we discussed last time.
> Lets discuss in our monthly meeting.

When is your meeting? One could consider this patch as a fix and it
looks kinda "obviously correct", so the need for delays and discussions
is a bit lost on me.

Cong, WDYT?

Reminder: please don't top post and trim your replies.
