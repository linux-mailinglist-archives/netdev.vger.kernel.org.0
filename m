Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C292DD4869
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 21:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbfJKT0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 15:26:14 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:39456 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728903AbfJKT0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 15:26:14 -0400
Received: by mail-wm1-f42.google.com with SMTP id v17so11216642wml.4;
        Fri, 11 Oct 2019 12:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uKbKcTI5oAu/5J+XUGF85siQfBKYiDyHMWqEMwYb3R8=;
        b=M3PBlTde+MQ1+upfHsMK7J1Rxi1Sbp1QyTwJb1ai1/tWQ1T5HfrpwfLhTOidEyJWIM
         LfHHmr9eUbPEZj5Fbc5wReHWhd3fl3Pkgac9dAMsCWDIlFF6jGpcJvoR/tdEt5a1Qg3k
         9esVR8sKhexmXHJE+NRZKix8cYUI+Jp0X3qCdztQDIzi1nM8tvL/zO3dDUYSzYTsvm++
         WeZU/wTB9aOTJ6tj0yBj9z7xNiYC+djytNNo+MU9ImpmnkUGpySmL8ghPJLFhlGmuciH
         pmnCKBupN73ORJghz7tEkuNO+bbChEuGNpeVV088rojs4ZBtpF31LL/ZZEt6rnOoc4wd
         k8yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uKbKcTI5oAu/5J+XUGF85siQfBKYiDyHMWqEMwYb3R8=;
        b=NEcNn8+r8cHF6wXYEZPIqQJbLEWDVbuQ6E9OKDtFp7epkAzkX791NdoyvkU8LiJ6mD
         TwPN5RcWOXmkKjeyZi9XERbtkgvi6luIU5gxSCdD12rK/Z9WS4/QgA5aFQ/OalASsGIn
         yq08AvVo+0OttLvfwX3yQK+B0kVRNBd0JRSCaBF7iPMv+S9ZySt/86WjvQA8Lg9aR9pW
         SXphFKuwQD/MOxHn7r4MRdJ3/IDK5iSCEqs9XNHA50P9VcbIUGpuRy1eW8GxZzZoU2p/
         hgJyTPxEsXdDa16yn72j0BMc3GoICd7rB39gPe3+UY2fd84spWiuHdssp8u0/1P3YdpO
         EIKw==
X-Gm-Message-State: APjAAAWH93GneB48m6SxfqdtHro0b6TvTLqYQnmeRcbv0yoyjjX8YZM9
        WJMcbmBGBYhuV7XHuOF3zeu6cym7
X-Google-Smtp-Source: APXvYqy3NsrGaARW3kWkbuyvJuNZIETQM9FRnCxjAmy2sTTH2QIV8nAEpj1KyvMPmkOHYi91kDn4SQ==
X-Received: by 2002:a05:600c:21da:: with SMTP id x26mr4459742wmj.152.1570821971183;
        Fri, 11 Oct 2019 12:26:11 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:a940:7bc:76e0:c57? (p200300EA8F266400A94007BC76E00C57.dip0.t-ipconnect.de. [2003:ea:8f26:6400:a940:7bc:76e0:c57])
        by smtp.googlemail.com with ESMTPSA id g185sm13491613wme.10.2019.10.11.12.26.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 12:26:10 -0700 (PDT)
Subject: Re: Module loading problem since 5.3
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <8132cf72-0ae1-48ae-51fb-1a01cf00c693@gmail.com>
 <CAB=NE6XdVXMnq7pgmXxv4Qicu7=xrtQC-b2sXAfVxiAq68NMKg@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <875eecfb-618a-4989-3b9f-f8272b8d3746@gmail.com>
Date:   Fri, 11 Oct 2019 21:26:05 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XdVXMnq7pgmXxv4Qicu7=xrtQC-b2sXAfVxiAq68NMKg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.10.2019 19:15, Luis Chamberlain wrote:
> 
> 
> On Thu, Oct 10, 2019, 6:50 PM Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> wrote:
> 
>        MODULE_SOFTDEP("pre: realtek")
> 
>     Are you aware of any current issues with module loading
>     that could cause this problem?
> 
> 
> Nope. But then again I was not aware of MODULE_SOFTDEP(). I'd encourage an extension to lib/kmod.c or something similar which stress tests this. One way that comes to mind to test this is to allow a new tests case which loads two drives which co depend on each other using this macro. That'll surely blow things up fast. That is, the current kmod tests uses request_module() or get_fs_type(), you'd want a new test case with this added using then two new dummy test drivers with the macro dependency.
> 
> If you want to resolve this using a more tested path, you could have request_module() be used as that is currently tested. Perhaps a test patch for that can rule out if it's the macro magic which is the issue.
> 
>   Luis
> 
Maybe issue is related to a bug in introduction of symbol namespaces, see here:
https://lkml.org/lkml/2019/10/11/659

Heiner
