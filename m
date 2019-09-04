Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF162A9249
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730436AbfIDT0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 15:26:23 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:34715 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729872AbfIDT0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 15:26:23 -0400
Received: by mail-wr1-f50.google.com with SMTP id s18so42870wrn.1
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 12:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zKZ9aHvD6PjJwGVRhczGVMvf0jMBBtcP/ZZ2tgpkDcI=;
        b=l2Wfe/cOz1uHnuj9Xx5CHH3pPLfS3bcmpNZSWp6uKs8Z5Yr7a1MfuliGZFV82Xwsan
         QaDmJqexuU8yn/QMs8Bs0ZhgPr/jV/br3pV6Psqhrrw/E/6blj87HbOKdFCQ5fC+POrr
         VgDfpAwQ4HDy6C2l96K77JRqNq3dNh92NlSFMeg7bG3ouIj2Ofb+wzf/Wx+6/Is59h0q
         fYTywRLzqPKOs6/KAr9oO5mehDd8/20+k5vXpLcUcnYzhlRNpKVBn09q7tKBB4Lapgfl
         pzh3CX2Zr/s39DbJaW/+tkE3PrFgxn9enZKGSlgBRA2up8JXqwqPtk1800vQtDD4kRFt
         H3Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zKZ9aHvD6PjJwGVRhczGVMvf0jMBBtcP/ZZ2tgpkDcI=;
        b=t3x5sfZElxBicNmQBPLsHCJ9qT+0AmKfdjDOS7XzSqzaicjE3YVyCs3ywwzleox+rJ
         KbUix5MDBP8jzVZaabOFxbfy2A8XK0h8ea/V7yrnz4p13x6TrDmOedYyisdo0zsiyOub
         rxPESrDT4fG7DDCcdC8y58ni0QmZyOFkL3pITwPRu21ONgX7wc4NovUVXFFp/wjrFz4w
         Dh/WdbxxaiKObit3lmHrv//WOg999nSTTV9BvyZX9HLogaZXqW89SBBOshz1wUJbFHWg
         K/wPDS2AtkuN/2Tk5ljXSsVwasAJE6BGirzax1ssusojqSn1xEUZY2BX6L/4q8tm76JF
         Z5Aw==
X-Gm-Message-State: APjAAAX0Io7xZ0OAqfqGYY/p8vnvsmucbCzYJ1u/bB64ex+Nv9POv/WS
        ZpgHIO9EBCSwC/NsRhEzX+M=
X-Google-Smtp-Source: APXvYqwS3vzJMbEr1/FItiKWaqyswLeQuhN0u30hWPMZ3h8QiPsqEhiUQ6ED42BoMalB+/K9qMCQLg==
X-Received: by 2002:adf:a55d:: with SMTP id j29mr47318859wrb.275.1567625181811;
        Wed, 04 Sep 2019 12:26:21 -0700 (PDT)
Received: from [192.168.8.147] (206.165.185.81.rev.sfr.net. [81.185.165.206])
        by smtp.gmail.com with ESMTPSA id z12sm16228349wrt.92.2019.09.04.12.26.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2019 12:26:21 -0700 (PDT)
Subject: Re: Is bug 200755 in anyone's queue??
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Steve Zabele <zabele@comcast.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Mark KEATON <mark.keaton@raytheon.com>,
        Network Development <netdev@vger.kernel.org>,
        "shum@canndrew.org" <shum@canndrew.org>,
        "vladimir116@gmail.com" <vladimir116@gmail.com>,
        "saifi.khan@strikr.in" <saifi.khan@strikr.in>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "on2k16nm@gmail.com" <on2k16nm@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <010601d53bdc$79c86dc0$6d594940$@net>
 <20190716070246.0745ee6f@hermes.lan> <01db01d559e5$64d71de0$2e8559a0$@net>
 <CA+FuTSdu5inPWp_jkUcFnb-Fs-rdk0AMiieCYtjLE7Qs5oFWZQ@mail.gmail.com>
 <8f4bda24-5bd4-3f12-4c98-5e1097dde84a@gmail.com>
 <CA+FuTSf4iLXh-+ADfBNxqcsw=u_vGm7Wsx7vchgwgwvGFYOA6w@mail.gmail.com>
 <CA+FuTSdi=tw=N4X2f+paFNM7KHqBgNkV_se-ykZ0+WoA7q0AhQ@mail.gmail.com>
 <00aa01d5630b$7e062660$7a127320$@net>
 <4242994D-E2CF-499A-848A-7B14CE536E33@raytheon.com>
 <c3b83305-82a5-f3c8-2602-1aed2e9b51ca@gmail.com>
 <F119F197-FD88-4F9B-B064-F23B2E5025A3@comcast.net>
 <CA+FuTSf24VrjOxS9Kg3+DFEYn7ihe6vMj5o7rggOz_6KH_rNpQ@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <87cef966-a94c-7705-26a6-0d6361f98a7a@gmail.com>
Date:   Wed, 4 Sep 2019 21:26:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSf24VrjOxS9Kg3+DFEYn7ihe6vMj5o7rggOz_6KH_rNpQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/4/19 5:46 PM, Willem de Bruijn wrote:
> On Wed, Sep 4, 2019 at 10:51 AM Steve Zabele <zabele@comcast.net> wrote:
>>
>> I think a dual table approach makes a lot of sense here, especially if we look at the different use cases. For the DNS server example, almost certainly there will not be any connected sockets using the server port, so a test of whether the connected table is empty (maybe a boolean stored with the unconnected table?)


UDP hash tables are shared among netns, and the hashes function depend on a netns salt ( net_hash_mix())

(see udp_hashfn() definition)

So a boolean would be polluted on a slot having both non connected socket on netns A, and a connected socket for netns B.


 should get to the existing code very quickly and not require accessing the memory holding the connected table. For our use case, the connected sockets persist for long periods (at network timescales at least) and so any rehashing should be infrequent and so have limited impact on performance overall.
>>
>> So does a dual table approach seem workable to other folks that know the internals?
> 
> Let me take a stab and compare. A dual table does bring it more in
> line with how the TCP code is structured.
> 
