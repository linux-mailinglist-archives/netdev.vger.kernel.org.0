Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D264CEB83
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 13:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbiCFMUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 07:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233599AbiCFMUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 07:20:05 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C28454BD5;
        Sun,  6 Mar 2022 04:19:13 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id o1so15287679edc.3;
        Sun, 06 Mar 2022 04:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=CDRwvE25IiF9s/w9/nAeUPJ9kRP/a8dQ1EQqJWnNJqc=;
        b=EdrzebUthBJJJPJdarJbeI8iloEjYFjuRbSd2ciya9du11rLOizxAmjbHHKjP2p03m
         7QknZsKo7wqrH5BFHAlTKqWCn0Z4/uLxmGpehOkpd+4yPeHjMeK8QQARyJlNHnRA7Y0Z
         C4ReXM1rkTbzzlNu+z6UeTr7rWIwr7lqgLWOzFereHUrrxo29ppEJYmjfkRYK3abFqck
         dJ0KwDZEumYqscIZgPXxxt4+VbRtKu5IIpTmoa0MuyogWaenFQ4xNazH+RE/SY8v0LeH
         2ZCV3VRPXMPCmEXMO+ZTNCvJN0dirOYTU7hOqsP7bGn1G3apwnMtgnaxVDBuzWTOlNAd
         1Upw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=CDRwvE25IiF9s/w9/nAeUPJ9kRP/a8dQ1EQqJWnNJqc=;
        b=f9ZNhEhItjSxqrAY/BbaYO2awb0cIVdjsFTAi1D8Rd8tzT7mU8ku+K5YOKcO0u3alN
         U/9f+dhJLZWhnjNcDIQH31xrwRowHdO9vfVlVJFS+eGeKNl6N9SThUHcuuJfFUHP3/nI
         77gt2ypnrGvMj9uelIoY0xsh3RzszC8ItGzx6jM69YHGwtbkdgIiYI5G4EBfa0dTjWto
         WMgZLAnjOXMbRjJ4OseWTBl+VO8SFzuJzJFi7CkSv78DctiMckLMX1Ewdx3J4yZ9Fxqw
         RvAvpzxI3AdZ5WONGl1TmKfGwxA/Gan1IwDHfMp6bozRPMy0bLSSUqwHSvqwps8RbLYf
         jgtw==
X-Gm-Message-State: AOAM5321pX9veh78+Qo0WK08easmVtOIlZ+4EFXMKjDQX33ArkyWp/rY
        XSMhgZSaB+jI8x3BAhbM8rU=
X-Google-Smtp-Source: ABdhPJwfqp4IjHlFES6ZV1NcwigYKBoHwDTIZK35LuSjbpb1R+JvW3pq3BnFzU5E+aoAh04G9Xl70g==
X-Received: by 2002:a05:6402:6da:b0:3fd:cacb:f4b2 with SMTP id n26-20020a05640206da00b003fdcacbf4b2mr6551900edy.332.1646569151681;
        Sun, 06 Mar 2022 04:19:11 -0800 (PST)
Received: from smtpclient.apple ([2a02:8109:9d80:3f6c:ad2a:8957:2c5c:5b7d])
        by smtp.gmail.com with ESMTPSA id b10-20020a056402278a00b00415b20902a6sm4877295ede.27.2022.03.06.04.19.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Mar 2022 04:19:10 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.60.0.1.1\))
Subject: Re: [PATCH 2/6] list: add new MACROs to make iterator invisiable
 outside the loop
From:   Jakob Koschel <jakobkoschel@gmail.com>
In-Reply-To: <CAHk-=wiacQM76xec=Hr7cLchVZ8Mo9VDHmXRJzJ_EX4sOsApEA@mail.gmail.com>
Date:   Sun, 6 Mar 2022 13:19:09 +0100
Cc:     Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <634CBC77-281E-421C-9ED9-DB9E7224E7EA@gmail.com>
References: <CAHk-=whJX52b1jNsmzXeVr6Z898R=9rBcSYx2oLt69XKDbqhOg@mail.gmail.com>
 <20220304025109.15501-1-xiam0nd.tong@gmail.com>
 <CAHk-=wjesxw9U6JvTw34FREFAsayEE196Fi=VHtJXL8_9wgi=A@mail.gmail.com>
 <CAHk-=wiacQM76xec=Hr7cLchVZ8Mo9VDHmXRJzJ_EX4sOsApEA@mail.gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.3693.60.0.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 6. Mar 2022, at 01:35, Linus Torvalds =
