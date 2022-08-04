Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732D958A18D
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 21:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239918AbiHDTuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 15:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240038AbiHDTuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 15:50:05 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69936FA36
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 12:49:16 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id pm17so731626pjb.3
        for <netdev@vger.kernel.org>; Thu, 04 Aug 2022 12:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc;
        bh=fHogq69ZVZGg9K+JZr1ZwGJieFfzAkb09iNVPrj0RsE=;
        b=SeJRLX4I1NuZGFD/qFZigrootAVxQ3gkO0nXE18VBVfJq2QPWUlgh8acDgemJhJZDQ
         56QnxfzLGqSOPzv9Kk8xcV5DgQDRwMejwXNdDuCwttVZHL06lea2PMJZc1VXZZ0+uQt5
         XlfxKWviZ/v6I+XU4/sL77T0Tfv42witi5OnckY02LIvuVjO/CnE9CK+VR5xPXmjSQzW
         mhn76I8+pHPOwNn5aTxgmJUAdmiWpDiygm77lGfZgumJ1bPU2DodF6VB8/wG6T6V6kWJ
         hUTai4N4AaXV45xFud6bftKiMdkpj39zxBthLs8Mj1uVLhU4ZKttO1vvRF6DeIyRP/zG
         BjNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc;
        bh=fHogq69ZVZGg9K+JZr1ZwGJieFfzAkb09iNVPrj0RsE=;
        b=qWgiulp95X2kxXSEPGLXKTFZKAUzPTCCtJboWTVGTzNd/d8sHvM37K8y1CmaElO5rw
         EnNMR4G/q44KgKtXdU431dQWsee+gT8OkdzlW7TVmpCiSWQvYo9HkPWnZ6RREOyv1nGQ
         mlnrZB50vTfYFmaZD+vI+8MZBBuFAdouymQOClVQqqbNHgcuO0jnpl0PRLJW3dSUscAg
         WEXoWbvUYO7DKgSmX7yvkvhxALZ0LQC2kauKVmdeTctX5jQyFbqv9SoxhBTRqPWBKNx1
         u/6ST66CWvQMjsI0Eg9vyoNA9/RmaCO4X0necpdteMmu4Ddj0vNRKByXv+J/su7asw1L
         6neA==
X-Gm-Message-State: ACgBeo3gPahIby3Kvx0N79T1kLENsdANL34LoAjOsPyDHR+SLpoYbfpH
        3wjUBJZE3m1m5zmlBAN5+CsctEB47T4=
X-Google-Smtp-Source: AA6agR4l0ZMD6JzWqggRzpl+BiHWOEYMpSWHArtoiDwoB+GJg39t1DYQ4fivjyQnf10O3zy/mIbTMA==
X-Received: by 2002:a17:902:a616:b0:16c:d74e:4654 with SMTP id u22-20020a170902a61600b0016cd74e4654mr3398220plq.4.1659642542096;
        Thu, 04 Aug 2022 12:49:02 -0700 (PDT)
Received: from [192.168.254.91] ([50.45.187.22])
        by smtp.gmail.com with ESMTPSA id o22-20020a635d56000000b0041b425b6962sm259708pgm.28.2022.08.04.12.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 12:49:01 -0700 (PDT)
Message-ID: <f03b4330c7e9d131d9ad198900a3370de4508304.camel@gmail.com>
Subject: Re: [RFC 1/1] net: move IFF_LIVE_ADDR_CHANGE to public flag
From:   James Prestwood <prestwoj@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, johannes@sipsolutions.net
Date:   Thu, 04 Aug 2022 12:49:01 -0700
In-Reply-To: <b6b11b492622b75e50712385947e1ba6103b8e44.camel@gmail.com>
References: <20220804174307.448527-1-prestwoj@gmail.com>
         <20220804174307.448527-2-prestwoj@gmail.com>
         <20220804114342.71d2cff0@kernel.org>
         <b6b11b492622b75e50712385947e1ba6103b8e44.camel@gmail.com>
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

Forgot to CC Johannes.

Thanks

On Thu, 2022-08-04 at 12:23 -0700, James Prestwood wrote:
> On Thu, 2022-08-04 at 11:43 -0700, Jakub Kicinski wrote:
> > On Thu,  4 Aug 2022 10:43:07 -0700 James Prestwood wrote:
> > > By exposing IFF_LIVE_ADDR_CHANGE to userspace it at least gives
> > > an
> > > indication that we can successfully randomize the address and
> > > connect. In the worst case address randomization can be avoided
> > > ahead of time. A secondary win is also time, since userspace can
> > > avoid a power down unless its required which saves some time.
> > 
> > It's not a generic thing tho, it's most of an implicit argument 
> > to eth_mac_addr(). Not all netdevs are Ethernet.
> > 
> > The semantics in wireless are also a little stretched because
> > normally
> > if the flag is not set the netdev will _refuse_ (-EBUSY) to change
> > the
> > address while running, not do some crazy fw reset.
> 
> Sorry if I wasn't clear, but its not nl80211 doing the fw reset
> automatically. The wireless subsystem actually completely disallows a
> MAC change if the device is running, this flag isn't even checked.
> This
> means userspace has to bring the device down itself, then change the
> MAC.
> 
> I plan on also modifying mac80211 to first check this flag and allow
> a
> live MAC change if possible. But ultimately userspace still needs to
> be
> aware of the support.
> 
> > 
> > Perhaps we should wait for Johannes to return form vacation but my
> > immediate reaction would be to add a knob (in wireless?) that
> > controls
> > whether the reset dance is allowed.
> 
> Ok sounds good. Lets see what Johannes has to say.
> 


