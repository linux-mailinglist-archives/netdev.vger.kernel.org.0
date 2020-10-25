Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1F12983D7
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 23:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1419155AbgJYWMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 18:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1419150AbgJYWMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 18:12:38 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E3DC061755;
        Sun, 25 Oct 2020 15:12:36 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q25so7980780ioh.4;
        Sun, 25 Oct 2020 15:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CCLWLpAlHU9Dh1dZ7UTlBHF0U829I1FR53xIgiCWEt4=;
        b=UX1w2aaSO2NmIgl6qUrz9WeLM/hr5vi2D/7bA4uwRGbF73qcp+ppTxihkIwWL2S7my
         WTkN4+oU/UKqfv8HfNOgcpSchn5qATbvZ0QRikxHiBNbafP246Cg/6VeI4POt5Kl557h
         ymlKcVUBepP0E1m+0xBLFK4X6n+oyraEzDoS7o8FCHsmZiq1r7TmUxMi5anU2HblrQU0
         4Uj9VlGVStcCGrYNyvCpFwtUq/rIoEVKzfKCnEvnir0Lo9DqK10JENOKPsMgBeaDmwht
         X6GzvN6jcBc5ubdWeSNS2RhffrOHY3mTEPxKydGErINOzfSLDG0Fx1531KkIffZh3oP6
         FPYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CCLWLpAlHU9Dh1dZ7UTlBHF0U829I1FR53xIgiCWEt4=;
        b=CMl/yMBh5kCtA2QtcLQACZ6S6r2897YFrqufi2i57DGLU2gWUfiWV0hASPWWa2iChk
         60yqu2Ccb+F+y4Bv2pWCWJMZppYLqh1djGdaJKLcAGudytWcfmCzY5pNp80tvbwMl1qm
         r+mdS6ogk7G5ZJObWqqaZYpjIoZ+VZDM821y9NLEtgciHhWZfimRx1wL1gqly6Vf/S3E
         /Q9QzdYyNg3mDlb9g08+ZoCZQI9/X6lV9CLCvH/NPVQxjlyhihbjkMG4WRK2N1gQ/gfr
         yAiumBaXrh1VBh4gKxB8bOo+xVBiLDuMWmn0ezVi6SIgQ6p7Irz/oQjBdQSetPH7jjVR
         Sibg==
X-Gm-Message-State: AOAM531/dWecgCWpDF9FwxzNeVSZNh6WWqqetnOee/e3G8HH/Q24TFkV
        Wou8pNjrqXJEBm9qgBfxKso=
X-Google-Smtp-Source: ABdhPJwhCiI1HfU5Mwu6CE9suaF+u9PFOa6DguVcgdmsPQFuRJfGZ6+kXT9h2IMGGCZcIMXmzUceyQ==
X-Received: by 2002:a02:1783:: with SMTP id 125mr9240721jah.121.1603663956272;
        Sun, 25 Oct 2020 15:12:36 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:e928:c58a:d675:869a])
        by smtp.googlemail.com with ESMTPSA id e13sm1010703ili.67.2020.10.25.15.12.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2020 15:12:35 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 3/5] lib: add libbpf support
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>
References: <20201023033855.3894509-1-haliu@redhat.com>
 <20201023033855.3894509-4-haliu@redhat.com>
 <29c13bd0-d2f6-b914-775c-2d90270f86d4@gmail.com> <87eelm5ofg.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <91aed9d1-d550-cf6c-d8bb-e6737d0740e0@gmail.com>
Date:   Sun, 25 Oct 2020 16:12:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <87eelm5ofg.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/25/20 9:13 AM, Toke Høiland-Jørgensen wrote:
> David Ahern <dsahern@gmail.com> writes:
> 
>> On 10/22/20 9:38 PM, Hangbin Liu wrote:
>>> Note: ip/ipvrf.c is not convert to use libbpf as it only encodes a few
>>> instructions and load directly.
>>
>> for completeness, libbpf should be able to load a program from a buffer
>> as well.
> 
> It can, but the particular use in ipvrf is just loading half a dozen
> instructions defined inline in C - there's no object files, BTF or
> anything. So why bother with going through libbpf in this case? The
> actual attachment is using the existing code anyway...
> 

actually, it already does: bpf_load_program

I recalled figuring out how to do it, just did not remember if it was
local changes to libbpf. Does not look like any changes were needed:

https://github.com/dsahern/bpf-progs/blob/master/src/cgroup_sock.c
