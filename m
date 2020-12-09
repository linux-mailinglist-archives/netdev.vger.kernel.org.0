Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1E92D44B0
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733214AbgLIOsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 09:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733204AbgLIOsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 09:48:36 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637FCC0613CF;
        Wed,  9 Dec 2020 06:47:56 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id r7so2027805wrc.5;
        Wed, 09 Dec 2020 06:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=1jMH+ref8olXwFL13zzKjNNaPpUOj2kHGlWvKjzwLz4=;
        b=ISTf/EdwqrYQHuEoIxf3m4dpM+Lq4AvfzxNE/8vgt0ECLLdRSnj70SlPoCyoVOI/ao
         3+eqnNUqyemHf85Ua4sPJpKBgPyzjYb9UPblySo99VJEoYUJAsymRVjKKbSy6jQeVoyI
         b+7zPl8o77i8taRUYE5OuBtQ6MUF48y/+RePXyhYcezDZ251vHqCU47AuqB9Goj0Gsrf
         lZK1/Ui/vM8lSVtskKBH6yzZQJ0zhDdiujpIebkYNcCEWQeP3DB6U28RtNH2q9T/GClj
         4cQ8XRTxJ/F2mRaqUqTy10FKTyTpwZp57W8dOILaDjsIG9j+OsnRqPoZYKUjAol2TV1z
         v/fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=1jMH+ref8olXwFL13zzKjNNaPpUOj2kHGlWvKjzwLz4=;
        b=j2KSsYGKF8N09PwSMv9kVsMjq22SFotQA+vR1JZkhoVTuWffsGwvwKOVwhyArQPAds
         1zO11kxJnFeBC4DuEaIi1N02AQPe3l8XBuRQKeNSexCCEfGRwyDML0IUeQht8QlLsWmT
         6reUODXrBKUuwvqb2q7GvEVNMR4TNdePRYDz1PHpjmnrt9L37qhx6YgqLZFZU7UJhVeC
         hBDFPjkWvwf2MgTAMr4zmRAc8eal8NRe0WsucRMuxJ2B/Jcj36pzGR3VBkDK4LnQ9Eig
         zYeqEJt8+USnXhjlD2H6PdywQ3Z7enEkWwVm5KloXuIMVuiL/dvfXoVPY6/YW7d8Kb4s
         dvVQ==
X-Gm-Message-State: AOAM5329FS894lYTUq+71MP2O+XaOTYSDoGuFfTKUQ4nAZ62FMFAHsV0
        1/WH2Xz93YFHfq3T0VTT4xmRWNnx/yHlPNsR
X-Google-Smtp-Source: ABdhPJygTRZ5VeIKJQNgfXmcZYWG0GGq7+wzgI4RBRIc7fRZD7MbFRmmSJOVIwVZjLs+9jJxydo/pQ==
X-Received: by 2002:adf:ead1:: with SMTP id o17mr3219775wrn.396.1607525274803;
        Wed, 09 Dec 2020 06:47:54 -0800 (PST)
Received: from [10.11.11.4] ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id j2sm4048820wrt.35.2020.12.09.06.47.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Dec 2020 06:47:54 -0800 (PST)
From:   Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.31\))
Subject: Urgent: BUG: PPP ioctl Transport endpoint is not connected
Message-Id: <83C781EB-5D66-426E-A216-E1B846A3EC8A@gmail.com>
Date:   Wed, 9 Dec 2020 16:47:52 +0200
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
To:     "linux-kernel@vger kernel. org" <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.3654.40.0.2.31)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All

I have problem with latest kernel release=20
And the problem is base on this late problem :


=
https://www.mail-archive.com/search?l=3Dnetdev@vger.kernel.org&q=3Dsubject=
:%22Re%5C%3A+ppp%5C%2Fpppoe%2C+still+panic+4.15.3+in+ppp_push%22&o=3Dnewes=
t&f=3D1

I have same problem in kernel 5.6 > now I use kernel 5.9.13 and have =
same problem.


In kernel 5.9.13 now don=E2=80=99t have any crashes in dimes but in one =
moment accel service stop with defunct and in log have many of this line =
:


error: vlan608: ioctl(PPPIOCCONNECT): Transport endpoint is not =
connected
error: vlan617: ioctl(PPPIOCCONNECT): Transport endpoint is not =
connected
error: vlan679: ioctl(PPPIOCCONNECT): Transport endpoint is not =
connected

In one moment connected user bump double or triple and after that =
service defunct and need wait to drop all session to start .

I talk with accel-ppp team and they said this is kernel related problem =
and to back to kernel 4.14 there is not this problem.

Problem is come after kernel 4.15 > and not have solution to this =
moment.

Please help to find the problem.

Last time in link I see is make changes in ppp_generic.c=20

ppp_lock(ppp);
        spin_lock_bh(&pch->downl);
        if (!pch->chan) {
                /* Don't connect unregistered channels */
                spin_unlock_bh(&pch->downl);
                ppp_unlock(ppp);
                ret =3D -ENOTCONN;
                goto outl;
        }
        spin_unlock_bh(&pch->downl);


But this fix only to don=E2=80=99t display error and freeze system=20
The problem is stay and is to big.


Please help to fix.



