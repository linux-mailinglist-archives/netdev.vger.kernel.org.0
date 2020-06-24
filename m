Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A9E207746
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 17:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404137AbgFXPVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 11:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390702AbgFXPVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 11:21:47 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C506C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 08:21:46 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id cm23so1286398pjb.5
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 08:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ol9Slh8In8dUnBduxx4JOdukPwamcC934GpmZu/Ua5E=;
        b=cy15rtYHzBaQzoepm+teFO7P5Q4dw7ZsiK6v0IopmUOdGk/2+s45JPjAkB9Yd8RrmR
         cjKqy3S/da91eO2aWRWdC2Bk0kRHJy+lzzwHRV/vHpXsH/mM5oF8lJaCo1sq3OT4jMv9
         m/naOrW1AiRiNyF23juPvP8TPaib54/CTJBJ1Bg4sqGZI/tEiPRh+LNTu0VQ38K48w0M
         lNUdeMR9P+9XzFWlwpj2jgBlxSG/bOMiPPA7F/bg8sDFAgxjQCQXSbzp4EYSSlwFyE7e
         WuWYpVKbIB4XMbV+Dwn+4HDHbMeh7UtJUCpRoVHlwJCK3127OPcYqKvjxHdh1iBkUQH2
         CKHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ol9Slh8In8dUnBduxx4JOdukPwamcC934GpmZu/Ua5E=;
        b=g73WFESTWovj8mo7azGK3sHeSH9yIlTK01Q0njKiIqN73zgHxI9yQxozylxTRTdwgo
         484sZQxVusXcd8ko0msMH3pbksi/3iLIxQkW7x2864rf1Ce/gAtIasrlyt3L+iVuoZYY
         wtzqzWJyNIsS9ptJCUDb62OB6xVL22uSU15jRcmy54zVUEqQdG+CykhVVdQBU4b1EQnx
         7MRg9BOb1CuIbTBLvaBboV2+zbHyhWlaxk7c5gcX0srB4VL1e/jbTClH/0+ng9498FOR
         WwMnn0SPm9lfh5mOJ0sKLUu4pDZbHbY2XPRGWDswxdiG3ftQSbOUF0FiOH1hPLzoPo0B
         pGtg==
X-Gm-Message-State: AOAM532QBsKKvFPcPUTh+XSbcz9LJqZOTSAf27zdBtgREt8UTcuxlraC
        CHgm0HRXNpkwO4iMqaf88x+BXYh1b3I=
X-Google-Smtp-Source: ABdhPJyj+2c04Qa1xbUKsokB6RA5B+3co4HBqVf7OOBQS14gDmoJqpLfSre8LX6RKr7hh8zz7B8L5Q==
X-Received: by 2002:a17:90b:347:: with SMTP id fh7mr29168827pjb.64.1593012105653;
        Wed, 24 Jun 2020 08:21:45 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id g18sm2535324pfk.40.2020.06.24.08.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 08:21:45 -0700 (PDT)
Date:   Wed, 24 Jun 2020 08:21:37 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 0/5] Eliminate the term slave in iproute2
Message-ID: <20200624082137.68dc44b0@hermes.lan>
In-Reply-To: <20200624095142.zete44mbrtieepju@lion.mk-sys.cz>
References: <20200623235307.9216-1-stephen@networkplumber.org>
        <20200624095142.zete44mbrtieepju@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Jun 2020 11:51:42 +0200
Michal Kubecek <mkubecek@suse.cz> wrote:

> On Tue, Jun 23, 2020 at 04:53:02PM -0700, Stephen Hemminger wrote:
> > These patches remove the term slave from the iproute2 visible
> > command line, documentation, and variable naming.
> > 
> > This needs doing despite the fact it will cause cosmetic
> > changes to visible outputs.  
> 
> AFAICS, your patches don't only change output of the command, they also
> change command line parsing so that they break backward compatibility
> and break existing scripts and tools. This is a very bad idea.
> 
> If you really want to go through this exercise - and I don't agree with
> the "needs doing" claim - you definitely should preserve existing
> keywords as aliases.
> 
> Michal

Sure the old keywords could be silent aliases for new ones.
