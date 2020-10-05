Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E50F283F0B
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 20:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbgJESxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 14:53:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29506 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728604AbgJESxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 14:53:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601923984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=bYTzQ3F6eG+76nTCxErICHufox8u7MGOZdIPwvtTRsk=;
        b=LKc2V1CvJcexLydaU/fQW32pswM01s+7yPuD+nzkR6apkdxtT+dJ90fiFvkC+x0VkgcjDh
        MRrZ3DsVLRLWBUP+qmFS6TavB8rZ7BECUkDzovbn3eh/Zc24A9hDM67yCqA1+VcDLH1NpT
        Xhir/8BSD4fNzzGo2XUOWyIwlPjPdtw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-d96Iy-mzPdSsQl8JmUMuSA-1; Mon, 05 Oct 2020 14:52:59 -0400
X-MC-Unique: d96Iy-mzPdSsQl8JmUMuSA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2965427C6;
        Mon,  5 Oct 2020 18:52:56 +0000 (UTC)
Received: from [10.10.115.89] (ovpn-115-89.rdu2.redhat.com [10.10.115.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2609055767;
        Mon,  5 Oct 2020 18:52:52 +0000 (UTC)
Subject: Re: [EXT] Re: [PATCH v4 03/13] task_isolation: userspace hard
 isolation from kernel
To:     Frederic Weisbecker <frederic@kernel.org>,
        Alex Belits <abelits@marvell.com>
Cc:     "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "will@kernel.org" <will@kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
 <b18546567a2ed61073ae86f2d9945257ab285dfa.camel@marvell.com>
 <20201001135640.GA1748@lothringen>
 <7e54b3c5e0d4c91eb64f2dd1583dd687bc34757e.camel@marvell.com>
 <20201004231404.GA66364@lothringen>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <d0289bb9-cc10-9e64-f8ac-b4d252b424b8@redhat.com>
Date:   Mon, 5 Oct 2020 14:52:49 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201004231404.GA66364@lothringen>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FZsMq2mJZeIH5dAtjmHM1IGNAg59yNcN1"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FZsMq2mJZeIH5dAtjmHM1IGNAg59yNcN1
Content-Type: multipart/mixed; boundary="iXkXMJXBMjNjUkrwCUh5aCwKUrA8HgQ0S"

--iXkXMJXBMjNjUkrwCUh5aCwKUrA8HgQ0S
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 10/4/20 7:14 PM, Frederic Weisbecker wrote:
> On Sun, Oct 04, 2020 at 02:44:39PM +0000, Alex Belits wrote:
>> On Thu, 2020-10-01 at 15:56 +0200, Frederic Weisbecker wrote:
>>> External Email
>>>
>>> -------------------------------------------------------------------
>>> ---
>>> On Wed, Jul 22, 2020 at 02:49:49PM +0000, Alex Belits wrote:
>>>> +/*
>>>> + * Description of the last two tasks that ran isolated on a given
>>>> CPU.
>>>> + * This is intended only for messages about isolation breaking. We
>>>> + * don't want any references to actual task while accessing this
>>>> from
>>>> + * CPU that caused isolation breaking -- we know nothing about
>>>> timing
>>>> + * and don't want to use locking or RCU.
>>>> + */
>>>> +struct isol_task_desc {
>>>> +=09atomic_t curr_index;
>>>> +=09atomic_t curr_index_wr;
>>>> +=09bool=09warned[2];
>>>> +=09pid_t=09pid[2];
>>>> +=09pid_t=09tgid[2];
>>>> +=09char=09comm[2][TASK_COMM_LEN];
>>>> +};
>>>> +static DEFINE_PER_CPU(struct isol_task_desc, isol_task_descs);
>>> So that's quite a huge patch that would have needed to be split up.
>>> Especially this tracing engine.
>>>
>>> Speaking of which, I agree with Thomas that it's unnecessary. It's
>>> too much
>>> code and complexity. We can use the existing trace events and perform
>>> the
>>> analysis from userspace to find the source of the disturbance.
>> The idea behind this is that isolation breaking events are supposed to
>> be known to the applications while applications run normally, and they
>> should not require any analysis or human intervention to be handled.
> Sure but you can use trace events for that. Just trace interrupts, workqu=
eues,
> timers, syscalls, exceptions and scheduler events and you get all the loc=
al
> disturbance. You might want to tune a few filters but that's pretty much =
it.
>
> As for the source of the disturbances, if you really need that informatio=
n,
> you can trace the workqueue and timer queue events and just filter those =
that
> target your isolated CPUs.
>

I agree that we can do all those things with tracing.
However, IMHO having a simplified logging mechanism to gather the source of
violation may help in reducing the manual effort.

Although, I am not sure how easy will it be to maintain such an interface
over time.

--
Thanks
Nitesh


--iXkXMJXBMjNjUkrwCUh5aCwKUrA8HgQ0S--

--FZsMq2mJZeIH5dAtjmHM1IGNAg59yNcN1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl97a4EACgkQo4ZA3AYy
oznBWxAAlhg9XOo89MStI92WCr4vACZOesnTMkmqmEwR20N1mxYpbpTGO8ewEJVv
B/bFRU6fCizkzaD1BVGeRjwv5i/kNl7EcqbFgHquzdat8Lypn5mx93hJyGz1SYrr
IKg8oH0AHD6dR3zeil/wxDe8xFDb29Bjz2B8ncGmvHrH4B7yvgLnKShsCYonv5Yu
w2I6W9yROnImpJF2nYP9ZGyHyGcElrHB3367vAlPwH9lv6UhXZP2L5WplvEV5Zec
pnLGYwlxMnbP1lW6gzEGnUF71fK7x3E3Q9eoFMqIZkmpfpmpjSlVW4Vd+Xu2hNeZ
WYaHevr7hC/WxIwOR4o0uo322TgshcI86XHKyhrDH8sj9Zuy8brUt5zIwYdcZOZS
8+gkWKRbE21KmMQ/I9TZfmd1c/n1h56Z3d45KEkdrPZjP6pb1BG9DemgIrtNm1SI
GTpjM6UBrTCGleWObLOJYbE/UDWbzLHPQmADUl45Zfti4T/2L4LZEBh0+qyAbEEk
A28X9gY7D2eEx3w+sNbpWIX8dFPclAYliKMucM1nOv4MCcoF8K3dR8Wm8qFr7SnH
GCNU/0IA4mUP+/h1C7eyBynRLPid5QGBmdlbFAYx36C9Qmr9GZJs3bbRAAKaUSW/
6SJ6GfPHWpf7uhaieX4OHIvjLwlc3UPur/UWqqAPPYQxumSUxCg=
=2AIi
-----END PGP SIGNATURE-----

--FZsMq2mJZeIH5dAtjmHM1IGNAg59yNcN1--

