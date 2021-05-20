Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B782389ACB
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 03:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhETBRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 21:17:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38279 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229808AbhETBRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 21:17:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621473341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tYrSZOuV9yb9D7AmrTgNoYkcy6ULm548ITLIXH9HvS0=;
        b=Ag/ZpdnUReVMRMp1wM81L3WUQcjAboIX7h8Dv8zfBD8LUylarTdzSLHOAyzpYXSIY7yLRB
        ulI586Um6uK0WIkSjeXCLPhA+ZGZ5RI2mUc8cMFrFCBozoWREjyattM+PetsdgPgLnhC3e
        s3BrYgC6VB5L3fyaDnxo81oyIycmxGU=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-MLibNw45PJCshOPXl4e9BQ-1; Wed, 19 May 2021 21:15:39 -0400
X-MC-Unique: MLibNw45PJCshOPXl4e9BQ-1
Received: by mail-io1-f69.google.com with SMTP id s188-20020a6b2cc50000b0290456cc0f2184so2123733ios.14
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 18:15:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:mime-version:in-reply-to:date
         :message-id:subject:to:cc;
        bh=tYrSZOuV9yb9D7AmrTgNoYkcy6ULm548ITLIXH9HvS0=;
        b=b8Rpqsj/2/ihpNISqJOJ7eFd0X8/4Qt2tyfNvvdKe3t/dLbmczysqhfN4MHjYZQjKm
         cDYvWvDuJAwCxoMOgu32C8PERLlByvZy6myO8G2uidVC3ifYb1JEwYExtlZyq0JrGiUK
         tLc4761FJMqMekRvNtk4nKmIjA6KlnbiBvrAEfp5JJ2ecbAb5vSNGWgqfb2U+JrehIlS
         xwBmBP+bhO0kJBnRG6uon5MmbbecpDzd2akyvQyOAIZFKkrfc5gE7gmNKj+sbBh4P/+i
         Y2uihGCZQogjk/E7hV/Ab10S6r8699FBquk4uyZCErABt6w9I3yHhY1T6e15zol0+450
         ztTA==
X-Gm-Message-State: AOAM53118G2ViEPmh9tgwUvNacyW3S8bXINnkHDS4D1W8WbyivIwY0NG
        sgfv37WWJ8gExRRBtX/ueRkP9Y/uvkX8G+c/OJHU8m4Skbl4Yf8JbbCcUH5P532blDQS+YIyynQ
        iJxFE0JHSfCimxj/agDe/IfpNjn9xkL8+
X-Received: by 2002:a6b:cd08:: with SMTP id d8mr2879952iog.86.1621473338655;
        Wed, 19 May 2021 18:15:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+mwhlQ7lJTgOQHIWAsp25O0cowKsXWOQ1tmpY0vtIkM6sB1mc79eNcYS3jk5BUU60ymksbde1hqLbJucc7XE=
X-Received: by 2002:a6b:cd08:: with SMTP id d8mr2879939iog.86.1621473338490;
 Wed, 19 May 2021 18:15:38 -0700 (PDT)
Received: from 868169051519 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 20 May 2021 01:15:38 +0000
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20210518155231.38359-1-lariel@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20210518155231.38359-1-lariel@nvidia.com>
Date:   Thu, 20 May 2021 01:15:38 +0000
Message-ID: <CALnP8ZYUsuBRpMZzU=F0711RVZmwGRvLBEk09aM6MKDhAGrMFQ@mail.gmail.com>
Subject: Re: [PATCH iproute2-next 0/2] ] tc: Add missing ct_state flags
To:     Ariel Levkovich <lariel@nvidia.com>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 18, 2021 at 06:52:29PM +0300, Ariel Levkovich wrote:
> This short series is:
>

Is it me or this series didn't get to netdev@?
I can't find it in patchwork nor lore archives.

