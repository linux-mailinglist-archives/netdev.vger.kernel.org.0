Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1A854A843
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 06:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237409AbiFNEok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 00:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiFNEoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 00:44:38 -0400
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032D52E9E4;
        Mon, 13 Jun 2022 21:44:37 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:60056)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1o0yPs-002t3o-D4; Mon, 13 Jun 2022 22:44:36 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:40374 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1o0yPr-008Y07-9H; Mon, 13 Jun 2022 22:44:36 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-cachefs@redhat.com, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, selinux@vger.kernel.org,
        serge@hallyn.com, amir73il@gmail.com, kernel-team@cloudflare.com,
        Jeff Moyer <jmoyer@redhat.com>,
        Paul Moore <paul@paul-moore.com>
References: <20220608150942.776446-1-fred@cloudflare.com>
        <87tu8oze94.fsf@email.froward.int.ebiederm.org>
        <e1b62234-9b8a-e7c2-2946-5ef9f6f23a08@cloudflare.com>
Date:   Mon, 13 Jun 2022 23:44:28 -0500
In-Reply-To: <e1b62234-9b8a-e7c2-2946-5ef9f6f23a08@cloudflare.com> (Frederick
        Lawler's message of "Mon, 13 Jun 2022 15:52:38 -0500")
Message-ID: <87y1xzyhub.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1o0yPr-008Y07-9H;;;mid=<87y1xzyhub.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1+prA+7T4gv0KWu4+rCykKSU9Ye39R87hA=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Frederick Lawler <fred@cloudflare.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 540 ms - load_scoreonly_sql: 0.07 (0.0%),
        signal_user_changed: 12 (2.2%), b_tie_ro: 10 (1.9%), parse: 1.30
        (0.2%), extract_message_metadata: 15 (2.8%), get_uri_detail_list: 2.4
        (0.5%), tests_pri_-1000: 23 (4.2%), tests_pri_-950: 1.22 (0.2%),
        tests_pri_-900: 1.01 (0.2%), tests_pri_-90: 123 (22.8%), check_bayes:
        121 (22.4%), b_tokenize: 12 (2.2%), b_tok_get_all: 10 (1.8%),
        b_comp_prob: 3.8 (0.7%), b_tok_touch_all: 92 (17.0%), b_finish: 0.89
        (0.2%), tests_pri_0: 337 (62.4%), check_dkim_signature: 0.53 (0.1%),
        check_dkim_adsp: 5 (0.9%), poll_dns_idle: 2.8 (0.5%), tests_pri_10:
        3.5 (0.6%), tests_pri_500: 19 (3.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v3] cred: Propagate security_prepare_creds() error code
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frederick Lawler <fred@cloudflare.com> writes:

> Hi Eric,
>
> On 6/13/22 12:04 PM, Eric W. Biederman wrote:
>> Frederick Lawler <fred@cloudflare.com> writes:
>> 
>>> While experimenting with the security_prepare_creds() LSM hook, we
>>> noticed that our EPERM error code was not propagated up the callstack.
>>> Instead ENOMEM is always returned.  As a result, some tools may send a
>>> confusing error message to the user:
>>>
>>> $ unshare -rU
>>> unshare: unshare failed: Cannot allocate memory
>>>
>>> A user would think that the system didn't have enough memory, when
>>> instead the action was denied.
>>>
>>> This problem occurs because prepare_creds() and prepare_kernel_cred()
>>> return NULL when security_prepare_creds() returns an error code. Later,
>>> functions calling prepare_creds() and prepare_kernel_cred() return
>>> ENOMEM because they assume that a NULL meant there was no memory
>>> allocated.
>>>
>>> Fix this by propagating an error code from security_prepare_creds() up
>>> the callstack.
>> Why would it make sense for security_prepare_creds to return an error
>> code other than ENOMEM?
>>  > That seems a bit of a violation of what that function is supposed to do
>>
>
> The API allows LSM authors to decide what error code is returned from the
> cred_prepare hook. security_task_alloc() is a similar hook, and has its return
> code propagated.

It is not an api.  It is an implementation detail of the linux kernel.
It is a set of convenient functions that do a job.

The general rule is we don't support cases without an in-tree user.  I
don't see an in-tree user.

> I'm proposing we follow security_task_allocs() pattern, and add visibility for
> failure cases in prepare_creds().

I am asking why we would want to.  Especially as it is not an API, and I
don't see any good reason for anything but an -ENOMEM failure to be
supported.

Without an in-tree user that cares it is probably better to go the
opposite direction and remove the possibility of return anything but
memory allocation failure.  That will make it clearer to implementors
that a general error code is not supported and this is not a location
to implement policy, this is only a hook to allocate state for the LSM.

>> I have probably missed a very interesting discussion where that was
>> mentioned but I don't see link to the discussion or anything explaining
>> why we want to do that in this change.
>> 
>
> AFAIK, this is the start of the discussion.

You were on v3 and had an out of tree piece of code so I assumed someone
had at least thought about why you want to implement policy in a piece
of code whose only purpose is to allocate memory to store state.

Eric



