Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E9212D539
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 01:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbfLaAWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 19:22:50 -0500
Received: from mail-40130.protonmail.ch ([185.70.40.130]:46435 "EHLO
        mail-40130.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727750AbfLaAWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 19:22:50 -0500
Date:   Tue, 31 Dec 2019 00:22:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1577751768;
        bh=kVR6ehha3wOSexeGB+4HQ8aUWg6sSfLIuvwBRwzM/a0=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=yj8I2u5VtHCFQQJVptgKg+elDNCkELeihPKFTvOzjtyIZQKlVT2TFix30ZTcgPCnf
         3P/V2773M6ok5qtpGymft4IQ1g8FRutD6LYcnvPQQcKdRcf+jZxxmQmXrM906HAhus
         1JXxdH1cVnqxG6H2ARJm7hxMu3spSY45+hKMEs7Y=
To:     kbuild test robot <lkp@intel.com>
From:   Ttttabcd <ttttabcd@protonmail.com>
Cc:     "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        Netdev <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Reply-To: Ttttabcd <ttttabcd@protonmail.com>
Subject: Re: [PATCH] tcp: Fix tcp_max_syn_backlog limit on connection requests
Message-ID: <yHuJXgAqQR7nYwhgnval7Gzpy1twzeu7B9mniTpp79i9ApTqWQ0ArMUXqR0l4mTecwc0m-zk_-LjvaDqaL-M1_yQMZAL1mEY2PhroSdQfEk=@protonmail.com>
In-Reply-To: <201912310520.gWWmntOp%lkp@intel.com>
References: <BJWfRScnTTecyIVZcjhEgs-tp51FEx8gFA3pa0LE6I4q7p6v9Y0AmcSYcTqeV2FURjefo7XOwj4RTM5nIM7pyv--6woYCI_DAskQGbr9ltE=@protonmail.com>
 <201912310520.gWWmntOp%lkp@intel.com>
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

I have fixed this issue in the previous email, using min_t
