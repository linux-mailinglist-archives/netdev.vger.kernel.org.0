Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86928215E09
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 20:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbgGFSLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 14:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729622AbgGFSLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 14:11:13 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B9EC061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 11:11:13 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id o22so12300795pjw.2
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 11:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8ViS6YsVxIUEwdT/q/D/7EEKtV4znaE4jaRtjjio1EE=;
        b=bRPF/3/HX9ZhqwxK+2Tj95t/ntT5JWBAF937L7nufqDy3J9ON1dxs8NlwrFwtSt83Q
         XZp/s6FXgy86YNwENyGqve6DPGAG36zgl0ao3a0cOFK8ZhFeHNhELEVaNDZMzyHRhnDl
         SS72K0D+ppTDpQ5UmqAfC9YZC5X/suTaPLS07SV9KUcpkTy31K8NSZpevlSIJIQanUEK
         Ne2avBJ2gE/DGsRWkYojM6PsdC/bOlzL0VL6OlK5eK+7OewsSkVbWUDF3cCTB3j/pzxG
         22yrtNQrAYIBshYsDsB8IaLiV8ibgy8nv+M9fpFGzZh23JSDXnrUbDdkgkac6qIfGWsC
         bcPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8ViS6YsVxIUEwdT/q/D/7EEKtV4znaE4jaRtjjio1EE=;
        b=SaNXjaDfjhwFbpmbNsCKMFxeT04zm2/7dK0H+uJ0uVQXLaOaF52Im4oLBMbe2uRF6H
         SCyaQUevzQtSM/gouC97qmbBGUf0vnrdyz1NM+Vyi93SbKSff+VgutkT2St9wIF1vvoH
         D/Y4ALzSHaFktVNy6ab2a820UsxFoZFv6SRBTUZXdeI4CXnYOR1dnFOiHvyP9E6oNENx
         XVq9KsiguQs4artLimSO0uQ+TDiTIs11IjdVS+c3//Koqez3wPbuoat3Pv1UHzYL/Koc
         TeivtOMxKGWtOxZwmCJLpIQiIh1kvgM0zWPCS3/K0nc4bppXAtosxedIf5ODRWvPmQOv
         lXOQ==
X-Gm-Message-State: AOAM532wb4k9CVWzB/Q2b3boSpZuHzHpjeLcHISnIjzJVIAMgLnfAexd
        k4YPCRfqX6krhOYbG1xOsmPVE9sUa8U=
X-Google-Smtp-Source: ABdhPJxRWE8Tt5QFAMoBAZejkbYrPKSwFqmqJ5TQ8RAZofAKb0JGUFDOfrw4aZxdmOskAhgyz1XqTg==
X-Received: by 2002:a17:90a:1b2c:: with SMTP id q41mr399789pjq.195.1594059072797;
        Mon, 06 Jul 2020 11:11:12 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y17sm9377645pfe.30.2020.07.06.11.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 11:11:12 -0700 (PDT)
Date:   Mon, 6 Jul 2020 11:11:09 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org,
        Martin Varghese <martinvarghesenokia@gmail.com>
Subject: Re: [PATCH iproute2] ip link: initial support for bareudp devices
Message-ID: <20200706111109.5039ed3f@hermes.lan>
In-Reply-To: <f3401f1acfce2f472abe6f89fe059a5fade148a3.1593630794.git.gnault@redhat.com>
References: <f3401f1acfce2f472abe6f89fe059a5fade148a3.1593630794.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Jul 2020 21:45:04 +0200
Guillaume Nault <gnault@redhat.com> wrote:

> Bareudp devices provide a generic L3 encapsulation for tunnelling
> different protocols like MPLS, IP, NSH, etc. inside a UDP tunnel.
> 
> This patch is based on original work from Martin Varghese:
> https://lore.kernel.org/netdev/1570532361-15163-1-git-send-email-martinvarghesenokia@gmail.com/
> 
> Examples:
> 
>   - ip link add dev bareudp0 type bareudp dstport 6635 ethertype mpls_uc
> 
> This creates a bareudp tunnel device which tunnels L3 traffic with
> ethertype 0x8847 (unicast MPLS traffic). The destination port of the
> UDP header will be set to 6635. The device will listen on UDP port 6635
> to receive traffic.
> 
>   - ip link add dev bareudp0 type bareudp dstport 6635 ethertype ipv4 multiproto
> 
> Same as the MPLS example, but for IPv4. The "multiproto" keyword allows
> the device to also tunnel IPv6 traffic.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Applied. 
Would it be possible to add a test for this in the iproute2 testsuite?
