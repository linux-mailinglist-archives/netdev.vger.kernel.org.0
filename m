Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3F43C3C6C
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 14:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbhGKMlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 08:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhGKMlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 08:41:20 -0400
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E17C0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 05:38:32 -0700 (PDT)
Received: by mail-ua1-x930.google.com with SMTP id 109so1500788uar.10
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 05:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=fW1OWJwWcEbw1rZlxfp/mGRibfFSmzVLOGGMy0QSBFxnAXSuMrItRwE3DrPKS492AM
         af9w7ezumA0ZdI6BK62etd2Xnwa0Jg4MtzyrwKIUFuyEdWovNUo8RrCiNVh95cKFc4LE
         X8ZN3t+mko1X5PfB9rDR7KZgTgBBuU5NMbTfVXpx3jlMMTjUEDjOmGoNX6hsOsHWbPqZ
         VaWzTRm+pQwatglLsUCqrGTmFciXIWT7ehRBV8s9+hJLOa2rZP1HTvaP4u3mFa1BwiC1
         KaohwS7fTdRmR0QRf45JBNMiiVgg0iv007FzM9BRaTDOvENIIBKFBUk62yA4wHtWoU4m
         3OgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=ia2zuB76H/RasOng/6b+RLYR28m3Q4CJ32iiHaZGEVJIotcTJxSnJiNfxP2bKC/UpO
         EIg8u2OYqy1KrU4DXOqT0yWwKOQdQxe9dd+In88atfu7kfob19ODzc+nF9syZgy9fyI2
         034/HLfJ2GSaikNoolnL5FPA8x9ay9QzNpMMawncp0RlHQmKUvCirVMmHTxWief4GKer
         kTMxYwMQx0RSt3nmd4hq755l6icYMM2meEzeCrXV0wZ6T6k458kGWWzssUemk7FltKu6
         R98b+wYmIV6TfY1Kz1j0sg0aBsdJMbaPjJEmh5nIG8GZVNFIGjRvcqX21skoqRR9HqPZ
         jpzA==
X-Gm-Message-State: AOAM532HymYwG8R+FFjluhW7yUIYxopR+HAyvG9hrK9ssc1+IHwdygV9
        W2uNfd5XsQbARf5XGlPoHrgPQv/L65GHfKZfP48=
X-Google-Smtp-Source: ABdhPJxPjBw6ifLZ08LjDB0JBZPSrVI30aeNnVmsE5KctjfMPrlls3Yvmk5MiAy0CH1Z2NACTuumjlfnBFnPDcRpwEY=
X-Received: by 2002:a9f:326c:: with SMTP id y41mr34409848uad.52.1626007111831;
 Sun, 11 Jul 2021 05:38:31 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a67:af14:0:0:0:0:0 with HTTP; Sun, 11 Jul 2021 05:38:31
 -0700 (PDT)
Reply-To: info.cherrykona@gmail.com
From:   Cherry kona <tonyelumelu67@gmail.com>
Date:   Sun, 11 Jul 2021 05:38:31 -0700
Message-ID: <CAAVnhxL4=5WENS_unin8sir4Do2JTwnpZyaJxG8exXPez5RtaA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


