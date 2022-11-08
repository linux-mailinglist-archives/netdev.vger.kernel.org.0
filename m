Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D66621DAE
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 21:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiKHUaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 15:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiKHUad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 15:30:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900CC24BD5
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 12:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667939379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EXj8GNFYBj1dZ63Trl3vi8N8BTnSh2r+U9o0Mo8SQKU=;
        b=Qayu7jfVGx8jt4ziideG+ZprcMEDiJJb/hfmIyWGn9kziX9lxYvNjmiEZBY/s20PK9pc7q
        09V2KttL+3jSTM5us6mGnXRObqKvuH7YLvY2F2gfkV8Dah2FxgNEitbqEpR881Ws0Y2rCU
        1othJBY3UaFWpz/P4u4jWfhva7P6xHo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-311-ZzXS6SbENCKVRHKfVAJ0uA-1; Tue, 08 Nov 2022 15:29:36 -0500
X-MC-Unique: ZzXS6SbENCKVRHKfVAJ0uA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A78EC800B30;
        Tue,  8 Nov 2022 20:29:35 +0000 (UTC)
Received: from localhost (unknown [10.39.192.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C83F32028E90;
        Tue,  8 Nov 2022 20:29:34 +0000 (UTC)
Date:   Tue, 8 Nov 2022 15:29:32 -0500
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCHSET v3 0/5] Add support for epoll min_wait
Message-ID: <Y2q8LDGCT8rh8zbQ@fedora>
References: <Y2lw4Qc1uI+Ep+2C@fedora>
 <4281b354-d67d-2883-d966-a7816ed4f811@kernel.dk>
 <Y2phEZKYuSmPL5B5@fedora>
 <93fa2da5-c81a-d7f8-115c-511ed14dcdbb@kernel.dk>
 <Y2p/YcUFhFDUnLGq@fedora>
 <75c8f5fe-6d5f-32a9-1417-818246126789@kernel.dk>
 <Y2qQuiZvuML14wX0@fedora>
 <ba524eab-eff7-5fad-06c2-8188cdf881a1@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GHAaYT9vVWXvwwcv"
Content-Disposition: inline
In-Reply-To: <ba524eab-eff7-5fad-06c2-8188cdf881a1@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--GHAaYT9vVWXvwwcv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 08, 2022 at 10:28:37AM -0700, Jens Axboe wrote:
> On 11/8/22 10:24 AM, Stefan Hajnoczi wrote:
> > On Tue, Nov 08, 2022 at 09:15:23AM -0700, Jens Axboe wrote:
> >> On 11/8/22 9:10 AM, Stefan Hajnoczi wrote:
> >>> On Tue, Nov 08, 2022 at 07:09:30AM -0700, Jens Axboe wrote:
> >>>> On 11/8/22 7:00 AM, Stefan Hajnoczi wrote:
> >>>>> On Mon, Nov 07, 2022 at 02:38:52PM -0700, Jens Axboe wrote:
> >>>>>> On 11/7/22 1:56 PM, Stefan Hajnoczi wrote:
> >>>>>>> Hi Jens,
> >>>>>>> NICs and storage controllers have interrupt mitigation/coalescing
> >>>>>>> mechanisms that are similar.
> >>>>>>
> >>>>>> Yep
> >>>>>>
> >>>>>>> NVMe has an Aggregation Time (timeout) and an Aggregation Thresho=
ld
> >>>>>>> (counter) value. When a completion occurs, the device waits until=
 the
> >>>>>>> timeout or until the completion counter value is reached.
> >>>>>>>
> >>>>>>> If I've read the code correctly, min_wait is computed at the begi=
nning
> >>>>>>> of epoll_wait(2). NVMe's Aggregation Time is computed from the fi=
rst
> >>>>>>> completion.
> >>>>>>>
> >>>>>>> It makes me wonder which approach is more useful for applications=
=2E With
> >>>>>>> the Aggregation Time approach applications can control how much e=
xtra
> >>>>>>> latency is added. What do you think about that approach?
> >>>>>>
> >>>>>> We only tested the current approach, which is time noted from entr=
y, not
> >>>>>> from when the first event arrives. I suspect the nvme approach is =
better
> >>>>>> suited to the hw side, the epoll timeout helps ensure that we batch
> >>>>>> within xx usec rather than xx usec + whatever the delay until the =
first
> >>>>>> one arrives. Which is why it's handled that way currently. That gi=
ves
> >>>>>> you a fixed batch latency.
> >>>>>
> >>>>> min_wait is fine when the goal is just maximizing throughput withou=
t any
> >>>>> latency targets.
> >>>>
> >>>> That's not true at all, I think you're in different time scales than
> >>>> this would be used for.
> >>>>
> >>>>> The min_wait approach makes it hard to set a useful upper bound on
> >>>>> latency because unlucky requests that complete early experience much
> >>>>> more latency than requests that complete later.
> >>>>
> >>>> As mentioned in the cover letter or the main patch, this is most use=
ful
> >>>> for the medium load kind of scenarios. For high load, the min_wait t=
ime
> >>>> ends up not mattering because you will hit maxevents first anyway. F=
or
> >>>> the testing that we did, the target was 2-300 usec, and 200 usec was
> >>>> used for the actual test. Depending on what the kind of traffic the
> >>>> server is serving, that's usually not much of a concern. From your
> >>>> reply, I'm guessing you're thinking of much higher min_wait numbers.=
 I
> >>>> don't think those would make sense. If your rate of arrival is low
> >>>> enough that min_wait needs to be high to make a difference, then the
> >>>> load is low enough anyway that it doesn't matter. Hence I'd argue th=
at
> >>>> it is indeed NOT hard to set a useful upper bound on latency, because
> >>>> that is very much what min_wait is.
> >>>>
> >>>> I'm happy to argue merits of one approach over another, but keep in =
mind
> >>>> that this particular approach was not pulled out of thin air AND it =
has
> >>>> actually been tested and verified successfully on a production workl=
oad.
> >>>> This isn't a hypothetical benchmark kind of setup.
> >>>
> >>> Fair enough. I just wanted to make sure the syscall interface that ge=
ts
> >>> merged is as useful as possible.
> >>
> >> That is indeed the main discussion as far as I'm concerned - syscall,
> >> ctl, or both? At this point I'm inclined to just push forward with the
> >> ctl addition. A new syscall can always be added, and if we do, then it=
'd
> >> be nice to make one that will work going forward so we don't have to
> >> keep adding epoll_wait variants...
> >=20
> > epoll_wait3() would be consistent with how maxevents and timeout work.
> > It does not suffer from extra ctl syscall overhead when applications
> > need to change min_wait.
> >=20
> > The way the current patches add min_wait into epoll_ctl() seems hacky to
> > me. struct epoll_event was meant for file descriptor event entries. It
> > won't necessarily be large enough for future extensions (luckily
> > min_wait only needs a uint64_t value). It's turning epoll_ctl() into an
> > ioctl()/setsockopt()-style interface, which is bad for anything that
> > needs to understand syscalls, like seccomp. A properly typed
> > epoll_wait3() seems cleaner to me.
>=20
> The ctl method is definitely a bit of an oddball. I've highlighted why
> I went that way in earlier emails, but in summary:
>=20
> - Makes it easy to adopt, just adding two lines at init time.
>=20
> - Moves detection of availability to init time as well, rather than
>   the fast path.

