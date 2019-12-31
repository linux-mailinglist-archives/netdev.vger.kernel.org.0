Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6056812D570
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 02:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbfLaBQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 20:16:00 -0500
Received: from mail4.protonmail.ch ([185.70.40.27]:35404 "EHLO
        mail4.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727807AbfLaBQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 20:16:00 -0500
Date:   Tue, 31 Dec 2019 01:15:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1577754957;
        bh=XDOvjdwcIuxmARzDGoEV0Rs9/i6zU9BPyJTuTF8BNuM=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=nvxfKMzFQrStbPqVLU+5JjmjRJnSP3WJUcytCSdt1Yf9Ox47wgTn6zVHF6A7wLnq7
         kI3HiOLGX9gAGTc49sMIkOY4r2aL2RZoo9Lu384rtE35wsR03XvqFuLyxUVPCdF748
         02waXO+F6m8OKdxb8a4Bb5ZW8d25qw7PmHwa0jMY=
To:     David Miller <davem@davemloft.net>
From:   Ttttabcd <ttttabcd@protonmail.com>
Cc:     "lkp@intel.com" <lkp@intel.com>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Reply-To: Ttttabcd <ttttabcd@protonmail.com>
Subject: Re: [PATCH] tcp: Fix tcp_max_syn_backlog limit on connection requests
Message-ID: <PT3jX1DHLVgVKzKSTJHPcbWtp2BEmk0YQAGv1PE548Wk7MZEFQdo_Jtl_hFp8sXdYtMBpQgcHYhvV7zuEmDSMEaG6aFZ9xOLh7UCdvF3Jac=@protonmail.com>
In-Reply-To: <20191230.165415.752420426831879647.davem@davemloft.net>
References: <BJWfRScnTTecyIVZcjhEgs-tp51FEx8gFA3pa0LE6I4q7p6v9Y0AmcSYcTqeV2FURjefo7XOwj4RTM5nIM7pyv--6woYCI_DAskQGbr9ltE=@protonmail.com>
 <201912310520.gWWmntOp%lkp@intel.com>
 <yHuJXgAqQR7nYwhgnval7Gzpy1twzeu7B9mniTpp79i9ApTqWQ0ArMUXqR0l4mTecwc0m-zk_-LjvaDqaL-M1_yQMZAL1mEY2PhroSdQfEk=@protonmail.com>
 <20191230.165415.752420426831879647.davem@davemloft.net>
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

> You have to post your updated patch as a new list posting, not as a reply
> to an existing posting.
>
> Thank you.

okay, thank you


