Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AED363BA84
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 08:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiK2HV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 02:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiK2HV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 02:21:27 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C6B3AC31
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 23:21:26 -0800 (PST)
Date:   Tue, 29 Nov 2022 08:21:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669706483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MQKXJPSvxUV0hQyNaD6UpX+KWDEBJiig1LV0w73OtnU=;
        b=OBYo6WlAlgUxxORd6W331PMCsxKNdyDSv7Lhn95ak4v2ts+ozz+j2pdR23uDBjXpmgtNnH
        JO/NLJ1d/pdRvnsd8ip5MwyZXdX61d4nTS55GkpYFKLUFOj6rVmd5NOabWRgc/VAoX6qxY
        FDYn2xH8b9h55tszsLyy3Pg0+UPeizKOegKPowQP4FYcKV0loVbBqxOBV8/KvhceYSOZ2B
        1JeOM0IvzvfKavCLVklxsMQ7+ISr8uVJGNMh/PqMlVGBhc2tP6NsUgo99mPBCxqeWCjPhj
        ic9UKft2G8N0K1fc3JpLG+QSPqCre6Bnhzizz3Ut4uGRUKxSgoDckhIAMeq6Tg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669706483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MQKXJPSvxUV0hQyNaD6UpX+KWDEBJiig1LV0w73OtnU=;
        b=UCwxCmFH8h0Q0ue0x81kfqVTvPjvVdL/tlpNkFi4Hv+4Nr3upOddwp9BlGw52khhPHADlN
        AKvElUTRw0payFDQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH v4 net-next 0/8]: hsr: HSR send/recv fixes
Message-ID: <Y4Wy8ix3uZs07RIw@linutronix.de>
References: <20221125165610.3802446-1-bigeasy@linutronix.de>
 <20221128192401.7e855eaf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221128192401.7e855eaf@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-11-28 19:24:01 [-0800], Jakub Kicinski wrote:
> On Fri, 25 Nov 2022 17:56:02 +0100 Sebastian Andrzej Siewior wrote:
> > I started playing with HSR and run into a problem. Tested latest
> > upstream -rc and noticed more problems. Now it appears to work.
> > For testing I have a small three node setup with iperf and ping. While
> > iperf doesn't complain ping reports missing packets and duplicates.
> 
> Any reason Arvid is not CCed? please always when there's a Fixes tag,
> the authors should be CCed.

As per commit
   e8d5bb4dfaa72 ("MAINTAINERS: Orphan HSR network protocol")

that email bounces. So not added because that email
(arvid.brodin@alten.se) won't reach him. Is there another one I missed?

> Please run v5 thru checkpatch there are spelling errors it points out
> (and maybe something more).

I remember doing that. Will do again ;)

Sebastian
