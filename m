Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4C435FD06
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 23:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhDNVMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 17:12:30 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:46668 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhDNVM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 17:12:28 -0400
Received: by mail-wr1-f53.google.com with SMTP id c15so12238300wro.13
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 14:12:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iK6/+a2m1QCQdz8CwvMan48B8AkbSNqGdZuPoC50NzY=;
        b=tIgpuoY2mx+1T51Eynb4buIPRoka6/PsUcs2Hi3VQZphjfQdilUJZ51ajqlQD64M1i
         YpKi35i7+g0QMJOGw2LkEZKFlbvSit0+ou0qyscCfhPjZCHqMr4h3x5jCWwzhuWKrXJJ
         joQK3ReOk9jlu7x15wSw78dVKWAS6fCGqZkUzCROlbQI0ewpXGT//bhDVqPlzQN/uh6e
         3IxmkoaRGZLt/hbzBH4FtrLY6XcbAxFTVyFPDixFR7he5PtJ4F1P5mI9Cd53+lkIpaPg
         gpRpm2akQCDuV3cz2+sFgmDO84LYdOafo2MWWE8yAEmXhBuKCZ9i6shdmyZ6MZRp9MwP
         9Oeg==
X-Gm-Message-State: AOAM530PHCtbNSztyqndTta9HmCR/RAaQHcgq0ll9bU7LMcQNLMdEhk/
        79pvDuLo9JFvjjKeQNYQhlAmvU8iDQ0riPAP1oNdcwWri8E=
X-Google-Smtp-Source: ABdhPJw1obtdMUCewsxv5ALNfcsKmvzg4tAtTSZuOp+DtUnNXdJT86qXhlIsCT0WLDigULfT2WnTT6EcbRUA0YThg9Q=
X-Received: by 2002:adf:efca:: with SMTP id i10mr15044836wrp.316.1618434725923;
 Wed, 14 Apr 2021 14:12:05 -0700 (PDT)
MIME-Version: 1.0
References: <051ae8ae27f5288d64ec6ef2bd9f77c06b829b52.camel@talbothome.com>
 <d01f59bbfdc3c8d5d33fa7fca12ec5e8fe74b837.camel@talbothome.com>
 <634e0debea558b90af2cebfc99518071f1d630e9.camel@talbothome.com> <20210414192958.GA4539@duo.ucw.cz>
In-Reply-To: <20210414192958.GA4539@duo.ucw.cz>
From:   Paul Wise <pabs@debian.org>
Date:   Wed, 14 Apr 2021 21:11:54 +0000
Message-ID: <CAKTje6H9JWiLv465u7Mfhd5PCtg8RXO14XsgMEPErRpkaQh0pg@mail.gmail.com>
Subject: Re: Bug#985893: Forking on MMSD
To:     Pavel Machek <pavel@ucw.cz>, 985893@bugs.debian.org
Cc:     Chris Talbot <chris@talbothome.com>, ofono@ofono.org,
        netdev@vger.kernel.org,
        debian-on-mobile-maintainers@alioth-lists.debian.net,
        librem-5-dev@lists.community.puri.sm, 982250@bugs.debian.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 7:42 PM Pavel Machek wrote:

> I don't think forking ofono is good idea.

I'd like to point out that this isn't ofono that is being forked, but mmsd.

-- 
bye,
pabs

https://wiki.debian.org/PaulWise
