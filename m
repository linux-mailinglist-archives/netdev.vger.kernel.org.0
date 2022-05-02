Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC20D516C8C
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 10:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383712AbiEBI40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 04:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379666AbiEBI4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 04:56:25 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511F726132
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 01:52:56 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651481574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q7rEm43a8zVghi0CMcsMpehioeSz+ZSInxwix1OPs3E=;
        b=3Dh9tlnuWcgugCmsgwk8MkJxKeq1HEVxf6dvOvhy0N3eOL8S75kOjHmabP8v+DtKTzbOmI
        NJnxP2Gqy3LxzIt45JD+wEa2kc5OauPU5SydtvQduHY7+OaiFji4zFrwGqnGlkytSpBzTs
        1j3q5mvrcLuP2pb5O+ikuuLOpxLexDYt8r3MYq9ydNTUI3lFTaODq3zE8asY5+QduYULCc
        gddz8tz3LLYwfuISU2wxsvIX6qSvm374TntrG8GNQ047rH2AtnsZ5UmSWxQyrPmyrn+Olq
        qxn1b3P6dw6sFsNqUhAvzbGv2b//8Yft3402/zTZEDPOFsp5vxWLE5Nf9AGa3Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651481574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q7rEm43a8zVghi0CMcsMpehioeSz+ZSInxwix1OPs3E=;
        b=5pRl9gIqiMXnvQ40jzf93U9/Xsr/DkBI514tHxRgDleSiLZiX7TklMj5YD+h4rJJLw0D7S
        l6Wdf2GCUJPNZyDg==
To:     Ondrej Mosnacek <omosnace@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     sgoutham@marvell.com, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        network dev <netdev@vger.kernel.org>
Subject: Re: ['[PATCH] net: thunderx: Do not invoke pci_irq_vector() from\n
 interrupt context', '']
In-Reply-To: <CAFqZXNtC8vL=JFYUX_ahX-Y4J+Uh0yvOy5SYD6wPzSmNeHodfQ@mail.gmail.com>
References: <87r15gngfj.ffs@tglx>
 <165142141033.5854.5996010695898086875.git-patchwork-notify@kernel.org>
 <CAFqZXNtC8vL=JFYUX_ahX-Y4J+Uh0yvOy5SYD6wPzSmNeHodfQ@mail.gmail.com>
Date:   Mon, 02 May 2022 10:52:53 +0200
Message-ID: <877d74nwnu.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 02 2022 at 10:27, Ondrej Mosnacek wrote:
> On Sun, May 1, 2022 at 6:10 PM <patchwork-bot+netdevbpf@kernel.org> wrote:
>> Here is the summary with links:
>>   - net: thunderx: Do not invoke pci_irq_vector() from interrupt context
>>     https://git.kernel.org/netdev/net/c/6b292a04c694
>
> It seems the patch got mangled when applying? The commit is missing
> the subject line.

Probably my fault. I somehow managed to have the proper Subject: line
and another empty 'Subject:' header in that mail.

Thanks,

        tglx
