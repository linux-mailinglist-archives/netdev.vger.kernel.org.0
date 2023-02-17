Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A861C69A625
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 08:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjBQHft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 02:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjBQHfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 02:35:48 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7450E4E5FC
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 23:35:47 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id n24so82913pgl.13
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 23:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W8lpu6BX5vI0MoOTZHmZNWsbWVN8ceQM7UsXsHOEkxg=;
        b=h6Gn9DNx7ghoNffhMEJqpHUMFes3dQR8BiWO07olOBF6bAGfz7iwK+Q8vEcmg2aPdu
         YTnzigf8mCPKSEBX420lqcTvETV/7KvRPk/O4BLos5B7C459/N71tJXDIAEyb0pDuOFQ
         4XP7Qkp9fmDiYR7pASHtEdJByox1zHJI3uPX+7gZzoD6KwL9cwc2nWroV1yIz3E/qli4
         4EwER2ts6xR5EUZ+pxXJL41PhJ0z8QMIJtGIZfXFbeNphNwEXT5a8JAn61+s5rWOEC3E
         ORFgJjIDTm9pWKu+tTELfQry0zbmTi/ke1MLSDXFw/RX64P2zg91iN9n5O0UL/uX4/am
         gB4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W8lpu6BX5vI0MoOTZHmZNWsbWVN8ceQM7UsXsHOEkxg=;
        b=Nfnmsmhk835+/thHruRfMBb31TEGrWE61JCWpEgJwAKXK+iQlLe5kxwRVMh3/KaOrA
         cTi7aIcCQgd4DjEqzUv2T7ASI0qK3TGaR/mQ4jcQcfH/zfJWAkkfL/k0LIiHr4mK3oA2
         ebbJVSzn2cH7Y9WmGs1OgnyJnoIWpAVOvfBmNL0+g95FiYib9ELua2joG+D9kItL7XFM
         RUJlAJkLpjACv2AypVgCWqH/+rJLabdBxzDrBrZ7TM658PZfkycod/tLd8MAb5F+fo1t
         LEUMeJtBHrgQSd0rZHhnSj3iYf+wQGKe8J5jOOT05wOzxdbkb9BdP60nO9boxvnYV39x
         Cyow==
X-Gm-Message-State: AO0yUKUibu+38Ult7z8hyvq/KV4WXo0BncGcHmRGrmXSktq6M9UaEezn
        XDoyM3558DByzZg9I9qgfOo=
X-Google-Smtp-Source: AK7set+9p6o1qZQNtszqU0NaJdF5b6LeNTGqNglDpCezZwGCHq+stPNHcY/LeWPFEcaumD0DruevwA==
X-Received: by 2002:aa7:9477:0:b0:591:3d20:3827 with SMTP id t23-20020aa79477000000b005913d203827mr8182833pfq.21.1676619346819;
        Thu, 16 Feb 2023 23:35:46 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h16-20020a62b410000000b0058d9a5bac88sm2374592pfn.203.2023.02.16.23.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 23:35:46 -0800 (PST)
Date:   Fri, 17 Feb 2023 15:35:41 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH bpf] selftests/bpf: enable mptcp before testing
Message-ID: <Y+8uTQERB5/JJ9sJ@Laptop-X1>
References: <20230210093205.1378597-1-liuhangbin@gmail.com>
 <6f0a72ee-ec30-8c97-0285-6c53db3d4477@tessares.net>
 <Y+m4KufriYKd39ot@Laptop-X1>
 <19a6a29d-85f3-b8d7-c9d9-3c97a625bd13@tessares.net>
 <Y+r78ZUqIsvaWjQG@Laptop-X1>
 <78481d57-4710-aa06-0ff7-fee075458aae@linux.dev>
 <Y+xU8i7BCwXJuqlw@Laptop-X1>
 <a7331a33-fc1f-f74b-4df6-df9483c81125@tessares.net>
 <Y+3lwZChsI0Trok8@Laptop-X1>
 <7aa20a67-962a-d60b-9f2d-6e22bb710c1f@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7aa20a67-962a-d60b-9f2d-6e22bb710c1f@linux.dev>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 11:04:33PM -0800, Martin KaFai Lau wrote:
> > Hi Matt, Martin,
> > 
> > I tried to set make mptcp test in netns, like decap_sanity.c does. But I got
> > error when delete the netns. e.g.
> > 
> > # ./test_progs -t mptcp
> > Cannot remove namespace file "/var/run/netns/mptcp_ns": Device or resource busy
> 
> Could you try to create and delete netns after test__join_cgroup()?
> 
Thanks a lot. It works now.

Hangbin
