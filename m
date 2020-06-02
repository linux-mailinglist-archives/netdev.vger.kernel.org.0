Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2991EB5D3
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 08:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgFBGbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 02:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgFBGbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 02:31:43 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B9AC061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 23:31:42 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id p5so2078992wrw.9
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 23:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kWcduIEz8yOvfueEBa486TtJ/LQHAp298LBem6l1ZNI=;
        b=uQm+cQqPr/7+PZldbyuUCRbOHuubnFdZeATLvTDxxdA/aRJ0F1iw+bNr2z+3iD73ZJ
         4pf+Bp+g4YpupqBamoFtED8jyazzDKHdPrmwYHzvtrQ3m7Tm/j5apzajzGw9fvYKjtdx
         ilqCy2gzvTAIbpSc18ehZtHscjGtFFjM0rnduMAPYnB+uk+1IIsjRM8w9eVgn5sAnrmZ
         BnHIzBXtvUCxm/efqDgoD47Z9A4OYPWQKWEE4xcKTv9uUeRr5PuGVCJ9dz7J/viol/X5
         iqhgEg/kJL0qxilct4cd5ZVsWp/7lKrzY35ddJDRoXOKh47bJec3sxZ9Jw0srYc1vGIu
         D9vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kWcduIEz8yOvfueEBa486TtJ/LQHAp298LBem6l1ZNI=;
        b=aygTnB7dyJ/ScibhG3x1dYO+WvdXG2ASrqpfYPUV5MwKStomNNzXQtXpGh+D8m6JxQ
         cHdog0+fPwBLtMdx1h47XA2ju2ZpBx2xCfD4vqhaWmxhYJTxYcQCtltr+mo1Sn2sbzFO
         Q7ukwKMg80qcoDu0sY+n7lUGJzpZZ1lGCT7EGSJONupqXdDB2ugvVxh+Q1RwcD0tKBat
         okmsN5ps7PPdkSZuY0IqXIVm7AqiodLm14SWAsfICBwNMwUBpngzxS0/txK3OoNHTN2h
         LRKQiH/el8yQHpzpYb03pLcWWg1o3Ptiv0IL5HIai5f0XqjhjMf5HiguSrlcUtBj7Z9A
         zWVA==
X-Gm-Message-State: AOAM532ZVs/VMnqInV/e30DyC7qxLXkPrJJLPXn68MVjZEnpkhAUPP5I
        XtZuF9JxOenv5o+eAt7MPZuu4w==
X-Google-Smtp-Source: ABdhPJwIwQ4HpYc196aMIE2wxdCqJyf1oZoTLWC7eKGEMepCohaXz8bVA4DIHMRiWTtsjAwJEMtCSw==
X-Received: by 2002:a5d:6751:: with SMTP id l17mr26844753wrw.179.1591079500613;
        Mon, 01 Jun 2020 23:31:40 -0700 (PDT)
Received: from localhost (ip-89-177-4-162.net.upcbroadband.cz. [89.177.4.162])
        by smtp.gmail.com with ESMTPSA id a126sm2001537wme.28.2020.06.01.23.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 23:31:39 -0700 (PDT)
Date:   Tue, 2 Jun 2020 08:31:39 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH v3 net-next 0/6] bnxt_en: Add 'enable_live_dev_reset' and
 'allow_live_dev_reset' generic devlink params.
Message-ID: <20200602063139.GT2282@nanopsycho>
References: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200601061819.GA2282@nanopsycho>
 <20200601064323.GF2282@nanopsycho>
 <CAACQVJoW9TcTkKgzAhoz=ejr693JyBzUzOK75GhFrxPTYOkAaw@mail.gmail.com>
 <20200601100411.GL2282@nanopsycho>
 <CAACQVJomhn1p2L=ZQakwSRXAci2oK0EG0HQsTVhRz6NLFZEHqw@mail.gmail.com>
 <20200601162416.386937b2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601162416.386937b2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jun 02, 2020 at 01:24:16AM CEST, kuba@kernel.org wrote:
>On Mon, 1 Jun 2020 21:01:42 +0530 Vasundhara Volam wrote:
>> > I think that the legacy ethtool should stick with the "ordinary fw reset",
>> > becase that is what user expects. You should add an attribute to
>> > "devlink dev reload" to trigger the "live fw reset"  
>> 
>> Okay.
>> 
>> I am planning to add a type field with "driver-only | fw-reset |
>> live-fw-reset | live-fw-patch" to "devlink dev reload" command.
>> 
>> driver-only - Resets host driver instance of the 'devlink dev'
>> (current behaviour). This will be default, if the user does not
>> provide the type option.
>> fw-reset - Initiate the reset command for the currently running
>> firmware and wait for the driver reload for completing the reset.
>> (This is similar to the legacy "ethtool --reset all" command).
>> live-fw-reset - Resets the currently running firmware and driver entities.
>> live-fw-patch - Loads the currently pending flashed firmware and
>> reloads all driver entities. If no pending flashed firmware, resets
>> currently loaded firmware.
>
>FWIW I'd prefer to extend the ethtool semantics. Ethtool reset has two
>reset "depths" already - single port, entire adapter, we could just add
>"entire sled" here. IOW we'd have reset which can affect only given
>port, then reset which can affect multiple ports, and reset which may
>affect multiple systems.

Hmm, I think that one way or another, we need to implement this in
devlink and have compat fallback from ethtool there (as we have for
other things too).


>
>The mechanism of the reset and whether old or new version of FW is
>activated is a detail, which I believe will be entirely uninteresting 
>to the user. Whether other systems or ports are affected is _very_
>important, OTOH.

Wait. So you say that user is not interested if the reset is fw "live"
or not? There might be all sorts of issues when the reset happens under
working driver instance. I think that user should be able to indicate if
he is willing to take the risk.

