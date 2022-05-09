Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14EF5205E8
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 22:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiEIUdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 16:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiEIUdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 16:33:04 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5C2297413
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 13:21:59 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d17so14945492plg.0
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 13:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=vYlLGaWIdvnNoSdXomGwt4b/rcHCq91RrTnlTtFGI8M=;
        b=K8by7TmqIhBeNn0LrmeZgjowTisQCd+wVRcCb0n/92Ex1IdqpUJbGl7vTJ1RBzATiZ
         8PlOpHDIPsD+u0IQmkoisadu7kmkvSR0LAh7WVYMqVNx7wr4mNNEItEk+RLwJRM4D7HB
         02EsL9NjqtROgaJhgmA1gnUAAMuPuQ0wgnJosPcb2IB+oeTrhNTHPboXV5l169BiLNh5
         0z/vfHQ1nGBDGp+s8ep2+1XEQIBIQl/N15xnB/o+juMhn+Qzp+NL/m5Z9nL1FtwMc4xH
         fdERBQqeu5f7cQGN0dHwtxA/M0TDJ//MHtpYnqyIsx3zng3/mbrltgiE3joj4CiFZ1ci
         13qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=vYlLGaWIdvnNoSdXomGwt4b/rcHCq91RrTnlTtFGI8M=;
        b=HMvmbT+2UiJDIR8uM/qaCL0QnzWK3wxUtrj8vLWGcOdDO3VRL7L0UyamMiu64ZErFM
         PYiBzI0heaXoX2f0TyEW556n14RF5nT9ymHvoI+oKwzRZRB2uN8eEqmaay/ZCD8rJhb+
         2gkxQSrM8sEe3baBDnfdxk4QyG8UCDvoPKLibNxESOYoKwyKCsMFXEcs2IUIoskyB/5r
         6u/GPQfzXK3k2J4aGhhr3Y6j3l+u7uJT6EOmIeSSuepOESFnvlKXcdstiYd2ItU9ct0K
         iJ3MY6FthGAJxPkjTk8Y3PL8pQCQf7dTymoSJGwwC0VWiPcNJGmnJdw6cmurcYp/Kkxx
         wUrQ==
X-Gm-Message-State: AOAM5309J+nDoXcc80+WNejard4UPsh1H0dDMS3znbpEXnJw40Eaafl2
        GZS6T6SjQUxvpEkV167lq34MVXyWn/Q=
X-Google-Smtp-Source: ABdhPJw2PTE1kjax8L9CC4mHdi5+iIaLsTcgqxqIcgFITcDWjlz8BXGP/Xnak46n3L+8dOtfO535lA==
X-Received: by 2002:a17:902:cf0b:b0:15a:2681:9180 with SMTP id i11-20020a170902cf0b00b0015a26819180mr17470251plg.137.1652127718786;
        Mon, 09 May 2022 13:21:58 -0700 (PDT)
Received: from [192.168.0.128] ([98.97.39.30])
        by smtp.googlemail.com with ESMTPSA id u67-20020a626046000000b0050dc762814esm9111974pfb.40.2022.05.09.13.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 13:21:58 -0700 (PDT)
Message-ID: <433e8f1e98c583d04798102f234aea6b566bef36.camel@gmail.com>
Subject: Re: [PATCH 0/2] Replacements for patches 2 and 7 in Big TCP series
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Coco Li <lixiaoyan@google.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Date:   Mon, 09 May 2022 13:21:56 -0700
In-Reply-To: <CANn89iL+r=dgW4ndjBBR=E0KQ0rBVshWMQOVmco0cZDbNXymrw@mail.gmail.com>
References: <CANn89iJW9GCUWBRtutv1=KHYn0Gpj8ue6bGWMO9LLGXqvgWhmQ@mail.gmail.com>
         <165212006050.5729.9059171256935942562.stgit@localhost.localdomain>
         <CANn89iL+r=dgW4ndjBBR=E0KQ0rBVshWMQOVmco0cZDbNXymrw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-3.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-05-09 at 11:54 -0700, Eric Dumazet wrote:
> On Mon, May 9, 2022 at 11:17 AM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> > 
> > This patch set is meant to replace patches 2 and 7 in the Big TCP series.
> > From what I can tell it looks like they can just be dropped from the series
> > and these two patches could be added to the end of the set.
> > 
> > With these patches I have verified that both the loopback and mlx5 drivers
> > are able to send and receive IPv6 jumbogram frames when configured with a
> > g[sr]o_max_size value larger than 64K.
> > 
> > Note I had to make one minor change to iproute2 to allow submitting a value
> > larger than 64K in that I removed a check that was limiting gso_max_size to
> > no more than 65536. In the future an alternative might be to fetch the
> > IFLA_TSO_MAX_SIZE attribute if it exists and use that, and if not then use
> > 65536 as the limit.
> 
> OK, thanks.
> 
> My remarks are :
> 
> 1) Adding these enablers at the end of the series will not be
> bisection friendly.

They don't have to be added at the end, but essentially they could be
drop in replacements for the two patches called out. I just called it
out that way as that is what I ended up doing in order to test the
patches, and to make it easier to just send them as a pair instead of
sending the entire set. I moved them to the end of the list and was
swapping between the 2 sets in my testing. I was able to reorder them
without any issues. So if you wanted you could place these two patches
as patches 2 and 7 in your series.

> 2) Lots more changes, and more backport conflicts for us.
> 
> I do not care really, it seems you absolutely hate the new attributes,
> I can live with that,
> but honestly this makes the BIG TCP patch series quite invasive.

As it stands the BIG TCP patch series breaks things since it is
outright overrriding the gso_max_size value in the case of IPv6/TCP
frames. As I mentioned before this is going to force people to have to
update scripts if they are reducing gso_max_size as they would also now
need to update gso_ipv6_max_size.

It makes much more sense to me to allow people to push up the value
from 64K to whatever value it is you want to allow for the IPv6/TCP GSO
and then just cap the protocols if they cannot support it.

As far as the backport/kcompat work it should be pretty straight
forward. You just replace the references in the driver to GSO_MAX_SIZE
with GSO_LEGACY_MAX_SIZE and then do a check in a header file somewhere
via #ifndef and if it doesn't exist you define it.

