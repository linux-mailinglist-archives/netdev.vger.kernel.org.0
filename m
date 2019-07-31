Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 422057D064
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 23:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbfGaV7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 17:59:06 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37170 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfGaV7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 17:59:06 -0400
Received: by mail-pl1-f194.google.com with SMTP id b3so31091869plr.4
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 14:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=df0erg+vMjIK+Rh7AauGXtn2j8HB/8B84v5g4eTevp8=;
        b=aVm2tlJbp7DBasChYrfHly031zDPy9JI41+m/MBzIu4DrC9Sx5NcZTramNsCJINlxr
         tFVs5tQhHYLs5wl4w0Nl594DwXnmDDUsWk9e6sedZO7JdpgG80pg4ORTRS6KKjY5EXWW
         Gg7s5WbKYojeiOEHIbORWLvNbVVHfpr+lE5Q8FwTKtkifJQq1rR/OEd0KvYpGsWiJQql
         Hz0M34VimCz2FNOft9TJ1LOSGNS6l8jLNi7fLWdUDoY6Tl8kvVqxL4H7kpymNGpbMo6/
         pgaa0HSmD3B26CJaL0L0tMXlnU8TGTmzbfGyicq78VhQNmUD1poTigRcd0WqW/2RwtOB
         DLMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=df0erg+vMjIK+Rh7AauGXtn2j8HB/8B84v5g4eTevp8=;
        b=RRsMYTBH88Ms7SZz7uDG0Q/N0PlZ18CA1yRYLe2+XwZJX2jNLhgklN9AH0dvVQdpRG
         zlCz+pDVtevFpDRLIJqJun2hMZ2ZRrGovxJufl5TTTRDwAYMNQkbbhdN8VBmaPnAYf9F
         hVq+sam0wynKbE1pefQ5H45z4EtmWlQvPcA7dr47USu05y6Tb58IhNymij/TleTUdGyQ
         M0s6c+4mRM6pb1EOascoofwXMufzOLHDcpvC5GR764i0faVCTv58k6B885OpfWngb5mc
         WF6HN9H+IZ5Y4oxniopMfYiw5tS3hQHqMnge8AAhhA6Qu76CkiVBSwj3/QS3wxZ4GRa6
         EGqw==
X-Gm-Message-State: APjAAAWqiYMNaL79ZTb94xxcm57kcu1pDcPgOoicUzSDjErZL/sFkoGl
        X4YU62vFJC9Jl1IkJ6yKoOBiZCDc
X-Google-Smtp-Source: APXvYqwMf7k0hAMXDsQ7zo6JV4DcSgSjy9B9nzxL5nCNhOjnbYSK+cJ/bfeNw5qyjPgzKGZQ/aLtdw==
X-Received: by 2002:a17:902:2baa:: with SMTP id l39mr123698629plb.280.1564610345416;
        Wed, 31 Jul 2019 14:59:05 -0700 (PDT)
Received: from [172.27.227.172] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id v138sm79569908pfc.15.2019.07.31.14.59.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 14:59:04 -0700 (PDT)
Subject: Re: [PATCH 0/2] tools: bpftool: add net (un)load command to load XDP
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "Daniel T. Lee" <danieltimlee@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
References: <20190730184821.10833-1-danieltimlee@gmail.com>
 <20190730155915.5bbe3a03@cakuba.netronome.com>
 <20190730231754.efh3fj4mnsbv445l@ast-mbp>
 <20190730170725.279761e7@cakuba.netronome.com>
 <20190731002338.d4lp2grsmm3aaav3@ast-mbp>
 <20190730182144.1355bf50@cakuba.netronome.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b5af0432-282e-003c-8c1c-19835dd3296a@gmail.com>
Date:   Wed, 31 Jul 2019 15:59:02 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190730182144.1355bf50@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/30/19 7:21 PM, Jakub Kicinski wrote:
> 
>>>> If bpftool was taught to do equivalent of 'ip link' that would be
>>>> very different story and I would be opposed to that.  
>>> Yes, that'd be pretty clear cut, only the XDP stuff is a bit more 
>>> of a judgement call.  
>> bpftool must be able to introspect every aspect of bpf programming.
>> That includes detaching and attaching anywhere.
>> Anyone doing 'bpftool p s' should be able to switch off particular
>> prog id without learning ten different other tools.
> I think the fact that we already have an implementation in iproute2,
> which is at the risk of bit rot is more important to me that the
> hypothetical scenario where everyone knows to just use bpftool (for
> XDP, for TC it's still iproute2 unless there's someone crazy enough 
> to reimplement the TC functionality :))

apparently the iproute2 version has bit rot which is a shame.

> 
> I'm not sure we can settle our differences over email :)
> I have tremendous respect for all the maintainers I CCed here, 
> if nobody steps up to agree with me I'll concede the bpftool net
> battle entirely :)

bpftool started as an introspection tool and has turned into a one stop
shop for all things ebpf. I am mixed on whether that is a good thing or
a bad thing.
