Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E907D5BDDA0
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 08:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiITGtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 02:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbiITGta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 02:49:30 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4BD183;
        Mon, 19 Sep 2022 23:49:27 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id e16so2635346wrx.7;
        Mon, 19 Sep 2022 23:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=h1WlJs9RX6ptyFkRROTLveDGNfVUE6oq4D0YXqMlz98=;
        b=DdjGBv8yb441S1WYIx3x39itgrmpw6ljUYNzWVQKpIlGuhS2p+FwcfJJHIzhYxnJ+o
         lBdkDM10DaFmpW1o/Leic6w6uHensWW4ohYS7L2O12ymWwrl5GmyG3BRGoLVYY6nnS3G
         fgecQZ0rjdb9PUYIVGmvntxhqgj4hdKrp7Hr4qquVNUcw74wnotz8QOzNu4mIN80yApU
         3Ap20oMM/R4By0PxUkdof7EPWjAfFtWD2lkiDDK7dqqiqG3mO//npXzvtlk0AxuLtFJl
         3LUlyvvbhG7v2NWl6IzLIc+6u7hIJyY1u5FQL/azYp3kNgU41Yqc2hdZ2dwwWCzSWkT3
         XChw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=h1WlJs9RX6ptyFkRROTLveDGNfVUE6oq4D0YXqMlz98=;
        b=keO//QyGkvBpBZ26GXEYfivYFVuMRpCjvdkbcOLHlXGbg1DQs7gSLXOqWr12v5Y8TA
         lo6nlUZpYdE8uHdvz2yE8xD3c3UxlHC9bPY64UXbxAxUfSnwxzPB3MD58YCjETReul0Z
         bGwOq/HV1HR0HufKm0atCuy2e2wej9UpS5zZLudhD3gMg4S8EgFr6qWfmnU8CWO1M+qC
         8CjzRoViwiRuOAVi33UZ4YQQmdpwAmUQvQiXVB0gbtDDTog5rAFp0LVHr/n1hmtt0G3+
         kgP+1iFULgyWi0E/INLNJVJV5Z2VAYOS3dKJtJ4eRRea5d/vWKNhPpfgzO6Dhasd5C2+
         Hp0A==
X-Gm-Message-State: ACrzQf1VvBfURSnB+pmxNvlkv+W7xv9UMCyPC4R05C47fWtjLbtBfz0I
        60uGvRDCJV8pD3yvPG1Xe7LkZLQ12h4=
X-Google-Smtp-Source: AMsMyM6PG6o/OF1Awc+CELYzPFNzTm1G9Q7CAIXtarmGGgfUfveznSldbZp5sgUmVkkLDJba07MLzQ==
X-Received: by 2002:adf:d1e8:0:b0:22a:c131:4c49 with SMTP id g8-20020adfd1e8000000b0022ac1314c49mr13074979wrd.647.1663656566068;
        Mon, 19 Sep 2022 23:49:26 -0700 (PDT)
Received: from [192.168.1.10] (2e41ab4c.skybroadband.com. [46.65.171.76])
        by smtp.googlemail.com with ESMTPSA id m8-20020a05600c4f4800b003b47b913901sm1662474wmq.1.2022.09.19.23.49.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 23:49:25 -0700 (PDT)
Message-ID: <fc8792bf-2d67-496a-6d90-940de21694d9@googlemail.com>
Date:   Tue, 20 Sep 2022 07:49:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: removing conntrack helper toggle to enable auto-assignment [was
 Re: b118509076b3 (probably) breaks my firewall]
To:     Jakub Kicinski <kuba@kernel.org>, Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        regressions@lists.linux.dev, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
References: <e5d757d7-69bc-a92a-9d19-0f7ed0a81743@googlemail.com>
 <20220908191925.GB16543@breakpoint.cc>
 <78611fbd-434e-c948-5677-a0bdb66f31a5@googlemail.com>
 <20220908214859.GD16543@breakpoint.cc> <YxsTMMFoaNSM9gLN@salvia>
 <a3c79b7d-526f-92ce-144a-453ec3c200a5@googlemail.com>
 <YxvwKlE+nyfUjHx8@salvia> <20220919124024.0c341af4@kernel.org>
 <20220919202310.GA3498@breakpoint.cc> <20220919135715.6057331d@kernel.org>
