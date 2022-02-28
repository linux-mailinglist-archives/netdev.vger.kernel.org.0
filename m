Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238C14C656D
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 10:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbiB1JIU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 28 Feb 2022 04:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbiB1JIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 04:08:18 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33559BC13;
        Mon, 28 Feb 2022 01:07:35 -0800 (PST)
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K6ZHg1qLBz67NYn;
        Mon, 28 Feb 2022 17:06:23 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Feb 2022 10:07:33 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2308.021;
 Mon, 28 Feb 2022 10:07:33 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Mimi Zohar <zohar@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "revest@chromium.org" <revest@chromium.org>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 0/6] bpf-lsm: Extend interoperability with IMA
Thread-Topic: [PATCH v2 0/6] bpf-lsm: Extend interoperability with IMA
Thread-Index: AQHYImlgJM6Z1962JUm5hvc+dgM0dqyjZeaAgACU/jCAAKZjAIAEHfiw
Date:   Mon, 28 Feb 2022 09:07:33 +0000
Message-ID: <8eeb74eea6564e3c819a2caca58b714a@huawei.com>
References: <20220215124042.186506-1-roberto.sassu@huawei.com>
         <408a96085814b2578486b2859e63ff906f5e5876.camel@linux.ibm.com>
         <5117c79227ce4b9d97e193fd8fb59ba2@huawei.com>
 <223d9eedc03f68cfa4f1624c4673e844e29da7d5.camel@linux.ibm.com>
In-Reply-To: <223d9eedc03f68cfa4f1624c4673e844e29da7d5.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.204.63.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Mimi Zohar [mailto:zohar@linux.ibm.com]
> Sent: Friday, February 25, 2022 8:11 PM
> On Fri, 2022-02-25 at 08:41 +0000, Roberto Sassu wrote:
> > > From: Mimi Zohar [mailto:zohar@linux.ibm.com]
> > > Sent: Friday, February 25, 2022 1:22 AM
> > > Hi Roberto,
> > >
> > > On Tue, 2022-02-15 at 13:40 +0100, Roberto Sassu wrote:
> > > > Extend the interoperability with IMA, to give wider flexibility for the
> > > > implementation of integrity-focused LSMs based on eBPF.
> > >
> > > I've previously requested adding eBPF module measurements and signature
> > > verification support in IMA.  There seemed to be some interest, but
> > > nothing has been posted.
> >
> > Hi Mimi
> >
> > for my use case, DIGLIM eBPF, IMA integrity verification is
> > needed until the binary carrying the eBPF program is executed
> > as the init process. I've been thinking to use an appended
> > signature to overcome the limitation of lack of xattrs in the
> > initial ram disk.
> 
> I would still like to see xattrs supported in the initial ram disk.
> Assuming you're still interested in pursuing it, someone would need to
> review and upstream it.  Greg?

I could revise this work. However, since appended signatures
would work too, I would propose to extend this appraisal
mode to executables, if it is fine for you.

> > At that point, the LSM is attached and it can enforce an
> > execution policy, allowing or denying execution and mmap
> > of files depending on the digest lists (reference values) read
> > by the user space side.
> >
> > After the LSM is attached, IMA's job would be just to calculate
> > the file digests (currently, I'm using an audit policy to ensure
> > that the digest is available when the eBPF program calls
> > bpf_ima_inode_hash()).
> >
> > The main benefit of this patch set is that the audit policy
> > would not be required and digests are calculated only when
> > requested by the eBPF program.
> 
> Roberto, there's an existing eBPF integrity gap that needs to be
> closed, perhaps not for your usecase, but in general.  Is that
> something you can look into?

It could be possible I look into it.

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Zhong Ronghua
