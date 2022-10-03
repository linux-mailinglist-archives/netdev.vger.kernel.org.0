Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB53F5F342C
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 19:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiJCRIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 13:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiJCRID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 13:08:03 -0400
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA142C101;
        Mon,  3 Oct 2022 10:08:02 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:51898)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1ofOv9-00E0WT-Cc; Mon, 03 Oct 2022 11:07:59 -0600
Received: from ip68-110-29-46.om.om.cox.net ([68.110.29.46]:40526 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1ofOv7-003Ws0-UW; Mon, 03 Oct 2022 11:07:59 -0600
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
        <87a66g25wm.fsf@email.froward.int.ebiederm.org>
        <9bf5e96b383e4a979618cb0f729cb833@AcuMS.aculab.com>
Date:   Mon, 03 Oct 2022 12:07:27 -0500
In-Reply-To: <9bf5e96b383e4a979618cb0f729cb833@AcuMS.aculab.com> (David
        Laight's message of "Fri, 30 Sep 2022 21:28:31 +0000")
Message-ID: <87fsg4ygxc.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1ofOv7-003Ws0-UW;;;mid=<87fsg4ygxc.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.110.29.46;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX19IDgxnyteAd4Kb6HY+QvRh3ZIbvIqDiFA=
X-SA-Exim-Connect-IP: 68.110.29.46
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *******;David Laight <David.Laight@ACULAB.COM>
X-Spam-Relay-Country: 
X-Spam-Timing: total 820 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 11 (1.4%), b_tie_ro: 10 (1.2%), parse: 1.09
        (0.1%), extract_message_metadata: 26 (3.2%), get_uri_detail_list: 9
        (1.1%), tests_pri_-1000: 26 (3.1%), tests_pri_-950: 1.53 (0.2%),
        tests_pri_-900: 1.24 (0.2%), tests_pri_-90: 219 (26.7%), check_bayes:
        216 (26.4%), b_tokenize: 18 (2.2%), b_tok_get_all: 13 (1.6%),
        b_comp_prob: 4.9 (0.6%), b_tok_touch_all: 175 (21.3%), b_finish: 1.28
        (0.2%), tests_pri_0: 518 (63.2%), check_dkim_signature: 0.81 (0.1%),
        check_dkim_adsp: 2.9 (0.4%), poll_dns_idle: 0.58 (0.1%), tests_pri_10:
        2.1 (0.3%), tests_pri_500: 10 (1.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [CFT][PATCH] proc: Update /proc/net to point at the accessing
 threads network namespace
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Laight <David.Laight@ACULAB.COM> writes:

> From: Eric W. Biederman
>> Sent: 30 September 2022 17:17
>> 
>> David Laight <David.Laight@ACULAB.COM> writes:
>> 
>> > From: Eric W. Biederman
>> >> Sent: 29 September 2022 23:48
>> >>
>> >> Since common apparmor policies don't allow access /proc/tgid/task/tid/net
>> >> point the code at /proc/tid/net instead.
>> >>
>> >> Link: https://lkml.kernel.org/r/dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com
>> >> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> >> ---
>> >>
>> >> I have only compile tested this.  All of the boiler plate is a copy of
>> >> /proc/self and /proc/thread-self, so it should work.
>> >>
>> >> Can David or someone who cares and has access to the limited apparmor
>> >> configurations could test this to make certain this works?
>> >
>> > It works with a minor 'cut & paste' fixup.
>> > (Not nested inside a program that changes namespaces.)
>> 
>> Were there any apparmor problems?  I just want to confirm that is what
>> you tested.
>
> I know nothing about apparmor - I just tested that /proc/net
> pointed to somewhere that looked right.

Fair enough.  We should attempt to verify with an apparmor configuration
before merging this just in case there is a detail someone overlooked.
It doesn't help much if there is a fix that has to be reverted right
away.


>> Assuming not this patch looks like it reveals a solution to this
>> issue.
>> 
>> > Although if it is reasonable for /proc/net -> /proc/tid/net
>> > why not just make /proc/thread-self -> /proc/tid
>> > Then /proc/net can just be thread-self/net
>> 
>> There are minor differences between the process directories that
>> tend to report process wide information and task directories that
>> only report some of the same information per-task.  So in general
>> thread-self makes much more sense pointing to a per-task directory.
>> 
>> The hidden /proc/tid/ directories use the per process code to generate
>> themselves.  The difference is that they assume the tid is the leading
>> thread instead of the other process.  Those directories are all a bit of
>> a scrambled mess.  I was suspecting the other day we might be able to
>> fix gdb and make them go away entirely in a decade or so.
>> 
>> So I don't think it makes sense in general to point /proc/thread-self at
>> the hidden per /proc/tid/ directories.
>
> Ok - I hadn't actually looked in them.
> But if you have a long-term plan to remove them directing /proc/net
> thought them might not be such a good idea.

Nah.  I just want to grouse about them and encourage people not to
use them in general.  They are a weird special case.  They aren't
painful enough to maintain to make me want to do something else.

It would actually be less work to fix the apparmor security polices,
and the to verify over the course of a several years that the broken
security policies are no longer shipped.


>> > I have wondered if the namespace lookup could be done as a 'special'
>> > directory lookup for "net" rather that changing everything when the
>> > namespace is changed.
>> > I can imagine scenarios where a thread needs to keep changing
>> > between two namespaces, at the moment I suspect that is rather
>> > more expensive than a lookup and changing the reference counts.
>> 
>> You can always open the net directories once, and then change as
>> an open directory will not change between namespaces.
>
> Part of the problem is that changing the net namespace isn't
> enough, you also have to remount /sys - which isn't entirely
> trivial.

Yes.  That is actually a much more maintainable model.  But it is still
imperfect.    I was thinking about the proc/net directories when
I made my comment.  Unlike proc where we have task ids there is nothing
in /proc that can do anything.

> It might be possibly to mount a network namespace version
> of /sys on a different mountpoint - I've not tried very
> hard to do that.

It is a bug if that doesn't work.

>> > Notwithstanding the apparmor issues, /proc/net could actuall be
>> > a symlink to (say) /proc/net_namespaces/namespace_name with
>> > readlink returning the name based on the threads actual namespace.
>> 
>> There really aren't good names for namespaces at the kernel level.  As
>> one of their use cases is to make process migration possible between
>> machines.  So any kernel level name would need to be migrated as well.
>> So those kernel level names would need a name in another namespace,
>> or an extra namespace would have to be created for those names.
>
> Network namespaces do seem to have names.
> Although I gave up working out how to change to a named network
> namespace from within the kernel (especially in a non-GPL module).

Network namespaces have mount points.  The mount points have names.

It is just a matter of finding the right filesystem and calling
sys_rename().

There are a some network namespace local names for other network
namespaces.  For those I don't see how it would make any sense
to change the name.  If you need to you can always create a
new network namespace and ensure you get the name you want there.
Which is good enough for process migration.  I don't know why else
anyone would want to change names.

> ...
>> > FWIW I'm pretty sure there a sequence involving unshare() that
>> > can get you out of a chroot - but I've not found it yet.
>> 
>> Out of a chroot is essentially just:
>> 	chdir("/");
>>         chroot("/somedir");
>>         chdir("../../../../../../../../../../../../../../../..");
>
> A chdir() inside a chroot anchors at the base of the chroot.
But the check is very simple.
If (working_directory == root_directory) make chdir("...") a noop.

Once the working directory is below the root directory (as
chroot("/somedir") achieves the chroot checks are no longer usable.

> fchdir() will get you out if you have an open fd to a directory
> outside the chroot.
> The 'usual' way out requires a process outside the chroot to
> just use mvdir().
> But there isn't supposed to be a way to get out.

As I recall the history chroot was a quick hack to allow building a
building against a different version of the binaries than were currently
installed.  It was not built as a security feature.

Eric
