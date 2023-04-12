Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49006DF02A
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 11:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjDLJVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 05:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDLJVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 05:21:38 -0400
Received: from mail.codelabs.ch (mail.codelabs.ch [IPv6:2a02:168:860f:1::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE9410F1
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 02:21:36 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.codelabs.ch (Postfix) with ESMTP id 54B7F220004;
        Wed, 12 Apr 2023 11:21:35 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
        by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YA_rLErEUzWx; Wed, 12 Apr 2023 11:21:34 +0200 (CEST)
Received: from [10.6.32.203] (unknown [185.12.128.224])
        by mail.codelabs.ch (Postfix) with ESMTPSA id 0A100220001;
        Wed, 12 Apr 2023 11:21:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=strongswan.org;
        s=default; t=1681291294;
        bh=eqZP+ZmrDVHbm53kQU9ytzaI1z1mni8UjUm60V/9EBU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K3Trb0FPWldHp91CGCMreSCpVEqzU3Lqvg/YoOUfYGGBG/dF6YhKBv51GSs+ShZnQ
         UDC2wkhXNt+12+xEgsrDxQfZZbqg/RolsqABBxMvK0VijqsaOBp7WidHFSOpBdRJR+
         l3wrwhtc/UpV2ll5oEvStwdcmpQTj0iVfyHmTRH0LXJVlnZey1ZO+lFbUhyA93SMs0
         NcGYOsqyQUfxJNws/edQvyaE5v7BTsoPcfUz7wPR5w+dfmjy7mTtc8u3W5QaRsMPJL
         YmrmJeAa/DPvW3Mr8t5QEfaWBk7J2HfLQqSc3xHkh70UGB4fmB1xyITWB+iYsDg7yS
         lKlEjE5oJumIw==
Message-ID: <ec3a6209cdb2bc42e3af457fcee92de92eae9e6d.camel@strongswan.org>
Subject: Re: [PATCH net] rtnetlink: Restore RTM_NEW/DELLINK notification
 behavior
From:   Martin Willi <martin@strongswan.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Date:   Wed, 12 Apr 2023 11:21:33 +0200
In-Reply-To: <ZDUtwwNBLfDuo9dq@Laptop-X1>
References: <20230411074319.24133-1-martin@strongswan.org>
         <ZDUtwwNBLfDuo9dq@Laptop-X1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> > Fixes: f3a63cce1b4f ("rtnetlink: Honour NLM_F_ECHO flag in rtnl_delete_=
link")
> > Fixes: d88e136cab37 ("rtnetlink: Honour NLM_F_ECHO flag in rtnl_newlink=
_create")
> > Signed-off-by: Martin Willi <martin@strongswan.org>
>=20
> Not sure if the Fixes tag should be
> 1d997f101307 ("rtnetlink: pass netlink message header and portid to rtnl_=
configure_link()")

While this one adds the infrastructure, the discussed issue manifests
only with the two commits above. Anyway, I'm fine with either, let me
know if I shall change it.

Thanks,
Martin
