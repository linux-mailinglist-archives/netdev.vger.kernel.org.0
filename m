Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657D53A40B7
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 12:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbhFKLBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 07:01:50 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:51773 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbhFKLBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 07:01:18 -0400
Received: from [192.168.1.155] ([95.115.52.72]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MPosX-1ldaEj40EF-00Mtt2; Fri, 11 Jun 2021 12:58:51 +0200
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        David Hildenbrand <david@redhat.com>, Greg KH <greg@kroah.com>,
        Christoph Lameter <cl@gentwo.de>
Cc:     Theodore Ts'o <tytso@mit.edu>, Jiri Kosina <jikos@kernel.org>,
        ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org
References: <YH2hs6EsPTpDAqXc@mit.edu>
 <nycvar.YFH.7.76.2104281228350.18270@cbobk.fhfr.pm>
 <YIx7R6tmcRRCl/az@mit.edu>
 <alpine.DEB.2.22.394.2105271522320.172088@gentwo.de>
 <YK+esqGjKaPb+b/Q@kroah.com>
 <c46dbda64558ab884af060f405e3f067112b9c8a.camel@HansenPartnership.com>
 <b32c8672-06ee-bf68-7963-10aeabc0596c@redhat.com>
 <e993d6c84c79d083ecfe5a8c8edabef9e9caa3ce.camel@HansenPartnership.com>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Message-ID: <6d8299e4-2707-7edf-ebe4-f5ca7b7ee8ca@metux.net>
Date:   Fri, 11 Jun 2021 12:58:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <e993d6c84c79d083ecfe5a8c8edabef9e9caa3ce.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: tl
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:W1CuRBv9b9vfO/cntxLvE7zRNUCd1/dUgLqWvl6KCwi7Sw23ByG
 lxCAe9Q91/0vR2PyBETRIzab+l26EBWvYSHZ0LUnS9cubvCX5xzUC+CV5JjFwPCWXQxaQOo
 5taiouS8C+FKLJ+dmpW4iHuaNuDY6rfJXKdICti+cmqPwkBEzGu+ypcMKrurkTnsQ34K6rI
 06GNiokz08qz4bFDbl2SA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Hq+AqsHvTCw=:QA0c4LdeomjvdgpT+WeCnm
 fvybeHcu/cjr4qkbFb37AHeWQkFDtgzJzer94ls3YhCWt+DHTcRYat2Xw0bDzC571L64go0Zn
 S47+PKyO7iqLbN5ux7Q1bobJkmQyzd4AVn+mJY+DPRWcavypMr61kqgdFjuX6IrVfAowwYiyw
 ly4+mDH127ZO25ThonvdPqnoC09zxMXWofSvrJHTIPF4vPxkQXahO8ZHchkVwwHh8tFFS9JUo
 vw0Lc1EfnmgDoFqHS8P6BW62s3Uh3KwIa5lpH9LO079r/sMc5j3UnvF0meS+/OFKTSylXL8pQ
 fF4Yn/2vfs6qyTFzVGrX0PFL6LNgcYXVDEO0NdXW2C5RLxtOyj3d1JvZqKDgzj4z6+zsBCtiK
 +vjMQtcEEILeH+OmBOdGnY90xLmBJgEiytsBww27KXXtF3L8mJhAPmUpYrzB6flKlq1MN5TEr
 gKbkU+qWBdVtrKAW68yo2YXTIZpiR3DPgifLAb24jDy5gkRZPhn17QKUazkuebWViJSbKQTtF
 v7QlP+4xZ/23ZVOX5McNNQ=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.06.21 21:23, James Bottomley wrote:

> but the US is definitely moving
> to a regime that says once you're vaccinated it's pretty much over for

As far as I see (watching from the other side of the globe), for most
states it already is over, no matter whether somebody got a shot or not.
(actually, getting reports of people *with* the shot get increasing
trouble, eg. kept out of stores, schools, planes, ...).

FL and TX seem to be the most relaxed states in this regard.
Maybe ask DeStantis and Abbot whether they'd support such a conference
in their states, maybe they'd even open their cheque books ;-)

> you and I don't see a problem with taking advantage of that for hybrid
> style events.  However, even with the best will in the world, I can't
> see much of a way around the problem that remote people at hybrid
> events will always be at a disadvantage ... suggestions for improving
> this are always welcome.

Looking from a totally different angle, I believe the hybrid approach
could even be a benefit. For example, longer talks - IMHO - are easier
to do (and for the audience) when just recorded, so people can listen to
them any time (and as often one wants to). Spontanous questions right
after, I guess, are only helpful for a small minority that's already 
deep in that particular topic - in those cases I'd prefer a more 
personal conversation. Another scenario are expert working groups, where
people already involved into certain topic talk closely - IMHO something
where direct (group) calls are a good medium, and probably working
better outside the strict time frames of such an event.

Maybe it's good idea to jump back to square one and ask the question,
what people actually expect from and try to achieve from such an event,
before going into some actual planning. (I could only express my very
personal view, but that's probably far from being representative)


--mtx

-- 
---
Hinweis: unverschlüsselte E-Mails können leicht abgehört und manipuliert
werden ! Für eine vertrauliche Kommunikation senden Sie bitte ihren
GPG/PGP-Schlüssel zu.
---
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
