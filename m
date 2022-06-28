Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC9255DD5E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345681AbiF1McN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Jun 2022 08:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345614AbiF1McL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 08:32:11 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F9B2E9C3;
        Tue, 28 Jun 2022 05:32:11 -0700 (PDT)
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LXP8t3QSTz6855h;
        Tue, 28 Jun 2022 20:31:26 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 28 Jun 2022 14:32:09 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Tue, 28 Jun 2022 14:32:09 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "kafai@fb.com" <kafai@fb.com>, "yhs@fb.com" <yhs@fb.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>
CC:     "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 5/5] selftests/bpf: Add test for
 bpf_verify_pkcs7_signature() helper
Thread-Topic: [PATCH v6 5/5] selftests/bpf: Add test for
 bpf_verify_pkcs7_signature() helper
Thread-Index: AQHYiuqztw8/FQ63U0mmvw4+rrmglK1kwAzg
Date:   Tue, 28 Jun 2022 12:32:09 +0000
Message-ID: <96c8a537297242f9a01b8124179611d6@huawei.com>
References: <20220628122750.1895107-1-roberto.sassu@huawei.com>
 <20220628122750.1895107-6-roberto.sassu@huawei.com>
In-Reply-To: <20220628122750.1895107-6-roberto.sassu@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.221.98.153]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Roberto Sassu
> Sent: Tuesday, June 28, 2022 2:28 PM
> Ensure that signature verification is performed successfully from an eBPF
> program, with the new bpf_verify_pkcs7_signature() helper.
> 
> Generate a testing signature key and compile sign-file from scripts/, so
> that the test is selfcontained. Also, search for the tcb_bic.ko kernel
> module, parse it in user space to extract the raw PKCS#7 signature and send
> it to the eBPF program for signature verification. If tcb_bic.ko is not
> found, the test does not fail.

Ops, tcp_bic.ko.

Roberto
