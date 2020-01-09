Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA4F5135ABB
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 14:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730157AbgAIN4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 08:56:02 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:43259 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgAIN4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 08:56:01 -0500
Received: by mail-io1-f66.google.com with SMTP id n21so7125778ioo.10;
        Thu, 09 Jan 2020 05:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=content-transfer-encoding:mime-version:subject:from:in-reply-to:cc
         :date:message-id:references:to;
        bh=mmPlHP71ISpsjXgRBcY1D4awusYQBGYFaYLTtQP8wmc=;
        b=EmIrmaBtIsP2JO2tpLCZJIdGRaBCIypw9i40eFjaneE+6A4rAtGbzVG60Dn0Nu5DX0
         zHG6urCV+i+SfYD2eS14NfyXx9MwP73eIlvPrkzP++BZCv99QnfedJSOfI47LEK0ocVV
         UAzF1bfu7OTv56byVp1mgPXyooxK2iDgBk40e2RCoj5Py9nU48hXtJ1hZ4mDUZKk9jtj
         HWADdpZIo2UPkwsM5rhzKSrhG9+pMLMaTBxHF1yGnu/P6YdwrftoV7FJPfLtJ/o4ozxp
         l6gcv3CfFqZuzai4hvP8JSTfhKdiCMdb81OxIK7r50VtzsRwu4mxm8tSuAT9YdLLNR1g
         Tlgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:mime-version:subject
         :from:in-reply-to:cc:date:message-id:references:to;
        bh=mmPlHP71ISpsjXgRBcY1D4awusYQBGYFaYLTtQP8wmc=;
        b=s/pFvMQo2W0us8cYEo15hhfVp7/4TGUtFcYEN/cZDROzK4SFXQeTubevFTY292KeAs
         ssGTyIF1P9hr5rTvHtMV8whsEzIJal/4tLtiPKhvV6RdrVnWT3cMP4EfPGc4r5BTUFbd
         R/uJ/+jjBEnk+Hho5BwVlHI2W9pLN+bIKWMMMx+9VVlIX/PS0xL8/5hKT1k+VH/zuUqg
         ySBLaiw/RQJHHT2Vt1D3mUCnJ2QEfraz4AL2syclvmcs2GYXq52tK3Tv8y6X9yi0G6ii
         dQGpjUqJuFBnUVaoZrJYkJvhU+5zEHk0pHlGfTLLhuMfM93lJrmz8CEVLodxCy8qRmUi
         kMHQ==
X-Gm-Message-State: APjAAAW3++jZR66EuA0UtTTXhEvbLh6nJSptH53HgQ55/fJsBcYGnkUS
        CqjLnW1bfUw+vT9YdeSdIGs=
X-Google-Smtp-Source: APXvYqzkrr+kjqupl1XB5lRiRX4IqflHY1M08ciXd6HbLYPrL8RQgMexHy/gBLyeRLeqoTZ9nptkdw==
X-Received: by 2002:a5d:8cda:: with SMTP id k26mr7919141iot.26.1578578160705;
        Thu, 09 Jan 2020 05:56:00 -0800 (PST)
Received: from [100.64.72.6] ([173.245.215.240])
        by smtp.gmail.com with ESMTPSA id v21sm1419524ios.69.2020.01.09.05.55.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 05:56:00 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (1.0)
Subject: Re: [Xen-devel] [PATCH net-next] xen-netback: get rid of old udev related code
From:   Rich Persaud <persaur@gmail.com>
In-Reply-To: <79a0e144-6e98-9a12-2ad8-89459ae2c426@suse.com>
Cc:     David Miller <davem@davemloft.net>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jason Andryuk <jandryuk@gmail.com>,
        =?utf-8?Q?Marek_Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
Date:   Thu, 9 Jan 2020 08:55:59 -0500
Message-Id: <5C36C1D3-7FDD-4880-A63C-907441F8C9C0@gmail.com>
References: <79a0e144-6e98-9a12-2ad8-89459ae2c426@suse.com>
To:     =?utf-8?Q?J=C3=BCrgen_Gro=C3=9F?= <jgross@suse.com>,
        "Durrant, Paul" <pdurrant@amazon.com>
