Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A19CDDDCF6
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 08:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfJTGCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 02:02:51 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34846 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfJTGCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 02:02:51 -0400
Received: by mail-wr1-f67.google.com with SMTP id l10so9848327wrb.2
        for <netdev@vger.kernel.org>; Sat, 19 Oct 2019 23:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zzAKdMnYeIz1Y8lWW/DIcrnQyTv2b9NFrPlBhMS66Ck=;
        b=Yr5OVYtt5ZjzIic+5675L/12JWjjVXrkg1fSBK9mveJV+1pdoc8Td4K0rjH8sSHOUN
         BoryQhd0Ro03fIJf8avsk76X8WeVv0ivDSlO0Ovz1SlefQQx1iTDlMgN+GlzVtLCX4FT
         QvQlLjKqESh1ArLf6HmBxHaDBlMOYZGc8Uz1EzkfKbsEF2IzddxYdItrW38/wNdgvyam
         vUiB2mf4K5VGtAYyiNwTsFlr2yPsSyrwzkiwfJBekXZVOUYVjvtofcY8JaysXQjaAyDt
         DTfXlGphK2qaxRIVdpi0USgOjAcKX0HsAyXGXdg7OTRV4zkcDOVzGrZUwobuua0ihvRL
         Zs+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zzAKdMnYeIz1Y8lWW/DIcrnQyTv2b9NFrPlBhMS66Ck=;
        b=LgNHO40vU2W5dJsPQk+yuPkCLAx7M+ey/8EqCpGA46LNsGNJu8+pQoPa9oGKPInX5m
         bR0RA3/zTd6mR6Gvxa41Ey2QKX7ozZbtiaM+6GRSmFpGnQNjiSHbQlx3Y9m566b4EWkM
         aZnMtA/ioAAeuR6mbT05zAmF+A4lBzp+Il60ivvSoVijWRNIbwbHs+AUvr1JYSGMf+Ve
         eUkD1KdWK3WydxcWT80AJe503QBkJ0fRGQHCgzYJ+q4GmSXV/uog2SjHXYdCFGuXkJJM
         tzK42is/ERrpJNarqhazksAF1JKbfyahiQIir1JiW8/LGK4bsUOQWlxQyd7Oq62C7rMW
         FZvA==
X-Gm-Message-State: APjAAAX/N81nqscWFifVV46q/6V1iCZrnPopQaSLZR5f9HEUGEZcRRee
        AyLa+XxEOX8NZPMOcYwV5FQSxA==
X-Google-Smtp-Source: APXvYqyVEmyJlwmPfh3n3XT6jAOkQL02UtAZp4Fst3YMDuzm2zqqD6TRmqYrneaYoeEnGnAlsaA4lA==
X-Received: by 2002:adf:a157:: with SMTP id r23mr13778304wrr.51.1571551368054;
        Sat, 19 Oct 2019 23:02:48 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id 37sm10426008wrc.96.2019.10.19.23.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 23:02:47 -0700 (PDT)
Date:   Sun, 20 Oct 2019 08:02:46 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v4 2/2] net: dsa: mv88e6xxx: Add devlink param
 for ATU hash algorithm.
Message-ID: <20191020060246.GP2185@nanopsycho>
References: <20191019185201.24980-1-andrew@lunn.ch>
 <20191019185201.24980-3-andrew@lunn.ch>
 <20191019191656.GL2185@nanopsycho>
 <20191019192750.GB25148@lunn.ch>
 <20191019210202.GN2185@nanopsycho>
 <20191019211234.GH25148@lunn.ch>
 <20191020055459.GO2185@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191020055459.GO2185@nanopsycho>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Oct 20, 2019 at 07:54:59AM CEST, jiri@resnulli.us wrote:
>Sat, Oct 19, 2019 at 11:12:34PM CEST, andrew@lunn.ch wrote:
>>> Could you please follow the rest of the existing params?
>>
>>Why are params special? Devlink resources can and do have upper case
>>characters. So we get into inconsistencies within devlink,
>>particularly if there is a link between a parameter and a resources.
>
>Well, only for netdevsim. Spectrum*.c resources follow the same format.
>I believe that the same format should apply on resources as well.
>

Plus reporters, dpipes follow the same format too. I'm going to send
patches to enforce the format there too.


>
>>
>>And i will soon be adding a resource, and it will be upper case, since
>>that is allowed. And it will be related to the ATU.
>>
>>     Andrew
>>
>>
