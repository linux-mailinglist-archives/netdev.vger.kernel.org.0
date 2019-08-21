Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EADD986EF
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 00:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbfHUWAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 18:00:23 -0400
Received: from mail-lj1-f169.google.com ([209.85.208.169]:41220 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728028AbfHUWAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 18:00:22 -0400
Received: by mail-lj1-f169.google.com with SMTP id m24so3578175ljg.8
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 15:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=UtLPTpmziN33YG4O4Q+fjJadZXwsjUnQKgfuJCB6e30=;
        b=Wv33EjD8K7IOFULJM+TWEQSabao5/oqiMjnkyfl+6HMstEOSL21yE53KCLaJPidc0q
         9qQfmolCwTV5Ek7i6WXu9us2CqOrFlqzfDi6IbIeX5BjL9wLsQzc8V1hBpm3xAARaQf+
         Oga/EyMhUtNF36RfXc/LeFK2p99pwVJ4Le5o3nDYYFhbiY2AjRaNZBXXGQjOAszNS5oK
         x5kqhOXZTj3hO9PsmEr0X8PmJhX7gtV4ye515mRAs+e0iC0iWEn9/nGXCvOoV2j/dlPU
         fC5cVbqPsWu16g8XTObBhnsp0ywWzJ2r/i6l7YtdXrK8fZoGJiWCgNeQgFNgLX0lPPv7
         ASwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=UtLPTpmziN33YG4O4Q+fjJadZXwsjUnQKgfuJCB6e30=;
        b=GVjZ8/FYmmeBu4grCp12g+l+zC3CjhjSJXtQob1wwCsZ6UnSfN31zAvfrNMUIxToB3
         vNo9gjEFUk2TPSncXDrEydmmI8UWJWnW3o5gWFyOcnC74sE/lRS1ctD7/3Z4DwESc+g/
         JB4S/TCi+Ergn+w7gAeJX6VmTAHmBCDDm4JUIWum0C3WrNQi0g9Off5kHB8Bs91TQprW
         Si0k3gr4Cv4pdDLL6X18NIeV1gSJ3Xifpw04hIYTUVd9EFGdxieCBnpXknKryj3TBRhA
         PsJPexVmC3o/MvseESnjhN6aaYhbGGu+f960+drJj2QzvNLmnjVkcmb1uUzV+BQO4Y29
         uKpA==
X-Gm-Message-State: APjAAAWNf4l/w/Exus7HsEmrwb3jY3CdvsIRT3whoR4xUs7w6q3YVF6Z
        +XRsJ3QPVDp+Zq8YqnC07yoXgpKQld77Qp/PGUPWhTNfRWvX
X-Google-Smtp-Source: APXvYqzkHSMhD3XMQ8GKHBBdvLF/0nj7DXZcIfPjPF24ezy7vpBJXXOuH0d3+RQVZvlHi4Wx+J41C7uj7eWbUoJtCuA=
X-Received: by 2002:a05:651c:1111:: with SMTP id d17mr12865350ljo.87.1566424820383;
 Wed, 21 Aug 2019 15:00:20 -0700 (PDT)
MIME-Version: 1.0
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 21 Aug 2019 18:00:09 -0400
Message-ID: <CAHC9VhSz1_KA1tCJtNjwK26BOkGhKGbPT7v1O82mWPduvWwd4A@mail.gmail.com>
Subject: New skb extension for use by LSMs (skb "security blob")?
To:     netdev@vger.kernel.org
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello netdev,

I was just made aware of the skb extension work, and it looks very
appealing from a LSM perspective.  As some of you probably remember,
we (the LSM folks) have wanted a proper security blob in the skb for
quite some time, but netdev has been resistant to this idea thus far.

If I were to propose a patchset to add a SKB_EXT_SECURITY skb
extension (a single extension ID to be shared among the different
LSMs), would that be something that netdev would consider merging, or
is there still a philosophical objection to things like this?

-- 
paul moore
www.paul-moore.com
