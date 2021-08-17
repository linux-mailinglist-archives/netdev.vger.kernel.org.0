Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027BC3EF0D6
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 19:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbhHQRXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 13:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhHQRXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 13:23:12 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA07C061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 10:22:38 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m24-20020a17090a7f98b0290178b1a81700so7388765pjl.4
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 10:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=zROYzFhfEGL3M5CVOqJ5nq8Q6zoKc2ab1iQlY2UMzrQ=;
        b=lC5DwTcpLTqyv2VI7riX2NLjm6bLCxQh1JvTMzsM+cQ5r48z8F0ydDHX4aA7hNZkqC
         CbL/J7xbQvzEueUfwYlASRSsKM0q9cBvfAlafi0Zc2RfwHzCJBTwC0SLSvY4w+2nN3wj
         ilK5CsNtPcmOLWS4GIx8ML/c6KLa6b9cSanJ9FyjcNJ/KDSSiT7AW4iGW6wZGDxQONo6
         6yUVvWfPijS7eW3tS9O+ETaJjKCRKjr61hV5MOe8Ho1MhCAADFHGNbKGoxerqHpKAdAj
         vUOrFOlv5L+u5MT22cdZFi7pmGUR0yKiTMZhAV+ltcDODa2DJGPS5LlctO+b7tWpxdtz
         qQGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=zROYzFhfEGL3M5CVOqJ5nq8Q6zoKc2ab1iQlY2UMzrQ=;
        b=s8OyVPOGg0fv3ZZc0hYWh7/+Tb6JQNG/fKn6lhE89XyF20YmrWPoVfQk53JaZXIJEN
         m8JY5pqn+Ti5Wxi+a94VlMg8t98Uepkkp8FutfX2H4zEt9jyhs7ixnIWU7t0SwQEc55r
         Gnt42PdW77jToACTNQKzahJb1luVB8WhXcmKz1K5Wtj+DDjpN7Cd/zM/zyJnzTzDnytb
         2806odAZlDoPF4eOLBUjthq+wtN/w2d+uVnSt4bUSmXPJwij/+qZOBWegt73CUSrxTsA
         loLC1sFc4fPYbU7OHyv5kZyVV97FKvys5Uf8P8mBqDOuNEM3yWvR0Glv9A3evT3BBVHe
         56iw==
X-Gm-Message-State: AOAM531B7pXUAawDy2by/djVP+7f6YI4rqEG9BS/MlH8f1Q/2qi5eQ77
        O+XaYaKSjeVbF2ZMBNi8GQI=
X-Google-Smtp-Source: ABdhPJzM2Qlh/osI//0igNf1O6JvCmG64N0Yd1b43FKUREAC+N3Y/zhsc7vaOQgLCjUcDEU+K89KmA==
X-Received: by 2002:aa7:8713:0:b0:3e0:4537:a1d4 with SMTP id b19-20020aa78713000000b003e04537a1d4mr4679223pfo.1.1629220958394;
        Tue, 17 Aug 2021 10:22:38 -0700 (PDT)
Received: from [192.168.150.112] ([49.206.114.79])
        by smtp.gmail.com with ESMTPSA id w145sm3430289pfc.169.2021.08.17.10.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 10:22:37 -0700 (PDT)
Message-ID: <79825fa723b291f09d4e65dc9c3b2159c7985cbc.camel@gmail.com>
Subject: Re: [PATCH iproute2-next v2 2/3] bridge: fdb: don't colorize the
 "dev" & "dst" keywords in "bridge -c fdb"
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Date:   Tue, 17 Aug 2021 22:52:35 +0530
In-Reply-To: <20210817082740.6be97031@hermes.local>
References: <20210814184727.2405108-1-gokulkumar792@gmail.com>
         <20210814184727.2405108-3-gokulkumar792@gmail.com>
         <20210817082740.6be97031@hermes.local>
Content-Type: text/plain; charset="UTF-7"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-08-17 at 08:27 -0700, Stephen Hemminger wrote:
+AD4 On Sun, 15 Aug 2021 00:17:26 +-0530
+AD4 Gokul Sivakumar +ADw-gokulkumar792+AEA-gmail.com+AD4 wrote:
+AD4 
+AD4 +AD4 +-		if (+ACE-is+AF8-json+AF8-context())
+AD4 +AD4 +-			print+AF8-string(PRINT+AF8-FP, NULL, +ACI-dev +ACI, NULL)+ADs
+AD4 
+AD4 Why not the check for is+AF8-json+AF8-context is unnecessary here.
+AD4 That is what PRINT+AF8-FP does.

Thanks for pointing it out, will remove those two unnecessary
condition checks and send a v3 patchset now.

Gokul

