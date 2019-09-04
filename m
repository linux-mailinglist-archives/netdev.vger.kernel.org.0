Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50F01A922E
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387903AbfIDTGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 15:06:19 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37717 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387898AbfIDTGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 15:06:19 -0400
Received: by mail-pg1-f196.google.com with SMTP id d1so11738205pgp.4
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 12:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DV/LTbRZuN6+GNqcVQj4V77YRfbUgqDnaLS53Y4KlNU=;
        b=fWwWhUN4jJ8WQ26qHQwdjR6leZzsZ7qzTB9SOcVUaS4K+1FWCtvgKTPLS/qA2YQrmt
         QNiK2hrxTdi6Ay4dUJF43P0Xu4YFn7Q7J3aZrUb8sMM8XJm9rDSVn/ZSL3DPqwsmuZvz
         V4ZDOkE908AM+7wpSykSejfqaKMmL/M6yW0XykRRDZEeFpRiQwFIiYQEgWAZBsClC6Ys
         7fX6AFRhuAvx+Pp9Z99H/6WsAGpCDbSGwDJFqq5BzTIjPei1dbZy5L5ALg4nRmH/Yxkx
         PUroIbQzM1NNqHymFS17uQ8mncVL9lvl0M9l26m/w7g+aFRgw7Ku56HAi6oaxIBqArjo
         tU3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DV/LTbRZuN6+GNqcVQj4V77YRfbUgqDnaLS53Y4KlNU=;
        b=Xz1SbndpAMNt5CrO+dpyH0rSzrb8BKVtyYk0t9rPl9Rn1oQ+WaCslDccJFzN60RSJ1
         iuF+Xh8G4N5KoBW444JgH0oBocUqHApdeIx02LmpxXGbi96EdScDoaI/XJ/z9pCYQ4Zq
         O9a3TQPM2l/rIdoh1WcQcZg0T1mf6SYppl7BKZQ1RERjDUmnMT9ySRyaA1i73wRk9bkx
         u3W/qluJlvLnosl8S5jQnmRq3KeJIKFi0bOUEqkkCeCZxaXWllLU6vWfIPFeDOQdA+j3
         kxDxamGCYeHxi2WOQzj6TuN03b7EqLJAd9GALAA8k2DZciGKFC3UjLFBoXFBHo9Q7wVy
         L/Zg==
X-Gm-Message-State: APjAAAW0xUFUexc70gFLHKAxnEv09C3lDxMxacu82rAAMuEUf7sBK3WQ
        rmSWdQgx99Klb46NFVBHP65nqg==
X-Google-Smtp-Source: APXvYqyznxeDjENFnn8qIqJgCv4Yg5tgUyeb+uKoIq2s/AXUB89FYklkt7W2PmNfUJfawnhm/NvMXA==
X-Received: by 2002:a17:90a:303:: with SMTP id 3mr6526725pje.124.1567623978553;
        Wed, 04 Sep 2019 12:06:18 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id o4sm3350486pjt.17.2019.09.04.12.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 12:06:18 -0700 (PDT)
Date:   Wed, 4 Sep 2019 12:06:16 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2] nexthop: Add space after blackhole
Message-ID: <20190904120616.05c277c6@hermes.lan>
In-Reply-To: <20190904150952.17274-1-dsahern@kernel.org>
References: <20190904150952.17274-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Sep 2019 08:09:52 -0700
David Ahern <dsahern@kernel.org> wrote:

> From: David Ahern <dsahern@gmail.com>
> 
> Add a space after 'blackhole' is missing to properly separate the
> protocol when it is given.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied with Fixes tag
