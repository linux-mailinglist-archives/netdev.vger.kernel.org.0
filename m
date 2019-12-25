Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8316212A918
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 21:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfLYUi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 15:38:29 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54880 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbfLYUi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 15:38:29 -0500
Received: by mail-pj1-f67.google.com with SMTP id kx11so2546935pjb.4
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 12:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4BozG8DLSXSs7oCobu9mp9eeYK8ny1yo+ErWyfAqdiQ=;
        b=TVa+q5sPtu6ysxJC2W6FeQQ31BStgRzAGz+4rh/XYboBEm7+BxvMbGEnZZPIvJL8Jh
         ygSPUi71VR9stmtEkOpPQdp0HEgMdlSgZ6/23m1AdLXVNddTHNlCRiD+kSazTCQv//zA
         994IvSa0bvCmyRAU6qY5l3ZVd7XLPYyOSVY5lC5BuEFeX3AjHS9pfyDyZvYXHICtzCDX
         pxAkA1JxguLHg/ec1fWBAgPxdV2gkd6pxQjUMC43uRj2VzD4rrBUAvqwuApHz0i7jUhf
         GuACzGuzfDNvKF8PdNo538zvWe5/4PoE4im3sPz+sYS4E2t+KuZkHDqyRFYu9YzHRArX
         38Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4BozG8DLSXSs7oCobu9mp9eeYK8ny1yo+ErWyfAqdiQ=;
        b=d5e/z8fR6/B930UrD0KFWsPWHvW5x+QWJEjvso3SW+uhRBGqSI9IZRt47YfDWMO1mx
         uStiOlXWbqUfVc2PuMo0vCzVl5eEQzqLrp+HlGGk03BPZgaCbUdByltVPwmJmvb2QZ/S
         jgFm8GEnELI6H4TWnzeTm+NuAskTbYATLIH+q0gq/0h/5Tc8mK1rvtL5g3x+kmhYIJMV
         s/i3qrRxQM5ho5uCH63geKSO5odBg1JZuPfdjlWj7e4hdYjqQ+WQe0BBoI9Y6g4UO4QK
         XJ62wqjjJLGhSf5lzVRCTVTohuqHq2gv42t7A2mGG/70PHC0Hx4NqBndolzjeCUBFZw1
         9WTg==
X-Gm-Message-State: APjAAAUqooOIhcpV0NnuUbmOJIfvgZkvKByToRHUNVDCtm9yPiitoBfY
        p95v9H5rIU4/EnuFhXOSmYnIAqAl8r4DZQ==
X-Google-Smtp-Source: APXvYqwkKAhfJAtppCbpZkYAlbCG9by0sR3okzc5TIPld3h3LJN011QdQyHo65Hi4DGqBXUJNRKSNA==
X-Received: by 2002:a17:90a:2486:: with SMTP id i6mr15607973pje.9.1577306308475;
        Wed, 25 Dec 2019 12:38:28 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j17sm6108748pfa.28.2019.12.25.12.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 12:38:28 -0800 (PST)
Date:   Wed, 25 Dec 2019 12:38:25 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Antony Antony <antony@phenome.org>
Cc:     netdev@vger.kernel.org, Matt Ellison <matt@arroyo.io>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH] ip: xfrm if_id -ve value is error
Message-ID: <20191225123825.4e4ddef9@hermes.lan>
In-Reply-To: <20191219141803.3453-1-antony@phenome.org>
References: <20191219141803.3453-1-antony@phenome.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Dec 2019 15:18:03 +0100
Antony Antony <antony@phenome.org> wrote:

> if_id is u32, error on -ve values instead of setting to 0
> 
> after :
>  ip link add ipsec1 type xfrm dev lo if_id -10
>  Error: argument "-10" is wrong: if_id value is invalid
> 
> before : note xfrm if_id 0
>  ip link add ipsec1 type xfrm dev lo if_id -10
>  ip -d  link show dev ipsec1
>  9: ipsec1@lo: <NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/none 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 1500
>     xfrm if_id 0 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
> 
> Fixes: 286446c1e8c ("ip: support for xfrm interfaces")
> 
> Signed-off-by: Antony Antony <antony@phenome.org>

Applied.
