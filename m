Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1178F13B37
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 18:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfEDQml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 12:42:41 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37425 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfEDQml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 12:42:41 -0400
Received: by mail-pf1-f196.google.com with SMTP id g3so4488122pfi.4
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 09:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kZRJ7fbEudCp19JCzwxgLn4No3tdU3+QkYEDmN/142c=;
        b=dlwHsqDrhtGiRyHPLjmJ9zBni5ea1MdkqaugN1YGUO37U5Gcoztbysx4Sd11/bu84q
         H4SRr7HBAaS804lp2dKjG1kvwE3gsH5cI4ap0AeKux22bgFcWD4qT6QZK1RKDBm3/txw
         E1iSEeuGbvrrvdvopmoUZjiZjxuJxKW6GFUS/v5bwQRUq/TMWJSXESIhDN3g31ppzcCJ
         +TVYaQXM1tIl8W9pESh4nZOSkcOWao2JFwYkdUnBkv9iJmMedl0KM8kUOdrs3Ualqupg
         MGHgPZFPZsTGzo1DKUeoR7lKQMG9EagQtlEJ8PbzYhPtvGZR5i/YBEoUEGMpaPYT0a3b
         k+Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kZRJ7fbEudCp19JCzwxgLn4No3tdU3+QkYEDmN/142c=;
        b=M27VRXCZZT7z9U3shfbL6oVF1MHCUyb7Z12MSUnjDiOMcRIoyKDPFCJDtWTB9obbc/
         mqSx22AuWrVSEXDUS1gNf3ZZnG/VF7LiXz5kYSSlBEzhwb7LH4Qw5miSCpmhA7cmA1aZ
         /68Gm+36+uuxqjcdnCohq1wxA7Yby1Cnb2tVSXpv8FD+HpRUGMQpWmYPZiF3wCT413Fy
         mLAjFcxnKJyLe8CvbcBP1NwR+jia9OX0xWApMtGSMM4nvoya8U70tyztbVN82xjmHJoG
         5s45wQO4soJxsrb/XpAPWYRTHbTST5YTDXdNKta9iaam3EYSdW2En+Xds8Den+N7KimX
         /cSA==
X-Gm-Message-State: APjAAAXW7KQ9dF/Dzbhdnq/thGlgp68Ze9f/o4lu7zoU/ZLkOusBqM/t
        M/WhTh35KhhtRKv4uuk0DNvVVQ==
X-Google-Smtp-Source: APXvYqxWS6QMrZsBKF6B89F+VFEZYILcJttjxqP06NwzwLrUx7AWY5KNv6HFryTqfk/Oe71MGIG6vw==
X-Received: by 2002:a62:b602:: with SMTP id j2mr20618225pff.68.1556988160486;
        Sat, 04 May 2019 09:42:40 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id u66sm7473911pfb.76.2019.05.04.09.42.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 May 2019 09:42:40 -0700 (PDT)
Date:   Sat, 4 May 2019 09:42:32 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Subject: Re: CVE-2019-11683
Message-ID: <20190504094232.041d6c68@hermes.lan>
In-Reply-To: <65007ac9-97f2-425e-66f4-3b552deb20ac@thelounge.net>
References: <7a1c575b-b341-261c-1f22-92d656d6d9ae@thelounge.net>
        <0ca5c3b7-49e5-6fdd-13ba-4aaee72f2060@gmail.com>
        <f81bad23-97d5-1b2b-20a1-f29cfc63ff79@thelounge.net>
        <f84d6562-3108-df30-36f7-0580bd6ea4e2@gmail.com>
        <65007ac9-97f2-425e-66f4-3b552deb20ac@thelounge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 4 May 2019 18:39:15 +0200
Reindl Harald <h.reindl@thelounge.net> wrote:

> Am 04.05.19 um 18:32 schrieb Eric Dumazet:
> > On 5/4/19 12:13 PM, Reindl Harald wrote:  
> >>
> >> ok, so the answer is no
> >>
> >> what's the point then release every 2 days a new "stable" kernel?
> >> even distributions like Fedora are not able to cope with that  
> > 
> > That is a question for distros, not for netdev@ ?  
> 
> maybe, but the point is that we go in a direction where you have every 2
> or 3 days a "stable" update up to days where at 9:00 AM a "stable" point
> release appears at kernel.org and one hour later the next one from Linus
> himself to fix a regression in the release an hour ago
> 
> release-realy-release-often is fine, but that smells like rush and
> nobody downstream be it a sysadmin or a distribution can cope with that
> when you are in a testing stage a while start deploy there are 2 new
> releases with a long changelog
> 
> just because you never know if what you intended to deploy now better
> should be skipped or joust go ahead because the next one a few days
> later brings a regression and which ones are the regressions adn which
> ones are the fixes which for me personally now leads to just randomly
> update every few weaks

The point of stable kernel releases is to feed the distribution pipeline.
Sitting on updates or doing value judgments as developers does not aide that
process. End users who can not handle continual change are not the target audience.
