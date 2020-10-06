Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECE1285425
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 23:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbgJFVwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 17:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727584AbgJFVwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 17:52:13 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79553C061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 14:52:13 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id i3so5839pjz.4
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 14:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nlw0ahtZWujrYrGl2/K59bEegsMjQXCr5mWmoSIM/6Q=;
        b=BF2tf9jisEHSeaDLbhJqZVD2dXA8UHYfq7rahgloODstyPvycmqEwdNF/vaqGP1BUJ
         ESdbvsgyksI3pG+W8tJCqdeYz8tSbGQ+Xp9ihow93lgK9nGGEcNK5Tw8MgdZ0FtYskEZ
         /0NRVR+t8jBBQZVrXqbG3ruH24XPzNTzWPKAAtbl+eHSB/PeRK9GrDrTDkvfDLNJxivk
         g+asLMqaSdR+rZrLZTZrwIwB+0TC3lIICekjSV8niVxoyQ38fTKLNjmxvw7hhSIhzKY9
         trhA4TzjmIHnXpyHOKNlI+bycknFQVrrjTzrpySGo/HSey48ClNo32Hs5p56uYq8cfN3
         i3YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nlw0ahtZWujrYrGl2/K59bEegsMjQXCr5mWmoSIM/6Q=;
        b=AjlwXuPeLPEJvfnGUxV+ubJ+GFKJyOdeR0nnWRpAq3hbdjfQne3kyElp+KRL7JAVhM
         j9bBILuoT9m4Ee5MlK8kalYRzJpXza808rG1O67iIArnJM+xZo368rlsz+Y4c8MVJMWt
         /NWOw/AqMvofsvaIyANBL1Bg++Lnv0DiU9MNBZgHfCeDLOvss6gtkTMVYlDoUNRKWe0p
         M2qSCdMmhnZni+UWPpqEAfGtFfq4F/eXTgeusrI6JvhWz7XUsix3DT4fhY2woTRCeJrz
         R6uR0k/iVcB7e9tAirv4Cas2DpyVJJjkISm0XgSyeZ8DGrjgHUQ8vgb9eFhlWTVDBL2k
         s++g==
X-Gm-Message-State: AOAM532JIFb28MJ54d2+/VtrqTJIVDWS9vTMS8Pz/dvm7NXy+PnD2YFT
        KkffevgBPOsQWkiYPpwagVL+UGIbay2CnA==
X-Google-Smtp-Source: ABdhPJxDS3iqBuSuFnfeFZ7FACKjenfjqzn2L57Cmblufsq40of5QQRsM0wQgXklE4CVAK7XauUDsA==
X-Received: by 2002:a17:902:7441:b029:d3:eaa4:8f35 with SMTP id e1-20020a1709027441b02900d3eaa48f35mr3176plt.74.1602021133051;
        Tue, 06 Oct 2020 14:52:13 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id g21sm167169pfh.30.2020.10.06.14.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 14:52:12 -0700 (PDT)
Date:   Tue, 6 Oct 2020 14:52:04 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Samanta Navarro <ferivoz@riseup.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] man: fix typos
Message-ID: <20201006145204.032647c9@hermes.local>
In-Reply-To: <20201004114259.nwnu3j4uuaryjvx4@localhost>
References: <20201004114259.nwnu3j4uuaryjvx4@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 4 Oct 2020 11:42:59 +0000
Samanta Navarro <ferivoz@riseup.net> wrote:

Looks good overall.

Take the "a" off in the gso_max_segs part.

Please resubmit this patch with proper Developer's Certificate of Origin
(a.k.a. Signed-off-by).
