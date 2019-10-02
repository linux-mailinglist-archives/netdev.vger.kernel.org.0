Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D579C4B24
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 12:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfJBKLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 06:11:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:26728 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727409AbfJBKLO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 06:11:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 03:11:14 -0700
X-IronPort-AV: E=Sophos;i="5.64,574,1559545200"; 
   d="scan'208";a="203548482"
Received: from jnikula-mobl3.fi.intel.com (HELO localhost) ([10.237.66.161])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 03:11:09 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org
Cc:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gfx@lists.freedesktop.org,
        Vishal Kulkarni <vishal@chelsio.com>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v3] string-choice: add yesno(), onoff(), enableddisabled(), plural() helpers
In-Reply-To: <20191001080739.18513-1-jani.nikula@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <8e697984-03b5-44f3-304e-42d303724eaa@rasmusvillemoes.dk> <20191001080739.18513-1-jani.nikula@intel.com>
Date:   Wed, 02 Oct 2019 13:11:06 +0300
Message-ID: <87eezvbgp1.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 01 Oct 2019, Jani Nikula <jani.nikula@intel.com> wrote:
> While the main goal here is to abstract recurring patterns, and slightly
> clean up the code base by not open coding the ternary operators, there
> are also some space savings to be had via better string constant
> pooling.

Make that

"""
While the main goal here is to abstract recurring patterns, and slightly
clean up the code base by not open coding the ternary operators, using
functions to access the strings also makes it easier to seek different
implementation options for potential space savings on string constants
in the future.
"""

to be more explicit that this change does not directly translate to any
space savings.

Rasmus, okay with that?


BR,
Jani.


-- 
Jani Nikula, Intel Open Source Graphics Center
