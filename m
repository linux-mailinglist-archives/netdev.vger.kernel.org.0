Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772AE54675A
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 15:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345689AbiFJN1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 09:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237423AbiFJN1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 09:27:19 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772D51F1840;
        Fri, 10 Jun 2022 06:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=a17rIhmYMXk/cMHXQP0SBvxNj3jz7ib4FGJ0RQdnt8U=;
        t=1654867638; x=1656077238; b=Q8Kc4OeQu90J4RYpYmf+cj+JE432E0qSBEBe9Ip5yyaQn1D
        IkmpEXetWeR1s5iEPIvDNohJKeg4mtoXgHQfATg8DAUG4GgCSgEnr9G6WE3XHejCiYcdmnfdRSJYO
        cMPjGWNrBC1AaHa2DWlqL5NImh7DvL1w1KWAbPU3qfiX4yrJ4nHJ8ArKI4AIVZOylp8oX394UsN71
        x8V0RsIPe99NueTLJ4zP0ori7xUGriCpbc5n4HYqO2kTOEuAUSz1rxx7lK8OR7NlXynfxu9PgPgKS
        LrYSN+DZVggtjkn/yp4UnLtww0z/daNlQ+FSuYHUCaCAhwu3ZgoTgM2+PY+EZIzQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nzefI-001VO4-R7;
        Fri, 10 Jun 2022 15:27:05 +0200
Message-ID: <f3246ffaf0a15bff2d8a9568ed73967d07dd414b.camel@sipsolutions.net>
Subject: Re: [PATCH v6 0/2] Remove useless param of devcoredump functions
 and fix bugs
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        briannorris@chromium.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, rafael@kernel.org
Date:   Fri, 10 Jun 2022 15:27:03 +0200
In-Reply-To: <YqNGB5VitXvBWzzp@kroah.com>
References: <cover.1654569290.git.duoming@zju.edu.cn>
         <YqNGB5VitXvBWzzp@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-06-10 at 15:24 +0200, Greg KH wrote:
> On Tue, Jun 07, 2022 at 11:26:24AM +0800, Duoming Zhou wrote:
> > The first patch removes the extra gfp_t param of dev_coredumpv()
> > and dev_coredumpm().
> >=20
> > The second patch fix sleep in atomic context bugs of mwifiex
> > caused by dev_coredumpv().
> >=20
> > Duoming Zhou (2):
> >   devcoredump: remove the useless gfp_t parameter in dev_coredumpv and
> >     dev_coredumpm
> >   mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv
>=20
> Did you forget to cc: everyone on patch 2?
>=20

Don't think so? I got it, and you're listed there too, afaict.

That said, it's actually entirely independent from patch 1, and patch 2
should probably even be Cc stable.

johannes
