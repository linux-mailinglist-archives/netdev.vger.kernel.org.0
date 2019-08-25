Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B61119C11B
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 02:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbfHYAFB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 24 Aug 2019 20:05:01 -0400
Received: from mga12.intel.com ([192.55.52.136]:58402 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727937AbfHYAFB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 20:05:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Aug 2019 17:05:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,427,1559545200"; 
   d="scan'208";a="355042767"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by orsmga005.jf.intel.com with ESMTP; 24 Aug 2019 17:05:00 -0700
Received: from orsmsx152.amr.corp.intel.com (10.22.226.39) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 24 Aug 2019 17:04:59 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.89]) by
 ORSMSX152.amr.corp.intel.com ([169.254.8.159]) with mapi id 14.03.0439.000;
 Sat, 24 Aug 2019 17:04:59 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     David Miller <davem@davemloft.net>
CC:     "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: Re: [net-next 07/14] ice: Rename ethtool private flag for lldp
Thread-Topic: [net-next 07/14] ice: Rename ethtool private flag for lldp
Thread-Index: AQHVWgvI2SLfmwCXmkWR8mJssY0U8acJ+HmAgAF1WAD//4+PVA==
Date:   Sun, 25 Aug 2019 00:04:58 +0000
Message-ID: <6F34BD38-F708-4D21-A9E9-23B3AB644151@intel.com>
References: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
        <20190823233750.7997-8-jeffrey.t.kirsher@intel.com>
        <20190823183111.509e176c@cakuba.netronome.com>,<20190824.164726.357731088137490877.davem@davemloft.net>
In-Reply-To: <20190824.164726.357731088137490877.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 24, 2019, at 16:47, David Miller <davem@davemloft.net> wrote:
> 
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Date: Fri, 23 Aug 2019 18:31:11 -0700
> 
>>> On Fri, 23 Aug 2019 16:37:43 -0700, Jeff Kirsher wrote:
>>> From: Dave Ertman <david.m.ertman@intel.com>
>>> 
>>> The current flag name of "enable-fw-lldp" is a bit cumbersome.
>>> 
>>> Change priv-flag name to "fw-lldp-agent" with a value of on or
>>> off.  This is more straight-forward in meaning.
>>> 
>>> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
>>> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
>>> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>> 
>> Just flagging this for Dave, it was introduced in v5.2 by:
> 
> So should we backport the rename into 'net'?  Is this a bug fix or just
> making life easier for people?

IMHO, no need to backport.
