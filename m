Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B63EBD05CF
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 05:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730363AbfJIDT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 23:19:58 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41958 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729658AbfJIDT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 23:19:58 -0400
Received: by mail-pf1-f194.google.com with SMTP id q7so644806pfh.8
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 20:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4NwVhfZ2GpbS1VR40X053QERnc+yaR5LjJjzrKzAyQI=;
        b=JsTi59wGXaZy+1l9YGVyHfapAF0YSTkab3+2zdRfNA27H7kSNBKPNKd0kBGm7e3RYw
         5nwdso1uPnaK3tjxMSZHB0JBPDa8HCz2GhRF/wI3t//GdXh/9SPN2nGrw3K6lQjfQldr
         Ac5L9WWqH01d5IOM62nVp19FwXDy3Dduea8xz2eshrK6VMh7sTg25lPqhbsIsuj40K3G
         gmVQugh3jxMb6AvCnqFNeXZLkxe7Z6WW194LXbFhY53iUoL6aJLBYCx966e1Qcb/Hrzy
         Sv795KtOoTG40Hyjtw2fRorcxNsKkaXJ2vSIcPwk4j4RHn52SOkLAKNKFxY+sfOB9/1p
         4McA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4NwVhfZ2GpbS1VR40X053QERnc+yaR5LjJjzrKzAyQI=;
        b=knoumom+IQr5UsHRA3M9jNYs1R8GvHKzIafkuGoiwsXWbLH4j1eb//57gWGck6VERZ
         KpkXDa4L2FArZvjZMCK8WIhS5HOoPzKgu3yu+6XoN7rMmdgHGh+0Cz3FtzaspA/c6R23
         0GDS96VYBahZoBxLVa64PibyUAp1XnhH4P/ox544wZPie0WKeIYXuimJTxgs1j6HsWZq
         o7a+hLbWm7NI1irWqp3oWT89ZtiwWO2+Rf9OMjkqlrPkCnIRGG9sSAYvDMqG9l03UQw6
         1bqO1+CPJi5dG2FW6uWtjkKilrXkWSQATViWxi9eFsc8ANx5a8LfwerprCuaZthNeAPK
         lHTA==
X-Gm-Message-State: APjAAAXafAOEqYinULqIsRk6Q3rScaJecJbcoOhgKds+dnDQ4eU4UJbw
        t7Gz8oyv6pQWqxuWTfSU362J+a230eKdLQ==
X-Google-Smtp-Source: APXvYqzxoX45tUGP02dmi7gmDXDbFcYVH7E7zB6GQExqBp1uItwvoiZ3KWcUEc3UdA9foHBca1LDqQ==
X-Received: by 2002:a17:90a:a406:: with SMTP id y6mr1468350pjp.120.1570591196415;
        Tue, 08 Oct 2019 20:19:56 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id r21sm582911pgm.78.2019.10.08.20.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 20:19:56 -0700 (PDT)
Date:   Tue, 8 Oct 2019 20:19:49 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     netdev@vger.kernel.org, scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: Re: [PATCH iproute2] Bareudp device support
Message-ID: <20191008201949.3cd766b9@hermes.lan>
In-Reply-To: <1570532361-15163-1-git-send-email-martinvarghesenokia@gmail.com>
References: <1570532361-15163-1-git-send-email-martinvarghesenokia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Oct 2019 16:29:21 +0530
Martin Varghese <martinvarghesenokia@gmail.com> wrote:

> From: Martin <martin.varghese@nokia.com>
> 
> The Bareudp device provides a generic L3 encapsulation for tunnelling
> different protocols like MPLS,IP,NSH, etc. inside a UDP tunnel.
> 
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>

When you resubmit this should go to iproute2-next
