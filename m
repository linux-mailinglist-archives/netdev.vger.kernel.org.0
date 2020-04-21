Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853131B32C2
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 00:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgDUWsh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Apr 2020 18:48:37 -0400
Received: from mga07.intel.com ([134.134.136.100]:61434 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgDUWsh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 18:48:37 -0400
IronPort-SDR: k+SfkvQ84w1O6diuyaubAjYNM0t3GpRO8HUNa+M1aCwD7FEoybPsve2QLCW+KLzy4fMvqByThE
 d2un/ut78BSA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 15:48:37 -0700
IronPort-SDR: xNY7g1XM3eH6S+9C1rEQearU9NyDF7cF33olJPC/U/kElHEOffqLk/MAcmmdwyW19ti3Mm7scj
 Wcd8cBxz5MMw==
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="258866889"
Received: from pvrobles-mobl1.amr.corp.intel.com (HELO localhost) ([10.254.110.52])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 15:48:36 -0700
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200421.153221.2089591404052111123.davem@davemloft.net>
References: <20200420234313.2184282-3-jeffrey.t.kirsher@intel.com> <20200421.122610.891640326169718840.davem@davemloft.net> <158750338551.60047.10607495842380954746@pvrobles-mobl1.amr.corp.intel.com> <20200421.153221.2089591404052111123.davem@davemloft.net>
Subject: Re: [net-next 02/13] igc: Use netdev log helpers in igc_main.c
From:   Andre Guedes <andre.guedes@linux.intel.com>
Cc:     jeffrey.t.kirsher@intel.com, kuba@kernel.org,
        andre.guedes@intel.com, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, aaron.f.brown@intel.com
To:     David Miller <davem@davemloft.net>
Date:   Tue, 21 Apr 2020 15:48:36 -0700
Message-ID: <158750931624.64093.11210523179576278990@pvrobles-mobl1.amr.corp.intel.com>
User-Agent: alot/0.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting David Miller (2020-04-21 15:32:21)
> Please kill these newline removal changes, thank you.

OK, I'm working on that. Thanks.

- Andre
