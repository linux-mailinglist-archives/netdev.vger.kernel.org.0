Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2B9281B65
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 21:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388401AbgJBTNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 15:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388365AbgJBTNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 15:13:21 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2051BC0613E2
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 12:13:21 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 144so1947316pfb.4
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 12:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4E58JDWcyE9kHD+mQNg34Irk/7DDzMGRzQkdVU3JrAQ=;
        b=ytUa4lMM03Lk/3vOWIwHDchVWLwTbBS+psnP0aqtOMfQplZiPbsxZ5IhvpU+NxGJnF
         5X9XhhBWk2sTfhepgaiaT+ytA9xSjw7Yrv2BxGmowDMg6d13i3FAOB8p+moegDR0zY8f
         mqVSFGj/EpLPAGGhK4IJKG2ttesIGD6Qk9HoeHsVSvZajh68j6m3PN1lp7ciKZPZDytO
         9tklsc556dwDJC23qspyKwy2jEUv4K4STEcvrhcm4XgZd/Nmau6cQje120RRfJljl7v8
         g/uvoRhBmgWVa+HKxHzCYhX7vsBRC3ujPOI0EtuwQyMNbzkrcBb5vM6CB9N8lWOEXo3U
         1NBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4E58JDWcyE9kHD+mQNg34Irk/7DDzMGRzQkdVU3JrAQ=;
        b=fiNfCKG1SvB2VBIueLn5aKSVQLN7XfPTMxGivwjNrmrSi7Ep/yR14dh5OQtXNMXhKx
         H3ZNV2sokikDTsunGeybHCIDsbpBxjJIZPR9mX18PXAkMA9E8EOGvPFuWZ213hxfYPSU
         pTRsFUMM+KqyarsraVrqhRb3UzlpVgg+GL2Rv7bz8ghZU9JTc9xiVjKbXAPzbUv4S1q8
         PAtLlP07ItiVySH+La73QPcId0VlVyC0C8GtDuqqvZTV+cKx6cCzDr1isdz5aHnQEmk7
         oNEySqbMJw/23N2U/KXm8ZgNSWDmyQACE+W3wZmG3rvJjLVjyh3jXEssPZE4es6MNFaX
         oMRQ==
X-Gm-Message-State: AOAM532L83XH88rOkqRlv0z9oAdIwUIL4oPBi4WUG7TLqpcz7YlGawhx
        88+6FWCi/QZg/NxitCQIjmC9SDuQO+YEXQ==
X-Google-Smtp-Source: ABdhPJwWjUANm1SSr9bTPMgtcY0BxAcpSbDKXj+7xVHyDV4BV7WPuTsieg/+DQkLC7h7cBiNpYKF8w==
X-Received: by 2002:a63:456:: with SMTP id 83mr3776594pge.210.1601666000662;
        Fri, 02 Oct 2020 12:13:20 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t186sm2372583pgc.49.2020.10.02.12.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 12:13:20 -0700 (PDT)
Date:   Fri, 2 Oct 2020 12:13:17 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 6/6] bonding: make Kconfig toggle to disable
 legacy interfaces
Message-ID: <20201002121317.474c95f0@hermes.local>
In-Reply-To: <20201002174001.3012643-7-jarod@redhat.com>
References: <20201002174001.3012643-1-jarod@redhat.com>
        <20201002174001.3012643-7-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  2 Oct 2020 13:40:01 -0400
Jarod Wilson <jarod@redhat.com> wrote:

> By default, enable retaining all user-facing API that includes the use of
> master and slave, but add a Kconfig knob that allows those that wish to
> remove it entirely do so in one shot.
> 
> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> Cc: Veaceslav Falico <vfalico@gmail.com>
> Cc: Andy Gospodarek <andy@greyhouse.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Thomas Davis <tadavis@lbl.gov>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> ---
>  drivers/net/Kconfig                   | 12 ++++++++++++
>  drivers/net/bonding/bond_main.c       |  4 ++--
>  drivers/net/bonding/bond_options.c    |  4 ++--
>  drivers/net/bonding/bond_procfs.c     |  8 ++++++++
>  drivers/net/bonding/bond_sysfs.c      | 14 ++++++++++----
>  drivers/net/bonding/bond_sysfs_port.c |  6 ++++--
>  6 files changed, 38 insertions(+), 10 deletions(-)
> 

This is problematic. You are printing both old and new values.
Also every distribution will have to enable it.

This looks like too much of change to users.

