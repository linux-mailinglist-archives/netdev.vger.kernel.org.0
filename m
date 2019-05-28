Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2E442D13F
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 23:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbfE1VyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 17:54:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32715 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727695AbfE1VyK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 17:54:10 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9D1193087926;
        Tue, 28 May 2019 21:54:09 +0000 (UTC)
Received: from localhost.localdomain (ovpn-112-56.rdu2.redhat.com [10.10.112.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4332E1972B;
        Tue, 28 May 2019 21:53:56 +0000 (UTC)
Reply-To: dwalsh@redhat.com
Subject: Re: [PATCH ghak90 V6 00/10] audit: implement container identifier
To:     Paul Moore <paul@paul-moore.com>,
        Neil Horman <nhorman@tuxdriver.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        Mrunal Patel <mpatel@redhat.com>
References: <cover.1554732921.git.rgb@redhat.com>
 <20190422113810.GA27747@hmswarspite.think-freely.org>
 <CAHC9VhQYPF2ma_W+hySbQtfTztf=K1LTFnxnyVK0y9VYxj-K=w@mail.gmail.com>
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
Message-ID: <509ea6b0-1ac8-b809-98c2-37c34dd98ca3@redhat.com>
Date:   Tue, 28 May 2019 17:53:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAHC9VhQYPF2ma_W+hySbQtfTztf=K1LTFnxnyVK0y9VYxj-K=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 28 May 2019 21:54:10 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/19 9:49 AM, Paul Moore wrote:
> On Mon, Apr 22, 2019 at 7:38 AM Neil Horman <nhorman@tuxdriver.com> wrote:
>> On Mon, Apr 08, 2019 at 11:39:07PM -0400, Richard Guy Briggs wrote:
>>> Implement kernel audit container identifier.
>> I'm sorry, I've lost track of this, where have we landed on it? Are we good for
>> inclusion?
> I haven't finished going through this latest revision, but unless
> Richard made any significant changes outside of the feedback from the
> v5 patchset I'm guessing we are "close".
>
> Based on discussions Richard and I had some time ago, I have always
> envisioned the plan as being get the kernel patchset, tests, docs
> ready (which Richard has been doing) and then run the actual
> implemented API by the userland container folks, e.g. cri-o/lxc/etc.,
> to make sure the actual implementation is sane from their perspective.
> They've already seen the design, so I'm not expecting any real
> surprises here, but sometimes opinions change when they have actual
> code in front of them to play with and review.
>
> Beyond that, while the cri-o/lxc/etc. folks are looking it over,
> whatever additional testing we can do would be a big win.  I'm
> thinking I'll pull it into a separate branch in the audit tree
> (audit/working-container ?) and include that in my secnext kernels
> that I build/test on a regular basis; this is also a handy way to keep
> it based against the current audit/next branch.  If any changes are
> needed Richard can either chose to base those changes on audit/next or
> the separate audit container ID branch; that's up to him.  I've done
> this with other big changes in other trees, e.g. SELinux, and it has
> worked well to get some extra testing in and keep the patchset "merge
> ready" while others outside the subsystem look things over.
>
Mrunal Patel (maintainer of CRI-O) and I have reviewed the API, and
believe this is something we can work on in the container runtimes team
to implement the container auditing code in CRI-O and Podman.


