Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806DF27457E
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 17:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgIVPjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 11:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgIVPjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 11:39:42 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B28C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 08:39:41 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id c13so21496578oiy.6
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 08:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=A8kug25xx7LS28snVa7SqfoVO+k+aheKuzyDU8XP1HI=;
        b=iNMVtuZZnb03bK+bz8kgA31hnTJAqcGJRFbACY9EzWnUF/Nc5KadLJH3gML9xSQG8o
         Vheugbdo3YKdQqAx4+3XAVr+xY+dEwHN/TDjjfDjkDQBFnK+B3BF0Xu+2jU+FNjJuEy1
         1MK2m/eDlz6n2gjULDBq7tarnOz0z1JMiKIYdRpwx21yUnfDMgaGBdPUoPaD1tDi665Y
         kgGo2ABp6E3H9QjM51KsFa+Zq8GeCyGtupwkPzs0avfwncvbRONuskCJnmgEgRFqLzNB
         7AJmCmInexTL6eUtqAlt5QdtsU1mltIFZvasoVRRtMXo9U81ZutOmz5+noEV69Gmly4d
         sAXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A8kug25xx7LS28snVa7SqfoVO+k+aheKuzyDU8XP1HI=;
        b=Uf2XG8E86RH4OdojPdK8Qr9l3ZGzS4rS7r1xAJefzZx02RWe4KyaALDkYKpVrKLLBM
         nf+l8PM/2AM4ImMiawklqPbpa9UP9fdWAyj9lpI/TFJohvx/f3aHLttpYT7lM0Jvnn1h
         mQNGZUX7P5ahHkQx1gJ8cA0+vCu9Ifkokl/S3hwXxKUyH02lXpnHG1GKlN5S3Nyp90Xb
         BuWOdteZ7BswHxsdNAT6yLn4xA/gMC6o9CILnTkJWaF+oa5hOhgHYNYXAMWDBQP0nXZL
         mUxavREOfRvF5aFWUqKzQtrBdjTp7cukKYBTR865bTzR4jiE29WWuUoyFc2ShXdE01pr
         eX6w==
X-Gm-Message-State: AOAM531Fszsj3WE+L+lT6sBNn8WueQOQu315fQnAAcUTxLzqNVlKx16U
        kmQEQ5pC3tA6Em5GEr/MMLUJdA/+yh8HhQ==
X-Google-Smtp-Source: ABdhPJxMKIeneHrqao6uCOm2C5kCOZn0P3GaCtYzmm0wkJzSai4dSqg6OAAZLQo0+34ATda3iUKOfA==
X-Received: by 2002:aca:5903:: with SMTP id n3mr3029458oib.159.1600789180984;
        Tue, 22 Sep 2020 08:39:40 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:b4d9:d40c:35f4:2d4f])
        by smtp.googlemail.com with ESMTPSA id l4sm7450555oie.25.2020.09.22.08.39.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 08:39:40 -0700 (PDT)
Subject: Re: ip rule iif oif and vrf
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org
References: <20200922131122.GB1601@ICIPI.localdomain>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2bea9311-e6b6-91ea-574a-4aa7838d53ea@gmail.com>
Date:   Tue, 22 Sep 2020 09:39:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200922131122.GB1601@ICIPI.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/20 7:11 AM, Stephen Suryaputra wrote:
> Hi,
> 
> We have a use case where there are multiple user VRFs being leak routed
> to and from tunnels that are on the core VRF. Traffic from user VRF to a
> tunnel can be done the normal way by specifying the netdev directly on
> the route entry on the user VRF route table:
> 
> ip route add <prefix> via <tunnel_end_point_addr> dev <tunnel_netdev>
> 
> But traffic received on the tunnel must be leak routed directly to the
> respective a specific user VRF because multiple user VRFs can have
> duplicate address spaces. I am thinking of using ip rule but when the
> iif is an enslaved device, the rule doesn't get matched because the
> ifindex in the skb is the master.
> 
> My question is: is this a bug, or is there anything else that can be
> done to make sure that traffic from a tunnel being routed directly to a
> user VRF? If it is the later, I can work on a patch.
> 

Might be a side effect of the skb dev change. I would like to remove
that but it is going to be challenge at this point.

take a look at:
perf record -a -e fib:* -g
<packets through the tunnel>
<Ctrl-C>
perf script

What does it say for the lookups - input arguments, table, etc?

Any chance you can re-recreate this using namespaces as the different nodes?
