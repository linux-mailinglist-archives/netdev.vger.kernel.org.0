Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2613169F0E
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 00:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730960AbfGOWjj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 15 Jul 2019 18:39:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:14610 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730608AbfGOWjj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 18:39:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jul 2019 15:39:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,494,1557212400"; 
   d="scan'208";a="366013305"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by fmsmga005.fm.intel.com with ESMTP; 15 Jul 2019 15:39:38 -0700
Received: from orsmsx151.amr.corp.intel.com (10.22.226.38) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 15 Jul 2019 15:39:38 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.240]) by
 ORSMSX151.amr.corp.intel.com ([169.254.7.148]) with mapi id 14.03.0439.000;
 Mon, 15 Jul 2019 15:39:37 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     David Ahern <dsahern@gmail.com>
CC:     Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Dorileo, Leandro" <leandro.maciel.dorileo@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [PATCH iproute2 net-next v2 1/6] Kernel header update for
 hardware offloading changes.
Thread-Topic: [PATCH iproute2 net-next v2 1/6] Kernel header update for
 hardware offloading changes.
Thread-Index: AQHVHLZawMzre0Bl50KXhj1a6LTj8abMxi6AgAAC/YCAAAc8gIAAJ+GA
Date:   Mon, 15 Jul 2019 22:39:37 +0000
Message-ID: <12CE2037-EE56-496E-A011-CD914C5CEF07@intel.com>
References: <1559859735-17237-1-git-send-email-vedang.patel@intel.com>
 <0AFDC65C-2A16-47B7-96F6-F6844AF75095@intel.com>
 <20190715125059.70470f9e@hermes.lan>
 <2c13cf19-0b4a-2149-1624-040191cedad9@gmail.com>
In-Reply-To: <2c13cf19-0b4a-2149-1624-040191cedad9@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.11.11]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32AE659D822DE24BBB4D18FD18378406@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ok I will send out the patches again. 

Thanks,
Vedang

> On Jul 15, 2019, at 1:16 PM, David Ahern <dsahern@gmail.com> wrote:
> 
> On 7/15/19 1:50 PM, Stephen Hemminger wrote:
>> On Mon, 15 Jul 2019 19:40:19 +0000
>> "Patel, Vedang" <vedang.patel@intel.com> wrote:
>> 
>>> Hi Stephen, 
>>> 
>>> The kernel patches corresponding to this series have been merged. I just wanted to check whether these iproute2 related patches are on your TODO list.
>>> 
>>> Let me know if you need any information from me on these patches.
>>> 
>>> Thanks,
>>> Vedang Patel
>> 
>> 
>> David Ahern handles iproute2 next
>> 
>> https://patchwork.ozlabs.org/patch/1111466/
>> 
> 
> given the long time delay between when the iproute2 patches were posted
> and when the kernel side was accepted you will need to re-send the
> iproute2 patches.