<torvalds@linux-foundation.org> wrote:
>=20
> On Sat, Mar 5, 2022 at 1:09 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>=20
>> Now, I'd love for the list head entry itself to "declare the type",
>> and solve it that way. That would in many ways be the optimal
>> situation, in that when a structure has that
>>=20
>>        struct list_head xyz;
>>=20
>> entry, it would be lovely to declare *there* what the list entry type
>> is - and have 'list_for_each_entry()' just pick it up that way.
>>=20
>> It would be doable in theory - with some preprocessor trickery [...]
>=20
> Ok, I decided to look at how that theory looks in real life.
>=20
> The attached patch does actually work for me. I'm not saying this is
> *beautiful*, but I made the changes to kernel/exit.c to show how this
> can be used, and while the preprocessor tricks and the odd "unnamed
> union with a special member to give the target type" is all kinds of
> hacky, the actual use case code looks quite nice.
>=20
> In particular, look at the "good case" list_for_each_entry() =
transformation:
>=20
>   static int do_wait_thread(struct wait_opts *wo, struct task_struct =
*tsk)
>   {
>  -     struct task_struct *p;
>  -
>  -     list_for_each_entry(p, &tsk->children, sibling) {
>  +     list_traverse(p, &tsk->children, sibling) {
>=20
> IOW, it avoided the need to declare 'p' entirely, and it avoids the
> need for a type, because the macro now *knows* the type of that
> 'tsk->children' list and picks it out automatically.
>=20
> So 'list_traverse()' is basically a simplified version of
> 'list_for_each_entry()'.
>=20
> That patch also has - as another example - the "use outside the loop"
> case in mm_update_next_owner(). That is more of a "rewrite the loop
> cleanly using list_traverse() thing, but it's also quite simple and
> natural.
>=20
> One nice part of this approach is that it allows for incremental =
changes.
>=20
> In fact, the patch very much is meant to demonstrate exactly that:
> yes, it converts the uses in kernel/exit.c, but it does *not* convert
> the code in kernel/fork.c, which still does that old-style traversal:
>=20
>                list_for_each_entry(child, &parent->children, sibling) =
{
>=20
> and the kernel/fork.c code continues to work as well as it ever did.
>=20
> So that new 'list_traverse()' function allows for people to say "ok, I
> will now declare that list head with that list_traversal_head() macro,
> and then I can convert 'list_for_each_entry()' users one by one to
> this simpler syntax that also doesn't allow the list iterator to be
> used outside the list.
>=20
> What do people think? Is this clever and useful, or just too subtle
> and odd to exist?
>=20
> NOTE! I decided to add that "name of the target head in the target
> type" to the list_traversal_head() macro, but it's not actually used
> as is. It's more of a wishful "maybe we could add some sanity checking
> of the target list entries later".
>=20
> Comments?

I guess we could apply this to list_for_each_entry() as well
once all the uses after the loop are fixed?

I feel like this simply introduces a new set of macros
(we would also need list_traverse_reverse(), =
list_traverse_continue_reverse()
etc) and end up with a second set of macros that do pretty much
the same as the first one.

I like the way of using list_traversal_head() to only remember the type.
The interface of list_traverse() is the same as list_for_each_entry() so
we could just do this with a simple coccinelle script once 'pos' is no
longer used after the loop:

-struct some_struct *pos;
+list_traversal_head(struct some_struct, pos, target_member);


although there are *some* cases where 'pos' is also used separately
in the function which would need to change, e.g.:

struct some_struct *pos =3D some_variable;

if (pos)
	// do one thing
else
	list_for_each_entry(pos, ..., ...)


(I've fixed ~440/450 cases now and I'm chunking it into patch sets right =
now.
The once left over are non-obvious code I would need some input on)

Personally I guess I also prefer the name list_for_each_entry() over =
list_traverse()
and not having two types of iterators for the same thing at the same =
time.


>=20
>                   Linus
> <patch.diff>

Jakob

