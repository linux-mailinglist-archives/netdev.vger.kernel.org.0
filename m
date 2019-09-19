Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4D9B7D66
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 17:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390313AbfISPAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 11:00:12 -0400
Received: from mail.neratec.com ([46.140.151.2]:6701 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388350AbfISPAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 11:00:11 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.neratec.com (Postfix) with ESMTP id 6ADBFCE091D;
        Thu, 19 Sep 2019 17:00:09 +0200 (CEST)
Received: from mail.neratec.com ([127.0.0.1])
        by localhost (mail.neratec.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id NAKy6ucdgIVZ; Thu, 19 Sep 2019 17:00:09 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.neratec.com (Postfix) with ESMTP id 446C2CE091F;
        Thu, 19 Sep 2019 17:00:09 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.neratec.com 446C2CE091F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=neratec.com;
        s=9F5C293A-195B-11E9-BBA5-B4F3B9D999CA; t=1568905209;
        bh=3L/2mBdc+rvWVyG06MKCEIxMLrgrXp+63IcLiD8Km0A=;
        h=To:From:Message-ID:Date:MIME-Version;
        b=XMEqpqUrvqm+aH5LVytiDRisDfG3yGZM5kfR5OeBcQxdpXv+xSjtJ3XXKUIxdww1J
         nBxTQMsIwDCRtGsAHacp/z7QOemN10wJCBZmrj9uEUkICSSLbCWzU80fHNrf4FrTZ0
         Y/fyyJHbKF8h5gbUACF8rRVXvzcaT89q9bVd77k1mndAyvhPpsUVYMstOMTMn7h75D
         kwPqub+1zVETUthi6eOyungTaA/bM9sQFYMBqEjINNyKdgYCCzEXkMw36RWdje1aqK
         5cye6K3WElc5XEH7ntTp/LljpROOLxpcTQQqyJAQJrse+y3udAKQyu67iygMTTY0zY
         4GCNqFC3gBJdQ==
X-Virus-Scanned: amavisd-new at neratec.com
Received: from mail.neratec.com ([127.0.0.1])
        by localhost (mail.neratec.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id WIyqbcggF5sG; Thu, 19 Sep 2019 17:00:09 +0200 (CEST)
Received: from [172.29.101.151] (CHD500279.lan.neratec.com [172.29.101.151])
        by mail.neratec.com (Postfix) with ESMTPSA id 3029BCE091D;
        Thu, 19 Sep 2019 17:00:09 +0200 (CEST)
Subject: Re: ELOed stable kernels
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Or Gerlitz <gerlitz.or@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>
References: <CAJ3xEMhzGs=8Vuw6aT=wCnQ24Qif89CUDxvbM0jWCgKjNNdbpA@mail.gmail.com>
 <e8cf18ee-d238-8d6f-e25f-9f59b28569d2@neratec.com>
 <20190919144426.GA3998200@kroah.com>
From:   Matthias May <matthias.may@neratec.com>
Message-ID: <5381116f-caae-531d-adf3-1c7e07118b69@neratec.com>
Date:   Thu, 19 Sep 2019 17:00:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190919144426.GA3998200@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/09/2019 16:44, Greg Kroah-Hartman wrote:
> On Thu, Sep 19, 2019 at 04:39:28PM +0200, Matthias May wrote:
>> On 19/09/2019 16:05, Or Gerlitz wrote:
>>> Hi Greg,
>>>
>>> If this is RTFM could you please point me to the Emm
>>>
>>> AFAIR if a stable kernel is not listed at kernel.org than it is EOL by now.
>>>
>>> Is this correct?
>>>
>>> thanks,
>>>
>>> Or.
>>>
>>
>> You can also look at the wikipedia page at
>> https://en.wikipedia.org/wiki/Linux_kernel#Maintenance_and_long-term_support
>>
>> I do the updates of the entries for each release once the release-announcement has been sent to the list.
>> At least since I'm doing this (last ~5 years), the last release-announcement of a branch always contains a notice that
>> this release is now EOL.
>> I reference all these messages for each version.
> 
> Very nice, I never noticed that!
> 
> Also, you might want to use lore.kernel.org for the email archives,
> don't know who runs those other sites you link to :)
> 
> thanks,
> 
> greg k-h
> 

In the past I used to link to https://lkml.org/ .
However this archive is... unreliable.
Often the messages would not show up for days, and there are some messages which are missing completely.

Currently I'm using lkml.iu.edu which is run by the Indiana University.

Thank you for pointing to lore.kernel.org
Seems better to have a reference which is run by kernel.org itself.

Do you happen to know what the update interval of this archive is?
At lkml.iu.edu, when the new version is announced, it often takes quite some time until it shows up in the archive.

BR
Matthias
