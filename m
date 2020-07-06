Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55834215D73
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 19:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729656AbgGFRuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 13:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729550AbgGFRuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 13:50:02 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D5DC061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 10:50:01 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t15so2935659pjq.5
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 10:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FbyLgQ3HJQ9yt8d1dnRyBTK1OmgI3W4424HZqH1BfH4=;
        b=yCz2qdbks20lnHTFOalI5N3uJk28haDPZsDkrjNvtow3V58B8jigMLl0rELevHCVTh
         z1fJuvE2smzI9k7WYkFv3Z5jKWGnlCG0b0HX7NVKIQe+YKc/mRdvvfiMhwnnn6E+wXUd
         JP8FwS0+W2QVjAyTzbhRLd4gDFwUlCtOowj6tOWEGhnxksJWcofm0CukmTd24PsJ/u63
         E5IEiBK+AKIYiJiPiRc8vKu+aoTfyvRQYXT+ioNxr9FASimMooMUaJW+pOJRDgbNzKtz
         aLJ9W1WGm0gy5+BD/baEZW+DykpP8xZmOiAc1uWlKumGNjfHao428BkyT8JEYhOvDVo2
         5ZIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FbyLgQ3HJQ9yt8d1dnRyBTK1OmgI3W4424HZqH1BfH4=;
        b=iDQlxN467aqn+DJkVAGBrQqnyurgnpNzEIO8nRXXUjT/NCjmBPyKowMv8D18YJn1T2
         +giQx3TL8XQTh0n4GK5LVBF+pHWNFQN24l+OnRft57Q6qaz6XZ1Cr/hx4J5EJcUAjXS/
         EI13a9qfOfJciA95OUZu/xS8ivIPPX77b5lmzxcJ79ylrM2jjsTI6zvopx/JmQ1LV96p
         odKpYJlvY99lGluOCL5Y+DiO2J3vUQtG5CSMQ14BXdw1bVvqOL0wOjNBZaepVYf8jOqk
         w10raBsGwMudV8wHiSJW5F3XZX7LldBu23lfJDfY7Ypy0Y7L4SZEGE+1QXaz8KWFa9Jh
         a3Nw==
X-Gm-Message-State: AOAM530oy1RNqgaHKhxuDuUHQhQZYLGsEezCBnN2+HfkdFatUb9i7BCx
        R7hgLuxu4WeavEmk9V047lyFviz/VnY=
X-Google-Smtp-Source: ABdhPJzTEeRXd1yh9GiMGquq4R2c0qtM7fkXJ868XV5DT/FIH8EBry4E9kelwgV+TN3U1kLj9IP/Pw==
X-Received: by 2002:a17:902:bd08:: with SMTP id p8mr32581076pls.154.1594057801483;
        Mon, 06 Jul 2020 10:50:01 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id b191sm20009032pga.13.2020.07.06.10.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 10:50:00 -0700 (PDT)
Date:   Mon, 6 Jul 2020 10:49:52 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Bjarni Ingi Gislason <bjarniig@rhi.hi.is>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] libnetlink.3: display section numbers in roman font,
 not boldface
Message-ID: <20200706104952.28bdf23a@hermes.lan>
In-Reply-To: <20200628162615.GA27573@rhi.hi.is>
References: <20200628162615.GA27573@rhi.hi.is>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 28 Jun 2020 16:26:15 +0000
Bjarni Ingi Gislason <bjarniig@rhi.hi.is> wrote:

>   Typeset section numbers in roman font, see man-pages(7).
> 
> ###
> 
>   Details:
> 
> Output is from: test-groff -b -mandoc -T utf8 -rF0 -t -w w -z
> 
>   [ "test-groff" is a developmental version of "groff" ]
> 
> <./man/man3/libnetlink.3>:53 (macro BR): only 1 argument, but more are expected
> <./man/man3/libnetlink.3>:132 (macro BR): only 1 argument, but more are expected
> <./man/man3/libnetlink.3>:134 (macro BR): only 1 argument, but more are expected
> <./man/man3/libnetlink.3>:197 (macro BR): only 1 argument, but more are expected
> <./man/man3/libnetlink.3>:198 (macro BR): only 1 argument, but more are expected
> 
> Signed-off-by: Bjarni Ingi Gislason <bjarniig@rhi.hi.is>

Applied, thanks.
