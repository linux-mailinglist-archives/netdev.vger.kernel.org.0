Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57031A6495
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 11:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbfICJCG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 3 Sep 2019 05:02:06 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:41636 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbfICJCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 05:02:06 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x8391rMf021012, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x8391rMf021012
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 3 Sep 2019 17:01:53 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0468.000; Tue, 3 Sep 2019 17:01:49 +0800
From:   Bambi Yeh <bambi.yeh@realtek.com>
To:     Hayes Wang <hayeswang@realtek.com>,
        Amber Chen <amber.chen@realtek.com>,
        Prashant Malani <pmalani@chromium.org>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ryankao <ryankao@realtek.com>, Jackc <jackc@realtek.com>,
        Albertk <albertk@realtek.com>,
        "marcochen@google.com" <marcochen@google.com>,
        nic_swsd <nic_swsd@realtek.com>,
        Grant Grundler <grundler@chromium.org>
Subject: RE: Proposal: r8152 firmware patching framework
Thread-Topic: Proposal: r8152 firmware patching framework
Thread-Index: AQHVX4GpTTdtotue5kafn6EzHtNLuacT5+mAgAOC+QCAAkCM0A==
Date:   Tue, 3 Sep 2019 09:01:48 +0000
Message-ID: <BAD4255E2724E442BCB37085A3D9C93AEEA087DF@RTITMBSVM03.realtek.com.tw>
References: <CACeCKacOcg01NuCWgf2RRer3bdmW-CH7d90Y+iD2wQh5Ka6Mew@mail.gmail.com>,<CACeCKacjCkS5UmzS9irm0JjGmk98uBBBsTLSzrXoDUJ60Be9Vw@mail.gmail.com>
 <755AFD2B-D66F-40FF-ADCD-5077ECC569FE@realtek.com>
 <0835B3720019904CB8F7AA43166CEEB2F18DA7A9@RTITMBSVM03.realtek.com.tw>
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2F18DA7A9@RTITMBSVM03.realtek.com.tw>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.234.218]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Prashant:

We will try to implement your requests.
Based on our experience, upstream reviewer often reject our modification if they have any concern.
Do you think you can talk to them about this idea and see if they will accept it or not?
Or if you can help on this after we submit it?

Also, Hayes is now updating our current upstream driver and it goes back and forth for a while.
So we will need some time to finish it and the target schedule to have your request done is in the end of this month.

Thank you very much.

Best Regards,
Bambi Yeh

-----Original Message-----
From: Hayes Wang <hayeswang@realtek.com> 
Sent: Monday, September 2, 2019 2:31 PM
To: Amber Chen <amber.chen@realtek.com>; Prashant Malani <pmalani@chromium.org>
Cc: David Miller <davem@davemloft.net>; netdev@vger.kernel.org; Bambi Yeh <bambi.yeh@realtek.com>; Ryankao <ryankao@realtek.com>; Jackc <jackc@realtek.com>; Albertk <albertk@realtek.com>; marcochen@google.com; nic_swsd <nic_swsd@realtek.com>; Grant Grundler <grundler@chromium.org>
Subject: RE: Proposal: r8152 firmware patching framework

Prashant Malani <pmalani@chromium.org> 
> >
> > (Adding a few more Realtek folks)
> >
> > Friendly ping. Any thoughts / feedback, Realtek folks (and others) ?
> >
> >> On Thu, Aug 29, 2019 at 11:40 AM Prashant Malani
> <pmalani@chromium.org> wrote:
> >>
> >> Hi,
> >>
> >> The r8152 driver source code distributed by Realtek (on
> >> www.realtek.com) contains firmware patches. This involves binary 
> >> byte-arrays being written byte/word-wise to the hardware memory
> >> Example: grundler@chromium.org (cc-ed) has an experimental patch
> which
> >> includes the firmware patching code which was distributed with the 
> >> Realtek source :
> >>
> https://chromium-review.googlesource.com/c/chromiumos/third_party/kern
> el
> /+/1417953
> >>
> >> It would be nice to have a way to incorporate these firmware fixes 
> >> into the upstream code. Since having indecipherable byte-arrays is 
> >> not possible upstream, I propose the following:
> >> - We use the assistance of Realtek to come up with a format which 
> >> the firmware patch files can follow (this can be documented in the 
> >> comments).
> >>       - A real simple format could look like this:
> >>               +
> >>
> <section1><size_in_bytes><address1><data1><address2><data2>...<address
> N
> ><dataN><section2>...
> >>                + The driver would be able to understand how to 
> >> parse each section (e.g is each data entry a byte or a word?)
> >>
> >> - We use request_firmware() to load the firmware, parse it and 
> >> write the data to the relevant registers.

I plan to finish the patches which I am going to submit, first. Then, I could focus on this. However, I don't think I would start this quickly. There are many preparations and they would take me a lot of time.

Best Regards,
Hayes


