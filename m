Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0013B16EB18
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 17:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730208AbgBYQQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 11:16:38 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41016 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgBYQQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 11:16:38 -0500
Received: by mail-pg1-f196.google.com with SMTP id 70so7096969pgf.8
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 08:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=f6ByfgXPM82KxYuRcY9g427z4rs8ELUhq95U8hEF4Xo=;
        b=IAh10TkX6uqGIj2oBiKLm4a0pl999aL+UkRIaTJzL/49yDWL/p5WopU1YzdfaEmiPP
         ucWFGevEm6EmuvPzr12sH0LAM7w51JSaYL0do+JVdIGTrrXw3D8476/9WZtj6PDaLwfu
         mImD3ZL29HiG40eu8AcWvCJhLEiwdtdMTMtdDdwquOM82+cbrCDXofUbi46zYmWjzevf
         KvOpD5AVDhCjpOVCerJrOvhyEQMW41O2MFTd0hijxMaZRSPKIk4tV8PI3ycDqCvknGZK
         /6pO6KeUHJXvhVg465a/MM7K/CLRNGevkjQ4Ng+OffPxZnKIgc93lR2V6sqfwX/6x8IN
         Uokw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=f6ByfgXPM82KxYuRcY9g427z4rs8ELUhq95U8hEF4Xo=;
        b=YudZkoVwIAmPVS8/BaukbboS848PeEo0a20JGLU0mzHXZhJhsple20rbOLRZ6tFJA0
         nKeFXV/a12NW72gtP6gi6iQbpvs5CMXWLSxEjX8RTixyc3suXQBisgHflAZA0ORMojW2
         eqFYxqhFoy++pmg7qHiM3l0GU4QXN0pLYyzDmRhyEc3yxRzWVQD1U8Bu3weN2cucgGy4
         dTj8udgqmyeOGbSJXC49gBqrDdigF6QXuqoyckXICxIOzla40tiQMnPI7W+Sp9DOG5uB
         9zehTyBtmo1i080tdyChNUFHBZLUx3ks2f2rzVuJYpiYIeY7T2MyvUlQ7CctPdclYxfd
         Hysw==
X-Gm-Message-State: APjAAAWBgUlGe0ynn64X39ylYXeHtc52JpdzU4wfAzL+j/unAhIXqfqK
        czFatQw9O3V7khAV0SWBMhI=
X-Google-Smtp-Source: APXvYqzqXrbpetuDc/BidY+qU6ZpZg8lYmpwDILy+v4W2t7qgEW20tE3lM3spSloekq0CATtqwYsvQ==
X-Received: by 2002:a63:c10d:: with SMTP id w13mr39638929pgf.312.1582647397881;
        Tue, 25 Feb 2020 08:16:37 -0800 (PST)
Received: from [172.20.102.201] ([2620:10d:c090:400::5:1dea])
        by smtp.gmail.com with ESMTPSA id y190sm18115629pfb.82.2020.02.25.08.16.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Feb 2020 08:16:37 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "David Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        kernel-team@fb.com, kuba@kernel.org
Subject: Re: [PATCH] bnxt_en: add newline to netdev_*() format strings
Date:   Tue, 25 Feb 2020 08:16:35 -0800
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <0C3291B2-E552-420F-B31F-F18C6F5FE056@gmail.com>
In-Reply-To: <20200224.153254.1115312677901381309.davem@davemloft.net>
References: <20200224232909.2311486-1-jonathan.lemon@gmail.com>
 <20200224.153254.1115312677901381309.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; markup=markdown
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24 Feb 2020, at 15:32, David Miller wrote:

> Jonathan, why did you post three copies of this same patch?

Er, what?

I ran "git send-email --dry-run" to confirm the email addresses were 
correct,
(mistyped yours) then ran "git send-email" once (without --dry-run) to 
actually
send the message.

There should be a single posting on the list, are you telling me 
otherwise?
-- 
Jonathan
