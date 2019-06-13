Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED5D44DDB
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 22:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfFMUws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 16:52:48 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40846 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbfFMUwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 16:52:47 -0400
Received: by mail-lf1-f67.google.com with SMTP id a9so155344lff.7
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 13:52:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AaBQqWMOUq2lx/a5leMGyqdX1HTXUBdiKkCwBfVJ/YU=;
        b=ODTN2IL+BjtmeO8HnaCK+4p4K7OAC0aYh8gfuQ3znJUTX8UP/TKK5asTuMATIh9u20
         CBnvsQZWmJd8AXbWr4nue2bKvH4h2i3Fg+peFYmNiA+gy8Sm5Xn3c+gbcuf/pC2YsuHZ
         Qz537IGukwTzYhOhxkh+XfRNRCsNJvqUmnr8VP0d99LQn+J2mZfpo2Nrkv9heimM6E7Q
         OKT66avGiRiJDUitmtCo1HbhhXpKtq1Iu3kpNqAYNYGhxBgJnWr60WWcrxjrtq4lQmgW
         Ze0bRcwOnQNIm+BRizmf6lreNTCauRtTs1PPzbdCBkOapYfGvv78Em9UHS1t7FvufC+P
         2Pow==
X-Gm-Message-State: APjAAAVuRIKsTPwL7GT2VpIB2T3w3fVH+B0pLpW+LTygbcX+KsiG2ieu
        DGMFG9XNY2reJjHQbeNAMWbUMmOtr/KOi+dyMPlgPUYJGSQ=
X-Google-Smtp-Source: APXvYqwT2viv8wyG2BJmKhRozUzxwLUWD82BknIsjH0knwSzZK2rnO91rkO333fuqtTD6yj9g+VS9irFvHaU8V/KjLY=
X-Received: by 2002:a19:e308:: with SMTP id a8mr44603797lfh.69.1560459165743;
 Thu, 13 Jun 2019 13:52:45 -0700 (PDT)
MIME-Version: 1.0
References: <3734f49cbe4b7543f09236d02cbe78b515af1e28.1560448299.git.aclaudi@redhat.com>
In-Reply-To: <3734f49cbe4b7543f09236d02cbe78b515af1e28.1560448299.git.aclaudi@redhat.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Thu, 13 Jun 2019 22:52:09 +0200
Message-ID: <CAGnkfhwxohh+_hNxifRb+8grD5YHu9cEqT4v1-Fs0u=71uXFFg@mail.gmail.com>
Subject: Re: [PATCH iproute2-next v2] Makefile: use make -C to change directory
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 8:02 PM Andrea Claudi <aclaudi@redhat.com> wrote:
>
> make provides a handy -C option to change directory before reading
> the makefiles or doing anything else.
>
> Use that instead of the "cd dir && make && cd .." pattern, thus
> simplifying sintax for some makefiles.
>
> Changes from v1:
> - Drop an obviously wrong leftover in testsuite/iproute2/Makefile
>
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
>

Reviewed-and-tested-by: Matteo Croce <mcroce@redhat.com>

-- 
Matteo Croce
per aspera ad upstream
