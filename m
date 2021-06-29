Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7FE3B74C0
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 16:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbhF2O7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 10:59:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:63732 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232521AbhF2O67 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 10:58:59 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10029"; a="205153451"
X-IronPort-AV: E=Sophos;i="5.83,309,1616482800"; 
   d="scan'208";a="205153451"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2021 07:56:32 -0700
X-IronPort-AV: E=Sophos;i="5.83,309,1616482800"; 
   d="scan'208";a="408197136"
Received: from mckumar-mobl.gar.corp.intel.com (HELO [10.213.117.55]) ([10.213.117.55])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2021 07:56:29 -0700
Subject: Re: [PATCH net-next 06/10] net: iosm: drop custom netdev(s) removing
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linuxwwan <linuxwwan@intel.com>
References: <20210615003016.477-1-ryazanov.s.a@gmail.com>
 <20210615003016.477-7-ryazanov.s.a@gmail.com>
 <CAHNKnsR5X8Axttk_YX=fpi5h6iV191fLJ6MZqrLvhZvPe==mXA@mail.gmail.com>
 <1d31c18cebf74ff29b5e388c4cd26361@intel.com>
 <CAMZdPi9bqTB8+=xAsx3C6yAJdf3CHx9Z0AUxZpFQ-FFU5q84cQ@mail.gmail.com>
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
Message-ID: <e241d0d4-563d-e111-974e-9e47228f5178@intel.com>
Date:   Tue, 29 Jun 2021 20:26:16 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAMZdPi9bqTB8+=xAsx3C6yAJdf3CHx9Z0AUxZpFQ-FFU5q84cQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Loic,

On 6/29/2021 7:44 PM, Loic Poulain wrote:

>>> BTW, if IOSM modems have a default data channel, I can add a separate
>>> patch to the series to create a default network interface for IOSM if you tell
>>> me which link id is used for the default data channel.
>>
>> Link id 1 is always associated as default data channel.
> 
> Quick question, Isn't your driver use MBIM session IDs? with
> session-ID 0 as the default one?

Link Id from 1 to 8 are treated as valid link ids. These ids are
decremented by 1 to match session id.

In this case link id 1 would be mapped to session id 0. So have
requested link id 1 to be set as default data channel.

Regards,
Chetan