X-Mailer: iPad Mail (17C54)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Dec 16, 2019, at 03:31, J=C3=BCrgen Gro=C3=9F <jgross@suse.com> wrote:
>=20
> =EF=BB=BFOn 16.12.19 09:18, Durrant, Paul wrote:
>>> -----Original Message-----
>>> From: J=C3=BCrgen Gro=C3=9F <jgross@suse.com>
>>> Sent: 16 December 2019 08:10
>>> To: Durrant, Paul <pdurrant@amazon.com>; David Miller
>>> <davem@davemloft.net>
>>> Cc: xen-devel@lists.xenproject.org; wei.liu@kernel.org; linux-
>>> kernel@vger.kernel.org; netdev@vger.kernel.org
>>> Subject: Re: [Xen-devel] [PATCH net-next] xen-netback: get rid of old ud=
ev
>>> related code
>>>> On 13.12.19 11:12, Durrant, Paul wrote:
>>>>>> -----Original Message-----
>>>>>> From: J=C3=BCrgen Gro=C3=9F <jgross@suse.com>
>>>>>> Sent: 13 December 2019 10:02
>>>>>> To: Durrant, Paul <pdurrant@amazon.com>; David Miller
>>>>>> <davem@davemloft.net>
>>>>>> Cc: xen-devel@lists.xenproject.org; wei.liu@kernel.org; linux-
>>>>>> kernel@vger.kernel.org; netdev@vger.kernel.org
>>>>>> Subject: Re: [Xen-devel] [PATCH net-next] xen-netback: get rid of old=

>>> udev
>>>>> related code
>>>>> On 13.12.19 10:24, Durrant, Paul wrote:
>>>>>>> -----Original Message-----
>>>>>>> From: J=C3=BCrgen Gro=C3=9F <jgross@suse.com>
>>>>>>> Sent: 13 December 2019 05:41
>>>>>>> To: David Miller <davem@davemloft.net>; Durrant, Paul
>>>>>>> <pdurrant@amazon.com>
>>>>>>> Cc: xen-devel@lists.xenproject.org; wei.liu@kernel.org; linux-
>>>>>>> kernel@vger.kernel.org; netdev@vger.kernel.org
>>>>>>> Subject: Re: [Xen-devel] [PATCH net-next] xen-netback: get rid of ol=
d
>>>>> udev
>>>>>>> related code
>>>>>>>> On 12.12.19 20:05, David Miller wrote:
>>>>>>>>> From: Paul Durrant <pdurrant@amazon.com>
>>>>>>>>> Date: Thu, 12 Dec 2019 13:54:06 +0000
>>>>>>>>>> In the past it used to be the case that the Xen toolstack relied
>>>> upon
>>>>>>>>>> udev to execute backend hotplug scripts. However this has not bee=
n
>>>>>> the
>>>>>>>>>> case for many releases now and removal of the associated code in
>>>>>>>>>> xen-netback shortens the source by more than 100 lines, and remov=
es
>>>>>>>> much
>>>>>>>>>> complexity in the interaction with the xenstore backend state.
>>>>>>>>>> NOTE: xen-netback is the only xenbus driver to have a functional
>>>>>>>> uevent()
>>>>>>>>>>         method. The only other driver to have a method at all is
>>>>>>>>>>         pvcalls-back, and currently pvcalls_back_uevent() simply
>>>>>> returns
>>>>>>>> 0.
>>>>>>>>>>         Hence this patch also facilitates further cleanup.
>>>>>>>>>> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
>>>>>>>>> If userspace ever used this stuff, I seriously doubt you can remov=
e
>>>>>> this
>>>>>>>>> even if it hasn't been used in 5+ years.
>>>>>>>> Hmm, depends.
>>>>>>>> This has been used by Xen tools in dom0 only. If the last usage has=

