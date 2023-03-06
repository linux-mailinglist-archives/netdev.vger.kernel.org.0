Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 348C66ACFA8
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 21:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjCFU6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 15:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjCFU6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 15:58:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3DC39298;
        Mon,  6 Mar 2023 12:58:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41C5EB8112E;
        Mon,  6 Mar 2023 20:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6922C4339C;
        Mon,  6 Mar 2023 20:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678136324;
        bh=dCCQxJiDiFMdgqM+UEIILb3kQDs4LjfVOu+KbANKfMU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QH78kW3MTJ3XxzsvQY9rxqoz2zoUTsO2acwyKd85M6fg/0j2tb16pe8hY5SHBO7dU
         pexG/eExr34gwNSTXiT2TmhtJxeSNLSyhbP31cUcoiuXe9YSw4EnrfR9KKVsIkJPrr
         PaNqSZprEtZT2IPy7kVMPnlPiwxOfs26dXTQsShXlq5HwJq3ZqGF+ThoghOZhCWBv2
         G4fk3UXfyilfvd0l/OLxFfVGKCXkufTpM4yxw9GqorZFohP7NHsGV36lEsCqBoB/0M
         OHoeo3Od3Ozl3g95xouEZQAlm1Hjf5ASC6bRuN4drpgbYKDXBWEz7wZ0cbK60L6AWb
         JtBT2SMvcbqtA==
Date:   Mon, 6 Mar 2023 12:58:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] nfc: change order inside nfc_se_io error path
Message-ID: <20230306125842.7fea0be5@kernel.org>
In-Reply-To: <20230306204150.vjpgqbau3kogg4n3@fpc>
References: <20230304164844.133931-1-pchelkin@ispras.ru>
        <7370a80b-56f9-a858-ff05-5ba9d7206c8c@linaro.org>
        <20230306203504.3qg7ewfhypd3ljdt@fpc>
        <20230306204150.vjpgqbau3kogg4n3@fpc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Mar 2023 23:41:50 +0300 Fedor Pchelkin wrote:
> On Mon, Mar 06, 2023 at 11:35:09PM +0300, Fedor Pchelkin wrote:
> > On Mon, Mar 06, 2023 at 04:28:12PM +0100, Krzysztof Kozlowski wrote:  
> > > I would argue that it is functional. Running code in or outside of
> > > critical section/locks is quite functional change.
> > >   
> > 
> > Hmm, actually, yes. I'll resend v2 with changed commit info as 'no
> > functional changes' statement can probably be misunderstood later.
> > 
> > Should this patch be backported by the way? It doesn't seem to fix any
> > real issue but, as you mentioned, it contains some functional changes
> > which may be of some importance in future.  
> 
> Sorry for the noise. Didn't see the patch was already applied. So it's
> okay as it is.


As luck would have it it was applied to the wrong branch (we use main,
not master now). Script malfunction perhaps. So I'll toss it, you can
send a v2 with the updated commit message, please.
