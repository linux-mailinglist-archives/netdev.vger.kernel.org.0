Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D011E14546B
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 13:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgAVMe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 07:34:28 -0500
Received: from mailin.studentenwerk.mhn.de ([141.84.225.229]:45398 "EHLO
        email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726204AbgAVMe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 07:34:27 -0500
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jan 2020 07:34:27 EST
Received: from mailhub.studentenwerk.mhn.de (mailhub.studentenwerk.mhn.de [127.0.0.1])
        by email.studentenwerk.mhn.de (Postfix) with ESMTPS id 482l6K5Dl1zRhSK;
        Wed, 22 Jan 2020 13:27:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stwm.de; s=stwm-20170627;
        t=1579696057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3yyTXS3QHlZFKWQCRy2IPfL2mJkRYpgCmXeGUd95d0A=;
        b=CPdDXJK9EXCNdRmqaWImfulhz3++nnh6MRf0i4NzGKUf/Zoa51pjQ19Y/blcTAkZI/pEd+
        V4CDOSe4WmaRQ3k/lbC+z1toZI7wiU270KFgKn8OcEuYiUS0AsVYQlINf7MtJm/etKT40a
        yqmrLT3nwNqw8XRX1MQhu0aEdRTXyf7SyEq1B3wnyDa1Ghb2djkSG5DKP3Wsj6mNs97urq
        JCIgF58WV/jZNDApvUyd7UXRREErSGPDfYuQpuF6my3aRNkMnug6XUd2PoRdJ+4HCruvd1
        Wg9KpxXPA3ICUIlegvphbe5UONL8n+OEBaFUeig+5B1VV3RL+qaYz/qyRDMS9Q==
From:   Wolfgang Walter <linux@stwm.de>
To:     David Miller <davem@davemloft.net>
Cc:     xiaofeng.yan2012@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ap420073@gmail.com,
        yanxiaofeng7@jd.com
Subject: Re: [PATCH v2] hsr: Fix a compilation error
Date:   Wed, 22 Jan 2020 13:27:37 +0100
Message-ID: <2043688.Di36XlgKKK@stwm.de>
User-Agent: KMail/4.14.3 (Linux/5.0.6-050006-generic; KDE/4.14.13; x86_64; ; )
In-Reply-To: <20200120.132136.1992070505971817725.davem@davemloft.net>
References: <20200120062639.3074-1-xiaofeng.yan2012@gmail.com> <20200120.132136.1992070505971817725.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=stwm.de;
        s=stwm-20170627; t=1579696057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3yyTXS3QHlZFKWQCRy2IPfL2mJkRYpgCmXeGUd95d0A=;
        b=Pf7f1T2KBNogpymp/mfj3AibMqnxHtp7kuDcgMg59x97g7CmS5iz1Q5Ptalj3ljDzsqMpl
        zlemrpmE6jtjH8dpFsckEwn364pxthjhLkJY5VVKjGaDnWpFhnjjExm1hXZ8dkM3f4RBxD
        w0ZwCxr1/QVCkJJUrknZCAPZ2ZFcqN1kLQiPfcwCuVlwssbMI2UZRe2b08EnUUxS043+ZM
        Pq0/G9+CO4lYIZhzH6Rx4kK4fcsQ2rxKegHO5StHaCdWxsrRBjjkmLDdX8niXLqqaiWO3z
        /gTgkI6CImCo+HAEPm7CpzSi0aEKx2YQlA4BxuYSPGb7i7cAtVwddO/rEYe5CA==
ARC-Seal: i=1; s=stwm-20170627; d=stwm.de; t=1579696057; a=rsa-sha256;
        cv=none;
        b=PYD20WI5OY+X/YqOle3ZO4dhKE9rkc9e0Ya/7H8dkFEi0zGl/myiZ1+3NzLc/I6Ex3FXb9
        zshzNCFGw3RL4Y6iGYM1LP84GHm6/x/ezVzC33BKMthzHQKAzsgoADGGfamJC4YVYCl/Kj
        V96jvuv6TByI24uwhbyE8+i0AQQ8xD7sUB8a3fjiiWx22vUhwhxEcErgrsvc+qz/P38SyJ
        yB0kuTmTm4+3pTChKzdbrzKItiESq9fqsK5lQ0exwdQ+1zhNy3ug/G+ind9cL4xzkBSNub
        VHMxqtsSzSJwTEEJyeuz02XCsIxT1FdWIecYnZ9I7UYfJtlxuglcw35l1OqlPg==
ARC-Authentication-Results: i=1;
        email.studentenwerk.mhn.de;
        none
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Montag, 20. Januar 2020, 13:21:36 schrieb David Miller:
> From: "xiaofeng.yan" <xiaofeng.yan2012@gmail.com>
> Date: Mon, 20 Jan 2020 14:26:39 +0800
>=20
> > From: "xiaofeng.yan" <yanxiaofeng7@jd.com>
> >=20
> > A compliation error happen when building branch 5.5-rc7
> >=20
> > In file included from net/hsr/hsr_main.c:12:0:
> > net/hsr/hsr_main.h:194:20: error: two or more data types in declara=
tion
> > specifiers>=20
> >  static inline void void hsr_debugfs_rename(struct net_device *dev)=

> >=20
> > So Removed one void.
> >=20
> > Fixes: 4c2d5e33dcd3 ("hsr: rename debugfs file when interface name =
is
> > changed") Signed-off-by: xiaofeng.yan <yanxiaofeng7@jd.com>
> > Acked-by: Taehee Yoo <ap420073@gmail.com>
>=20
> Applied, thank you.

This seems to be the same fix as the fix from Arnd Bergmann:

=09https://lkml.org/lkml/2020/1/7/876

which was applied to net-next:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/com=
mit/?id=3Db9ae51273655a72a12fba730843fd72fb132735a

Regards,
--=20
Wolfgang Walter
Studentenwerk M=FCnchen
Anstalt des =F6ffentlichen Rechts
