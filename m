Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62641A08C3
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 19:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfH1RjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 13:39:07 -0400
Received: from mga12.intel.com ([192.55.52.136]:17071 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbfH1RjH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 13:39:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 10:38:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,441,1559545200"; 
   d="scan'208";a="381360027"
Received: from ellie.jf.intel.com (HELO ellie) ([10.24.12.211])
  by fmsmga006.fm.intel.com with ESMTP; 28 Aug 2019 10:38:58 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, vedang.patel@intel.com,
        leandro.maciel.dorileo@intel.com, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/3] taprio: Fix kernel panic in taprio_destroy
In-Reply-To: <CA+h21hr7hZShmHfmF8XX3PpCKm_3FkYm=CzkBmyiYezWGR7kLw@mail.gmail.com>
References: <20190828144829.32570-1-olteanv@gmail.com> <20190828144829.32570-2-olteanv@gmail.com> <87a7btqmk7.fsf@intel.com> <CA+h21hr7hZShmHfmF8XX3PpCKm_3FkYm=CzkBmyiYezWGR7kLw@mail.gmail.com>
Date:   Wed, 28 Aug 2019 10:38:58 -0700
Message-ID: <87sgplp4ul.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

>> Personally, I would do things differently, I am thinking: adding the
>> taprio instance earlier to the list in taprio_init(), and keeping
>> taprio_destroy() the way it is now. But take this more as a suggestion
>> :-)
>>
>
> While I don't strongly oppose your proposal (keep the list removal
> unconditional, but match it better in placement to the list addition),
> I think it's rather fragile and I do see this bug recurring in the
> future. Anyway if you want to keep it "simpler" I can respin it like
> that.
>

I am thinking that keeping things "simpler" has the advantage of making
any bugs really loud and hopefully easier to catch.


Cheers,
--
Vinicius