Add an epoll_create1() flag to test for availability?

> I don't think anyone would want to often change the wait, it's
> something you'd set at init time. If you often want to change values
> for some reason, then obviously a syscall parameter would be a lot
> better.
>=20
> epoll_pwait3() would be vastly different than the other ones, simply
> because epoll_pwait2() is already using the maximum number of args.
> We'd need to add an epoll syscall struct at that point, probably
> with flags telling us if signal_struct or timeout is actually valid.

Yes :/.

> This is not to say I don't think we should add a syscall interface,
> just some of the arguments pro and con from having actually looked
> at it.
>=20
> --=20
> Jens Axboe
>=20
>=20

--GHAaYT9vVWXvwwcv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmNqvCwACgkQnKSrs4Gr
c8gciAgAyIWUfXfeWsTtymDmgRBikdZ6kFz/AE+An70tlsWTL+aTspggKNwK7r4f
XHwFLfMS0Y63JjHo73z6y/RC1QZfiida4gjTun+l29b+7t7b8/bWf/wBozp0zTNu
Hpj0AeFwJWXHSl7Kx4udL68GpTOL7pU6ei8YqvL1PBlcHWw9YARuFV6wcL5yCT9L
4EwVUKH1NPoKvF/aUMZsh9s4XDDc2vjN0X2u/tClpCkUAU1qKUa0bTjtEBzcpo6H
AQD59s6Zr9Ffu3lYX/dk7y3tPDk2M8r0Mj309YzG1TascBNe2eL/mx1q+FAHU36z
hfVdswE9F5EClByymk+ZexsrM/iFiw==
=pMjK
-----END PGP SIGNATURE-----

--GHAaYT9vVWXvwwcv--

