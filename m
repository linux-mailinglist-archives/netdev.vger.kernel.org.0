Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD273E88F8
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 05:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbhHKDqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 23:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbhHKDqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 23:46:40 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C795C061765
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 20:46:17 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id a5so923108plh.5
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 20:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mJ/CqbansfBHGDXiLc+SyJeedo7o8DtFnix8gxOZZTY=;
        b=tbT+zBMv+rNkA7V69zPPQ7bvemhnVSQTmP31g3SeVAJhLgMv7YINeFJQuN7LnnJBf6
         eFQqb5CXoLBQBkywND3Rq+DVyqzjYmHT/H3GNcBjk2gGD8H7amEN0jvPWW2p5l7dQtYj
         +ae0xOnuOfK2zl6z1fqCRdV6FokiyAoVJms9V4BGZb2S/8Et00/GUI3t+1z5yM38Dlll
         X+3oDOnHmt/g+0DU7H71D0H12Ot10B6/TzcuND1BFVdSOC5K0JDTgpnq6z1JsCTA7wCP
         IYPRHn3OJoO7DMwX5v9f2kUXtWYgMVq6e2POf+53YVviJCD8uHDesILbCXG00zsv1SKx
         aMGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mJ/CqbansfBHGDXiLc+SyJeedo7o8DtFnix8gxOZZTY=;
        b=nL7lI/Fz0pNnuYvukMB+BjT0cTFGz+kvxulBTc2vRsritoGBaVQMPO0DRTnK4YFSwq
         vH85K9rs4G7X4uy6hoEFFG+/oEnuEjmo5sKg7vJoeDxPatLHqYv/WTPgDY8lXAqK2e7h
         jem1qSHw/Ql0TQ/hidSnpmRPqKUQh7HerMntf9DfBfrcMySCIxZmdUMzKkIZ6NR02OT1
         ewCRQaJi8qKYFEIKTVreR5PnNKRU6qj36BCQHFe0WWi9UgizjCyZz6Mrm1r4Lc9V5cXG
         y8/uDiX82EunI0uHbJ3DGMH1A1NIyo9hTCESgjBc7aYhZGqHovDR4c1Q9XJqoas5H4f9
         vayw==
X-Gm-Message-State: AOAM533hiXUfZQMWN53HrTiq4qR+Doin7msz7mGDdjrWXpkEY9KEf7Ou
        VkkRqGwJ/qNRoJ2Z1R1RQ/bpKoSNVYqRiw==
X-Google-Smtp-Source: ABdhPJxucTEaLeQLOlOcqS5RklZKvjI8SfVAASjJihpMtec4PyGZ4dVIf5NAQkuJSvS9xIYb4Z7vBg==
X-Received: by 2002:a63:fc20:: with SMTP id j32mr372288pgi.283.1628653576882;
        Tue, 10 Aug 2021 20:46:16 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id h6sm27246589pfe.177.2021.08.10.20.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 20:46:16 -0700 (PDT)
Date:   Tue, 10 Aug 2021 20:46:13 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next v2 1/3] Add, show, link, remove IOAM
 namespaces and schemas
Message-ID: <20210810204613.1b61aae1@hermes.local>
In-Reply-To: <20210724172108.26524-2-justin.iurman@uliege.be>
References: <20210724172108.26524-1-justin.iurman@uliege.be>
        <20210724172108.26524-2-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 24 Jul 2021 19:21:06 +0200
Justin Iurman <justin.iurman@uliege.be> wrote:

> +	print_null(PRINT_ANY, "", "\n", NULL);

Use print_nl() since it handles the case of oneline output.
Plus in JSON the newline is meaningless.
