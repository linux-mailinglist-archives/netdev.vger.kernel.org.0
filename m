Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69CD165072
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 05:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfGKDMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 23:12:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25080 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726353AbfGKDMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 23:12:03 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6B3BtMi102532
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 23:12:02 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tnvf3grrx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 23:11:56 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <zohar@linux.ibm.com>;
        Thu, 11 Jul 2019 04:07:31 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 11 Jul 2019 04:07:28 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6B37F0p35652076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 03:07:15 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5429A405B;
        Thu, 11 Jul 2019 03:07:27 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 735A7A4054;
        Thu, 11 Jul 2019 03:07:26 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.110.74])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Jul 2019 03:07:26 +0000 (GMT)
Subject: Re: [GIT PULL] Keys: Set 4 - Key ACLs for 5.3
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>, keyrings@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, linux-nfs@vger.kernel.org,
        CIFS <linux-cifs@vger.kernel.org>, linux-afs@lists.infradead.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Date:   Wed, 10 Jul 2019 23:07:15 -0400
In-Reply-To: <CAHk-=wiFti6=K2fyAYhx-PSX9ovQPJUNp0FMdV0pDaO_pSx9MQ@mail.gmail.com>
References: <28477.1562362239@warthog.procyon.org.uk>
         <CAHk-=wjxoeMJfeBahnWH=9zShKp2bsVy527vo3_y8HfOdhwAAw@mail.gmail.com>
         <20190710194620.GA83443@gmail.com> <20190710201552.GB83443@gmail.com>
         <CAHk-=wiFti6=K2fyAYhx-PSX9ovQPJUNp0FMdV0pDaO_pSx9MQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19071103-4275-0000-0000-0000034BBC6E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071103-4276-0000-0000-0000385BC1F1
Message-Id: <1562814435.4014.11.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-10_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907110035
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

On Wed, 2019-07-10 at 18:59 -0700, Linus Torvalds wrote:
> Anyway, since it does seem like David is offline, I've just reverted
> this from my tree, and will be continuing my normal merge window pull
> requests (the other issues I have seen have fixes in their respective
> trees).

Sorry for the delay.  An exception is needed for loading builtin keys
"KEY_ALLOC_BUILT_IN" onto a keyring that is not writable by userspace.
 The following works, but probably is not how David would handle the
exception.

diff --git a/security/keys/key.c b/security/keys/key.c
index 519211a996e7..a99332c1e014 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -896,7 +896,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
        /* if we're going to allocate a new key, we're going to have
         * to modify the keyring */
        ret = key_permission(keyring_ref, KEY_NEED_WRITE);
-       if (ret < 0) {
+       if (ret < 0 && !(flags & KEY_ALLOC_BUILT_IN)) {
                key_ref = ERR_PTR(ret);
                goto error_link_end;
        }

Mimi

