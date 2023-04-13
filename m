Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55FE06E054D
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 05:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjDMDef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 23:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjDMDeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 23:34:15 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE1B9014;
        Wed, 12 Apr 2023 20:33:54 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-632400531a0so350982b3a.1;
        Wed, 12 Apr 2023 20:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681356833; x=1683948833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hloLBrgYh44fuy8cM0zwiuQXs/GYHvKwaYyHpl84U/E=;
        b=EW4P/azJoc41gI+oHOFlv42vucB0LDZHD7OPVFRkjLlmPRFoOKYZTeJ9Dj11gdUVaZ
         nU42fDLp7BAXfYtsvjYrpJsJfcSvDfVRgBEGIsyowQDG8CWERswl6OtCpvHPj43ZRvh8
         VBQ05PpFZOtK8AqeIV8mDhr3AnJJB4QUhTzDak2JNNagWHDdvPWGfXESxkmUKWx//79N
         47YVOXCZZLF0bO/DOT6apfW+aDWjNmaGvaBRaHwdnsPcKnX2bdGw3QM2lSWZBtVslwRm
         wRnz1VONpb/4TgRyyymzIUqosuNs6BpiYGlW701TPbGi9PAOwqLFYG7O0nQtVARasg7o
         AYyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681356833; x=1683948833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hloLBrgYh44fuy8cM0zwiuQXs/GYHvKwaYyHpl84U/E=;
        b=HMc5fjyymxAdCJ/PRN7Jm3R2a59TlDUvNQoSO1QSZgwh7JXx8sDpBz2dGOx+HQ3NTO
         JNwow4YSWTEJzJVm473z19ZWOXyEo/lm7j+VrDq7P8mi/6f+WzICNLAYLz01JRGRV+uh
         eBJD38SuFcLF3u07jnRZpLE5KIajy8GzqtKLJV+0gG+lZA5F71xHHTOFrgVF5JU9KqvA
         33pTn6XpFdk6XjgOxbLqfdBLSd8hgAUzjZOeWiT631Fa2KdRHR5qNqJZpqezaBYeB5ZX
         BXx49ejiqQeouNBECdVIwObYqcYPqkw+fuNhOeigbcidgflIhM31S0ZEmEpGRFQb2/GP
         CSIw==
X-Gm-Message-State: AAQBX9df2PaR8ArA1EqiZLuFLeJH7nh+eOKzA1Cs2dCQbLsntIM/9ZVW
        1bIL7W97ZBmt+aCacgb+OYU=
X-Google-Smtp-Source: AKy350bmB09mAmgLLKMqm3hWWMV7nrOm6F78S+GdFRnN0dOUrPGDcur+ngtzqNJXWsVEZGbgURa7Tg==
X-Received: by 2002:a05:6a00:1d83:b0:635:4f6:2f38 with SMTP id z3-20020a056a001d8300b0063504f62f38mr1176761pfw.2.1681356833346;
        Wed, 12 Apr 2023 20:33:53 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id x8-20020aa793a8000000b0062ddcad2cc5sm219279pff.30.2023.04.12.20.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 20:33:52 -0700 (PDT)
Date:   Wed, 12 Apr 2023 20:33:50 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, avraham.stern@intel.com,
        gregory.greenman@intel.com
Subject: Re: pull-request: wireless-next-2023-03-30
Message-ID: <ZDd4Hg6bEv22Pxi9@hoboy.vegasvil.org>
References: <20230330205612.921134-1-johannes@sipsolutions.net>
 <20230331000648.543f2a54@kernel.org>
 <ZCtXGpqnCUL58Xzu@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCtXGpqnCUL58Xzu@localhost>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 12:45:46AM +0200, Richard Cochran wrote:
> On Fri, Mar 31, 2023 at 12:06:48AM -0700, Jakub Kicinski wrote:
> > On Thu, 30 Mar 2023 22:56:11 +0200 Johannes Berg wrote:
> > >  * hardware timestamping support for some devices/firwmares
> > 
> > Was Richard CCed on those patches? 
> > Would have been good to see his acks there.
> > 
> > Adding him here in case he wants to take a look 'post factum'.
> 
> Timestamping on wifi is something I've spent a fair amount of time
> thinking about.  I'll take a look but not this week as I am on
> vacation until April 10.

This so-called "hardware timestamping support" appears to be a big
nothing burger.

I took a quick look at the PR, and AFAICT this is only internal code
for iwlwifi/mvm, and the code is dead code, meaning not reachable by
user space for any practical purpose.

Like in drivers/net/wireless/intel/iwlwifi/mvm/ops.c ...

	RX_HANDLER_GRP(LEGACY_GROUP,
		       WNM_80211V_TIMING_MEASUREMENT_NOTIFICATION,
		       iwl_mvm_time_sync_msmt_event, RX_HANDLER_SYNC,
		       struct iwl_time_msmt_notify),
	RX_HANDLER_GRP(LEGACY_GROUP,
		       WNM_80211V_TIMING_MEASUREMENT_CONFIRM_NOTIFICATION,
		       iwl_mvm_time_sync_msmt_confirm_event, RX_HANDLER_SYNC,
		       struct iwl_time_msmt_cfm_notify),

These aren't useful, or are they?

I am aware of FTM etc, but I see no attempt to do anything with it in
this code.

Thanks,
Richard
