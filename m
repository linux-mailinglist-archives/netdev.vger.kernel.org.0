Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B1A1FD780
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 23:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgFQVhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 17:37:11 -0400
Received: from mail.ispras.ru ([83.149.199.45]:42916 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbgFQVhI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 17:37:08 -0400
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jun 2020 17:37:02 EDT
Received: from [192.168.1.8] (unknown [213.87.137.195])
        by mail.ispras.ru (Postfix) with ESMTPSA id 54355BFD1E;
        Thu, 18 Jun 2020 00:31:03 +0300 (MSK)
To:     Joe Perches <joe@perches.com>, Waiman Long <longman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Rientjes <rientjes@google.com>
Cc:     Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Sterba <dsterba@suse.cz>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, linux-mm@kvack.org,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-amlogic@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org, wireguard@lists.zx2c4.com,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, ecryptfs@vger.kernel.org,
        kasan-dev@googlegroups.com, linux-bluetooth@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-nfs@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org
References: <20200616015718.7812-1-longman@redhat.com>
 <fe3b9a437be4aeab3bac68f04193cb6daaa5bee4.camel@perches.com>
From:   Denis Efremov <efremov@ispras.ru>
Autocrypt: addr=efremov@ispras.ru; keydata=
 mQINBFsJUXwBEADDnzbOGE/X5ZdHqpK/kNmR7AY39b/rR+2Wm/VbQHV+jpGk8ZL07iOWnVe1
 ZInSp3Ze+scB4ZK+y48z0YDvKUU3L85Nb31UASB2bgWIV+8tmW4kV8a2PosqIc4wp4/Qa2A/
 Ip6q+bWurxOOjyJkfzt51p6Th4FTUsuoxINKRMjHrs/0y5oEc7Wt/1qk2ljmnSocg3fMxo8+
 y6IxmXt5tYvt+FfBqx/1XwXuOSd0WOku+/jscYmBPwyrLdk/pMSnnld6a2Fp1zxWIKz+4VJm
 QEIlCTe5SO3h5sozpXeWS916VwwCuf8oov6706yC4MlmAqsQpBdoihQEA7zgh+pk10sCvviX
 FYM4gIcoMkKRex/NSqmeh3VmvQunEv6P+hNMKnIlZ2eJGQpz/ezwqNtV/przO95FSMOQxvQY
 11TbyNxudW4FBx6K3fzKjw5dY2PrAUGfHbpI3wtVUNxSjcE6iaJHWUA+8R6FLnTXyEObRzTS
 fAjfiqcta+iLPdGGkYtmW1muy/v0juldH9uLfD9OfYODsWia2Ve79RB9cHSgRv4nZcGhQmP2
 wFpLqskh+qlibhAAqT3RQLRsGabiTjzUkdzO1gaNlwufwqMXjZNkLYu1KpTNUegx3MNEi2p9
 CmmDxWMBSMFofgrcy8PJ0jUnn9vWmtn3gz10FgTgqC7B3UvARQARAQABtCFEZW5pcyBFZnJl
 bW92IDxlZnJlbW92QGlzcHJhcy5ydT6JAlQEEwEIAD4CGwMFCwkIBwIGFQoJCAsCBBYCAwEC
 HgECF4AWIQR2VAM2ApQN8ZIP5AO1IpWwM1AwHwUCXsQtuwUJB31DPwAKCRC1IpWwM1AwHxhw
 EADCag2FEvD03XdcMIC4I0C7ksllN9kYAdjQ1MwlnO+EHpkzUBh8xPXGVfGIJ+AfQIQodLZa
 umUGyf/bKlkrJQ3E5a8SfykG+6P6CKmDBqPHBRBchsr6uI15pA3SjYxECx2rBEcm0eIssl44
 5nm6dlpzFK2KGGD4VDSpogBEEc+UrIoipqqdJzvg6QJChE4cNLQGFB31lF7Or+CJ6HPirjbS
 AhSijvhG7AueTaU2xyONuYlrP0Ooup9cL1cLf/A/MHW6Ekn5M6KNzfioYP255Rpx8W8c25AI
 PMamb6bixL4a0ZhtHCC1XbTBCSQAmzcJuDvziMXY5ozVpGRRRvv++iubTkkgxlBqganJGuDy
 iKByTAqpUBvoZKi0riFiKXK5/FrETD4KAg5vU/qL+WXZuf3Bp54+Ugzv7nCkQ0dntSwldPRS
 vi5Yfku0pRh4bQajSNV2E8qjVht4OTai9d49k8yyuesoDkfT/rf/Uge3cc5SQwe2JL6GuiKG
 lyOF4o1c2s1Xaf1EzPAPYPCqU+E29+n1uXwG+65oEyUHTMIWT+BQhtEdc4GTIYcSV9UZyY3p
 NvwXVearNHvtrSA176ZbJJmInqmEYjP42y9KdrWo9XBMoWlqL3cl0owF7BWa+tr9Uy9GQ2vu
 IpuJ8253NjGwqJvUACpnRCfUUmZRXNlKLzB+KbkCDQRbCVF8ARAA3ITFo8OvvzQJT2cYnPR7
 18Npm+UL6uckm0Jr0IAFdstRZ3ZLW/R9e24nfF3A8Qga3VxJdhdEOzZKBbl1nadZ9kKUnq87
 te0eBJu+EbcuMv6+njT4CBdwCzJnBZ7ApFpvM8CxIUyFAvaz4EZZxkfEpxaPAivR1Sa22x7O
 MWH/78laB6KsPgwxV7fir45VjQEyJZ5ac5ydG9xndFmb76upD7HhV7fnygwf/uIPOzNZYVEl
 GVnqTBqisFRWg9w3Bqvqb/W6prJsoh7F0/THzCzp6PwbAnXDedN388RIuHtXJ+wTsPA0oL0H
 4jQ+4XuAWvghD/+RXJI5wcsAHx7QkDcbTddrhhGdGcd06qbXe2hNVgdCtaoAgpCEetW8/a8H
 +lEBBD4/iD2La39sfE+dt100cKgUP9MukDvOF2fT6GimdQ8TeEd1+RjYyG9SEJpVIxj6H3Cy
 GjFwtIwodfediU/ygmYfKXJIDmVpVQi598apSoWYT/ltv+NXTALjyNIVvh5cLRz8YxoFsFI2
 VpZ5PMrr1qo+DB1AbH00b0l2W7HGetSH8gcgpc7q3kCObmDSa3aTGTkawNHzbceEJrL6mRD6
 GbjU4GPD06/dTRIhQatKgE4ekv5wnxBK6v9CVKViqpn7vIxiTI9/VtTKndzdnKE6C72+jTwS
 YVa1vMxJABtOSg8AEQEAAYkCPAQYAQgAJgIbDBYhBHZUAzYClA3xkg/kA7UilbAzUDAfBQJe
 xC4MBQkHfUOQAAoJELUilbAzUDAfPYoQAJdBGd9WZIid10FCoI30QXA82SHmxWe0Xy7hr4bb
 ZobDPc7GbTHeDIYmUF24jI15NZ/Xy9ADAL0TpEg3fNVad2eslhCwiQViWfKOGOLLMe7vzod9
 dwxYdGXnNRlW+YOCdFNVPMvPDr08zgzXaZ2+QJjp44HSyzxgONmHAroFcqCFUlfAqUDOT30g
 V5bQ8BHqvfWyEhJT+CS3JJyP8BmmSgPa0Adlp6Do+pRsOO1YNNO78SYABhMi3fEa7X37WxL3
 1TrNCPnIauTgZtf/KCFQJpKaakC3ffEkPhyTjEl7oOE9xccNjccZraadi+2uHV0ULA1mycHh
 b817A03n1I00QwLf2wOkckdqTqRbFFI/ik69hF9hemK/BmAHpShI+z1JsYT9cSs8D7wbaF/j
 QVy4URensgAPkgXsRiboqOj/rTz9F5mpd/gPU/IOUPFEMoo4TInt/+dEVECHioU3RRrWEahr
 GMfRngbdp/mKs9aBR56ECMfFFUPyI3VJsNbgpcIJjV/0N+JdJKQpJ/4uQ2zNm0wH/RU8CRJv
 EwtKemX6fp/zLI36Gvz8zJIjSBIEqCb7vdgvWarksrhmi6/Jay5zRZ03+k6YwiqgX8t7ANwv
 Ya1h1dQ36OiTqm1cIxRCGl4wrypOVGx3OjCar7sBLD+NkwO4RaqFvdv0xuuy4x01VnOF
Subject: Re: [PATCH v4 0/3] mm, treewide: Rename kzfree() to kfree_sensitive()
Message-ID: <17e4fede-bab0-d93c-6964-69decc889d7d@ispras.ru>
Date:   Thu, 18 Jun 2020 00:31:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <fe3b9a437be4aeab3bac68f04193cb6daaa5bee4.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/16/20 9:53 PM, Joe Perches wrote:
> On Mon, 2020-06-15 at 21:57 -0400, Waiman Long wrote:
>>  v4:
>>   - Break out the memzero_explicit() change as suggested by Dan Carpenter
>>     so that it can be backported to stable.
>>   - Drop the "crypto: Remove unnecessary memzero_explicit()" patch for
>>     now as there can be a bit more discussion on what is best. It will be
>>     introduced as a separate patch later on after this one is merged.
> 
> To this larger audience and last week without reply:
> https://lore.kernel.org/lkml/573b3fbd5927c643920e1364230c296b23e7584d.camel@perches.com/
> 
> Are there _any_ fastpath uses of kfree or vfree?
> 
> Many patches have been posted recently to fix mispairings
> of specific types of alloc and free functions.

I've prepared a coccinelle script to highlight these mispairings in a function
a couple of days ago: https://lkml.org/lkml/2020/6/5/953
I've listed all the fixes in the commit message. 

Not so many mispairings actually, and most of them are harmless like:
kmalloc(E) -> kvfree(E)

However, coccinelle script can't detect cross-functions mispairings, i.e.
allocation in one function, free in another funtion.

Thanks,
Denis
