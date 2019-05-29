Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1AF2DF41
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 16:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbfE2OHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 10:07:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53150 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbfE2OHx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 10:07:53 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EB54930C0DE3;
        Wed, 29 May 2019 14:07:37 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.18.25.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B0CC785D2;
        Wed, 29 May 2019 14:07:25 +0000 (UTC)
Reply-To: dwalsh@redhat.com
Subject: Re: [PATCH ghak90 V6 00/10] audit: implement container identifier
To:     Paul Moore <paul@paul-moore.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        Mrunal Patel <mpatel@redhat.com>
References: <cover.1554732921.git.rgb@redhat.com>
 <509ea6b0-1ac8-b809-98c2-37c34dd98ca3@redhat.com>
 <CAHC9VhRW9f6GbhvvfifbOzd9p=PgdB2gq1E7tACcaqvfb85Y8A@mail.gmail.com>
 <3299293.RYyUlNkVNy@x2>
 <20190529004352.vvicec7nnk6pvkwt@madcap2.tricolour.ca>
 <31804653-7518-1a9c-83af-f6ce6a6ce408@redhat.com>
 <CAHC9VhT295iYu_uDcQ7eqVq8SSkYgEQAsoNrmpvbMR5ERcBzaA@mail.gmail.com>
From:   Daniel Walsh <dwalsh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=dwalsh@redhat.com; prefer-encrypt=mutual; keydata=
 mQENBFsaqOEBCADBSnZCZpi262vX8m7iL/OdHKP9G9dhS28FR60cjd8nMPqHDNhQJBjLMZra
 66L2cCIEhc4HEItail7KU1BckrMc4laFaxL8tLoVTKHZwb74n2OcAJ4FtgzkNNlB1XJvSwC/
 909uwt7cpDqwXpJvyP3t17iuklB1OY0EEjTDt9aU4+0QjHzV18L4Cpd9iQ4ksu+EHT+pjlBk
 DdQB+hKoAjxPl11Eh6pZfrAcrNWpYBBk0A3XE9Jb6ghbmHWltNgVOsCa9GcswJHUEeFiOup6
 J5DTv6Xzwt0t6QB8nIs+wDJH+VxqAXcrxscnAhViIfGGS2AtxzjnVOz/J+UZPaauIGXTABEB
 AAG0LERhbmllbCBKIFdhbHNoIChGb3IgR2l0KSA8ZHdhbHNoQHJlZGhhdC5jb20+iQE4BBMB
 AgAiBQJbGqjhAhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRCi35Adq+LAKHuJB/98
 nZB5RmNjMWua4Ms8q5a1R9XWlDAb3mrST6JeL+uV/M0fa18e2Aw4/hi/WZHjAjoypLmcuaRx
 GeCbC8iYdpfRDUG79Y956Qq+Vs8c6VfNDMY1mvtfb00eeTaYoOCu0Aa9LDeR9iLKh2g0RI+N
 Zr3EU45RxZdacIs1v6mU8pGpyUq/FvuTGK9GzR9d1YeVCuSpQKN4ckHNZHJUXyk0vOZft1oO
 nSgLqM9EDWA+yz1JLmRYwbNsim7IvfVOav5mCgnKzHcL2mLv8qCnMFZjoQV8aGny/W739Z3a
 YJo1CdOg6zSu5SOvmq9idYrBRkwEtyLXss2oceTVBs0MxqQ/9mLPuQENBFsaqOEBCADDl2hl
 bUpqJGgwt2eQvs0Z0DCx/7nn0hlLfEn4WAv2HqP25AjIRXUX31Mzu68C4QnsvNtY4zN+FGRC
 EfUpYsjiL7vBYlRePhIohyMYU4RLp5eXFQKahHO/9Xlhe8mwueQNwYxNBPfMQ65U2AuqxpcS
 scx4s5w208mhqHoKz6IB2LuKeflhYfH5Y1FNAtVGHfhg22xlcAdupPPcxGuS4fBEW6PD/SDf
 Y4HT5iUHsyksQKjM0IFalqZ7YuLfXBl07OD2zU7WI9c3W0dwkvwIRjt3aD4iAah544uOLff+
 BzfxWghXeo80S2a1WCL0S/2qR0NVct/ExaDWboYr/bKpTa/1ABEBAAGJAR8EGAECAAkFAlsa
 qOECGwwACgkQot+QHaviwCi2hgf/XRvrt+VBmp1ZFxQAR9E6S7AtRT8KSytjFiqEC7TpOx3r
 2OZ4gZ3ZiW4TMW8hS7aYRgF1uYpLzl7BbrCfCHfAWEcXZ+uG8vayg8G/mLAcNlLY+JE76ATs
 53ziEY9R2Vb/wLMFd2nNBdqfwGcRH9N9VOej9vP76nCP01ZolY8Nms2hE383/+1Quxp5EedU
 BN5W5l7x9riBJyqCA63hr4u8wNsTuQgrDyhm/U1IvYeLtMopgotjnIR3KiTKOElbppLeXW3w
 EO/sQTPk+vQ4vcsJYY9Dnf1NlvHE4klj60GHjtjitsBEHzdE7s+J9FOxPmt8l+gMogGumKpN
 Y4lO0pfTyg==
