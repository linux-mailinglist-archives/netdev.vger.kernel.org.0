Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985AE21DFDA
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 20:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgGMShb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 14:37:31 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:35728 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726306AbgGMSh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 14:37:27 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jv3KN-000360-Ra; Mon, 13 Jul 2020 12:37:23 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jv3KM-000346-KJ; Mon, 13 Jul 2020 12:37:23 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Matt Bennett <Matt.Bennett@alliedtelesis.co.nz>
Cc:     "christian.brauner\@ubuntu.com" <christian.brauner@ubuntu.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "containers\@lists.linux-foundation.org" 
        <containers@lists.linux-foundation.org>,
        "zbr\@ioremap.net" <zbr@ioremap.net>
References: <20200702002635.8169-1-matt.bennett@alliedtelesis.co.nz>
        <87h7uqukct.fsf@x220.int.ebiederm.org>
        <20200702191025.bqxqwsm6kwnhm2p7@wittgenstein>
        <2ab92386ce5293e423aa3f117572200239a7228b.camel@alliedtelesis.co.nz>
Date:   Mon, 13 Jul 2020 13:34:34 -0500
In-Reply-To: <2ab92386ce5293e423aa3f117572200239a7228b.camel@alliedtelesis.co.nz>
        (Matt Bennett's message of "Sun, 5 Jul 2020 22:32:06 +0000")
Message-ID: <87tuyb9scl.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jv3KM-000346-KJ;;;mid=<87tuyb9scl.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19QCjJNh46OkUrfqmfDg7PJNrfXqRLKuLI=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.2 required=8.0 tests=ALL_TRUSTED,BAYES_20,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMNoVowels,XMSubLong,
        XM_B_SpammyTLD autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        * -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
        *      [score: 0.1519]
        *  0.7 XMSubLong Long Subject
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 0; Body=1 Fuz1=1 Fuz2=1]
        *  1.0 XM_B_SpammyTLD Contains uncommon/spammy TLD
X-Spam-DCC: ; sa07 0; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Matt Bennett <Matt.Bennett@alliedtelesis.co.nz>
X-Spam-Relay-Country: 
X-Spam-Timing: total 834 ms - load_scoreonly_sql: 0.12 (0.0%),
        signal_user_changed: 13 (1.6%), b_tie_ro: 11 (1.3%), parse: 1.96
        (0.2%), extract_message_metadata: 17 (2.1%), get_uri_detail_list: 2.1
        (0.3%), tests_pri_-1000: 7 (0.9%), tests_pri_-950: 1.37 (0.2%),
        tests_pri_-900: 1.02 (0.1%), tests_pri_-90: 320 (38.4%), check_bayes:
        310 (37.2%), b_tokenize: 8 (1.0%), b_tok_get_all: 178 (21.4%),
        b_comp_prob: 3.9 (0.5%), b_tok_touch_all: 115 (13.8%), b_finish: 1.06
        (0.1%), tests_pri_0: 430 (51.6%), check_dkim_signature: 1.82 (0.2%),
        check_dkim_adsp: 2.9 (0.4%), poll_dns_idle: 17 (2.0%), tests_pri_10:
        3.6 (0.4%), tests_pri_500: 32 (3.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 0/5] RFC: connector: Add network namespace awareness
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Matt Bennett <Matt.Bennett@alliedtelesis.co.nz> writes:

> On Thu, 2020-07-02 at 21:10 +0200, Christian Brauner wrote:
>> On Thu, Jul 02, 2020 at 08:17:38AM -0500, Eric W. Biederman wrote:
>> > Matt Bennett <matt.bennett@alliedtelesis.co.nz> writes:
>> > 
>> > > Previously the connector functionality could only be used by processes running in the
>> > > default network namespace. This meant that any process that uses the connector functionality
>> > > could not operate correctly when run inside a container. This is a draft patch series that
>> > > attempts to now allow this functionality outside of the default network namespace.
>> > > 
>> > > I see this has been discussed previously [1], but am not sure how my changes relate to all
>> > > of the topics discussed there and/or if there are any unintended side effects from my draft
>> > > changes.
>> > 
>> > Is there a piece of software that uses connector that you want to get
>> > working in containers?
>
> We have an IPC system [1] where processes can register their socket
> details (unix, tcp, tipc, ...) to a 'monitor' process. Processes can
> then get notified when other processes they are interested in
> start/stop their servers and use the registered details to connect to
> them. Everything works unless a process crashes, in which case the
> monitoring process never removes their details. Therefore the
> monitoring process uses the connector functionality with
> PROC_EVENT_EXIT to detect when a process crashes and removes the
> details if it is a previously registered PID.
>
> This was working for us until we tried to run our system in a container.
>
>> > 
>> > I am curious what the motivation is because up until now there has been
>> > nothing very interesting using this functionality.  So it hasn't been
>> > worth anyone's time to make the necessary changes to the code.
>> 
>> Imho, we should just state once and for all that the proc connector will
>> not be namespaced. This is such a corner-case thing and has been
>> non-namespaced for such a long time without consistent push for it to be
>> namespaced combined with the fact that this needs quite some code to
>> make it work correctly that I fear we end up buying more bugs than we're
>> selling features. And realistically, you and I will end up maintaining
>> this and I feel this is not worth the time(?). Maybe I'm being too
>> pessimistic though.
>> 
>
> Fair enough. I can certainly look for another way to detect process
> crashes. Interestingly I found a patch set [2] on the mailing list
> that attempts to solve the problem I wish to solve, but it doesn't
> look like the patches were ever developed further. From reading the
> discussion thread on that patch set it appears that I should be doing
> some form of polling on the /proc files.

Recently Christian Brauner implemented pidfd complete with a poll
operation that reports when a process terminates.

If you are willing to change your userspace code switching to pidfd
should be all that you need.

Eric
