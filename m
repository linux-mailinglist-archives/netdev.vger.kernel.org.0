Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D446D0AEC
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 18:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjC3QXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 12:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjC3QXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 12:23:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72981BBAB;
        Thu, 30 Mar 2023 09:23:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1596F61F3A;
        Thu, 30 Mar 2023 16:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B48C433EF;
        Thu, 30 Mar 2023 16:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680193398;
        bh=yr/5iQ/gO3mWx/SFPu/L9aOMda77KFoXhyhzcLQzx1U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HI5+Fl6EahNxf+aeYGD6PCnSbJ2khmzMHk7CME7fMaLpO8OmDPKi9qRHspLCogOU3
         O3zKnIPRD+kfDIpc85odLhEJErMbyYHdt4bhmk13/4+0NPhYyOZ+BnP6NK/o285cmJ
         Bi6WVkOXGMOlUddfaRPYVIxFOU/dl+t4urz3C6ifws2KLByBG8ns6mO4cmlpBNkx6A
         oyWwIFtOGgG4mXvtKdpsba+TmrCwUDqG4g7oHpg8mOokvOorZgpNoHylE5xNJRs67b
         8iTxouS3Mca4m+c9Gn4XxKNnnD8Zwpa1Ulujz/6eLrT4tkkCfiHMuQwqgzakDXdszV
         uiWBZdTWU6Yew==
Date:   Thu, 30 Mar 2023 09:23:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     jbrouer@redhat.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH v4 net-next 2/2] net: introduce budget_squeeze to help
 us tune rx behavior
Message-ID: <20230330092316.52bb7d6b@kernel.org>
In-Reply-To: <CAL+tcoCRn7RfzgrODp+qGv_sYEfv+=1G0Jm=yEoCoi5K8NfSSA@mail.gmail.com>
References: <20230315092041.35482-1-kerneljasonxing@gmail.com>
        <20230315092041.35482-3-kerneljasonxing@gmail.com>
        <20230316172020.5af40fe8@kernel.org>
        <CAL+tcoDNvMUenwNEH2QByEY7cS1qycTSw1TLFSnNKt4Q0dCJUw@mail.gmail.com>
        <20230316202648.1f8c2f80@kernel.org>
        <CAL+tcoCRn7RfzgrODp+qGv_sYEfv+=1G0Jm=yEoCoi5K8NfSSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 17:59:46 +0800 Jason Xing wrote:
> I'm wondering for now if I can update and resend this patch to have a
> better monitor (actually we do need one) on this part since we have
> touched the net_rx_action() in the rps optimization patch series?
> Also, just like Jesper mentioned before, it can be considered as one
> 'fix' to a old problem but targetting to net-next is just fine. What
> do you think about it ?

Sorry, I don't understand what you're trying to say :(
