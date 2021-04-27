Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A640836C827
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 16:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238470AbhD0O7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 10:59:17 -0400
Received: from void.so ([95.85.17.176]:13300 "EHLO void.so"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236173AbhD0O7K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 10:59:10 -0400
Received: from void.so (localhost [127.0.0.1])
        by void.so (Postfix) with ESMTP id CF9CB2B2FBA;
        Tue, 27 Apr 2021 17:58:23 +0300 (MSK)
Received: from void.so ([127.0.0.1])
        by void.so (void.so [127.0.0.1]) (amavisd-new, port 10024) with LMTP
        id pQ3HAm4e1keW; Tue, 27 Apr 2021 17:58:23 +0300 (MSK)
Received: from mx.void.so (localhost [127.0.0.1])
        by void.so (Postfix) with ESMTPA id 9D82F2B2FB9;
        Tue, 27 Apr 2021 17:58:22 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=void.so; s=mail;
        t=1619535503; bh=qKNua5KhGqsJ/P0wyBQaiw9GM/Sjie/sLfhRTHM+6fE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=mCxZVq9KNHoB9uxnBS10wKtL9SmftuxjrB9VzWp4GiPxDZ0zVK0q5VmbKtPFVQTg/
         vtYBw+5Q8SQahC40fNNIVzWCVN1UV64BB+9A1nKVUTVe9bZLC7uOqnrVquSu4RxC1V
         2xs03yOVXv2cwPVfl1w40y4uFak28tnHSaeBJXtA=
MIME-Version: 1.0
Date:   Tue, 27 Apr 2021 17:58:22 +0300
From:   Void <mail@void.so>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH v4 net-next] net: multipath routing: configurable seed
In-Reply-To: <e5e46b25-065f-7c56-3c31-6b9cc130510d@gmail.com>
References: <YILPPCyMjlnhPmEN@rnd>
 <93ca6644-fc5a-0977-db7d-16779ebd320c@gmail.com> <YIfcfEiym5PKAe0w@rnd>
 <e5e46b25-065f-7c56-3c31-6b9cc130510d@gmail.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <21a2fb1925b215cc48ab8e2f783a7de7@void.so>
X-Sender: mail@void.so
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-04-27 17:27, David Ahern wrote:
> On 4/27/21 3:42 AM, Pavel Balaev wrote:
>> After running "scripts/checkpatch.pl" I got warnings about alignment.
>> So I run checkpatch.pl --fix and fixed alignment as a script did.
>> So warnings goes away. I don't get the rules of alignment, can you
>> tell me the right way?
> 
> I don't see any statements under Documentation/process; not sure where
> it is explicitly stated. You can get the general idea by following the
> surrounding code and then let checkpatch correct from there.
I create 3 patches and check it:

./scripts/checkpatch.pl 
0001-net-ipv4-multipath-routing-configurable-seed.patch
total: 0 errors, 0 warnings, 0 checks, 186 lines checked

0001-net-ipv4-multipath-routing-configurable-seed.patch has no obvious 
style problems and is ready for submission.
./scripts/checkpatch.pl 
0002-net-ipv6-multipath-routing-configurable-seed.patch
total: 0 errors, 0 warnings, 0 checks, 151 lines checked

0002-net-ipv6-multipath-routing-configurable-seed.patch has no obvious 
style problems and is ready for submission.
./scripts/checkpatch.pl 
0003-selftests-net-forwarding-configurable-seed-tests.patch
WARNING: added, moved or deleted file(s), does MAINTAINERS need 
updating?
#76:
new file mode 100755

total: 0 errors, 1 warnings, 394 lines checked

No alignment warnings at all.
