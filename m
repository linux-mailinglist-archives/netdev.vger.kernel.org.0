Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 160587FF0F
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 19:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731663AbfHBRAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 13:00:17 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44527 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfHBRAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 13:00:17 -0400
Received: by mail-pf1-f194.google.com with SMTP id t16so36304456pfe.11
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 10:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=xxwNJ2ZKOqmOi6S0YaWWIIY7gFomt8bt+0RZUPC7ajs=;
        b=RCA2WlWQXQIP2GaGeNwFdOTLunJxJc/kdfSuZy08xov8qVdPmkSZuibrM3s7COsXSv
         P68gUmkF7WuCtL/Gc1S7+mCkgd8IPtT4dx1eolLXxnPHnn7AJ2wziJLde9UpefuMCyaS
         /5YEdQo7QOR8k0NUvjC5ALJV3zOXR6m/DK1FQlg9qLJ/l6we95Hw+tjjMkukaLaxAq0B
         XVZd+McFCj7BsO71t6OJIjuILisMlfABAo9NgVbEEK2axgvDDIjbe+8jjnH+4tnS+YO0
         N52sAUhp4KvQ3JBmRZOrTVzN2TAacOhpca5vDyur1TqkU7WXE11T6N22VEtYuB2XPzo8
         nmnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=xxwNJ2ZKOqmOi6S0YaWWIIY7gFomt8bt+0RZUPC7ajs=;
        b=sy105pTHiqUGcEh18kYA8nZ0hy3SCqIg3bLk3g7x/LFAb9hYdpv4BlrDg6ViVrzvCv
         C3mt/N0FSR9cwcbvklzf2vbpCGI+IdKw5nZ0qIXOrOGvT/SunWTsXE61TDkJmVNldKfm
         xdVjCdsFaXPwCqL+rLBHyxdq34B9nKfyCQIueoTQODmeU9+J/QhhDCPQdkZX6f9koLPQ
         LUXxrPIVXKmxbKu89u+w2QDXUZ4qXY6VyZ1A6XBEpVYlKVU/ln3MURx9oRRWEeUk9Mde
         8c1tBm6K5KBp/Ag+LSwT1AVIpjH4QENaNQ7ZRBuQerMvW7SXYEE/c2U4g4J+TPOfx3Qz
         dZ2w==
X-Gm-Message-State: APjAAAWictqK5mgfKATnC/aer5ANPP6IcjzfPGiz27gC//GnNzJyI5le
        1dc1ktMONYOQFa9lrfLWDgyYJg9OEEEpjw==
X-Google-Smtp-Source: APXvYqweBAcmCs7fMruiDtq4cb4xNNu0txJSPokty9hdectXnJYBlx6NGjT2G/PLEE20JgvVBZkKnw==
X-Received: by 2002:a63:ff20:: with SMTP id k32mr125512834pgi.445.1564765216070;
        Fri, 02 Aug 2019 10:00:16 -0700 (PDT)
Received: from Shannons-MBP.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id x1sm7880545pjo.4.2019.08.02.10.00.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 10:00:15 -0700 (PDT)
Subject: Re: [net-next 2/9] i40e: make visible changed vf mac on host
To:     "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
References: <20190801205149.4114-1-jeffrey.t.kirsher@intel.com>
 <20190801205149.4114-3-jeffrey.t.kirsher@intel.com>
 <9a3a4675-b031-7666-f259-978d18b6db19@pensando.io>
 <0EF347314CF65544BA015993979A29CD74513DCB@irsmsx105.ger.corp.intel.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <705015a6-fefe-04fd-12f0-a28e2ba1fb79@pensando.io>
Date:   Fri, 2 Aug 2019 10:00:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <0EF347314CF65544BA015993979A29CD74513DCB@irsmsx105.ger.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/19 1:14 AM, Loktionov, Aleksandr wrote:
> Good day Nelson

Please don't top post.  The custom on this mailing list is to answer 
inline in order to be sure we're answering in context.  As it is, I 
believe you missed answering one of my questions.

> In 99% cases VF has _only one_ unicast mac anyway, and the last MAC has been chosen because of VF mac address change algo -  it marks unicast filter for deletion and appends a new unicast filter to the list.
> The implementation has been chosen because of simplicity /* Just 3 more lines to solve the issue */, from one point it may look wasteful for some 1% of VF corner cases.
> But from another point of view, more complicated code will affect 99% normal cases. Modern cpu are sensitive to cache thrash by code size and pipeline stalls by conditionals

Yes, absolutely.  So it follows that (a) we don't want to leave things 
in a loop if not necessary to repeat them, (b) we'd like to keep loops 
small as possible, (c) we want to keep our spin_lock sections small, and 
(d) we don't want to do things that later don't matter if an error 
happens when writing to the firmware.  So it seems to me that you should 
move that copy line from the loop and outside of the spin_lock, and put 
it after the call sync the filters.  Perhaps track the good mac index 
with "good_mac = i" at the end of the loop code and use that later to 
know which mac to copy into the vf struct.

I also noticed that you're checking the mac addresses for validity, but 
only before copying it to the local vf struct.  If you need to check the 
addresses, shouldn't you check them before you add them to the vf's 
filter list so you don't try to sync bad addresses to the FW?

If the sync to the FW fails, you send the error status to the VF but you 
still have this new address copied into the vf struct.  I think the copy 
line should be after the FW sync, and only if the sync succeeds.

sln


>
> Alex
>
> -----Original Message-----
> From: Shannon Nelson [mailto:snelson@pensando.io]
> Sent: Friday, August 2, 2019 2:11 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net
> Cc: Loktionov, Aleksandr <aleksandr.loktionov@intel.com>; netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com; Bowers, AndrewX <andrewx.bowers@intel.com>
> Subject: Re: [net-next 2/9] i40e: make visible changed vf mac on host
>
> On 8/1/19 1:51 PM, Jeff Kirsher wrote:
>> From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
>>
>> This patch makes changed VM mac address visible on host via ip link
>> show command. This problem is fixed by copying last unicast mac filter
>> to vf->default_lan_addr.addr. Without this patch if VF MAC was not set
>> from host side and if you run ip link show $pf, on host side you'd
>> always see a zero MAC, not the real VF MAC that VF assigned to itself.
>>
>> Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
>> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
>> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>> ---
>>    drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 3 +++
>>    1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
>> b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
>> index 02b09a8ad54c..21f7ac514d1f 100644
>> --- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
>> +++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
>> @@ -2629,6 +2629,9 @@ static int i40e_vc_add_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
>>    			} else {
>>    				vf->num_mac++;
>>    			}
>> +			if (is_valid_ether_addr(al->list[i].addr))
>> +				ether_addr_copy(vf->default_lan_addr.addr,
>> +						al->list[i].addr);
>>    		}
>>    	}
>>    	spin_unlock_bh(&vsi->mac_filter_hash_lock);
> Since this copy is done inside the for-loop, it looks like you are copying every address in the list, not just the last one.  This seems wasteful and unnecessary.
>
> Since it is possible, altho' unlikely, that the filter sync that happens a little later could fail, might it be better to do the copy after you know that the sync has succeeded?
>
> Why is the last mac chosen for display rather than the first?  Is there anything special about the last mac as opposed to the first mac?
>
> sln
>

