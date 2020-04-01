Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0F519B4DF
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 19:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732295AbgDARrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 13:47:55 -0400
Received: from mail-lj1-f174.google.com ([209.85.208.174]:43934 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbgDARry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 13:47:54 -0400
Received: by mail-lj1-f174.google.com with SMTP id g27so351050ljn.10
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 10:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id
         :disposition-notification-to:date:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=BZGtJyQljD+cYphH3TuErQ+MAF9Iz1jFmPEs8f2an4g=;
        b=aO41N5gOB09lX6BI5+IC9bY20cCp7knCluqAIkbBFGiNiTdvdtExM28/x1/aBUorTI
         KhCyzChkGwi4gGJh5nfcd2SBL6B1I7BtLjKJgK/h6Gt4MiGvvtZ67Y9zT6KQm5XSuGf/
         GKrTT5GfGrE74ttCFJgd7asLHSi+QRKlQBDxAB0WIO4QYXz/Ub4Hy86Y2QdlBpoGbtD+
         x9mekmaFret1oDqPkZeQUkrMGXXB64Jp0AlwVPIfLcl1BvCnv/v4tYnDX/P0h7dzwykD
         AuYqdp5oKJJHUah3tDEIQ5pygi53fzXYKgfDzPsuY0cwNhiPDm4tNYnBZJR7SmOW+RlI
         LfQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :disposition-notification-to:date:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=BZGtJyQljD+cYphH3TuErQ+MAF9Iz1jFmPEs8f2an4g=;
        b=m3KLcE94wTrSHlItTmx/gaFrrtSBYd20WPVjCUxzH4e4lrsmsawYIRtVSA8Xd4FIs0
         Y59TnlsU72J/u62SjizPg8iTwNyspDRx560UvZX+V6dTtfb3cnyMLu690zy33WgxsyFN
         ZhZoFdQjx6Q2D6DZ/MkVNPT00K/uXUw9haLCDsihIHabdu+vTTuCwaTULR8H76N7xaNy
         XFkGSnWlUFidoXIwub9zvZS9hXFuDbQqCZwaSfMcT2Z46b/vMZgzdaI2Wa2dFexkeuru
         9hnmfVvEv6Mag+9ACW2C5hRY2ALi9GNYWsqfgrpl6fKm2kd9jtjSb6EmEJkIT9ulV5w5
         nt8A==
X-Gm-Message-State: AGi0PuYXGcGlI3RGmfKuAm37e3M0fD2vvLJovPD87PVG9yLEFckq3yfM
        uUtEsnyBMG7oHPQCyRRkiNHlGBA7
X-Google-Smtp-Source: APiQypJQpW+jcUSI16IO6dGik/+lgSyVLG0q8dM94cJCghQm4r/Lb73Jz3vXIdJPzglCxm0LNDOZ5g==
X-Received: by 2002:a2e:b4cc:: with SMTP id r12mr13869917ljm.50.1585763270173;
        Wed, 01 Apr 2020 10:47:50 -0700 (PDT)
Received: from localhost (public-gprs651326.centertel.pl. [5.184.87.127])
        by smtp.gmail.com with ESMTPSA id a4sm1839772ljb.27.2020.04.01.10.47.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 10:47:49 -0700 (PDT)
Subject: Re: Creating a bonding interface via the ip tool gives it the wrong
 MAC address
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
References: <a43adea0-8885-2bda-c931-5b8bf06e3a70@gmail.com>
 <20200401155601.GW31519@unicorn.suse.cz>
From:   Mikhail Morfikov <morfikov@gmail.com>
Autocrypt: addr=morfikov@gmail.com; keydata=
 mDMEXRaE+hYJKwYBBAHaRw8BAQdADVtvGNnC7y4y14i2IuxupgValXBb5YBbzeymUVfQEQu0
 Lk1pa2hhaWwgTW9yZmlrb3YgKE1vcmZpaykgPG1vcmZpa292QGdtYWlsLmNvbT6IlgQTFgoA
 PgIbAwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgBYhBHVmE1jF+1cCeRanATLZy2NHlsyhBQJe
 Pv2fBQkDCawlAAoJEDLZy2NHlsyhtRoA/jWpJePkdf/X3ZweFGQD7EcmYa8Mc8b85InzvuDP
 czZrAQDfjICfUaZUjwPAKu9ZZrUPgo7WOJJAeVtqm6YK3gYUCLg4BF0WhPoSCisGAQQBl1UB
 BQEBB0DW89pZH+DofYPMWqLrOMQEKoS/ps6D43qVqEIS6EtzbgMBCAeIfgQYFgoAJgIbDBYh
 BHVmE1jF+1cCeRanATLZy2NHlsyhBQJePv4KBQkDCayQAAoJEDLZy2NHlsyhkhsBAKF0oQnM
 hczFQ4+zd8yf5y2HkIHo0JVdBIX4E+HMm425AQDlZNnOWQJ8qNeORyoMacN3s4dzwSzQ5HWy
 tOy2ebBQAg==
Message-ID: <991aa9c1-8856-35e0-258a-8a250587f03b@gmail.com>
Date:   Wed, 1 Apr 2020 19:47:47 +0200
MIME-Version: 1.0
In-Reply-To: <20200401155601.GW31519@unicorn.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/04/2020 17:56, Michal Kubecek wrote:
> I suspect you may be hitting the same issue as we had in
> 
>   https://bugzilla.suse.com/show_bug.cgi?id=1136600
> 
> (comment 9 explains the problem).

Yes, that's it. I just created the following file: 

# cat /etc/systemd/network/99-default.link
[Match]
OriginalName=bond*

[Link]
MACAddressPolicy=none

And that fixed the issue.
