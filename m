Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6F926E623
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgIQUFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:05:37 -0400
Received: from mga06.intel.com ([134.134.136.31]:35244 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbgIQUFc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 16:05:32 -0400
IronPort-SDR: 1EqDDV9SWySMMXQjgrHW1/Tq43ZTXe22s50bgNybd15hjg4bWdlaVn0ZUNNKZFGLILKPh0ZVw+
 9up+rZjLo4DQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="221336979"
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="221336979"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 12:40:16 -0700
IronPort-SDR: OJtaUmUU2VRk9KtKnU2JOdZ0Wx6lNOu+0+CFBjlBeB4odozE5Gxp9wTpGmmaUJi2k6Nfsj2iiR
 1ryN5FpIrCvQ==
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="483882946"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.151.155]) ([10.212.151.155])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 12:40:13 -0700
Subject: Re: [trivial PATCH] treewide: Convert switch/case fallthrough; to
 break;
To:     Keith Busch <kbusch@kernel.org>, Joe Perches <joe@perches.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Jiri Kosina <trivial@kernel.org>,
        Kees Cook <kees.cook@canonical.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-rdma@vger.kernel.org,
        iommu@lists.linux-foundation.org, dm-devel@redhat.com,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, intel-wired-lan@lists.osuosl.org,
        oss-drivers@netronome.com, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-nvme@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-scsi@vger.kernel.org,
        storagedev@microchip.com, sparclinux@vger.kernel.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-parisc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, bpf@vger.kernel.org,
        dccp@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-sctp@vger.kernel.org,
        alsa-devel <alsa-devel@alsa-project.org>
References: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
 <20200909205558.GA3384631@dhcp-10-100-145-180.wdl.wdc.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <321069c8-a4c1-56ff-49fb-4c2bce1e6352@intel.com>
Date:   Thu, 17 Sep 2020 12:40:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200909205558.GA3384631@dhcp-10-100-145-180.wdl.wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/2020 1:55 PM, Keith Busch wrote:
> On Wed, Sep 09, 2020 at 01:06:39PM -0700, Joe Perches wrote:
>> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
>> index eea0f453cfb6..8aac5bc60f4c 100644
>> --- a/crypto/tcrypt.c
>> +++ b/crypto/tcrypt.c
>> @@ -2464,7 +2464,7 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
>>  		test_hash_speed("streebog512", sec,
>>  				generic_hash_speed_template);
>>  		if (mode > 300 && mode < 400) break;
>> -		fallthrough;
>> +		break;
>>  	case 399:
>>  		break;
> 
> Just imho, this change makes the preceding 'if' look even more
> pointless. Maybe the fallthrough was a deliberate choice? Not that my
> opinion matters here as I don't know this module, but it looked a bit
> odd to me.
> 

Yea this does look very odd..
