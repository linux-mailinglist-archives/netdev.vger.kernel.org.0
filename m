Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6635FFA2F
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 15:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiJONNe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 15 Oct 2022 09:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiJONNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 09:13:33 -0400
X-Greylist: delayed 903 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 15 Oct 2022 06:13:29 PDT
Received: from symantec4.comsats.net.pk (symantec4.comsats.net.pk [203.124.41.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2D645F78
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 06:13:29 -0700 (PDT)
X-AuditID: cb7c291e-7bdff700000061a5-16-634a9c8bddbb
Received: from host201505.comsatshosting.com (host201505.comsatshosting.com [210.56.11.66])
        (using TLS with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        by symantec4.comsats.net.pk (Symantec Messaging Gateway) with SMTP id 1C.F5.24997.B8C9A436; Sat, 15 Oct 2022 16:42:04 +0500 (PKT)
Received: from [103.145.253.52] (UnknownHost [103.145.253.52]) by host201505.comsatshosting.com with SMTP;
   Sat, 15 Oct 2022 18:02:54 +0500
Message-ID: <1C.F5.24997.B8C9A436@symantec4.comsats.net.pk>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Description: Mail message body
Subject: Hello!
To:     netdev@vger.kernel.org
From:   "Wahid Majrooh" <tj@riazeda.com.pk>
Date:   Sat, 15 Oct 2022 05:57:48 -0700
Reply-To: wfnngaf@gmail.com
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ta0gUURTHu7vjOq57cxxf1zULhhJ8pAkVQVESJGZCVvbFSh3X0ZVdZ21n
        fGwP0II2lhDRBBOr3UxREyo1lcyU/WBqRKKbmAUSBKGCIFH0+FD3rrvufDmc+Z25/3PO/87Q
        avZhsJ4uF2XBKvJmTqOl5g6FHt97pz3bsM8+SR2adEZngKzv/TtzQb72SIlgLq8WrGlHi7RG
        z9ATUNkEagcczzV1wOQAITRi9qPv736rHEBLs8ykCr10vgGbDw0AjbZOq8hbkDmM/s17KJKr
        mVS02HJXs8nD0fS9rz6ejLpca2oHoHGegH44ZIIjmDA04vZ4X49k9GhjZDiY5BomEdUvD3g5
        xexBTb9vBJGcZeLQXF8n1Qhgm6Jbm6Jbm6JbW6CbE1C9AEm2Ch5bY9ifarBUSLwspYqCnFpp
        6gfYqLfXEneOgM453g0YGnA62F140sAG8dX4lBucolVcFDQOYrS92FJiM/KSsdBaZRYkLhKu
        ubINLNzCxVVmE6eHv/owjdiiolAjmQUZ34wbIFpNjnFYDZbwtiuC1bIp5gZxNMXFwLyDH3iW
        KeNlwSQIlYLVX82jaQ5BdS9WDrcKZUJtablZ9pfxuZzbuMIoK95h4qHtVaaBjVYWlPOo6BA3
        yKJ1eKhtj8kuUiVfIZWX+XQj4HoOpjo/9WrGwikyBuuHAb0ZYAf0M9fYmJoe8MbmRyQ+aBjH
        cdkzi+OLqQUcfww5JtQsJVpEQR8DrxI5hsgZq8StpfTRMH8Jzx6mKJD++h0waAHzKAUPjOD/
        8lfBCXyXEfAcuQsd/i8CS7HQ04FhqA96d0KwrptY62MBvVXsjgq70zmTSdyReVnpTvx4JnHH
        R33uRBLI+mFASl8HntrXC3ajjJYw5nzXZPTs6bJhS0fGvOZL7Ybu488LCT1n/lwffO2cWUme
        Cb6lTRlmtNW7BuNcPUvzqsYDttzkm2lpHttfqqQ1eE4s/ZYyn3sptsU+W5TEXl4zr3D20/ez
        LoJ6LrY9473lrMvZ0Lx4TS49NlHzqbOgul/8PFqQzlGSkU9PUlsl/j/VRd0AMgQAAA==
X-Spam-Status: Yes, score=7.9 required=5.0 tests=BAYES_50,
        FREEMAIL_FORGED_REPLYTO,HK_RANDOM_REPLYTO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [203.124.41.30 listed in list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5001]
        *  1.0 HK_RANDOM_REPLYTO Reply-To username looks random
        *  3.3 RCVD_IN_SBL_CSS RBL: Received via a relay in Spamhaus SBL-CSS
        *      [103.145.253.52 listed in zen.spamhaus.org]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.7 SPF_SOFTFAIL SPF: sender does not match SPF record (softfail)
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Compliment,

It will be a pleasure to discuss an important issue with you on area of Investment. My name is Abdul from Kabul


Abdul


