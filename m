Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA6DA0197
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 14:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfH1M1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 08:27:51 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:35122 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbfH1M1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 08:27:51 -0400
Received: by mail-wr1-f41.google.com with SMTP id g7so1109182wrx.2
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 05:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N785Ki8CTfvy0MmwNY5spjSQC1evQAv5H3Orf+NLOK4=;
        b=q+AG7JJ4MU1WdIVqvhXDvKhJo7R38YjhzsOMtru5bKG4OYB8wPjdu1wb0Dx+vLG9P4
         4dtVbHCgJGr6emqwRV4M9URiMEGB/cpGq9gw5/hooz7557GbDiNW1IF+fTRnVlH9vbt0
         gavmHD3aP8iPZQVvEkEFae1ympySVcMsPOkz+OhrgT4kOJhW9nTpmZDiKuzFV7krc13K
         THkdhsBWNWNEu3vtPRyyDpZWfyPcj6yZFXazSaF2Jf61Yp8isQEKIsi8/pZF6lYRgasf
         nyJiOSc+zQYSg1qPt3ATJGFz3afpq1gohEIPQm5V/HEN5DJk0PGud4wJOK3ftByRyjRc
         0yew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N785Ki8CTfvy0MmwNY5spjSQC1evQAv5H3Orf+NLOK4=;
        b=gNPUH+DS+y0aRfRspVYIFX6tlmiiT/yHYW8S1Sag5aRjngBlibgdRbJLfx2EfU5WOX
         GqQOpK6Ljbi/qb1xC8OHLITT78HJ/6e4yOWtcL34CHMLjsfDATTcXt3PBs/5huCYdait
         GXdLFL8DDumXv5X1pA19WMvsg2smzyMpp7ryjt3Ak6Oh0s7gVlgWEoD0Lew4binALqDH
         lXDV+nhOUV/6OrLnH6XwVorN1B3xoJ/dFOC+p6qO/nJNC3s90IzMO/MeEhHhRon8VfKI
         iNehCZFRgza8XXj5pp/SU5HH7BV+Y3PO6FRDSQVlaN9VddEYVSUs2Zba25YT5XlJLuYf
         0jzA==
X-Gm-Message-State: APjAAAX1fC9rEh999YMP9ZJw4i8pBqWGezvG5WvMLGZzZgNBxeajmTa8
        Dn5PPztvL5ZtO7Fe/AmSznXWbbhe
X-Google-Smtp-Source: APXvYqz81mVOE1g/jqJGac5wGeBMdh0Pym1WRGZgIJzcHamxhB3x28UD+kK55WaSutJBhr8dM8SN+w==
X-Received: by 2002:a5d:4e90:: with SMTP id e16mr4289799wru.339.1566995268996;
        Wed, 28 Aug 2019 05:27:48 -0700 (PDT)
Received: from [192.168.8.147] (11.170.185.81.rev.sfr.net. [81.185.170.11])
        by smtp.gmail.com with ESMTPSA id l9sm3030985wmi.29.2019.08.28.05.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Aug 2019 05:27:48 -0700 (PDT)
Subject: Re: multipath tcp MIB counter placement - share with tcp or extra?
To:     Florian Westphal <fw@strlen.de>, Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org
References: <20190828114321.GG20113@breakpoint.cc>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <deb00e41-0188-0ca9-ccb3-b74b34a4cc5d@gmail.com>
Date:   Wed, 28 Aug 2019 14:27:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190828114321.GG20113@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/28/19 1:43 PM, Florian Westphal wrote:
> Hi Eric,
> 
> The out-of-tree multipath TCP stack adds a few MIB counters to track
> (and debug) MTPCP behaviour.  Examples:
> 
>         SNMP_MIB_ITEM("MPCapableSYNRX", MPTCP_MIB_MPCAPABLEPASSIVE),
>         SNMP_MIB_ITEM("MPCapableSYNTX", MPTCP_MIB_MPCAPABLEACTIVE),
> [..]
>         SNMP_MIB_ITEM("MPTCPRetrans", MPTCP_MIB_RETRANSSEGS),
>         SNMP_MIB_ITEM("MPFailRX", MPTCP_MIB_MPFAILRX),
>         SNMP_MIB_ITEM("MPCsumFail", MPTCP_MIB_CSUMFAIL),
> 
> and so on.
> 
> I think that such MIB counters would be good to have in the 'upstreaming'
> attempt as well.
> 
> The out-of-tree code keeps them separate from the tcp mib counters and also
> exposes them in a different /proc file (/proc/net/mptcp_net/snmp).
> 
> Would you be ok with mptcp-upstreaming adding its MIB counters to the
> existing TCP MIB instead?
> 
> This would make 'nstat' and other tools pick them up automatically.
> It would also help TCP highlevel debugging to see if MPTCP is involved
> in any way.
> 
> Let me know -- I can go with a separate MIB, its no problem, I just want
> to avoid going down the wrong path.

There are about 40 counters.

Space for that will be per netns : num_possible_cpus * 40 * 8  bytes

The cost of folding all the values will make nstat slower even if MPTCP is not used.

Maybe find a way to not having to fold the MPTCP percpu counters if MPTCP is not loaded ?
