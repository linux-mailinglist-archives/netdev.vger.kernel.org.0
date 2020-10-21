Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4D3295232
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 20:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504081AbgJUS2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 14:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438929AbgJUS2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 14:28:47 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36214C0613CE
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 11:28:47 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o7so1983279pgv.6
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 11:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pdV8toHhUoGEzI+3zGwdo0L/IUP2+YszA0KBpT7i3tk=;
        b=ByftFS0aApkdGly2d+f8cbyo2r6vzMcIx6tT7jsp94RmsunPGz2oMVQ4j2PB7aXn2i
         WMElzMVm6SeRzaGWUTqBpWVKj3RcJveD5uou+f6jouKAErqNKs6n4BAlrXhJN9DGkVFJ
         6JbOyOHPWAFY+yJJfp9D5qHvT1kEFTBhE+nBEKMABGswTkgiHAZj2lb3Ph+p7mCAFgfA
         0DuVLkR2FgTbFWbz2/xhR7ObgoF/O91tDJHDRDD3IP9s+lq9SojOwu1QDzDNLfSDUEZv
         zdIwaZcyA4hc/A528e4Pv0RZVoKdnEPWQ2q3A8UYkq4hxJfigFitsXqT6H4laduFqr3n
         0+uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pdV8toHhUoGEzI+3zGwdo0L/IUP2+YszA0KBpT7i3tk=;
        b=brplhUtRwoNylZyts6X0iqwKeijtkYTp6rU3u+8K7+bEwqNedIMihm6/x8N1UAKlxc
         ZMNBWN3dnwVIe+hARLOKLDBSCtrKkRswZKvUvJCO4DK/9sox2Co7h/EleQjXcxJRoFa7
         MBfmKrF8hqhB+6aSrFkwWsS3qJrBaPmJ1voOtWKAR/lGHkjFtxXoxjYjcgBV+gMGEUfz
         asriP/lZsGMFwaYQjWRrdVcyOXFI4DjsWkbRZbOfghkKKGq8afKdP2lrRgJAISLz1SUg
         EFiInPGzC/EXJan2LK+gZgPlrAeGBDmfbWVgbPX4/3INnY2pxfg32MVEScUkhEeIDxaf
         52QQ==
X-Gm-Message-State: AOAM533u+KVJgyCgkmVQBtGowoDn9FyWM6Gg35DjevmwMJezeyQYAl8v
        cJQ8UR6zlA67wHKp3vzF89VBMA==
X-Google-Smtp-Source: ABdhPJwquAZ2TOLErdL2OQTzMlBRE+8tkVWuERXLM4gN92uS2qR3Gq0k90Flsa9B1eVBqEW+WkKljA==
X-Received: by 2002:a63:f701:: with SMTP id x1mr4388980pgh.378.1603304926788;
        Wed, 21 Oct 2020 11:28:46 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id b3sm2907890pfd.66.2020.10.21.11.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 11:28:46 -0700 (PDT)
Date:   Wed, 21 Oct 2020 11:28:38 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Petr Machata <me@pmachata.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        dsahern@gmail.com, john.fastabend@gmail.com, jiri@nvidia.com,
        idosch@nvidia.com
Subject: Re: [PATCH iproute2-next 15/15] dcb: Add a subtool for the DCB ETS
 object
Message-ID: <20201021112838.3026a648@hermes.local>
In-Reply-To: <877drkk4qu.fsf@nvidia.com>
References: <20201020114141.53391942@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <877drkk4qu.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 22:43:37 +0200
Petr Machata <me@pmachata.org> wrote:

> Jakub Kicinski <kuba@kernel.org> writes:
> 
> > On Tue, 20 Oct 2020 02:58:23 +0200 Petr Machata wrote:  
> >> +static void dcb_ets_print_cbs(FILE *fp, const struct ieee_ets *ets)
> >> +{
> >> +	print_string(PRINT_ANY, "cbs", "cbs %s ", ets->cbs ? "on" : "off");
> >> +}  
> >
> > I'd personally lean in the direction ethtool is taking and try to limit
> > string values in json output as much as possible. This would be a good
> > fit for bool.  
> 
> Yep, makes sense. The value is not user-toggleable, so the on / off
> there is just arbitrary.
> 
> I'll consider it for "willing" as well. That one is user-toggleable, and
> the "on" / "off" makes sense for consistency with the command line. But
> that doesn't mean it can't be a boolean in JSON.

There are three ways of representing a boolean. You chose the worst.
Option 1: is to use a json null value to indicate presence.
      this works well for a flag.
Option 2: is to use json bool.
	this looks awkward in non-json output
Option 3: is to use a string
     	but this makes the string output something harder to consume
	in json.

