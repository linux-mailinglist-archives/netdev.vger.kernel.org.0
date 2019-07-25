Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B045754F3
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 19:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbfGYRAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 13:00:32 -0400
Received: from mga14.intel.com ([192.55.52.115]:54474 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726390AbfGYRAb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 13:00:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jul 2019 10:00:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,307,1559545200"; 
   d="scan'208";a="345497434"
Received: from klaatz-mobl1.ger.corp.intel.com (HELO [10.237.221.70]) ([10.237.221.70])
  by orsmga005.jf.intel.com with ESMTP; 25 Jul 2019 10:00:28 -0700
Subject: Re: [PATCH bpf-next v3 08/11] samples/bpf: add unaligned chunks mode
 support to xdpsock
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "Richardson, Bruce" <bruce.richardson@intel.com>,
        "Loftus, Ciara" <ciara.loftus@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
References: <20190716030637.5634-1-kevin.laatz@intel.com>
 <20190724051043.14348-1-kevin.laatz@intel.com>
 <20190724051043.14348-9-kevin.laatz@intel.com>
 <fd7b6b71-5bfd-986a-b288-b9e3478acebb@mellanox.com>
From:   "Laatz, Kevin" <kevin.laatz@intel.com>
Message-ID: <27c5c008-def3-d9dc-792c-e5a500103be8@intel.com>
Date:   Thu, 25 Jul 2019 18:00:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <fd7b6b71-5bfd-986a-b288-b9e3478acebb@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 25/07/2019 10:43, Maxim Mikityanskiy wrote:
> On 2019-07-24 08:10, Kevin Laatz wrote:
>> This patch adds support for the unaligned chunks mode. The addition of the
>> unaligned chunks option will allow users to run the application with more
>> relaxed chunk placement in the XDP umem.
>>
>> Unaligned chunks mode can be used with the '-u' or '--unaligned' command
>> line options.
>>
>> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
>> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
>> ---
>>    samples/bpf/xdpsock_user.c | 17 +++++++++++++++--
>>    1 file changed, 15 insertions(+), 2 deletions(-)
> <...>
>
>> @@ -372,6 +378,7 @@ static void usage(const char *prog)
>>    		"  -z, --zero-copy      Force zero-copy mode.\n"
>>    		"  -c, --copy           Force copy mode.\n"
>>    		"  -f, --frame-size=n   Set the frame size (must be a power of two, default is %d).\n"
> Help text for -f has to be updated, it doesn't have to be a power of two
> if -u is specified.

Will fix in the v4, thanks!



