Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C535F0FBA
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbiI3QST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbiI3QSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:18:18 -0400
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D708511F7DC;
        Fri, 30 Sep 2022 09:18:16 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:52432)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oeIiL-00Cx42-4s; Fri, 30 Sep 2022 10:18:13 -0600
Received: from ip68-110-29-46.om.om.cox.net ([68.110.29.46]:45878 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oeIiI-00EqUh-Vo; Fri, 30 Sep 2022 10:18:12 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
References: <dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com>
        <CAHk-=wgS_XpzEL140ovgLwGv6yXvV7Pu9nKJbCuo5pnRfcEbvg@mail.gmail.com>
        <YzXo/DIwq65ypHNH@ZenIV> <YzXrOFpPStEwZH/O@ZenIV>
        <CAHk-=wjLgM06JrS21W4g2VquqCLab+qu_My67cv6xuH7NhgHpw@mail.gmail.com>
        <YzXzXNAgcJeJ3M0d@ZenIV> <YzYK7k3tgZy3Pwht@ZenIV>
        <CAHk-=wihPFFE5KcsmOnOm1CALQDWqC1JTvrwSGBS08N5avVmEA@mail.gmail.com>
        <871qrt4ymg.fsf@email.froward.int.ebiederm.org>
        <87ill53igy.fsf_-_@email.froward.int.ebiederm.org>
        <ea14288676b045c29960651a649d66b9@AcuMS.aculab.com>
Date:   Fri, 30 Sep 2022 11:17:29 -0500
In-Reply-To: <ea14288676b045c29960651a649d66b9@AcuMS.aculab.com> (David
        Laight's message of "Fri, 30 Sep 2022 09:30:41 +0000")
Message-ID: <87a66g25wm.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oeIiI-00EqUh-Vo;;;mid=<87a66g25wm.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.110.29.46;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX18cBPQLUQPVWjAzXKZv3bvRp1x4Q+NftFs=
X-SA-Exim-Connect-IP: 68.110.29.46
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *******;David Laight <David.Laight@ACULAB.COM>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1607 ms - load_scoreonly_sql: 0.10 (0.0%),
        signal_user_changed: 12 (0.8%), b_tie_ro: 10 (0.6%), parse: 1.71
        (0.1%), extract_message_metadata: 28 (1.7%), get_uri_detail_list: 4.5
        (0.3%), tests_pri_-1000: 19 (1.2%), tests_pri_-950: 1.87 (0.1%),
        tests_pri_-900: 1.42 (0.1%), tests_pri_-90: 134 (8.3%), check_bayes:
        123 (7.7%), b_tokenize: 10 (0.6%), b_tok_get_all: 11 (0.7%),
        b_comp_prob: 6 (0.4%), b_tok_touch_all: 91 (5.7%), b_finish: 1.07
        (0.1%), tests_pri_0: 370 (23.0%), check_dkim_signature: 0.54 (0.0%),
        check_dkim_adsp: 2.8 (0.2%), poll_dns_idle: 1008 (62.7%),
        tests_pri_10: 2.9 (0.2%), tests_pri_500: 1031 (64.2%), rewrite_mail:
        0.00 (0.0%)
Subject: Re: [CFT][PATCH] proc: Update /proc/net to point at the accessing
 threads network namespace
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Laight <David.Laight@ACULAB.COM> writes:

> From: Eric W. Biederman
>> Sent: 29 September 2022 23:48
>> 
>> Since common apparmor policies don't allow access /proc/tgid/task/tid/net
>> point the code at /proc/tid/net instead.
>> 
>> Link: https://lkml.kernel.org/r/dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>> 
>> I have only compile tested this.  All of the boiler plate is a copy of
>> /proc/self and /proc/thread-self, so it should work.
>> 
>> Can David or someone who cares and has access to the limited apparmor
>> configurations could test this to make certain this works?
>
> It works with a minor 'cut & paste' fixup.
> (Not nested inside a program that changes namespaces.)

Were there any apparmor problems?  I just want to confirm that is what
you tested.

Assuming not this patch looks like it reveals a solution to this
issue.

> Although if it is reasonable for /proc/net -> /proc/tid/net
> why not just make /proc/thread-self -> /proc/tid
> Then /proc/net can just be thread-self/net

There are minor differences between the process directories that
tend to report process wide information and task directories that
only report some of the same information per-task.  So in general
thread-self makes much more sense pointing to a per-task directory.

The hidden /proc/tid/ directories use the per process code to generate
themselves.  The difference is that they assume the tid is the leading
thread instead of the other process.  Those directories are all a bit of
a scrambled mess.  I was suspecting the other day we might be able to
fix gdb and make them go away entirely in a decade or so.

So I don't think it makes sense in general to point /proc/thread-self at
the hidden per /proc/tid/ directories.

> I have wondered if the namespace lookup could be done as a 'special'
> directory lookup for "net" rather that changing everything when the
> namespace is changed.
> I can imagine scenarios where a thread needs to keep changing
> between two namespaces, at the moment I suspect that is rather
> more expensive than a lookup and changing the reference counts.

You can always open the net directories once, and then change as
an open directory will not change between namespaces.

> Notwithstanding the apparmor issues, /proc/net could actuall be
> a symlink to (say) /proc/net_namespaces/namespace_name with
> readlink returning the name based on the threads actual namespace.

There really aren't good names for namespaces at the kernel level.  As
one of their use cases is to make process migration possible between
machines.  So any kernel level name would need to be migrated as well.
So those kernel level names would need a name in another namespace,
or an extra namespace would have to be created for those names.

> I've also had problems with accessing /sys/class/net for multiple
> namespaces within the same thread (think of a system monitor process).
> The simplest solution is to start the program with:
> 	ip netne exec namespace program 3</sys/class/net
> and the use openat(3, ...) to read items in the 'init' namespace.
>
> FWIW I'm pretty sure there a sequence involving unshare() that
> can get you out of a chroot - but I've not found it yet.

Out of a chroot is essentially just:
	chdir("/");
        chroot("/somedir");
        chdir("../../../../../../../../../../../../../../../..");
Out of most namespaces except the pid and user namespace is
just chns.

You can't get out of the pid namespace as you can't change your pid.

Not being able to escape a user namespace is what makes it impossible to
confuse a process and gain privileges through a privilege gaining exec.

Eric
