Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9661497F38
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 17:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbfHUPnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 11:43:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48020 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727894AbfHUPng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 11:43:36 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7LFh4sE140347
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 11:43:35 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uh81xtun8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 11:43:35 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <zohar@linux.ibm.com>;
        Wed, 21 Aug 2019 16:43:32 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 21 Aug 2019 16:43:29 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7LFhSk936306986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 15:43:28 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89B9752050;
        Wed, 21 Aug 2019 15:43:28 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.219.114])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2390052054;
        Wed, 21 Aug 2019 15:43:24 +0000 (GMT)
Subject: Re: [GIT PULL] Keys: Set 4 - Key ACLs for 5.3
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     David Howells <dhowells@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>, keyrings@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, linux-nfs@vger.kernel.org,
        CIFS <linux-cifs@vger.kernel.org>, linux-afs@lists.infradead.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Date:   Wed, 21 Aug 2019 11:43:23 -0400
In-Reply-To: <23498.1565962602@warthog.procyon.org.uk>
References: <1562814435.4014.11.camel@linux.ibm.com>
         <28477.1562362239@warthog.procyon.org.uk>
         <CAHk-=wjxoeMJfeBahnWH=9zShKp2bsVy527vo3_y8HfOdhwAAw@mail.gmail.com>
         <20190710194620.GA83443@gmail.com> <20190710201552.GB83443@gmail.com>
         <CAHk-=wiFti6=K2fyAYhx-PSX9ovQPJUNp0FMdV0pDaO_pSx9MQ@mail.gmail.com>
         <23498.1565962602@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19082115-0028-0000-0000-0000039227A6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082115-0029-0000-0000-000024544FC7
Message-Id: <1566402203.5162.12.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-21_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908210163
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-08-16 at 14:36 +0100, David Howells wrote:
> Mimi Zohar <zohar@linux.ibm.com> wrote:
> 
> > Sorry for the delay.  An exception is needed for loading builtin keys
> > "KEY_ALLOC_BUILT_IN" onto a keyring that is not writable by userspace.
> >  The following works, but probably is not how David would handle the
> > exception.
> 
> I think the attached is the right way to fix it.
> 
> load_system_certificate_list(), for example, when it creates keys does this:
> 
> 	key = key_create_or_update(make_key_ref(builtin_trusted_keys, 1),
> 
> marking the keyring as "possessed" in make_key_ref().  This allows the
> possessor permits to be used - and that's the *only* way to use them for
> internal keyrings like this because you can't link to them and you can't join
> them.

In addition, as long as additional keys still can't be added or
existing keys updated by userspace on the .builtin_trusted_keys, then
this is fine.

> 
> David
> ---
> diff --git a/certs/system_keyring.c b/certs/system_keyring.c
> index 57be78b5fdfc..1f8f26f7bb05 100644
> --- a/certs/system_keyring.c
> +++ b/certs/system_keyring.c
> @@ -99,7 +99,7 @@ static __init int system_trusted_keyring_init(void)
>  	builtin_trusted_keys =
>  		keyring_alloc(".builtin_trusted_keys",
>  			      KUIDT_INIT(0), KGIDT_INIT(0), current_cred(),
> -			      &internal_key_acl, KEY_ALLOC_NOT_IN_QUOTA,
> +			      &internal_keyring_acl, KEY_ALLOC_NOT_IN_QUOTA,
>  			      NULL, NULL);
>  	if (IS_ERR(builtin_trusted_keys))
>  		panic("Can't allocate builtin trusted keyring\n");
> diff --git a/security/keys/permission.c b/security/keys/permission.c
> index fc84d9ef6239..86efd3eaf083 100644
> --- a/security/keys/permission.c
> +++ b/security/keys/permission.c
> @@ -47,7 +47,7 @@ struct key_acl internal_keyring_acl = {
>  	.usage	= REFCOUNT_INIT(1),
>  	.nr_ace	= 2,
>  	.aces = {
> -		KEY_POSSESSOR_ACE(KEY_ACE_SEARCH),
> +		KEY_POSSESSOR_ACE(KEY_ACE_SEARCH | KEY_ACE_WRITE),
>  		KEY_OWNER_ACE(KEY_ACE_VIEW | KEY_ACE_READ | KEY_ACE_SEARCH),
>  	}
>  };

Thanks, David.  The builtin keys are now being loaded.

Mimi

