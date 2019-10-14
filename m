Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E301D5FCC
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 12:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731368AbfJNKJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 06:09:32 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34157 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730880AbfJNKJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 06:09:31 -0400
Received: by mail-wm1-f65.google.com with SMTP id y135so14136035wmc.1;
        Mon, 14 Oct 2019 03:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=o2MGbH0sl7jl/AOs9onFYSQLsVIpoiec9/okAKmAn3E=;
        b=DNlqi/Qbk92sYsfunZrpAJH79XZwsdm0TzASMQNGdRoO7DIEf+JObAoz6guoOquWx1
         2yhAU33ZVi0MXMmaeLEGM7KmyHm0qqpa08f+jKeTuhKpTBEwJhDhSI8t5UT9M7RMv60D
         Zh3DNr1me+EspD/8ZvY2CwKjlzszCJxeXi0aRmlD41+bEryy9N9LCDC4etF69rJr4c6e
         FuKse1xUsVu8mNWUIH6do8L9uxtvhR8kJy10hNZoVbFPkawHxSYOP4f8Z6Si4el9rL2x
         2N4ZdxmYBV4dKsBbLLxi19b4x+gf45GKndPNmdAwoV7ZNBWhyqDY99bA/FCH/mmgj496
         Pvbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=o2MGbH0sl7jl/AOs9onFYSQLsVIpoiec9/okAKmAn3E=;
        b=mGfuWmONuKeDlIUVo1xpWf+rcMzjszoXGdTVGOJyj6k+DxskW6+emHxqtVVmeAuol+
         hAbNmbu8IjH8ehWxBVejHRQMn2GzP3WWvilG0F6DDuX+ItUuGJZprE2mZ9jBwbQkudFf
         Z/lV4fwh4PEqxOAs2vouaiQyWkEHPcAvYGp/pBKhNrS9Xhh02cG9L318z5A1QJgH/dad
         A5torJCiCy7IBRM6UlCxMD50QcnmdxJZTNVqtcUjNYOpfSKEY29Ta/0Z2rcsl+AMj4ii
         w7fGwZUTfAm9i5EjmS7E4MECIcU10w6PBclDSvBuRFtBBoLIwPB2XkiUg85SAZAAxsef
         DT+g==
X-Gm-Message-State: APjAAAWLiQIL6EEQzOeIIXdD8N4C0hklgYOwXjo/peImBQNlibahhCSi
        SA3Bnykw2gvoSxs0Bn/mJd0=
X-Google-Smtp-Source: APXvYqzssuGzVNBk2ayLJQK0M+PP70+MlYJlryvhbvu4J9Bzn9tkYOLIwMBLalOfn6xeyS8rK+XAYA==
X-Received: by 2002:a1c:a708:: with SMTP id q8mr13162577wme.86.1571047768995;
        Mon, 14 Oct 2019 03:09:28 -0700 (PDT)
Received: from andrea.guest.corp.microsoft.com ([2a01:110:8012:1012:484d:bbc3:12dc:348b])
        by smtp.gmail.com with ESMTPSA id l7sm17686122wrv.77.2019.10.14.03.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 03:09:28 -0700 (PDT)
Date:   Mon, 14 Oct 2019 12:09:25 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        vkuznets <vkuznets@redhat.com>, Dexuan Cui <decui@microsoft.com>
Subject: Re: [PATCH v2 2/3] Drivers: hv: vmbus: Enable VMBus protocol
 versions 4.1, 5.1 and 5.2
Message-ID: <20191014100925.GB11206@andrea.guest.corp.microsoft.com>
References: <20191010154600.23875-1-parri.andrea@gmail.com>
 <20191010154600.23875-3-parri.andrea@gmail.com>
 <DM5PR21MB0137ACE07DCD2A6BBEC83665D7960@DM5PR21MB0137.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR21MB0137ACE07DCD2A6BBEC83665D7960@DM5PR21MB0137.namprd21.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -182,15 +182,21 @@ static inline u32 hv_get_avail_to_write_percent(
> >   * 2 . 4  (Windows 8)
> >   * 3 . 0  (Windows 8 R2)
> >   * 4 . 0  (Windows 10)
> > + * 4 . 1  (Windows 10 RS3)
> >   * 5 . 0  (Newer Windows 10)
> > + * 5 . 1  (Windows 10 RS4)
> > + * 5 . 2  (Windows Server 2019, RS5)
> >   */
> > 
> >  #define VERSION_WS2008  ((0 << 16) | (13))
> >  #define VERSION_WIN7    ((1 << 16) | (1))
> >  #define VERSION_WIN8    ((2 << 16) | (4))
> >  #define VERSION_WIN8_1    ((3 << 16) | (0))
> > -#define VERSION_WIN10	((4 << 16) | (0))
> > +#define VERSION_WIN10_V4 ((4 << 16) | (0))
> 
> I would recommend not changing the symbol name for version 4.0.
> The change makes it more consistent with the later VERSION_WIN10_*
> symbols, but it doesn't fundamentally add any clarity and I'm not sure
> it's worth the churn in the other files that have to be touched. It's a
> judgment call, and that's just my input.

My fingers were itching:  ;-) I've reverted this change, following
your recommendation.

Thanks,
  Andrea
