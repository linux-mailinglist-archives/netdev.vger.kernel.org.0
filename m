Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333CC60D868
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 02:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbiJZASC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 20:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbiJZASA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 20:18:00 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3EADCACC;
        Tue, 25 Oct 2022 17:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666743479; x=1698279479;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oyd+l1GsSKxcb098K/jTmL5mtspj4j9mcqRnV2H/Ptg=;
  b=ICUFGGbvv6/CFGyei97UBWZ61Vllisdosb7t3dnw0ClzbhA6VnkiCOhn
   lQPRs4ehG/OuRC5EyxeVwxE9nNF2qkXo5UpB93JAofIgwBJt6EU6+yjKU
   lIYVl1nkuxXQS5pI5rHhnIhpqoICtgJd/kiRSoT5rjw28tfo+xqpr4ATW
   qXCZ6Rnxt9At9s2Ss7vtZZY09gLZmQ1eWeKVqU+i++0WjZuSUXTKYv2cH
   kyl7FzLaEl1QDypst3lQi+rC87a0gONL/0KO2AkUYZUmea0m6AGhPbeuT
   JDb8QiAaTmC0iNXbJRL4/0CsT1PvW3NKOzNGvXOjWxRqjn8yGge5EyY01
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="295228483"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="295228483"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 17:17:59 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="609764421"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="609764421"
Received: from swatthag-mobl1.amr.corp.intel.com (HELO desk) ([10.209.27.104])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 17:17:58 -0700
Date:   Tue, 25 Oct 2022 17:17:57 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Peter Zijlstra <peterz@infradead.org>, scott.d.constable@intel.com,
        daniel.sneddon@linux.intel.com, Jakub Kicinski <kuba@kernel.org>,
        dave.hansen@intel.com, Paolo Abeni <pabeni@redhat.com>,
        antonio.gomez.iglesias@linux.intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, gregkh@linuxfoundation.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Branch Target Injection (BTI) gadget in minstrel
Message-ID: <20221026001757.gyjzcwe5wznu6drj@desk>
References: <cover.1666651511.git.pawan.kumar.gupta@linux.intel.com>
 <Y1fDiJtxTe8mtBF8@hirez.programming.kicks-ass.net>
 <20221025193845.z7obsqotxi2yiwli@desk>
 <c27de92c10d05891bc804fe0b955c7428ec534dd.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c27de92c10d05891bc804fe0b955c7428ec534dd.camel@sipsolutions.net>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 09:56:21PM +0200, Johannes Berg wrote:
>On Tue, 2022-10-25 at 12:38 -0700, Pawan Gupta wrote:
>>
>> > And how is sprinking random LFENCEs around better than running with
>> > spectre_v2=eibrs,retpoline which is the current recommended mitigation
>> > against all this IIRC (or even eibrs,lfence for lesser values of
>> > paranoia).
>>
>> Its a trade-off between performance and spot fixing (hopefully handful
>> of) gadgets. Even the gadget in question here is not demonstrated to be
>> exploitable. If this scenario changes, polluting the kernel all over is
>> definitely not the right approach.
>>
>Btw, now I'm wondering - you were detecting these with the compiler
>based something, could there be a compiler pass to insert appropriate
>things, perhaps as a gcc plugin or something?

I hear it could be a lot of work for gcc. I am not sure if its worth
especially when we can't establish the exploitability of these gadgets.
There are some other challenges like, hot-path sites would prefer to
mask the indexes instead of using a speculation barrier for performance
reasons. I assume adding this intelligence to compilers would be
extremely hard. Also hardware controls and features in newer processors
will make the software mitigations redundant.