>>>>>> been
>>>>>>>> in a Xen version which is no longer able to run with current Linux i=
n
>>>>>>>> dom0 it could be removed. But I guess this would have to be a rathe=
r
>>>>>> old
>>>>>>>> version of Xen (like 3.x?).
>>>>>>>> Paul, can you give a hint since which Xen version the toolstack no
>>>>>>>> longer relies on udev to start the hotplug scripts?
>>>>>>> The udev rules were in a file called tools/hotplug/Linux/xen-
>>>>>> backend.rules (in xen.git), and a commit from Roger removed the NIC
>>>> rules
>>>>>> in 2012:
>>>>>>> commit 57ad6afe2a08a03c40bcd336bfb27e008e1d3e53
>>>>>> Xen 4.2
>>>>>>> The last commit I could find to that file modified its name to xen-
>>>>>> backend.rules.in, and this was finally removed by George in 2015:
>>>>>>> commit 2ba368d13893402b2f1fb3c283ddcc714659dd9b
>>>>>> Xen 4.6
>>>>>>> So, I think this means anyone using a version of the Xen tools withi=
n
>>>>>> recent memory will be having their hotplug scripts called directly by=

>>>>>> libxl (and having udev rules present would actually be counter-
>>>> productive,
>>>>>> as George's commit states and as I discovered the hard way when the
>>>> change
>>>>>> was originally made).
>>>>>> The problem are systems with either old Xen versions (before Xen 4.2)=

>>>> or
>>>>>> with other toolstacks (e.g. Xen 4.4 with xend) which want to use a ne=
w
>>>>>> dom0 kernel.
>>>>>> And I'm not sure there aren't such systems (especially in case someon=
e
>>>>>> wants to stick with xend).
>>>>> But would someone sticking with such an old toolstack expect to run on=

>>>> an unmodified upstream dom0? There has to be some way in which we can
>>>> retire old code.
>>>> As long as there are no hypervisor interface related issues
>>>> prohibiting running dom0 unmodified I think the expectation to be
>>>> able to use the kernel in that environment is fine.
>> I think we need a better policy in future then otherwise we will only col=
lect baggage.
>=20
> The Linux kernel policy regarding user interfaces and existing use cases
> is rather clear and we should not deviate without very strong reasons.
>=20
>>> Another question coming up would be: how is this handled in a driver
>>> domain running netback? Which component is starting the hotplug script
>>> there? I don't think we can assume a standard Xen toolset in this case.
>>> So I'd rather leave this code as it is instead of breaking some rare
>>> but valid use cases.
>> I am not sure there is a standard. Do we 'support' driver domains with an=
y sort of tools API or do they really just have to notice things via xenstor=
e? I agree Linux running as a driver domain could indeed use udev.
>=20
> I intend in no way to break projects like Qubes. Disaggregation is
> one of the very big advantages of Xen over KVM, Hyper-V and VMWare.
> We should not give that up "just to get rid of some code". Period.

=46rom a quick poll of Qubes and OpenXT netback usage: neither project would=
 be impacted by the proposed change.  Qubes uses xl devd to call hotplug scr=
ipts.  OpenXT uses uevent triggers, but does not rely on any script provided=
 in the uevent.  Ongoing simplification of backend drivers would be welcome.=


Rich

>=20
>>>> Aside from the udev kicks though, I still think the hotplug-status/ring=

>>> state interaction is just bogus anyway. As I said in a previous thread,
>>> the hotplug-status ought to be indicated as carrier status, if at all, s=
o
>>> I still think all that code ought to go.
>>> I agree regarding the future interface, but with the carrier state just
>>> being in the plans to be added now, it is clearly too early to remove
>>> the code with that reasoning.
>> I don't think so. Like I said, I think the hotplug status has nothing to d=
o with the state of the shared ring. Even with the code as-is, nothing infor=
ms the frontend if the netif is subsequently closed or re-plumbed, so why mu=
st we continue to maintain this code? AFAICT it is just not fit for purpose.=

>=20
> If it is being used that way we need to continue supporting it.
>=20
>=20
> Juergen
>=20
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xenproject.org
> https://lists.xenproject.org/mailman/listinfo/xen-devel
