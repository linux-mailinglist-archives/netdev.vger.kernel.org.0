Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9116697C1B
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 16:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbfHUOIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 10:08:20 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45304 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfHUOIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 10:08:19 -0400
Received: by mail-pf1-f194.google.com with SMTP id w26so1496495pfq.12;
        Wed, 21 Aug 2019 07:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DfIwMjuye46lrWu38aFKyCCnR8npSE/y3cObQoGGmVI=;
        b=sWF8XKfsPmFxZ7v+A7/UE/8lyDs/keMDWMO0Ptcp4dNz/tII1laWgfvyekP+ZVtSP/
         iii0j+YUecSY9mZvMwjMS87OJcbP5r8SKrywOSnZD+IFcDFCNUJxwp304rR97qSHN3jG
         kqBSroNjZm1Bo5sNUTGzisMu0mWveZj/ra7ZNsFbP1ZdFQU6G8IjvQutBY0+07A1cYgo
         YkSGL1eOgYJPYUf2rAUcMS+CF05hnV7zlTeOlZ8omjqOanPE/AAdyRWIFFqBr68uzYp0
         MeycER8/OcTYdr40pN71I5hrYbwTL+aQZl5AVJDdwGufgCBJvvCUSjx3hPTcVZ0SUdr8
         ByDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DfIwMjuye46lrWu38aFKyCCnR8npSE/y3cObQoGGmVI=;
        b=jJ+SsUpVv3i5K5qFAUsm+QEasoNWrTGpvuHwV1VGQ1UfZNqxP8+3SptYbRiaKHiYxW
         hMdHMCO7yZagt8MvgU+So0kHLYKZaEiiCv7f8daYK8HVya3bvFuwZesOHRAjoV5jH6UO
         xqN6zT1/uCOjfOz9DGJMTFmCO+R86Twx3lRKNWPsnuesiWzRnEVz+vOx/6lXEveuyRtq
         IipzRC7bLmZ1rEQlajMQRXcSM9t1DlnBHXiUQJo75k8e8iy4Z7uOYT/Z7uiCa0q+sO9z
         CPJ6zIksJgfd5yzmW18oZIKFTF4dDuvOIC0Sy+4K+4WgbqEvI/jnBOcA8fV9YVo54XGE
         Y5dA==
X-Gm-Message-State: APjAAAUVNT6VORd2Og4g/Xzbi5A+NrwC1uqonvbn9G9Uqc2lNiu8ATuz
        kPgETYMPJi6lEHh9NeO52/k=
X-Google-Smtp-Source: APXvYqyrQiwKGjDEac4IuaAOQuYhXBIfoqSas+0eApLSYs7UiWACl7R6cF7QbWH9y7YCC0qnPjxhtQ==
X-Received: by 2002:a17:90a:8d85:: with SMTP id d5mr125889pjo.137.1566396499032;
        Wed, 21 Aug 2019 07:08:19 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id a26sm24722808pff.174.2019.08.21.07.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 07:08:17 -0700 (PDT)
Date:   Wed, 21 Aug 2019 07:08:15 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Hubert Feurstein <h.feurstein@gmail.com>, mlichvar@redhat.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH spi for-5.4 0/5] Deterministic SPI latency with NXP DSPI
 driver
Message-ID: <20190821140815.GA1447@localhost>
References: <20190818182600.3047-1-olteanv@gmail.com>
 <CA+h21hr4UcoJK7upNJjG0ibtX7CkF=akxVdrb--1AJn6-z=sUQ@mail.gmail.com>
 <20190821043845.GB1332@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821043845.GB1332@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 09:38:45PM -0700, Richard Cochran wrote:
> Overall, the PTP switch use case is well supported by Linux.  The
> synchronization of the management CPU to the PTP, while nice to have,
> is not required to implement a Transparent Clock.  Your specific
> application might require it, but honestly, if the management CPU
> needs good synchronization, then you really aught to feed a PPS from
> the switch into a gpio (for example) on the CPU.

Another way to achieve this is to have a second MAC interface on the
management CPU connected to a spare port on the switch.  Then time
stamping, PHC, ptp4l, and phc2sys work as expected.

Thanks,
Richard
