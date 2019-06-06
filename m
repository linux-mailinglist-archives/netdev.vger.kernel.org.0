Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5DD437F44
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbfFFVLf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 6 Jun 2019 17:11:35 -0400
Received: from mga12.intel.com ([192.55.52.136]:23479 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbfFFVLe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 17:11:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 14:11:34 -0700
X-ExtLoop1: 1
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Jun 2019 14:11:34 -0700
Received: from orsmsx126.amr.corp.intel.com (10.22.240.126) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Thu, 6 Jun 2019 14:11:34 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.229]) by
 ORSMSX126.amr.corp.intel.com ([169.254.4.124]) with mapi id 14.03.0415.000;
 Thu, 6 Jun 2019 14:11:33 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Dorileo, Leandro" <leandro.maciel.dorileo@intel.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>
Subject: Re: [PATCH iproute2 net-next v1 4/6] taprio: add support for
 setting txtime_delay.
Thread-Topic: [PATCH iproute2 net-next v1 4/6] taprio: add support for
 setting txtime_delay.
Thread-Index: AQHVHJCfr/oadZmQIUKa1dd7ssOv4aaPfLEAgAAYXIA=
Date:   Thu, 6 Jun 2019 21:11:33 +0000
Message-ID: <27179243-E0D4-4BF1-8F89-6C5E3CBEE5E8@intel.com>
References: <1559843541-12695-1-git-send-email-vedang.patel@intel.com>
 <1559843541-12695-4-git-send-email-vedang.patel@intel.com>
 <20190606124422.3f34d07d@hermes.lan>
In-Reply-To: <20190606124422.3f34d07d@hermes.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.14.182]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <301EAAFAF580B54989F735BAD6731D5F@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 6, 2019, at 12:44 PM, Stephen Hemminger <stephen@networkplumber.org> wrote:
> 
> On Thu,  6 Jun 2019 10:52:19 -0700
> Vedang Patel <vedang.patel@intel.com> wrote:
> 
>> +	if (tb[TCA_TAPRIO_ATTR_TXTIME_DELAY])
>> +		txtime_delay = rta_getattr_s32(tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]);
>> +
>> +	print_int(PRINT_ANY, "txtime_delay", " txtime delay %d", txtime_delay);
>> +
> 
> Once again do not print anything if option is not present.
Yeah It makes sense. I will make the change. Thanks for the inputs.

-Vedang
