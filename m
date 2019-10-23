Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB40EE1C82
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 15:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391853AbfJWN0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 09:26:20 -0400
Received: from mga14.intel.com ([192.55.52.115]:38480 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391495AbfJWN0U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 09:26:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 06:26:20 -0700
X-IronPort-AV: E=Sophos;i="5.68,221,1569308400"; 
   d="scan'208";a="191828934"
Received: from jnikula-mobl3.fi.intel.com (HELO localhost) ([10.237.66.161])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 06:26:16 -0700
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
Subject: Re: [PATCH v4] string-choice: add yesno(), onoff(), enableddisabled(), plural() helpers
In-Reply-To: <ab199f9a-844b-47e5-b643-2bf35316d5ef@rasmusvillemoes.dk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20191023131308.9420-1-jani.nikula@intel.com> <ab199f9a-844b-47e5-b643-2bf35316d5ef@rasmusvillemoes.dk>
Date:   Wed, 23 Oct 2019 16:26:13 +0300
Message-ID: <87h83zegp6.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Oct 2019, Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
> On 23/10/2019 15.13, Jani Nikula wrote:
>> The kernel has plenty of ternary operators to choose between constant
>> strings, such as condition ? "yes" : "no", as well as value == 1 ? "" :
>> "s":
>> 
>> 
>> v4: Massaged commit message about space savings to make it less fluffy
>> based on Rasmus' feedback.
>
> Thanks, it looks good to me. FWIW,
>
> Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Thanks.

I think the question is, which tree to apply this to, who's going to
pick it up? I'm fine with any route.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Graphics Center
