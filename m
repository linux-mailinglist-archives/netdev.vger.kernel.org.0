Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9147D1386E0
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 16:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733068AbgALPOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 10:14:49 -0500
Received: from mail4.protonmail.ch ([185.70.40.27]:58712 "EHLO
        mail4.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733062AbgALPOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 10:14:49 -0500
Date:   Sun, 12 Jan 2020 15:14:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1578842087;
        bh=GYvB/YjW/U58Qft0cwN//Yxj9VA4Tdvc7lOrhfB1F/c=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=vAJzwTcH2Yl32ivVLUDm+8Oi4mgkxeP/Mz/05stgS9agbgxf0Iyu9Inb23WkpyDma
         /B50PAKz0pdMmxvrSgrZuM0Df8mxir1cyQtEFBtU65BmPNNDvTIWaXxh+2yAUJVE1/
         dM+DQOTjaeys62P8SEiSPA0xJ09XqwFWuIvIX46g=
To:     Stephen Hemminger <stephen@networkplumber.org>
From:   Ttttabcd <ttttabcd@protonmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Reply-To: Ttttabcd <ttttabcd@protonmail.com>
Subject: Re: [PATCH] fragment: Improved handling of incorrect IP fragments
Message-ID: <cG71NUDfI9tJnD4i5DpHv7kpY5x0EDSY1Jks6WIu6MhJhibPRQAsIhqWcpOVPUwncqQ6FlfxGJlC_e6BxTSc5h-03-gwg9lz0tl7eVyMLqA=@protonmail.com>
In-Reply-To: <20200106160635.2550c92f@hermes.lan>
References: <u0QFePiYSfxBeUsNVFRhPjsGViwg-pXLIApJaVLdUICuvLTQg5y5-rdNhh9lPcDsyO24c7wXxy5m6b6dK0aB6kqR0ypk8X9ekiLe3NQ3ICY=@protonmail.com>
 <20200102112731.299b5fe4@hermes.lan>
 <BRNuMFiJpql6kgRrEdMdQfo3cypcBpqGRtfWvbW8QFsv2MSUj_fUV-s8Fx-xopJ8kvR3ZMJM0tck6FYxm8S0EcpZngEzrfFg5w22Qo8asEQ=@protonmail.com>
 <20200106160635.2550c92f@hermes.lan>
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

> You need to split IPv4 and IPv6 parts into two different patches.

Forgot to ask, is it necessary to divide this patch into two?
