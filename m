Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4DB93A32B9
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhFJSKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:10:21 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:32897 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbhFJSKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:10:16 -0400
Received: from [192.168.1.155] ([95.115.39.199]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MAOa3-1m2Ar83JKV-00Bw0l; Thu, 10 Jun 2021 20:07:57 +0200
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
To:     David Hildenbrand <david@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Greg KH <greg@kroah.com>, Christoph Lameter <cl@gentwo.de>
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
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Message-ID: <5038827c-463f-232d-4dec-da56c71089bd@metux.net>
Date:   Thu, 10 Jun 2021 20:07:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <b32c8672-06ee-bf68-7963-10aeabc0596c@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: tl
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:h3TsVFZQW1eeWxWIwEU03AV+gSVwsiMLM6JxbsYr4WP0Fwq23A2
 CiXWNpTQ5rJyN4lnIlW3kNqu1QDJHOU9jXONXeRpeKHiJh149DjgQM0E2BKk2DnTypFbthH
 r0BSBnK2DPiDCypN8o4dp/TEYuXShTv8MoV3a1LIiFYVPq/F68NtDYbwRsf40mUoOx6kkFA
 jJOwRV273/dupW+JPy8Fg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:RPR8u21hQiQ=:WMPCtJcTv+xnqOrRaqItdg
 pTQrLFmyOswfSwUDFdlHDGFylEX4TtOn0b9LskM+UqYiTWSbFD9p76i03ghY4Ke2PgXAKBZ75
 q6ytFDizMVPHn6Zg+ZGzSq7vHCvS2xWn0u2B0YIhlTEAjiJd4bA+9rPrK0T1dcfGT6Mox8pkR
 mtm1+Fw3thU+HLx+oKF7kfQyE8xMXqSnA3d4Ita5jpsrf/fTFJtUxSoPBPG+a8SZCFpdc9wvZ
 9/jlKkBDy/73YvOT/02BbZPep5/H51zO1ivWiWWbFcgC3bDLYQr8zXwsT/YU0Cmgv6M6zfq3j
 2TZ7gcubdef2OOqLR+t0vEVuQtJcNVHtDduwWi6dR9ofvNkrsewfSwcQi8w2Wr8P3olZ8aeWB
 FfsQGDokItv2hz1feciWckHCLE/IBKROay7Om69AlP+YItfgS/W83MMpmR9PFn8f5dSIAdGWz
 qH1svdZS7+V9gaDRw6uNwheFQ8HuFct02guXK9Gnh33W6t/+Gn84C5N7VIV/d2X/VbKAvg1vp
 Ty6S/JHRodXa4AeYpvQH04=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.06.21 12:37, David Hildenbrand wrote:
> On 28.05.21 16:58, James Bottomley wrote:
>> On Thu, 2021-05-27 at 15:29 +0200, Greg KH wrote:
>>> On Thu, May 27, 2021 at 03:23:03PM +0200, Christoph Lameter wrote:
>>>> On Fri, 30 Apr 2021, Theodore Ts'o wrote:
>>>>
>>>>> I know we're all really hungry for some in-person meetups and
>>>>> discussions, but at least for LPC, Kernel Summit, and
>>>>> Maintainer's Summit, we're going to have to wait for another
>>>>> year,
>>>>
>>>> Well now that we are vaccinated: Can we still change it?
>>>>
>>>
>>> Speak for yourself, remember that Europe and other parts of the world
>>> are not as "flush" with vaccines as the US currently is :(
>>
>> The rollout is accelerating in Europe.  At least in Germany, I know
>> people younger than me are already vaccinated. 
> 
> And I know people younger than you in Germany personally ( ;) ) that are 
> not vaccinated yet and might not even get the first shot before 
> September, not even dreaming about a second one + waiting until the 
> vaccine is fully in effect.

And I know *a lot* of people who will never take part in this generic
human experiment that basically creates a new humanoid race (people
who generate and exhaust the toxic spike proteine, whose gene sequence
doesn't look quote natural). I'm one of them, as my whole family.

> So yes, sure, nobody can stop people that think the pandemic is over 
> ("we are vaccinated") from meeting in person. 

Pandemic ? Did anybody look at the actual scientific data instead of
just watching corporate tv ? #faucigate


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