Content-Language: en-GB
From:   Chris Clayton <chris2553@googlemail.com>
In-Reply-To: <20220919135715.6057331d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19/09/2022 21:57, Jakub Kicinski wrote:
> On Mon, 19 Sep 2022 22:23:10 +0200 Florian Westphal wrote:
>> Jakub Kicinski <kuba@kernel.org> wrote:
>>> On Sat, 10 Sep 2022 04:02:18 +0200 Pablo Neira Ayuso wrote:  
>>>> Disagreed, reverting and waiting for one more release cycle will just
>>>> postpone the fact that users must adapt their policies, and that they
>>>> rely on a configuration which is not secure.  
>>>
>>> What are the chances the firewall actually needs the functionality?  
>>
>> Unknown, there is no way to tell.
> 
> Chris, is your firewall based on some project or a loose bunch of
> scripts you wrote?
> 

It's a script executed at boot via sysv init. I wrote the script myself following a HOWTO that I found somewhere on the
net. I very rarely run an ftp server on my laptop but I do occasionally need to get files from a remote ftp server.

I eventually figured out what needed to be done to restore my firewall to working order. I had no clue that the change
was coming. I built my system using the Linux From Scratch recipes in 2017. I update the software I have installed
whenever newreleases become available so it's like my own rolling release. But it is very stable. I inspect the output
from the boot log and dmesg fairly regularly (at least once a week), but had never seen anything about this deprecation
until my firewall failed to load when the write to the now-removed variable was attempted.

So I guess I'm an unusual case in that I don't rely on distro maintainers to fix up stuff like this on the rare
occasions it comes along. On reflection, I'd say leave it be - as I said earlier, it just seemed rather late in the 6.0
development cycle for this to pop up.
> I had little exposure to NF/conntrack in my career but I was guessing 
> for most users one of the two cases:
> 
>  - the system is professionally (i.e. someone is paid) maintained, 
>    so they should have noticed the warning and fixed in the last 10 yrs
> 
>  - the system is a basic SOHO setup which is highly unlikely to see much
>    more than TLS or QUIC these days
> 
> IOW the intersection of complex traffic and lack of maintenance is
> small.
> 
>> In old times, it was enough (not tested, just for illustration):
>>
>> iptables -A FORWARD -p tcp -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
>>
>> and load nf_conntrack_ftp (or whatever).  Module will auto-snoop traffic
>> on tcp port 21 for ftp commands, if it finds some, it auto-installs dynamic
>> 'expectation entries', so when data connection comes it will hit RELATED rule
>> above.
>>
>> This stopped working years ago, unless you did set the (now removed)
>> knob back to 1.
>>
>> Assuming iptables, users would need to do something like
>> iptables -t raw -A PREROUTING -p tcp --dport 21 -d $ftpaddr -j CT --helper "ftp"
>>
>> to tell that packets/connections on tcp:21 need to be examined for ftp commands.
> 
> Thanks for the explainer! 
> 
>>> Perhaps we can add the file back but have it do nothing?  
>>
>> I think its even worse, users would think that auto-assign is enabled.
> 
> Well, users should do the bare minimum of reading kernel logs :(
> 
> I think we should do _something_ because we broke so many things 
> in this release if we let this rot until its smell reaches Linus -
> someone is getting yelled at...
> 
> Now, Linus is usually okay with breaking uAPI if there is no other 
> way of preventing a security issue. But (a) we break autoload of
> all helpers and we only have security issue in one, and (b) not loading
> the module doesn't necessarily mean removing the file (at least IMHO).
> We have a bunch of dead files in proc already, although perhaps the 
> examples I can think of are tunables.
