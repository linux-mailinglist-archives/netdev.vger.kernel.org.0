Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7A1112F242
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 01:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgACAiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 19:38:04 -0500
Received: from mail-40135.protonmail.ch ([185.70.40.135]:64406 "EHLO
        mail-40135.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgACAiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 19:38:04 -0500
Date:   Fri, 03 Jan 2020 00:38:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1578011882;
        bh=bTYOcK/NiZxpI3VbTmd5jGlLpQZ3BJ9QYKekfXqO6Eg=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=nef1Y5/K0WzfTPedqM+L1wR3oBfWk6xrb7DVx1YlScOEs6Zw1h4oGpXYKcKpb7k6i
         +zSCcUScQXTp4Jjw+Hhb2xJbZ0RYP91HXvMtlXDFfL7dGFqfW5Gm7DfVUx3Xvs1ECH
         nTklJKWO7NRg/hFssfibTwdnOpGUHheA7FRzi4uA=
To:     David Miller <davem@davemloft.net>
From:   Ttttabcd <ttttabcd@protonmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Reply-To: Ttttabcd <ttttabcd@protonmail.com>
Subject: Re: [PATCH] tcp: Fix tcp_max_syn_backlog limit on connection requests
Message-ID: <E_PYeI4M2UmOj967xmb6YUpvnq1jo-67gMYX3Ziuhw0Eq2S7ZGgCtdK91JXEwbc5vXJlR8FfZXpoOCYcesX_Ze9FQtsVSRNGotePaOwyPTA=@protonmail.com>
In-Reply-To: <20200102.161934.1501839710048860065.davem@davemloft.net>
References: <0GtwbnKBeenJLjYDiEqWz1RxHrIwx7PSbAxVS-oif8zDKbB97dg5TwYLUmWww8xIFQ3u4mOIcRvA27LqGYmSiF68CjFnubwPqDJyAO9FlQA=@protonmail.com>
 <20200102.161934.1501839710048860065.davem@davemloft.net>
Feedback-ID: EvWK9os_-weOBrycfL_HEFp-ixys9sxnciOqqctCHB9kjCM4ip8VR9shOcMQZgeZ7RCnmNC4HYjcUKNMz31NBA==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_REPLYTO
        shortcircuit=no autolearn=no autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On the surface this looks fine to me, but I'll give Eric a chance to
> review and give feedback.
>
> Thank you.

okay, thank you

