Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1704F1B28E8
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 16:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgDUOCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 10:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726018AbgDUOCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 10:02:04 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C77BC061A10
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 07:02:04 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id u12so5077208uau.10
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 07:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WqbOxN61nXB5zGZBDuS82MIDt45zl7XVaPZW7hxj7QI=;
        b=alUQ643Z4imji3zmf/asSffqA7DEw4Gzjbmw6guiXI+6JedofV7AD/07MgoKS+1Ajt
         pK4ZC2esqTdkuaR9LVwWe8ApMT0VYz2W5cAdOHtDASKM0/odnqvGjG0ebRyyI4eu14Pc
         yZLPVVzaqV4zZU5OR5RJWaybeLRPWs0RZGjAErhIF/Sj/9c/lkLhO9IqN7S+UCPc+z5S
         8pX8VCuo/lpHTg49MSHg+WrHy5B67/zoTObaXo/mV9zDVVA964xNYlZEktBlB8CCe+HU
         Q6a/zmePfZuIIKeWWJrlb/VAGuxwNKQxwCQjpww/JsSdqmm7AHjoKtpRN+G/+0BWNDah
         iuKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WqbOxN61nXB5zGZBDuS82MIDt45zl7XVaPZW7hxj7QI=;
        b=GOg7CQdCQYF1L4WYowlHtmnU5ZBt/RspZZgfbI3lXKXEH+pHJzMqqZJGog9ZbYTHDj
         fHPdqR2aSUR1CFT7LwMI+yF15lTWUNCFLjD705CZNahD5lkQiTk6KAEHKBpaOx1NHM7f
         V0ovyrByQzlvuf17AHOnlwGjqJ+loV8lqyCad6EFTuAHmf0rgIkNykAV74Ij/Y97BEiK
         9jdL+kNuA3KRyCsiUB61bjdmjS5VzWIfCzxAviIqJ4v2T3qH7Tqk6HB+agIEmxgi1is6
         MbVnaKiweyRteY8M79t7SjXMs2Akgsl1lRfZ1VllrTvbPczyA9kdruyfvmsLqaswVJX4
         Omqg==
X-Gm-Message-State: AGi0Puak82PMOZGyNhU0VJS6/RnNfrHXIRLl1UoXepoBfIUet13eCcQd
        0b3jWkhpMmJSuyKaYrhceT9pPF1u7f1+9e8uBt55Kg==
X-Google-Smtp-Source: APiQypLUGMaSG3mKjGwHFHhUsuvQLIAFiKnW1vQF6fSXPA0+ub7aXz7eQosw7YjrHEXnv/M5S4A4QNOCLICLT6RJu5Y=
X-Received: by 2002:a9f:3765:: with SMTP id a34mr12073609uae.134.1587477722865;
 Tue, 21 Apr 2020 07:02:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200421081507.108023-1-zenczykowski@gmail.com> <20200421104014.7xfnfphpavmy6yqg@salvia>
In-Reply-To: <20200421104014.7xfnfphpavmy6yqg@salvia>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 21 Apr 2020 07:01:50 -0700
Message-ID: <CANP3RGfBtFhP8ESVprekuGB-664RHoSYC50mHEKYZwosfHHLxA@mail.gmail.com>
Subject: Re: [PATCH] libipt_ULOG.c - include strings.h for the definition of ffs()
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Must be some version of clang - presumably with
-Wimplicit-function-declaration turned on.
I'm honestly not sure quite how to check, but it is whatever is the
default in aosp on master.
