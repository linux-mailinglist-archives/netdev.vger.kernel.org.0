Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01DA04C0045
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbiBVRmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbiBVRl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:41:59 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF286394
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 09:41:32 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id m1-20020a17090a668100b001bc023c6f34so226023pjj.3
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 09:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=A2MC21KCsKq/URnkpZqrPsmsNGPhb59wpeK0W4mJwVk=;
        b=rnRP40f6XwJWgur2yEDz0tzKznIv5VnqEVrKRPzn89zfocsUbimRjXf2kpTFIpIu7j
         wS90n9Olt2wd3IFNmpt6nZOEUFtx98Hx5Zs8f4HT7aDJ5oO5AhRuN/8D5R1+vT4RnZxA
         8MtNeFip+kfapamXqVxVP0d+7rB+bkruB1VDcLR9lzWM7Mfmunb4Y0AZ7bA2ALt/ptpw
         pXu0rysLI+zTYSM/Hul37nZhTMRzGT8CNA/+pF30e6Bd513AZ1OZgA7+h8Gr8qMgPH6V
         /hPuVfzs7u+imlHmq7Cf5KkRjqZF4itNFxkwuPaTTjB+UrAPAqKwwAboR2uXew+70+7O
         cUzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=A2MC21KCsKq/URnkpZqrPsmsNGPhb59wpeK0W4mJwVk=;
        b=1+cNd4VIJFbyoa94ww2rmGv9s4JgRasQdw2gZOtBjtNvcDT1ivGETZ1t1DqrdLPG2c
         kYop7sB9MCU2sl4qNvbtJBuuwxNqyH9AbslpGPidFIyte8JjwMmXkCOCSLEpe2y/bv6o
         4uIb2HPrvlMjpa3bUCNNLPQIVce0mKjVMWBoRKtWijzwyx8muCenUzTqfVJxcoZ0sJK7
         jOXY8u/22zr8EEn8e1FdvgZmObttqlcu6k/dc4xqw1kMERVP3cL/FkFBNl+Lax3M1wHb
         wzUHcmu9HGpFrKBDUWgbMZKSejuNWxR7GcwSqi0tBZwRslnrWNts/1XYmuS3tbYmE4GI
         7GqQ==
X-Gm-Message-State: AOAM533K9NqCNmFqFW6o8Iq44QgCBzxVymFq0RiUCODIjZnX1GebdFur
        HLt7UT60JyjDxRVWg9xhLGmF/anD4CtLccgF
X-Google-Smtp-Source: ABdhPJxPI6hmmCcgcn61LFTGcXMGK7lfOuTPirw1q7Ja+ADWYj0B2ABVCBXj6+BDK/v5tfJu0Pj97g==
X-Received: by 2002:a17:903:230e:b0:14d:a8c5:90c2 with SMTP id d14-20020a170903230e00b0014da8c590c2mr24651877plh.5.1645551691320;
        Tue, 22 Feb 2022 09:41:31 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id j15sm18934353pfj.102.2022.02.22.09.41.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 09:41:30 -0800 (PST)
Date:   Tue, 22 Feb 2022 09:41:27 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 215633] New: =?UTF-8?B?R0VORVZF77yaY2Fubm90?= support bind
 listening address
Message-ID: <20220222094128.2d0a8882@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Tue, 22 Feb 2022 12:39:10 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 215633] New: GENEVE=EF=BC=9Acannot support bind listening add=
ress


https://bugzilla.kernel.org/show_bug.cgi?id=3D215633

            Bug ID: 215633
           Summary: GENEVE=EF=BC=9Acannot support bind listening address
           Product: Networking
           Version: 2.5
    Kernel Version: 4.19.90
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: rmsh1216@163.com
        Regression: No

when create geneve interface and turn it up, then found the specified port =
is
listening at 0.0.0.0 address.

[root@localhost ~]# ip link add geneve1 type geneve id 2 dstport 6081 remote
10.10.10.2
[root@localhost ~]# netstat -apntu|grep 6081
udp        0      0 0.0.0.0:6081            0.0.0.0:*                      =
   =20
-

read the code, the geneve driver initializes the IP address to 0 by default=
. It
does not support setting the listening address.

static struct socket *geneve_create_sock(struct net *net, bool ipv6,
                                         __be16 port, bool ipv6_rx_csum)
{
        struct socket *sock;
        struct udp_port_cfg udp_conf;
        int err;

        memset(&udp_conf, 0, sizeof(udp_conf));

        if (ipv6) {
                udp_conf.family =3D AF_INET6;
                udp_conf.ipv6_v6only =3D 1;
                udp_conf.use_udp6_rx_checksums =3D ipv6_rx_csum;
        } else {
                udp_conf.family =3D AF_INET;
                udp_conf.local_ip.s_addr =3D htonl(INADDR_ANY);
        }

        udp_conf.local_udp_port =3D port;

        /* Open UDP socket */
        err =3D udp_sock_create(net, &udp_conf, &sock);
        if (err < 0)
                return ERR_PTR(err);

        return sock;
}

It is necessary to support configurable listening address for the reaseon t=
hat=20
0.0.0.0 address listen is not safe.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
