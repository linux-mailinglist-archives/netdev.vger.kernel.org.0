Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3D94C5DE0
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 18:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiB0Rry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 12:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiB0Rrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 12:47:52 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF1D192B8;
        Sun, 27 Feb 2022 09:47:15 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21RFhvWH024416;
        Sun, 27 Feb 2022 17:46:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=1QT+MIO5sQ0+JqoR5oSJ3DCQEEiRdGdRmp8VLGdPWfY=;
 b=TXdyGagn3Hf+0Sh+VqIUC5zyVVR6UFq80qAi/s4LALIjFggi5sMFOqzMYL94MPrUgQlr
 6uBPZXhdOEI1/A9z+raQTshHas3+aFpHrZspt621RTAAGadagwavc69TQKeNrN7dDLnY
 3qfclnz64nk69u8hVnHNvz4mAZsRHAylUhunkb0DNdee/xhuIwTFexSd9xZ++NvoYcHm
 l2es5TZJHzvxfdIuvUpKqilRWIPAbo5V2emias6B44l4MU2cvjgy/rKLbsn7SPb0yRdW
 wJAKIEApKK+3xzmkBTZqhKbY1/qPFGfH9ZgtezTp28Mz2YTZWPJfRFK9YGeM9ZkMiqcr zg== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3egc6u9ffy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Feb 2022 17:46:55 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21RHgqKh008397;
        Sun, 27 Feb 2022 17:46:53 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3efbu8vr5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Feb 2022 17:46:53 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21RHkpUP45220184
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 27 Feb 2022 17:46:51 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E491811C05B;
        Sun, 27 Feb 2022 17:46:50 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA03411C050;
        Sun, 27 Feb 2022 17:46:48 +0000 (GMT)
Received: from sig-9-65-89-64.ibm.com (unknown [9.65.89.64])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun, 27 Feb 2022 17:46:48 +0000 (GMT)
Message-ID: <8b140d740ccb813a3fabacd928a5dc3499f145db.camel@linux.ibm.com>
Subject: Re: [PATCH v2 0/6] bpf-lsm: Extend interoperability with IMA
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Roberto Sassu <roberto.sassu@huawei.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "revest@chromium.org" <revest@chromium.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Sun, 27 Feb 2022 12:46:48 -0500
In-Reply-To: <YhnfzipoU1NbkjQQ@kroah.com>
References: <20220215124042.186506-1-roberto.sassu@huawei.com>
         <408a96085814b2578486b2859e63ff906f5e5876.camel@linux.ibm.com>
         <5117c79227ce4b9d97e193fd8fb59ba2@huawei.com>
         <223d9eedc03f68cfa4f1624c4673e844e29da7d5.camel@linux.ibm.com>
         <YhnfzipoU1NbkjQQ@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: E-5Jt3XnaWTAon6wvc8bbVIw6kQEakXm
X-Proofpoint-GUID: E-5Jt3XnaWTAon6wvc8bbVIw6kQEakXm
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-27_07,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 adultscore=0 suspectscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202270122
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-02-26 at 09:07 +0100, Greg Kroah-Hartman wrote:
> On Fri, Feb 25, 2022 at 02:11:04PM -0500, Mimi Zohar wrote:
> > On Fri, 2022-02-25 at 08:41 +0000, Roberto Sassu wrote:
> > > > From: Mimi Zohar [mailto:zohar@linux.ibm.com]
> > > > Sent: Friday, February 25, 2022 1:22 AM
> > > > Hi Roberto,
> > > > 
> > > > On Tue, 2022-02-15 at 13:40 +0100, Roberto Sassu wrote:
> > > > > Extend the interoperability with IMA, to give wider flexibility for the
> > > > > implementation of integrity-focused LSMs based on eBPF.
> > > > 
> > > > I've previously requested adding eBPF module measurements and signature
> > > > verification support in IMA.  There seemed to be some interest, but
> > > > nothing has been posted.
> > > 
> > > Hi Mimi
> > > 
> > > for my use case, DIGLIM eBPF, IMA integrity verification is
> > > needed until the binary carrying the eBPF program is executed
> > > as the init process. I've been thinking to use an appended
> > > signature to overcome the limitation of lack of xattrs in the
> > > initial ram disk.
> > 
> > I would still like to see xattrs supported in the initial ram disk. 
> > Assuming you're still interested in pursuing it, someone would need to
> > review and upstream it.  Greg?
> 
> Me?  How about the filesystem maintainers and developers?  :)
> 
> There's a reason we never added xattrs support to ram disks, but I can't
> remember why...

CPIO 'newc' format doesn't support xattrs.

thanks,

Mimi

