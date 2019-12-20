Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0421273DF
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 04:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfLTD3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 22:29:18 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36014 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbfLTD3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 22:29:18 -0500
Received: by mail-pl1-f194.google.com with SMTP id a6so2753211plm.3
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 19:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=46u3CLBKo67RcvMJdDrkSH4iCGahPOimkh+ezme2/3c=;
        b=xH859gUP3H5ts0nOpyG3vkSZPB5HJtES31XHs3zRNz3MZKgAkBIWLfymUZyMku9/VG
         rF6iwxWK0dRG3PbXZ/TL4l8iXoAi7tqgvxhbP8sBqArbYkqJiFd3opFZKC40oLGy5TE4
         ST1NmxpQgAsVgs18A7Thdl2fVklRTRCHlWWGYEpXtEGSw+VnNAyRVR8P9uRL49DCwNX6
         O9/hStJ84s1Xf8PM+lalEwjFPKkENmb+ZvWvVMR+B/YulRuBNRz+b5yUe133MVXhsc5d
         fSivQVyvN6102q8kLnLgCl+++S26q9MNNLsjcWXw7OtqsQPFEIwV0IuPg56q3R+JYnIh
         40vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=46u3CLBKo67RcvMJdDrkSH4iCGahPOimkh+ezme2/3c=;
        b=tnvJFgYht/CuDGRS4y9C0XJ45ip8m+nnMuvAlYJIYtUAA/R1V3lvAJFs8P6EZRk6Z7
         XXr4UGHnNn/2IHCzU5vg7jk9IUaQtbz95ijRVKXLZAvEbF/hNWLfpsIm1lVILcE1O7P/
         cdwYY21KEwm7U0uf/Dwjt9aQhNEGCJEGd6j5a8eQ3zHHYKVcjAU1+EgSU0Z7kdmcHetp
         zuOoI1AiC+o0LAAQ5T/LwtTJrYR68zVLiYvy1gRaUiyicAT/QQcQZ02PWL8+6iXP2gy1
         BwLMa/DHkyGYbwdeoBFN8xH7C5VxBHTWqi+uIl5wCQ1AGqjMALux1HHbi9muNWDdnOGX
         oYDA==
X-Gm-Message-State: APjAAAVWbasV+UrFS5WNNoXJIKdASb28wXSH9KQJazvBFSb3HXjL67Y/
        dM3RXOVbvXlvWFcuE5z/mhOSFA==
X-Google-Smtp-Source: APXvYqwiqTrrkxIUNUoNV+83P4j/0qzFtsK46ddLxPz//94W7nQSZyEpnYWXDEQomfUdJ6Q7x7g1Dg==
X-Received: by 2002:a17:902:b18e:: with SMTP id s14mr13180984plr.261.1576812557511;
        Thu, 19 Dec 2019 19:29:17 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id g8sm10154375pfh.43.2019.12.19.19.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 19:29:17 -0800 (PST)
Date:   Thu, 19 Dec 2019 19:29:09 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Miller <davem@davemloft.net>
Cc:     cforno12@linux.vnet.ibm.com, netdev@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com
Subject: Re: [PATCH, net-next, v3, 0/2] net/ethtool: Introduce
 link_ksettings API for virtual network devices
Message-ID: <20191219192909.5ed9996c@hermes.lan>
In-Reply-To: <20191219.141619.1840874136750249908.davem@davemloft.net>
References: <20191219194057.4208-1-cforno12@linux.vnet.ibm.com>
        <20191219131156.21332555@hermes.lan>
        <20191219.141619.1840874136750249908.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Dec 2019 14:16:19 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Stephen Hemminger <stephen@networkplumber.org>
> Date: Thu, 19 Dec 2019 13:11:56 -0800
> 
> > I don't think this makes sense for netvsc. The speed and duplex have no
> > meaning, why do you want to allow overriding it? If this is to try and make
> > some dashboard look good; then you aren't seeing the real speed which is
> > what only the host knows. Plus it does take into account the accelerated
> > networking path.  
> 
> Maybe that's the point, userspace has extraneous knowledge it might
> use to set it accurately.
> 
> This helps for bonding/team etc. as well.
> 
> I don't think there is any real harm in allowing to set this, and
> we've done this in the past I think.

My preference would be to have host report some real data.
But that might take host side changes which have a long lead time to
get done.
