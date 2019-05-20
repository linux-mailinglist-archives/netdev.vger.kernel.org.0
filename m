Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEFA223C4C
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 17:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392219AbfETPiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 11:38:17 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41891 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730766AbfETPiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 11:38:17 -0400
Received: by mail-qt1-f193.google.com with SMTP id y22so16787553qtn.8
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 08:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BI5a9u3gRGjDiVaCG9ohml9bqGbyDXBPGAywSXYi+Ms=;
        b=aeWPNa8xQZgiewEj1WhOiqGMUU7HC+qjed8vT6BKFI/8rADHAwwOcyaZLCHsTJs0oU
         +t6ZMsstWhz9XGNVg68je+vixMZnsbz7ZC2UPneZmOFtNi0+xYY++Qc8zoECwMkDcLZe
         UiMNpyIP3HWwtsZ2QFyZe4TazlVBmi8oeS+kJVW4mp7up/qL+g2gsD9vaegAuhJrhokd
         1dwqCOGa5PYZ7ZWji6UravGhmsJF5vMroDW925RsDuroY+AGSx9h9vYgppUCxLr9LZH5
         FC2yDyGzbWfIN5hNJyHFK6aLNXesNnB1SVSxCBXIgQPE8pHQJIr28nLtsgzyDf4Fe9Qq
         MGtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BI5a9u3gRGjDiVaCG9ohml9bqGbyDXBPGAywSXYi+Ms=;
        b=pPYNWTRGxDfhtGCxfcet0dVfEQmdR69Qy06+cE8FvqQ5El25gAvDVEn5TwJu9Hbsym
         kCm/539O1NdtkO55eN5VV1Fg4vQmkIyMRHfkfG3x0amhLR/kf/+Kb4Il3hQZhsucMpdc
         hqdoxPF0QPjrUD19dGQJd0Evrw2fs5eEK7D9y28JCnIjaqEM6RQgMZOXNGlNO+XHtSMg
         EC40vKhXCoG8os0kmSrIpxvorA/PWN/rTxr3BV0YBSC7HrB2YiIHV39VBE1Zh6JymHZW
         8lcazo0SF6ns//etIP97pCPAP0F+I0xRFx3bFC9mAVj74vlw5l7tGFWndgng2YgMvwO1
         oe7Q==
X-Gm-Message-State: APjAAAXskbG/fbV0eJOY4PRbR5aSKll9xXN3yedPIouYA8Ht5EjY2Xm+
        Xi4QUHqQkILHpeAfo+t1B5EZIA==
X-Google-Smtp-Source: APXvYqyU70fP35PwYZEzR6I6DlPDx+Q4poKbNAMdPy9zoPqPjX7Zuq38lJuyrkwgi8sxvc/uAzs1tQ==
X-Received: by 2002:a0c:b89d:: with SMTP id y29mr14326659qvf.170.1558366696498;
        Mon, 20 May 2019 08:38:16 -0700 (PDT)
Received: from [192.168.0.124] (24-212-162-241.cable.teksavvy.com. [24.212.162.241])
        by smtp.googlemail.com with ESMTPSA id i13sm7565224qkm.68.2019.05.20.08.38.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 08:38:15 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 0/3] flow_offload: Re-add per-action
 statistics
To:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <9b137a90-9bfb-9232-b01b-6b6c10286741@solarflare.com>
 <f4fdc1f1-bee2-8456-8daa-fbf65aabe0d4@solarflare.com>
 <cacfe0ec-4a98-b16b-ef30-647b9e50759d@mojatatu.com>
 <f27a6a44-5016-1d17-580c-08682d29a767@solarflare.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <3db2e5bf-4142-de4b-7085-f86a592e2e09@mojatatu.com>
Date:   Mon, 20 May 2019 11:38:14 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <f27a6a44-5016-1d17-580c-08682d29a767@solarflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-20 11:26 a.m., Edward Cree wrote:
> On 18/05/2019 21:39, Jamal Hadi Salim wrote:
>> On 2019-05-17 1:14 p.m., Edward Cree wrote:
>>> On 17/05/2019 16:27, Edward Cree wrote:

> Unless *I* missed something, I'm not changing the TC<=>user-space API at
>   all.  If user space specifies an index, then TC will either create a new
>   action with that index, or find an existing one.  Then flow_offload turns
>   that into a cookie; in the 'existing action' case it'll be the same
>   cookie as any previous offloads of that action, in the 'new action' case
>   it'll be a cookie distinct from any existing action.

That is fine then if i could do:

tc actions add action drop index 104
then
followed by for example the two filters you show below..

Is your hardware not using explicit indices into a stats table?

> Drivers aren't interested in the specific index value, only in "which
>   other actions (counters) I've offloaded are shared with this one?", which
>   the cookie gives them.
> 
> With my (unreleased) driver code, I've successfully tested this with e.g.
>   the following rules:
> tc filter add dev $vfrep parent ffff: protocol arp flower skip_sw \
>      action vlan push id 100 protocol 802.1q \
>      action mirred egress mirror dev $pf index 101 \
>      action vlan pop \
>      action drop index 104
> tc filter add dev $vfrep parent ffff: protocol ipv4 flower skip_sw \
>      action vlan push id 100 protocol 802.1q \
>      action mirred egress mirror dev $pf index 102 \
>      action vlan pop \
>      action drop index 104
> 
> Then when viewing with `tc -stats filter show`, the mirreds count their
>   traffic separately (and with an extra 4 bytes per packet for the VLAN),
>   whereas the drops (index 104, shared) show the total count (and without
>   the 4 bytes).
>

Beauty.  Assuming the stats are being synced to the kernel?
Test 1:
What does "tc -s actions ls action drop index 104" show?
Test 2:
Delete one of the filters above then dump actions again as above.

> (From your other email)
>> tcfa_index + action identifier seem to be sufficiently global, no?
> The reason I don't like using the action identifier is because flow_offload
>   slightly alters those: mirred gets split into two (FLOW_ACTION_REDIRECT
>   and FLOW_ACTION_MIRRED (mirror)).  Technically it'll still work (a redirect
>   and a mirror are different actions, so can't have the same index, so it
>   doesn't matter if they're treated as the same action-type or not) but it
>   feels like a kludge.
> 

As long as uapi semantics are not broken (which you are demonstrating it
is not) then we are good.

cheers,
jamal

> -Ed
> 

