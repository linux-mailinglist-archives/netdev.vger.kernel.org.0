Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48B6578F44
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 02:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235683AbiGSAaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 20:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiGSAaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 20:30:12 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8759B6551;
        Mon, 18 Jul 2022 17:30:09 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id l23so24326303ejr.5;
        Mon, 18 Jul 2022 17:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tHECUp5Nu2/GZmp47KHS0DA3aZn/HqPLp4AXTv+D1so=;
        b=cmjJp4Wc70UFyJOU6m9PHDv6cgBcSxACjV8XCYXocWtr/FcDcZs/QFmdPSXbhLyk3R
         FCPJlVcDF3a/bfbY1OWEBMjl7TtYtUqMl4/A/cUcxiW5hsr+PAuT1lF+4Ixp22UZhHaL
         sJIUDawrTaLiqBcojVG2hn0PPXAFrYn7zche+uxAV4J2eoaR53m7JLz9lb0PPCkXovqr
         TCkGxZqKxLlK4CUnskdjqrd6D8nX5LutfIhmOojrYGQhrbAL0nFeOJB3HSXXDc75ja4Q
         Ur9wiz3Bf1hLJs4caVo1AfyVNX5xpE4+6LBYPFFX8y4zfXhOa+ndM9cAVlVQj/YWQdYx
         EP1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tHECUp5Nu2/GZmp47KHS0DA3aZn/HqPLp4AXTv+D1so=;
        b=dBZzEOhtjIyFkgbp1UeKf8XczD+xW+qQXcBLUyb0RhTbkjpWyIwJwqxSn0Apaw1oLs
         aDrSqvrJFUf1nzQoApe8exwuu7WnWDXzjAuE6kHon1F/9LqsULM9SHbct09WHVkZNw1s
         S4CI6nvqadzFDsQy75jZw63W/oSP3zx6yeZ4o8Osjtr6Qyaj1m7S3Y45MpqZU6g/KbrY
         +yh00FxpVoCey9AitLjsxvlfJfpk1Z4GR0zFhwpqBMmTbXm6oZR9Ut6MCABvp5gaFxbs
         gKyCaJ99aA79gieEJAZfX+JXjRqArymTr72AAOaPUXIKymwVqAjZFwOtszY1UdQ8aNwz
         QGjA==
X-Gm-Message-State: AJIora9oQiiTjoCW//GkIDfsWmzq3SL8KZFkXJ85WUdCHbMiOhJIDdij
        Z0jHvWViDmS2fW/C3L4vHYbDWIIezGeNSt88+Ek=
X-Google-Smtp-Source: AGRyM1svWNwoYq60pp37EFhGkxbFoEzaD37OWwpIsvtcVPSeTlz8BczIXRa0zpFaHGe5N9WvcJ4GnRQwW7CTE2lGvM0=
X-Received: by 2002:a17:907:96ac:b0:72f:1dea:5b66 with SMTP id
 hd44-20020a17090796ac00b0072f1dea5b66mr10887738ejc.266.1658190608048; Mon, 18
 Jul 2022 17:30:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220718072144.2699487-1-airlied@gmail.com> <YtWeUOJewho7p/vM@intel.com>
In-Reply-To: <YtWeUOJewho7p/vM@intel.com>
From:   Dave Airlie <airlied@gmail.com>
Date:   Tue, 19 Jul 2022 10:29:56 +1000
Message-ID: <CAPM=9tyhOfOz1tn7uNsg_0EzvrBHcSoY+8bignNb2zfgZr6iRw@mail.gmail.com>
Subject: Re: [PATCH] docs: driver-api: firmware: add driver firmware guidelines.
To:     Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        alsa-devel@alsa-project.org,
        Network Development <netdev@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org,
        "dri-devel@lists.sf.net" <dri-devel@lists.sf.net>,
        Dave Airlie <airlied@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +* Firmware should be versioned with at least a major/minor version. It
> > +  is suggested that the firmware files in linux-firmware be named with
> > +  some device specific name, and just the major version. The
> > +  major/minor/patch versions should be stored in a header in the
> > +  firmware file for the driver to detect any non-ABI fixes/issues. The
> > +  firmware files in linux-firmware should be overwritten with the newest
> > +  compatible major version. Newer major version firmware should remain
> > +  compatible with all kernels that load that major number.
>
> would symbolic links be acceptable in the linux-firmware.git where
> the <fmw>_<major>.bin is a sym link to <fwm>_<major>.<minor>.bin
>
> or having the <fwm>_<major>.bin really to be the overwritten every minor
> update?

I don't think providing multiple minor versions of fw in
linux-firmware is that interesting.
Like if the major is the same, surely you always want the newer ones.
As long as the
ABI doesn't break. Otherwise we are just wasting disk space with fws
nobody will be using.

Dave.
