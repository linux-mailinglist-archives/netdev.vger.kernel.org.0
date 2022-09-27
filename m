Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00BF35EC924
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 18:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbiI0QMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 12:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233039AbiI0QL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 12:11:57 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2FC110B
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 09:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1664295075;
        bh=at5PEYB7MYYtYEPJSTehbMaiU2dsQ9XOsVfiFS1Scms=;
        h=X-UI-Sender-Class:Date:From:To:Subject;
        b=HBNcO5NmDQWgyJdPoOOfnshpbTeBPpjvpo1wP7DZuZMaxS5HST+df28Q1y4m6C7Fl
         eeWLQ49Ls2Sm2MtF4g95r9BwVH1j7i4yaptE0pvzvrmgrnwRmq1Xz+YqdGZSNeBfQB
         4NonpYmISCHmM0rE2POEJZ80392Pxmia1isWfh3E=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from gmx.fr ([181.118.49.178]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mv31c-1pUDKt0THk-00r3sl for
 <netdev@vger.kernel.org>; Tue, 27 Sep 2022 18:11:15 +0200
Date:   Tue, 27 Sep 2022 12:11:06 -0400
From:   Jamie Gloudon <jamie.gloudon@gmx.fr>
To:     netdev@vger.kernel.org
Subject: ip: Missing brace in ip6tunnel.c
Message-ID: <YzMgmkVJBmzZpG7E@gmx.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Provags-ID: V03:K1:hFQqODzExokhQqNsMLbpargECnTp90Y7F5JtcVL6o34MK2ghU6r
 UDo2WbRjGNztCjqiP+lfPshN4T0jGW0Wh2t9wsk2XZf6UfuPfNBCVeOUci+UUwdXht8zwKR
 IshwuPAJmWhfq8KrK30OEJTcaXGLEtJmskuCjOglYcXn3v1xcb5Pw2GhubSaYs1sJY5Y1gQ
 atWVd6rIGwA+Sz/WzCJag==
X-UI-Out-Filterresults: notjunk:1;V03:K0:14Pbfohhrkw=:norFcMYHFFvLCUeIjU79RO
 kUpX3BwBRmLlq3tBg4GmrTM0VM6jmwPNIWAeJngfmiuBdfEppCHctMmFmikufZlaIh5ovZK3b
 2vd3gLAskZ10yp9szi4k28WDA1yCsIqqW6tlbYyKf4xzLxi7vtkA6NaP5gdjc8XlDmnkiULdq
 QR44RaNCaqJEiNdGxTijTnLR7v7PMghDP/t7f5QnjDxrjq8z80fPyfrHbHNzIsU1xkjHJa9JU
 wa77S/P1CE9l6RJcWbP9Eoqet49GB2H2bv5UHYsovnsi5MZpR3FdYM5vKz5jstK4vXgWz85UZ
 tfDba41eUXSqYt+mpaRr0deoNzzPol/sgyMs6TdtmJFSx8Wr2ggnSEsNjoQ0bfC7sAE0AR+Yb
 EsCJuFOvoM/ljcZSsdEzw8kUYCEslFsyAxnx2SbTnhcn/+BBszTAykEWhoCCr4BZk6ZVXmCZA
 k2fvFUU9YPy5xdAXb3ivAWhjf5u9tjpYeLSRXmXd/aoggXKv2dV3w0Fr/yZNWL0pc3e4Jqt6f
 3teIAOZmw8obW+brxf7sCH0Vk4JI19WcVOmt+qcu86/A4mHGIxT3XB/3lwyG07TxbX3+GjaA3
 m1IxNGeJzch+VJpdS/Sh2dMiqrr5pLBfbl1hpzHD4yBXi7KrsUQnAcQVKOJm53X0KUISoBa93
 5lIbiP5QLIb7X+Q/YrMjQH6ND7DbafUQUoThLvOoTUpCCVpnuO6z1WP+vl57hJ1tPQUs7x0Xs
 1oJwqMG0GF9OQoNPTcp25OpMxd1WktpXqJ9bjIf1/L7chW8CiM7b0CWilCIjvldDP65FkvUjj
 +bHJCXLpdPNSClI8rGigEDcLyvvh4yRUzukOGPGBhEjo7psJjY3KuCgoRVvtXzEcJteBiwLEH
 SkwZEqV1hG7VTPcXf+3x+ly8pSnwtOVjBBak75wb33FmoV7TcDhLoJ6gqINkItKU9tPT3q7f2
 e/vPDtB5llq57hKyencNin+Pv9JYnFnYWfoXhHurmsGOOl2CMwHJINFGWwX/P0haeliD3yKmM
 R7osXBE6/gudHt4PIcgF8bSMau1WWB1kfKuuERIIy21/2IVeZDc/P7t/OPk0qRv1sJkhX6FcO
 va6Bh8XkS4nhH9XGbatUvjaMn8wlcYKe3l8Zw5bdLrI6qMVsaBPFOhJPj2cGI1rvqgrRky8d4
 TxQe0tmgGU3m5yNPps/svIDNZ+
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_BL,
        RCVD_IN_MSPIKE_ZBI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey,
    I am not absolutely sure, but in line 165 of ip6tunnel.c should be
if(t && (t->dev->flags & IFF_UP) like line 169?

Regards