Organization: Red Hat
Message-ID: <9a9ccb28-3cbc-c0b1-71b2-26df08105b4a@redhat.com>
Date:   Wed, 29 May 2019 10:07:24 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAHC9VhT295iYu_uDcQ7eqVq8SSkYgEQAsoNrmpvbMR5ERcBzaA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 29 May 2019 14:07:53 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/29/19 9:17 AM, Paul Moore wrote:
> On Wed, May 29, 2019 at 8:03 AM Daniel Walsh <dwalsh@redhat.com> wrote:
>> On 5/28/19 8:43 PM, Richard Guy Briggs wrote:
>>> On 2019-05-28 19:00, Steve Grubb wrote:
>>>> On Tuesday, May 28, 2019 6:26:47 PM EDT Paul Moore wrote:
>>>>> On Tue, May 28, 2019 at 5:54 PM Daniel Walsh <dwalsh@redhat.com> wrote:
>>>>>> On 4/22/19 9:49 AM, Paul Moore wrote:
>>>>>>> On Mon, Apr 22, 2019 at 7:38 AM Neil Horman <nhorman@tuxdriver.com>
>>>> wrote:
>>>>>>>> On Mon, Apr 08, 2019 at 11:39:07PM -0400, Richard Guy Briggs wrote:
>>>>>>>>> Implement kernel audit container identifier.
>>>>>>>> I'm sorry, I've lost track of this, where have we landed on it? Are we
>>>>>>>> good for inclusion?
>>>>>>> I haven't finished going through this latest revision, but unless
>>>>>>> Richard made any significant changes outside of the feedback from the
>>>>>>> v5 patchset I'm guessing we are "close".
>>>>>>>
>>>>>>> Based on discussions Richard and I had some time ago, I have always
>>>>>>> envisioned the plan as being get the kernel patchset, tests, docs
>>>>>>> ready (which Richard has been doing) and then run the actual
>>>>>>> implemented API by the userland container folks, e.g. cri-o/lxc/etc.,
>>>>>>> to make sure the actual implementation is sane from their perspective.
>>>>>>> They've already seen the design, so I'm not expecting any real
>>>>>>> surprises here, but sometimes opinions change when they have actual
>>>>>>> code in front of them to play with and review.
>>>>>>>
>>>>>>> Beyond that, while the cri-o/lxc/etc. folks are looking it over,
>>>>>>> whatever additional testing we can do would be a big win.  I'm
>>>>>>> thinking I'll pull it into a separate branch in the audit tree
>>>>>>> (audit/working-container ?) and include that in my secnext kernels
>>>>>>> that I build/test on a regular basis; this is also a handy way to keep
>>>>>>> it based against the current audit/next branch.  If any changes are
>>>>>>> needed Richard can either chose to base those changes on audit/next or
>>>>>>> the separate audit container ID branch; that's up to him.  I've done
>>>>>>> this with other big changes in other trees, e.g. SELinux, and it has
>>>>>>> worked well to get some extra testing in and keep the patchset "merge
>>>>>>> ready" while others outside the subsystem look things over.
>>>>>> Mrunal Patel (maintainer of CRI-O) and I have reviewed the API, and
>>>>>> believe this is something we can work on in the container runtimes team
>>>>>> to implement the container auditing code in CRI-O and Podman.
>>>>> Thanks Dan.  If I pulled this into a branch and built you some test
>>>>> kernels to play with, any idea how long it might take to get a proof
>>>>> of concept working on the cri-o side?
>>>> We'd need to merge user space patches and let them use that instead of the
>>>> raw interface. I'm not going to merge user space until we are pretty sure the
>>>> patch is going into the kernel.
>>> I have an f29 test rpm of the userspace bits if that helps for testing:
>>>       http://people.redhat.com/~rbriggs/ghak90/git-1db7e21/
>>>
>>> Here's what it contains (minus the last patch):
>>>       https://github.com/linux-audit/audit-userspace/compare/master...rgbriggs:ghau40-containerid-filter.v7.0
>>>
>>>> -Steve
>>>>
>>>>> FWIW, I've also reached out to some of the LXC folks I know to get
>>>>> their take on the API.  I think if we can get two different container
>>>>> runtimes to give the API a thumbs-up then I think we are in good shape
>>>>> with respect to the userspace interface.
>>>>>
>>>>> I just finished looking over the last of the pending audit kernel
>>>>> patches that were queued waiting for the merge window to open so this
>>>>> is next on my list to look at.  I plan to start doing that
>>>>> tonight/tomorrow, and as long as the changes between v5/v6 are not
>>>>> that big, it shouldn't take too long.
>>> - RGB
>>>
>>> --
>>> Richard Guy Briggs <rgb@redhat.com>
>>> Sr. S/W Engineer, Kernel Security, Base Operating Systems
>>> Remote, Ottawa, Red Hat Canada
>>> IRC: rgb, SunRaycer
>>> Voice: +1.647.777.2635, Internal: (81) 32635
>> Our current thoughts are to put the setting of the ID inside of conmon,
>> and then launching the OCI Runtime.  In a perfect world this would
>> happen in the OCI Runtime, but we have no controls over different OCI
>> Runtimes.
>>
>> By putting it into conmon, then CRI-O and Podman will automatically get
>> the container id support.  After we have this we have to plumb it back
>> up through the contianer engines to be able to easily report the link
>> between the Container UUID and The Kernel Container Audit ID.
> I'm glad you guys have a plan, that's encouraging, but sadly I have no
> idea about the level of complexity/difficulty involved in modifying
> the various container bits for a proof-of-concept?  Are we talking a
> week or two?  A month?  More?
>
If we had the kernel and the libaudit api, it would involve a small
effort in conmon,  I would figure a few days for a POC.  Getting the
hole wiring into CRI-O and Podman, would be a little more effort.


