Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25242522496
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 21:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349109AbiEJTRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 15:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344047AbiEJTRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 15:17:44 -0400
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7C62609E1
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 12:17:41 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout02.posteo.de (Postfix) with ESMTPS id D3EF424010A
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 21:17:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1652210259; bh=ytrK2CBdoNyq3TQUxDwxGqNP998kUeZVBv6SkMgZ8c4=;
        h=From:To:Cc:Subject:Date:From;
        b=IKgXAAWCvPmlVagRuT3K5Lxf9Kk6jBnrURVmRXEvUBM6Ira56GVLPQHb5CqpqEp8Y
         yKE3vJWmThx1c+fE0W2osc0M02R/scSFqBgZPDGjSPij9oVvCR5hwseFyyZUQ+5PUP
         3OwM3L+XKngwkWrcIQt+b6zUpEuHEnD2UOXEhzAUenYcy4oruWNt5f3UnVi5bG3dpl
         XwdEpwaFPJ4sS3Uhd/DUlR9qyDBWTG/OxfLIfkeEZS97xnk5j8a5a1mRPfQdX/Dpki
         mev0p51358/TnO/6k+NnKFHn2qKZSI2y586KOApfeTCFOTov+Gb26ZksKOd+UDs6G6
         jNgTfGCDeZVUw==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4KySV871Pqz6tnP;
        Tue, 10 May 2022 21:17:36 +0200 (CEST)
From:   Manuel Ullmann <labre@posteo.de>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Manuel Ullmann <labre@posteo.de>,
        Igor Russkikh <irusskikh@marvell.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        regressions@lists.linux.dev, davem@davemloft.net,
        ndanilov@marvell.com, kuba@kernel.org, edumazet@google.com,
        Jordan Leppert <jordanleppert@protonmail.com>,
        Holger Hoffstaette <holger@applied-asynchrony.com>,
        koo5 <kolman.jindrich@gmail.com>
Subject: Re: [PATCH v6] net: atlantic: always deep reset on pm op, fixing up
 my null deref regression
References: <87bkw8dfmp.fsf@posteo.de>
        <b140c37fe1aac315e07464dd6a2d7a8f463e6fe4.camel@redhat.com>
Date:   Tue, 10 May 2022 19:17:56 +0000
In-Reply-To: <b140c37fe1aac315e07464dd6a2d7a8f463e6fe4.camel@redhat.com>
        (Paolo Abeni's message of "Tue, 10 May 2022 10:37:24 +0200")
Message-ID: <87r151gpsr.fsf@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> writes:

> On Sun, 2022-05-08 at 00:36 +0000, Manuel Ullmann wrote:
>> [...]
>
> For future submission, please always specify the target tree (which is
> -net in this case). No need to resubmit: I'm applying it.
>
> Thanks,
>
> Paolo

Ah, okay. So next branches are reserved for new changes, while non-next
may be targeted by fixups or at least regression fixes. I can't recall a
definition for this in the documentation, but that might be me. I'll
keep this in mind for the future. Thanks for applying it and bearing
with me.

Regards,
Manuel
