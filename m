Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A705890A0
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 18:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbiHCQkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 12:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiHCQj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 12:39:59 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7E3B1DC
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 09:39:57 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id d4so8737428ilc.8
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 09:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=UCh0NmoCmabNWgWJ/tUrQh2kdChsA9GHWC9sQChapLw=;
        b=nfGRJNXrDdjCXKmG+YuN5LMHWmvUsfpT9RwX9K31nd4Ba+XTa2gUZ4EdFGNEcTVyUy
         eba4D3Jq2bgZpKGt5yDEKNVwcz5UUltmATChUlXO5LIqZWvraK2pPtrumy2X2KbG/6gv
         cr5Lc8Oj9fTzpQ/PmwCkLLx4nstPEm4F58xw3rfpYVSOUBS+zHA1LKIqJgT33Nj0wniy
         DUlqaSTiIkEbVFsKD64jj+zC3poyCN5ht09cS29PhJIGY7rbhvGzyWBgIMgd8o+WFKX7
         Cknz7GFAPav9qRiYkGjkf/OyL34qa/DvUSxVVXfMUCGBncN4luwr3A58F2/kYl83VPoX
         lOTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UCh0NmoCmabNWgWJ/tUrQh2kdChsA9GHWC9sQChapLw=;
        b=UlggIFVrpiwvl818ZzrXJNeDuHJdXUZrmH6XgKGnxFXi4apTuaRDHLdvpxLi4SgXbW
         4nuhph6dsqaKFJMLx+8SP3Sp9ypJ030qeoiQTRxPTCIqpgc+FvDOCvQp9BussH70ZJT+
         zCfpLHr2mr+aUUjTTnUpUWHlg9QIJKtuv4GlfOLu57HJZ6o8SrFRWfXHmM8EvxTRfi+1
         4vKD/lOU2QynbCAw3n6n4/c3KiOyNy74J7gE44hg+9JSNFxUbbjdnjWaB0E4odmCaht2
         G54ik6QuqJ/lhdT42+HFmQpXqEDOHuHjSdVdAWXNpyg9w2yhCns6uhPF5PDLDG4r8xMK
         Tciw==
X-Gm-Message-State: AJIora+CQX2GQNo07Iu6Sv59MP4+W/ki/bWOFhfn1xXxj/fXcUgpQJ1o
        pOlz7m+x1LDVSifHhbxsQOYN4g==
X-Google-Smtp-Source: AGRyM1sQNXg2KhMHneLcef3+CpUgiEDuFNui1Pkc1Qw3RWvfpsYzhU5MhWuhBD8ORf0X4v0nAIp5Ug==
X-Received: by 2002:a92:cf4a:0:b0:2dd:e288:e4c4 with SMTP id c10-20020a92cf4a000000b002dde288e4c4mr11134344ilr.130.1659544796858;
        Wed, 03 Aug 2022 09:39:56 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h1-20020a056e020d4100b002de2ea2f78csm6136328ilj.23.2022.08.03.09.39.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 09:39:56 -0700 (PDT)
Message-ID: <1bbb9374-c503-37c6-45d8-476a8b761d4a@kernel.dk>
Date:   Wed, 3 Aug 2022 10:39:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] io_uring support for zerocopy send
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <d5568318-39ea-0c39-c765-852411409b68@kernel.dk>
 <CAHk-=wjh91hcEix55tH7ydTLHbcg3hZ6SaqgeyVscbYz57crfQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wjh91hcEix55tH7ydTLHbcg3hZ6SaqgeyVscbYz57crfQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/22 2:45 PM, Linus Torvalds wrote:
> On Sun, Jul 31, 2022 at 8:03 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On top of the core io_uring changes, this pull request adds support for
>> efficient support for zerocopy sends through io_uring. Both ipv4 and
>> ipv6 is supported, as well as both TCP and UDP.
> 
> I've pulled this, but I would *really* have wanted to see real
> performance numbers from real loads.
> 
> Zero-copy networking has decades of history (and very much not just in
> Linux) of absolutely _wonderful_ benchmark numbers, but less-than
> impressive take-up on real loads.
> 
> A lot of the wonderful benchmark numbers are based on loads that
> carefully don't touch the data on either the sender or receiver side,
> and that get perfect behavior from a performance standpoint as a
> result, but don't actually do anything remotely realistic in the
> process.
> 
> Having data that never resides in the CPU caches, or having mappings
> that are never written to and thus never take page faults are classic
> examples of "look, benchmark numbers!".
> 
> Please?

That's a valid concern! One of the key points behind Pavel's work is
that we wanted to make zerocopy _actually_ work with smaller payloads. A
lot of the past work has been focused on (or only useful with) bigger
payloads, which then almost firmly lands it in the realm of "looks good
on streamed benchmarks". If you look at the numbers Pavel posted, it's
definitely firmly in benchmark land, but I do think the goals of
breaking even with non zero-copy for realistic payload sizes is the real
differentiator here.

For the io_uring network developments, Dylan wrote a benchmark that we
use to mimic things like Thrift. Yes it's a benchmark, but it's meant to
model real world things, not just measure ping-pongs or streamed
bandwidth. It's actually helped drive various of the more recent
features, as well as things coming in the next release, and been very
useful as a research vehicle for adding real io_uring support to Thrift.
The latter is why it was created in the first place, not to have Yet
Another benchmark that can just spew meaningless numbers. Zero-copy is
being added there too, and we just talked about adding some more tweaks
to netbench that allows it to model data/cache usage too on both ends.

The Thrift work is what is really driving this, but it isn't quite done
yet. Looking very promising vs epoll now, though, we'll make some more
noise about this once it lands. Moving to a completion based model takes
a bit of time, it's not a quick hack conversion where you just switch to
a different notification base.

-- 
Jens Axboe

