Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39EA1E29BD
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 20:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729200AbgEZSJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 14:09:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:6568 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728838AbgEZSJi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 14:09:38 -0400
IronPort-SDR: f7R9HjkCZF9lNzecWoPFMtFcbGMNCEtetrQwOO0CeCoHcKwZtJQIB1R60BeKp+39gKH6EgZsfh
 P2RetrMvTcAQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 11:09:38 -0700
IronPort-SDR: 54NnjXZ9mXnLB1DvXNpWU8njdKujXocWpi/SIAJCkwQBHNluKMUJzOKtQTEqN0waOSPfJ+VSxh
 bTZazJaNHscw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,437,1583222400"; 
   d="scan'208";a="468441073"
Received: from dspatli-mobl.amr.corp.intel.com (HELO ellie) ([10.212.21.42])
  by fmsmga006.fm.intel.com with ESMTP; 26 May 2020 11:09:38 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Murali Karicheri <m-karicheri2@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [net-next RFC PATCH 00/13] net: hsr: Add PRP driver
In-Reply-To: <CA+h21hqiV71wc0v=-KkPbWNyXSY+-oiz+DsQLAe1XEJw7eP=_Q@mail.gmail.com>
References: <20200506163033.3843-1-m-karicheri2@ti.com> <87r1vdkxes.fsf@intel.com> <CA+h21hqiV71wc0v=-KkPbWNyXSY+-oiz+DsQLAe1XEJw7eP=_Q@mail.gmail.com>
Date:   Tue, 26 May 2020 11:09:37 -0700
Message-ID: <87imgilg9q.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Vladimir Oltean <olteanv@gmail.com> writes:
>>
>> I don't really like these prefixes, I am thinking of when support for
>> IEEE 802.1CB is added, do we rename this to "hsr_prp_frer"?
>>
>> And it gets even more complicated, and using 802.1CB you can configure
>> the tagging method and the stream identification function so a system
>> can interoperate in a HSR or PRP network.
>>
>
> Is it a given that 802.1CB in Linux should be implemented using an hsr
> upper device?

What I was trying to express is the idea of using "hsr" as the directory
name/prefix for all the features that deal with frame replication for
reliability, including 802.1CB. At least until we find a better name.

> 802.1CB is _much_ more flexible than both HSR and PRP. You can have
> more than 2 ports, you can have per-stream rules (each stream has its
> own sequence number), and those rules can identify the source, the
> destination, or both the source and the destination.

Same understanding here.


Cheers,
-- 
Vinicius
