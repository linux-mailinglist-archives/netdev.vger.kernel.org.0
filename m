Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25106621A6E
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234512AbiKHRZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:25:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234012AbiKHRZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:25:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D86B81
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 09:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667928258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jaxJz/zVXTLSHM/FX5ogpiQ4fyPxyR99ZK0ufiiW1NY=;
        b=HJfp0/bgY6D8wqR+MdwFRTpAFOGGHTD3NYJUiIjZipslh8UPQGBU16VEwbtn939M9pFBoY
        H+YWcSsT6VExt5A/0R0VGEi9vuGw50JTww+LhSlOnL4n0EBQ97FCMi9POLQC/jaDuSVJYR
        Svrh0KpVHCIJyiMfrlEzLI+u5xhYckY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-zSt8iAHUMaOs1HYu3Wzv0Q-1; Tue, 08 Nov 2022 12:24:13 -0500
X-MC-Unique: zSt8iAHUMaOs1HYu3Wzv0Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2AD43C43B21;
        Tue,  8 Nov 2022 17:24:12 +0000 (UTC)
Received: from localhost (unknown [10.39.195.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D93C2166B29;
        Tue,  8 Nov 2022 17:24:11 +0000 (UTC)
Date:   Tue, 8 Nov 2022 12:24:10 -0500
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCHSET v3 0/5] Add support for epoll min_wait
Message-ID: <Y2qQuiZvuML14wX0@fedora>
References: <Y2lw4Qc1uI+Ep+2C@fedora>
 <4281b354-d67d-2883-d966-a7816ed4f811@kernel.dk>
 <Y2phEZKYuSmPL5B5@fedora>
 <93fa2da5-c81a-d7f8-115c-511ed14dcdbb@kernel.dk>
 <Y2p/YcUFhFDUnLGq@fedora>
 <75c8f5fe-6d5f-32a9-1417-818246126789@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="O0PSbzeHbyNIUTpg"
Content-Disposition: inline
In-Reply-To: <75c8f5fe-6d5f-32a9-1417-818246126789@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--O0PSbzeHbyNIUTpg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 08, 2022 at 09:15:23AM -0700, Jens Axboe wrote:
> On 11/8/22 9:10 AM, Stefan Hajnoczi wrote:
> > On Tue, Nov 08, 2022 at 07:09:30AM -0700, Jens Axboe wrote:
> >> On 11/8/22 7:00 AM, Stefan Hajnoczi wrote:
> >>> On Mon, Nov 07, 2022 at 02:38:52PM -0700, Jens Axboe wrote:
> >>>> On 11/7/22 1:56 PM, Stefan Hajnoczi wrote:
> >>>>> Hi Jens,
> >>>>> NICs and storage controllers have interrupt mitigation/coalescing
> >>>>> mechanisms that are similar.
> >>>>
> >>>> Yep
> >>>>
> >>>>> NVMe has an Aggregation Time (timeout) and an Aggregation Threshold
> >>>>> (counter) value. When a completion occurs, the device waits until t=
he
> >>>>> timeout or until the completion counter value is reached.
> >>>>>
> >>>>> If I've read the code correctly, min_wait is computed at the beginn=
ing
> >>>>> of epoll_wait(2). NVMe's Aggregation Time is computed from the first
> >>>>> completion.
> >>>>>
> >>>>> It makes me wonder which approach is more useful for applications. =
With
> >>>>> the Aggregation Time approach applications can control how much ext=
ra
> >>>>> latency is added. What do you think about that approach?
> >>>>
> >>>> We only tested the current approach, which is time noted from entry,=
 not
> >>>> from when the first event arrives. I suspect the nvme approach is be=
tter
> >>>> suited to the hw side, the epoll timeout helps ensure that we batch
> >>>> within xx usec rather than xx usec + whatever the delay until the fi=
rst
> >>>> one arrives. Which is why it's handled that way currently. That gives
> >>>> you a fixed batch latency.
> >>>
> >>> min_wait is fine when the goal is just maximizing throughput without =
any
> >>> latency targets.
> >>
> >> That's not true at all, I think you're in different time scales than
> >> this would be used for.
> >>
> >>> The min_wait approach makes it hard to set a useful upper bound on
> >>> latency because unlucky requests that complete early experience much
> >>> more latency than requests that complete later.
> >>
> >> As mentioned in the cover letter or the main patch, this is most useful
> >> for the medium load kind of scenarios. For high load, the min_wait time
> >> ends up not mattering because you will hit maxevents first anyway. For
> >> the testing that we did, the target was 2-300 usec, and 200 usec was
> >> used for the actual test. Depending on what the kind of traffic the
> >> server is serving, that's usually not much of a concern. From your
> >> reply, I'm guessing you're thinking of much higher min_wait numbers. I
> >> don't think those would make sense. If your rate of arrival is low
> >> enough that min_wait needs to be high to make a difference, then the
> >> load is low enough anyway that it doesn't matter. Hence I'd argue that
> >> it is indeed NOT hard to set a useful upper bound on latency, because
> >> that is very much what min_wait is.
> >>
> >> I'm happy to argue merits of one approach over another, but keep in mi=
nd
> >> that this particular approach was not pulled out of thin air AND it has
> >> actually been tested and verified successfully on a production workloa=
d.
> >> This isn't a hypothetical benchmark kind of setup.
> >=20
> > Fair enough. I just wanted to make sure the syscall interface that gets
> > merged is as useful as possible.
>=20
> That is indeed the main discussion as far as I'm concerned - syscall,
> ctl, or both? At this point I'm inclined to just push forward with the
> ctl addition. A new syscall can always be added, and if we do, then it'd
> be nice to make one that will work going forward so we don't have to
> keep adding epoll_wait variants...

epoll_wait3() would be consistent with how maxevents and timeout work.
It does not suffer from extra ctl syscall overhead when applications
need to change min_wait.

The way the current patches add min_wait into epoll_ctl() seems hacky to
me. struct epoll_event was meant for file descriptor event entries. It
won't necessarily be large enough for future extensions (luckily
min_wait only needs a uint64_t value). It's turning epoll_ctl() into an
ioctl()/setsockopt()-style interface, which is bad for anything that
needs to understand syscalls, like seccomp. A properly typed
epoll_wait3() seems cleaner to me.

Stefan

--O0PSbzeHbyNIUTpg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmNqkLoACgkQnKSrs4Gr
c8jMTwgAh6tsZz93MQq2mnRSH6XAQo+Ph8jToGrOwVvszEAkUWVuU43QLvwenksK
1qKC6u6XF67qTJFEuv0GranpsTrkrthQblxDd+MZjFd9XwWg3/JlmEqsqPM7BnJs
zKsO3vAf7FH6kn5EN2lW3CVZPQm/9M5aZjpkYZR9RGJInqLgG5yf686ZV1gXQx+F
AId8I4UVY2iQIpbtOewVDs92y6kZCU5GbTv5eZffU+r0a+nS/heGghbTY0BfNcix
ZBPffReBZOIWnXyC5gPMH0tRGkc8exm8ZIMPvm21eXqaCo2vwT5EVPkYup19OyEk
27EdGvpWh6p8WHDZydntmVkLqcD87w==
=/P5y
-----END PGP SIGNATURE-----

--O0PSbzeHbyNIUTpg--

