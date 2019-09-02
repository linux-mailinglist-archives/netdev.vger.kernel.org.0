Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 199A2A4F35
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 08:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbfIBGb0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 2 Sep 2019 02:31:26 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:36263 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729262AbfIBGb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 02:31:26 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x826VBEk031462, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x826VBEk031462
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 2 Sep 2019 14:31:11 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0468.000; Mon, 2 Sep 2019 14:31:10 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Amber Chen <amber.chen@realtek.com>,
        Prashant Malani <pmalani@chromium.org>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Bambi Yeh <bambi.yeh@realtek.com>,
        Ryankao <ryankao@realtek.com>, Jackc <jackc@realtek.com>,
        Albertk <albertk@realtek.com>,
        "marcochen@google.com" <marcochen@google.com>,
        nic_swsd <nic_swsd@realtek.com>,
        Grant Grundler <grundler@chromium.org>
Subject: RE: Proposal: r8152 firmware patching framework
Thread-Topic: Proposal: r8152 firmware patching framework
Thread-Index: AQHVXpk95WoLzGj3hUKUo2QxLu5QNqcTv/EAgAApyYCABAJLsA==
Date:   Mon, 2 Sep 2019 06:31:08 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18DA7A9@RTITMBSVM03.realtek.com.tw>
References: <CACeCKacOcg01NuCWgf2RRer3bdmW-CH7d90Y+iD2wQh5Ka6Mew@mail.gmail.com>,<CACeCKacjCkS5UmzS9irm0JjGmk98uBBBsTLSzrXoDUJ60Be9Vw@mail.gmail.com>
 <755AFD2B-D66F-40FF-ADCD-5077ECC569FE@realtek.com>
In-Reply-To: <755AFD2B-D66F-40FF-ADCD-5077ECC569FE@realtek.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.214]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
> https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel
> /+/1417953
> >>
> >> It would be nice to have a way to incorporate these firmware fixes
> >> into the upstream code. Since having indecipherable byte-arrays is not
> >> possible upstream, I propose the following:
> >> - We use the assistance of Realtek to come up with a format which the
> >> firmware patch files can follow (this can be documented in the
> >> comments).
> >>       - A real simple format could look like this:
> >>               +
> >>
> <section1><size_in_bytes><address1><data1><address2><data2>...<addressN
> ><dataN><section2>...
> >>                + The driver would be able to understand how to parse
> >> each section (e.g is each data entry a byte or a word?)
> >>
> >> - We use request_firmware() to load the firmware, parse it and write
> >> the data to the relevant registers.

I plan to finish the patches which I am going to submit, first. Then,
I could focus on this. However, I don't think I would start this
quickly. There are many preparations and they would take me a lot of
time.

Best Regards,
Hayes


