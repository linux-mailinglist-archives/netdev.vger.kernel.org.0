Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020A15F09E8
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 13:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiI3LUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 07:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiI3LUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 07:20:16 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CE0659A
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 04:07:18 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id n83so4368627oif.11
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 04:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=uy2FqrRQLwdHN94gdbssde7AApfgzcrW3Xd9tJIrclc=;
        b=wz9C2bV3zRM56gnZDkOEZXybVPGl/CRZ5GztCPipkbxDsJQpxW5UIfXtnV0YlbZse8
         Ayu8sM0wUJuzS1Lg520F4nArNDmwTskEYjsW8CaDjUGwd/MEgVSynXTnZzgElMNvew0e
         wA2XqXIxzmGKqD0SPyOpIJvXwHX4lRjJkZWXpQI0LGCsfce0/t2mpxLiZATgmyFRmiN4
         rocAMWoQam1wTNxk5ndyX4SkTp9xvz09UBmvFv+RISp1Ckjh/6BdL+MzbIVagzCnKtsn
         qV9pF9ghweSdmKDIFmOSTPgKlkSabss6/ORulJwLYsf5B2BxSPdBPhb2JvfH8PpwNWOn
         JHsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=uy2FqrRQLwdHN94gdbssde7AApfgzcrW3Xd9tJIrclc=;
        b=vSWQEIft3WELUc3Qmuf52FSG7SsVBdjkH26XtAeZ/YZeq3S4ARlUM2T2R2dNsVlPvU
         NVhcv5ZhnGazXWBxuzEeu/qX4ecVnPYaOd4bsphGG4NsadIgXDA0TBWxiW7aEYrvYX9G
         Qlt8wNBGo7Y+CVTVZbjV7nosAPndFg2nxvoLizBmOQe2P0xFZffGRHpJSJJ8HRhgqcH/
         hL8C1Zmcjyf1s+tfLdFwS9DxNcDmNHn4wTjICLiJxgu664CYGaayWbhCbWsaakcYynQy
         07QiLz+Jq2qhiXRIu3PXSip3bbZCGayk2bMH04koi5SwIw1Ca/U7ANIHHkoTu7x8p+hD
         RVEQ==
X-Gm-Message-State: ACrzQf0k36h31/hkP968GJn75KZh5SnJhE5EEHzET6ENdTXjD9M/h+9+
        KNWNlP7Rtz2V/gVoq34WBkAGnFkzXgOTfBNu6rJNUA==
X-Google-Smtp-Source: AMsMyM59lADPbAVz6xkrLfiIK+S7rLDyE/KOwsBIcpbRFBhvD+iSp/vaqwkabGYJaU7g4vFS84gy4Cxf3jklVM2jZYg=
X-Received: by 2002:a05:6808:1997:b0:34f:d372:b790 with SMTP id
 bj23-20020a056808199700b0034fd372b790mr3534781oib.2.1664536037381; Fri, 30
 Sep 2022 04:07:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220927212306.823862-1-kuba@kernel.org> <a3dbb76a-5ee8-5445-26f1-c805a81c4b22@blackwall.org>
 <20220928072155.600569db@kernel.org>
In-Reply-To: <20220928072155.600569db@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 30 Sep 2022 07:07:05 -0400
Message-ID: <CAM0EoMmWEme2avjNY88LTPLUSLqvt2L47zB-XnKnSdsarmZf-A@mail.gmail.com>
Subject: Re: [PATCH net-next] docs: netlink: clarify the historical baggage of
 Netlink flags
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Guillaume Nault <gnault@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 10:21 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 28 Sep 2022 10:03:07 +0300 Nikolay Aleksandrov wrote:
> > The part about NLM_F_BULK is correct now, but won't be soon. I have patches to add
> > bulk delete to mdbs as well, and IIRC there were plans for other object types.
> > I can update the doc once they are applied, but IMO it will be more useful to explain
> > why they are used instead of who's using them, i.e. the BULK was added to support
> > flush for FDBs w/ filtering initially and it's a flag so others can re-use it
> > (my first attempt targeted only FDBs[1], but after a discussion it became clear that
> > it will be more beneficial if other object types can re-use it so moved to a flag).
> > The first version of the fdb flush support used only netlink attributes to do the
> > flush via setlink, later moved to a specific RTM command (RTM_FLUSHNEIGH)[2] and
> > finally settled on the flag[3][4] so everyone can use it.
>
> I thought that's all FDB-ish stuff. Not really looking forward to the
> use of flags spreading but within rtnl it may make some sense. We can
> just update the docs tho, no?
>
> BTW how would you define the exact semantics of NLM_F_BULK vs it not
> being set, in abstract terms?

I missed the discussion.
NLM_F_BULK looks strange. Why pollute the main header? Wouldnt NLM_F_ROOT
have sufficed to trigger the semantic? Or better create your own
"service header"
and put fdb specific into that object header? i.e the idea in netlink
being you specify:
{Main header: Object specific header: Object specific attributes in TLVs}
Main header should only be extended if you really really have to -
i.e requires much
longer review..

Historical context: We did try to push netlink as a wire protocol
(meaning it goes
across nodes instead of user-kernel), see:
https://www.rfc-editor.org/rfc/rfc3549.html and
https://datatracker.ietf.org/doc/html/draft-jhsrha-forces-netlink2-02
(there's an implementation
of netlink2 that i can dig up).
unfortunately there was much politiking and ForCES protocol was the compromise;
as a side, there's _no way in hell_ current netlink would be possible
to use on the wire
because of all these one-offs that were being added over time.
RFC3549 has some documentation which is not really up to date but still valid
(section 2.2/3 on the header). Note: The EXCL, APPEND etc are very
similar to file system
semantics (eg open())
Generic netlink was written because there were too many people
grabbing netlink ids
and we were going to run out of them at some point. IIRC, i called it
"foobar" originally
and Dave didnt like that name. It was intended to be the less
efficient cousin (subject to
more locks etc) - and the RPC semantic changes were mostly to
accommodate the fact
that you couldnt use netlink proper - although I am more a fan of
CRUD(restful) semantics
than RPC (netlink proper is salvagable for CRUD as is).

Not sure how much of this can be leveraged in the documentation (I
will take a look).

cheers,
jamal

cheers,
jamal
