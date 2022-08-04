Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC08958A12B
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 21:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbiHDTXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 15:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbiHDTXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 15:23:48 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8D537FA9
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 12:23:47 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id h21-20020a17090aa89500b001f31a61b91dso6187924pjq.4
        for <netdev@vger.kernel.org>; Thu, 04 Aug 2022 12:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc;
        bh=/2STq9RFfa9PMmXgQmnuLJWHeY4idjTBf00Ajo15GUE=;
        b=U7rkCt70v08d11dqBZoNZIUJAI0TbKz2Xi/vT6/0bqLUwtpRjTeUzaZ10xjRXxdew4
         FEVFazbQI8aXhkviknx7PieXAWfjUERQyUd/ISP0uzHtVOwynwb2l+FJEzLcQ87ssgNE
         h7H2k0sc1odKmS0tWmsAIP03C/GxvKXLWZZO4HlxIqeGtADoykXiySjOnURBZZDT2qBD
         rsZqvTOyMTM3fYrhlQGaidtCHpzifJj7eW5PkLYjrNfbY400H7HLrrwkJzTUb/AmBd7w
         80NTTRqj6vxt0/ue63Ka8/pMI/fqP+2t/wU6AN89ghVoYLntqw2r9NotHJByM42M/pW9
         89uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc;
        bh=/2STq9RFfa9PMmXgQmnuLJWHeY4idjTBf00Ajo15GUE=;
        b=jM/MX8ocg4s13vPJ+V6teLMHNzpJygfBpLsz4mJp0IEJ+7/XbFeEg0cN3nOLUlQO/9
         G6TIk1wV/U77Ba6+O4kyRprjLY6q+0cCoDH8E8VcS11XzRL6A16xdDoM6g+Zd/cqnlqM
         1EInAOKQOQlf8LyTn7/I6gdkAOD4dntHqVmGAOKpEeVe8U6szK8OIENeQsWCunsIX4su
         N1z9C6qvtEywyBX6SCkiPNPBlx7hiVK3+zjt5rYz86Y10fDd0Qeb1zj6mBtG+iQSepxe
         GivBVLNqdjVHGfvxTBbOlZK6D1DTK2uia4HNLXolMC1tV8aHQnTLnVmDkLilC8wSzZD3
         U1LA==
X-Gm-Message-State: ACgBeo0N0KUI0/Wu86f6WMPsNVnjG5q6Da7k4OmA1EZOqAs7GwVEL2N+
        NqrqXrK/2+bvnxzI3W3ceqZejxekLe4=
X-Google-Smtp-Source: AA6agR5WpsT/j18z1hTWEREI/gV+RQiFV1GpleEKOG2FH7U1zD2pDY3X+OAXCQ5NV1vu/kDFwXzIFg==
X-Received: by 2002:a17:90b:343:b0:1ef:b65d:f4d8 with SMTP id fh3-20020a17090b034300b001efb65df4d8mr11815192pjb.187.1659641026555;
        Thu, 04 Aug 2022 12:23:46 -0700 (PDT)
Received: from [192.168.254.91] ([50.45.187.22])
        by smtp.gmail.com with ESMTPSA id e187-20020a621ec4000000b0052d200c8040sm1274014pfe.211.2022.08.04.12.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 12:23:46 -0700 (PDT)
Message-ID: <b6b11b492622b75e50712385947e1ba6103b8e44.camel@gmail.com>
Subject: Re: [RFC 1/1] net: move IFF_LIVE_ADDR_CHANGE to public flag
From:   James Prestwood <prestwoj@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Date:   Thu, 04 Aug 2022 12:23:45 -0700
In-Reply-To: <20220804114342.71d2cff0@kernel.org>
References: <20220804174307.448527-1-prestwoj@gmail.com>
         <20220804174307.448527-2-prestwoj@gmail.com>
         <20220804114342.71d2cff0@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-08-04 at 11:43 -0700, Jakub Kicinski wrote:
> On Thu,  4 Aug 2022 10:43:07 -0700 James Prestwood wrote:
> > By exposing IFF_LIVE_ADDR_CHANGE to userspace it at least gives an
> > indication that we can successfully randomize the address and
> > connect. In the worst case address randomization can be avoided
> > ahead of time. A secondary win is also time, since userspace can
> > avoid a power down unless its required which saves some time.
> 
> It's not a generic thing tho, it's most of an implicit argument 
> to eth_mac_addr(). Not all netdevs are Ethernet.
> 
> The semantics in wireless are also a little stretched because
> normally
> if the flag is not set the netdev will _refuse_ (-EBUSY) to change
> the
> address while running, not do some crazy fw reset.

Sorry if I wasn't clear, but its not nl80211 doing the fw reset
automatically. The wireless subsystem actually completely disallows a
MAC change if the device is running, this flag isn't even checked. This
means userspace has to bring the device down itself, then change the
MAC.

I plan on also modifying mac80211 to first check this flag and allow a
live MAC change if possible. But ultimately userspace still needs to be
aware of the support.

> 
> Perhaps we should wait for Johannes to return form vacation but my
> immediate reaction would be to add a knob (in wireless?) that
> controls
> whether the reset dance is allowed.

Ok sounds good. Lets see what Johannes has to say.

