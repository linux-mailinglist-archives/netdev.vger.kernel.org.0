Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3391836BCDD
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 03:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234602AbhD0BLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 21:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbhD0BLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 21:11:10 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83444C061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 18:10:27 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id t18so125300wry.1
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 18:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmussen.co.za; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=m5JL+oviiEMYN2iHPoRwtixy+Ii+r7jIbAKypbLkjJw=;
        b=tPHUQ09XZoPYnAp/5Wud0XsNW1kwUtzWkod8kxxMw6ecsklaUFoSOrjFm5ugteGhcZ
         fUwHlPztu8IHj0N8fSPmSfcGF8Cpbvkpuq0gI/7d+6PC4Ru0t0/NxfxsCmJqAXlO8/8S
         oEavMYCPaCTLGd3FZBuh9nyYYhKIAiTMC/Tok=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=m5JL+oviiEMYN2iHPoRwtixy+Ii+r7jIbAKypbLkjJw=;
        b=K0F3Qm4w1/sYc9MUkDwUtWsL3dc54hqBwwmUA2Kt5bWsaHj7eMeLMqG8ac63OHoz91
         3fgsVfeXe+kbrJQBwKjkvi1u8GhfJQyE4suqKgsM+zlob1g+/m/2Vx0D8PUuHzds0d0M
         s4NvmT344trV+lTpuIVhtpWRZXBVOdXFIoSTybL5QmwhACHElXVKi72P+FQo6NrLdd/C
         ZsKd6NhWOC4L2Tr+l+1LMllj5zkSdxzDwxoIBKEH0nd7rSaEyOgBqCpTxv/yBnfZZjsR
         +31ruhaLR2yj/3e52fbTaVpY02ESCzS9gWZt9hwlmDLrBY558qoCJzwzLpiHGoB1xS0b
         ZzrA==
X-Gm-Message-State: AOAM531w+Jscvx8D9xLwcFYUXuoTp2+jOv2Abg6tbClrD5rl5UM8Qc8U
        Z0ebzbAvGtzadl6fc9rRhtJs7fpIQv8Mxu4GwnhRKHynL4ZDng==
X-Google-Smtp-Source: ABdhPJyJiBBZPK1XCCZLJOXwzNWUYPqfeYmNXg2Ry9d47SVgHYzSIYWcR9JGAxYTBUokeTZXtjgZr/OMt8nIvjNZE0k=
X-Received: by 2002:adf:ed4b:: with SMTP id u11mr17698117wro.293.1619485826087;
 Mon, 26 Apr 2021 18:10:26 -0700 (PDT)
MIME-Version: 1.0
From:   Norman Rasmussen <norman@rasmussen.co.za>
Date:   Mon, 26 Apr 2021 18:10:15 -0700
Message-ID: <CAGF1phbWt6Qk_XG++-ZHFDcb0MvwAcBDv6=hzpGV3+J4ySqAkw@mail.gmail.com>
Subject: iproute2: ss: feature request: filtering on process information
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Is it possible to match process information using expressions? I can't
figure out how to do it without matching all possible ports and using
grep to filter. Ideally I'd like to filter using ss expressions, eg:
`ss process sshd`, or `ss pid 1234`, or (probably only in combination
with other predicates) `ss fd 3`, etc...

-- 
- Norman Rasmussen
 - Email: norman@rasmussen.co.za
 - Home page: http://norman.rasmussen.co.za/
