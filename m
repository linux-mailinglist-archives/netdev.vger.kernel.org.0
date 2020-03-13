Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1922D184D24
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 18:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgCMRAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 13:00:46 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:35540 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgCMRAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 13:00:46 -0400
Received: by mail-pj1-f53.google.com with SMTP id mq3so4658559pjb.0
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 10:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uNamY5coKxe7ax+3q4QRdu2InpY//4/lBAUDffNTZSk=;
        b=IuaksfItvQlxSK5JbDYhYeer7gVMH7PCKtY0RErKAQHH7gIQR+2looBz+mSq3d6eXK
         cDNyVqKZgQGw9OQyYZPYzi+Dg37RM4vD3JtxiwPDxyIAMaQwAab6IqrqglrELQKR2LAV
         IXBGwLtzZy9+EZ5UKqGK8dqwiDuA6IkaRnNaGxZAnTL2I2m0IKXRQG1WTkCQT+ej5duy
         XLaHktO2IAC2AQCuMAjMTO5crNw8+4tVZnoi77lsShX6uSBmJG7ph/QOyjQkhP9eYf85
         3g13dRPZzNHfrcY9F4bMc1eAK1YCuYNDtGLMa/Nf5G2sZdpp8EByQf0hJdCZ+PD87+VO
         cYkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uNamY5coKxe7ax+3q4QRdu2InpY//4/lBAUDffNTZSk=;
        b=kO0uBzfZfxnUQjtiMwElEY+jFRnD8/V9huSra4ljhzdA2H1mhau3NExqANU9C4m14h
         mGvb6DluJ1/p2MDqGOGx/o7sBF4x01jomnS9YABXbuS+dNZmaJWD6cD3piztJhZLnu37
         SOzAg7a9DLxIW49KsL+SZuix9xpdW9AQYq1LDdDPMH/T2vzXkjCqe0VQ35J7SpOi9aWE
         e89CWO30QTNwdqxPJepAXUh/Jsb1Fx2Wm1ml88QHwRrQzuHq/SbfnHfI+A2QOeonLwCB
         VNG/UIoeoiMWrtZbJep+s4r1ejkJ8eFuV8dBv2bLG4qVRmexMT5hDAuLTalwFu2dot7I
         vzzg==
X-Gm-Message-State: ANhLgQ02k97+P9kBizMHmHMJI5ziIavElt7kMSS6stVZ/cJrgjIknwyr
        NhArpnpFbysM+j0deZI2IB0Y/QWNSkk=
X-Google-Smtp-Source: ADFU+vtkEeNtdlUydCNRklNz4Fj0fxSKkHtmlZAUUBEz3vQPusagvXbsmMbHAEZ4657agbnM+lVByg==
X-Received: by 2002:a17:902:8609:: with SMTP id f9mr13636319plo.203.1584118844942;
        Fri, 13 Mar 2020 10:00:44 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j12sm42109561pga.78.2020.03.13.10.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 10:00:44 -0700 (PDT)
Date:   Fri, 13 Mar 2020 10:00:41 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Chuck <chuck@intelligence.org>
Cc:     netdev@vger.kernel.org
Subject: Re: How to set domainname with iproute2? (net-tools deprecation)
Message-ID: <20200313100041.374b26da@hermes.lan>
In-Reply-To: <CAPwpnyTDpkX2hxiqYLxTuMM38cq+whPSC0yoee-YPLEAwfvqpQ@mail.gmail.com>
References: <CAPwpnyTDpkX2hxiqYLxTuMM38cq+whPSC0yoee-YPLEAwfvqpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Mar 2020 09:21:52 -0700
Chuck <chuck@intelligence.org> wrote:

> I see calls to move the world from net-tools to iproute2 [1] [2] [3].
> 
> My Linux distro uses the `hostname` executable from net-tools to set the
> hostname, which simply passes it through to the `sethostname` system call.
> I don't see any references to `sethostname` in the iproute2 sources.  I
> guess the replacement is systemd's `hostnamectl set-hostname`?
> 
> My distro uses the `domainname` executable (which is a symlink to
> `hostname`) from net-tools to set the domain name, which simply passes it
> through to the `setdomainname` system call.  I don't see any calls
> to `sethostname` in either iproute2 or systemd.
> 
> What is the recommended way to set the domain name during system
> start-up without net-tools?
> 
> (Asking here because iproute2 is supposed to replace net-tools.  If this is
> not the right list for this, 1. Apologies, and 2. Where is the right place
> for this inquiry?)
> 
> [1] https://lwn.net/Articles/710533/
> [2] https://lwn.net/Articles/710535/
> [3] https://wiki.linuxfoundation.org/networking/iproute2

Iproute2 is focused around netlink and supporting the kernel networking.
