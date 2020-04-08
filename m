Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1BE1A2B55
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 23:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbgDHVha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 17:37:30 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35741 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbgDHVha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 17:37:30 -0400
Received: by mail-wm1-f65.google.com with SMTP id r26so1609862wmh.0;
        Wed, 08 Apr 2020 14:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fN4JOUYXzZadhHaigIxCdjHL5JQOp1zv8p0cKNRSlto=;
        b=hlOthodMjO6sjcfcFgccaZ5PMj6V6vILjdJSDPQJgVhPz9GHOlo05D53ScrTPPvFMh
         wC1oWvzgN1o7eyi0KBFyOY0UERDgw/ODH6MdC1ghsZb8jlScHD/HmAU6Udh1iViY5/3C
         0SbEuhzT5fM3teMC5iNGNv58Khvtt4DEGbfSUGcTZ28w7K0j0M0ZTDfP3HhcSTZ8obY4
         2z1hfIjSVsV9dE+L6qIbbo/b/XrTS9ttbRrbsTpUXsck6BQgQo3ELJ+kNqQ9yP7B8WNr
         b3Un1zfGwO280S3y8HGc5iBOju5CLaoUU9O/wsxnA37UdaLGlxafOtOwuFZpLrrAh/fO
         ZWWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fN4JOUYXzZadhHaigIxCdjHL5JQOp1zv8p0cKNRSlto=;
        b=asUmbuSX2T9DiHL8J6yWbfCrEcNDmwsFC+6ImtbUPYpu7PKGf77v3Ce0rH86UuGD2W
         IafJw+sPfkufwAPQJ0CG+spdjQ4cW+ttvbRjeDX0WY+nxHb487lzKYnFEwVf8MfO/CuL
         tr6DlvXDEBTczTrZf23IFuNIY7ev6hdHlEn7t7FqGiFK2azUoXS6ajO5eZ7inS+4bLhv
         wfVzIafRuy4db9Mejc9yuD9vciq2YGsmte2mQyUOD7bfX2YYJyG0S4gU0sS1Va2DMV+c
         53zTq0wF3PdQlfZgTaGMBq4tzCEsEYMdH3weYqMSNvTB3C35UQcdDgLFZWh82+Aap6ln
         t7PQ==
X-Gm-Message-State: AGi0PuY0zcRuhcGjDdEVOdoq34SkX0133m7WFjYY58dgyeJ4ozIsXI5T
        mVT92+vFr9KLMxSipxVbwb/Jwp91
X-Google-Smtp-Source: APiQypJV8KbYMbR8exxMpzoNyBXOPHtXxKpL5ZMYtkEcbd6n6QLNiLkEfLHV3+CIV8cBbb0TgPm1HA==
X-Received: by 2002:a1c:2056:: with SMTP id g83mr6533900wmg.179.1586381847878;
        Wed, 08 Apr 2020 14:37:27 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:695e:ad67:528c:ed17? (p200300EA8F296000695EAD67528CED17.dip0.t-ipconnect.de. [2003:ea:8f29:6000:695e:ad67:528c:ed17])
        by smtp.googlemail.com with ESMTPSA id p10sm36707335wrm.6.2020.04.08.14.37.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 14:37:27 -0700 (PDT)
Subject: Re: RFC: Handle hard module dependencies that are not symbol-based
 (r8169 + realtek)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Lucas De Marchi <lucas.demarchi@intel.com>,
        Jessica Yu <jeyu@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-modules@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f8e3f271-82df-165f-63f1-6df73ba3d59c@gmail.com>
Message-ID: <88aabe57-b38f-2200-05ab-7f54bda274fe@gmail.com>
Date:   Wed, 8 Apr 2020 23:37:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <f8e3f271-82df-165f-63f1-6df73ba3d59c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.04.2020 23:20, Heiner Kallweit wrote:
> Currently we have no way to express a hard dependency that is not
> a symbol-based dependency (symbol defined in module A is used in
> module B). Use case:
> Network driver ND uses callbacks in the dedicated PHY driver DP
> for the integrated PHY (namely read_page() and write_page() in
> struct phy_driver). If DP can't be loaded (e.g. because ND is in
> initramfs but DP is not), then phylib will use the generic
> PHY driver GP. GP doesn't implement certain callbacks that are
> needed by ND, therefore ND's probe has to bail out with an error
> once it detects that DP is not loaded.
> We have this problem with driver r8169 having such a dependency
> on PHY driver realtek. Some distributions have tools for
> configuring initramfs that consider hard dependencies based on
> depmod output. Means so far somebody can add r8169.ko to initramfs,
> and neither human being nor machine will have an idea that
> realtek.ko needs to be added too.
> 
> Attached patch set (two patches for kmod, one for the kernel)
> allows to express this hard dependency of ND from DP. depmod will
> read this dependency information and treat it like a symbol-based
> dependency. As a result tools e.g. populating initramfs can
> consider the dependency and place DP in initramfs if ND is in
> initramfs. On my system the patch set does the trick when
> adding following line to r8169_main.c:
> MODULE_HARDDEP("realtek");
> 
> I'm interested in your opinion on the patches, and whether you
> maybe have a better idea how to solve the problem.
> 
> Heiner
> 
Any feedback?

Thanks, Heiner
