Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5099119EF49
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 04:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgDFCVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 22:21:21 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38464 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgDFCVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 22:21:21 -0400
Received: by mail-pf1-f196.google.com with SMTP id c21so6825685pfo.5
        for <netdev@vger.kernel.org>; Sun, 05 Apr 2020 19:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ahn7rTvX/CbmK9AyPXlGjeMgHQekPkkq4Aap0xjPHwo=;
        b=19q+EJPrKlkVJQNuPN68Hy+4yy3jcY2K9+MhqTMCkUXsGblt2Tduf7LiaS/QsqF/yI
         G9Pod7DXuZFYRjs94/i5auaRSajNps8tlR7pRXB+6/8qjc5EnJZ78swJlojFzBKZG9Ps
         RuytZ7zg8dzJokVhTfLDO4Rc3h+3sQWPVKVbmKceuvEmCv3iTWMw/DEP/oM2e7137dbK
         NJT3vxBj0ZXt/F0mXT6LN6GbXkpnn7ykHTSvHSWKMgbIytsk86jewsBwFwu78MhGnX95
         jYvjqbqWg+JKtJBTyS3ZMqIs9+iHA1+aQxjfS9MvGzjfo3XxN0qobW3ZWNygkrMmw1Ru
         ortg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ahn7rTvX/CbmK9AyPXlGjeMgHQekPkkq4Aap0xjPHwo=;
        b=J9BPmynWQwG4bUsaBYfyl+r6oXkm2Qm/LMK4v+7cHehdQUmTUNRhtvf7+Q/zxK4M58
         T5BhiANwTSQOe7DOm1ol6MynvKWvb0cZWMKwTGsKcXNHZAiZu8E6zRX61naa9yZGLmCT
         Z4MHNr4prkPWqsmJGItzO+iwf5soGtR4wydq4HnaKFwohkM4JDzF9fZ/JZZhIt+Hkf8Q
         YUfKcPCV5JXz8e1u7ItFCZhPsP/HOr60Zq6FHTgYc2bQrEKn0v86Lkt7GXWzVrJAmjL5
         Z7uOZ2lGaV7SxkiM9ZcbTEq5u3Qrb0GgjGsZ5WZjb5bhbpGn7l2m0WUYOTQt2HU3oHrg
         q0HQ==
X-Gm-Message-State: AGi0PuaLvC3CYooeZtxNvykjkLz/uTf1UY7lnyiLYJZ8N1+wGOE2+wCe
        IRY+A1Pp5S7G489s4D3YbnTTaA==
X-Google-Smtp-Source: APiQypLD3Kjy5pen/N5hs8TJjGJvY5p2QUYI6PcUUgN2eKNJLc+vvuRqJBc7FbMTO+Ou1yfOtzmoMg==
X-Received: by 2002:a63:d801:: with SMTP id b1mr19445444pgh.49.1586139677982;
        Sun, 05 Apr 2020 19:21:17 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id nk12sm11099323pjb.41.2020.04.05.19.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2020 19:21:17 -0700 (PDT)
Date:   Sun, 5 Apr 2020 19:21:09 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch iproute2/net-next 0/8] devlink: spring cleanup
Message-ID: <20200405192109.5e883411@hermes.lan>
In-Reply-To: <20200404161621.3452-1-jiri@resnulli.us>
References: <20200404161621.3452-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  4 Apr 2020 18:16:13 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> From: Jiri Pirko <jiri@mellanox.com>
> 
> This patchset contains couple of small fixes, consistency changes,
> help and man adjustments.
> 
> Jiri Pirko (8):
>   devlink: remove custom bool command line options parsing
>   devlink: Fix help and man of "devlink health set" command
>   devlink: fix encap mode manupulation
>   devlink: Add alias "counters_enabled" for "counters" option
>   devlink: rename dpipe_counters_enable struct field to
>     dpipe_counters_enabled
>   devlink: Fix help message for dpipe
>   devlink: remove "dev" object sub help messages
>   man: add man page for devlink dpipe
> 
>  bash-completion/devlink   |   8 +--
>  devlink/devlink.c         | 131 +++++++++++++++++---------------------
>  man/man8/devlink-dev.8    |   8 +--
>  man/man8/devlink-dpipe.8  | 100 +++++++++++++++++++++++++++++
>  man/man8/devlink-health.8 |  30 +++++----
>  5 files changed, 181 insertions(+), 96 deletions(-)
>  create mode 100644 man/man8/devlink-dpipe.8
> 

Since these all don't depend on new kernel features, let me take
them directly and skip net-next
