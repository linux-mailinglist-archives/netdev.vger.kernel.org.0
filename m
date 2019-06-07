Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22566399BF
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 01:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbfFGXhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 19:37:52 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:37935 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729810AbfFGXhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 19:37:52 -0400
Received: by mail-pl1-f169.google.com with SMTP id f97so1383804plb.5
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 16:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ACK/NfFFl41cKymew2w1DJmgIElM65sa88gYhGevkTI=;
        b=W3uL2EUBTJjTiFKqo19UbB3pVslOpyKq9M0EeSZEUjSZbiy7TGCLGMkb8M+IcLRhVe
         Rf/1+/QJLAwzYeclIUVJKLTIVkdNiLe40hhAugp2MxxPscZCssH33lrprmaUJPrBuwc/
         onShRau1PeUq/vis4aO2QT8HrtsB9B5eAQR/F8IyjTrBLvMd6sV9dhQU9ZOTpSMQwyE4
         19PsLBaCnQcslXSL7IXcagSppVUejEf8azG3lMgNyLbgM60Io/7Z+JgNPQV78wAgEnU2
         YDW8/z6TSEF46557FBfKW1K7xQ3hh2KXF0yh7SCQqjJHLqLg0yfTgXNvC8VHZF2PC35g
         uwQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ACK/NfFFl41cKymew2w1DJmgIElM65sa88gYhGevkTI=;
        b=ehIOLp6it4PdHgl/FGIrakb971rHu8GVeYNHwUWr9tT8D/KJz7iJ/P0QWQ3EdSu2a8
         ZXfkQqGRZiv89v/MUDr1yIOubZWt58x7BGkd5ckwf1dmSIcet5Uv5qCJBBApSLh/MG1P
         yvSxR4dRv8u1GQ7mjKXb8jH1pmd1GQsLEyqQroDpSs8O0Bl6RuOjMGpcE9bup5JVMASL
         zMoiQydWjztIXtloh6p5cUvvfA8zlJpS4qHPl61Cvk8SIWThtlD8hc7qGtsVoOxzBiw/
         RxEwn1XJ/AR4t2iMXuVpXvXJdlOZMT3Tr62l0KkLyZLVFxBeS6lGCvyVC/o94gvKgRqw
         D2uQ==
X-Gm-Message-State: APjAAAX3wrpMC3JakPwmwDnTIK7xBZ8Syj9ONEbMAoiBie3x03S0IY57
        /VUlWA8cfCKg//e36xcVIjxBZuaev/o=
X-Google-Smtp-Source: APXvYqwYrmeaHd+6GeMfqTn4HT35qwoWdiIFuHjaE3atAOAhAz8kaNsnYlbg0RmB/PY+hDzNRP46HA==
X-Received: by 2002:a17:902:2be8:: with SMTP id l95mr54900427plb.231.1559950671831;
        Fri, 07 Jun 2019 16:37:51 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id b2sm3074795pgk.50.2019.06.07.16.37.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 16:37:51 -0700 (PDT)
Date:   Fri, 7 Jun 2019 16:37:43 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2 iproute-next 10/10] ipmonitor: Add nexthop option to
 monitor
Message-ID: <20190607163743.6c47c8d4@hermes.lan>
In-Reply-To: <20190607223816.27512-11-dsahern@kernel.org>
References: <20190607223816.27512-1-dsahern@kernel.org>
        <20190607223816.27512-11-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  7 Jun 2019 15:38:16 -0700
David Ahern <dsahern@kernel.org> wrote:

> From: David Ahern <dsahern@gmail.com>
> 
> Add capability to ip-monitor to listen and dump nexthop messages.
> Since the nexthop group = 32 which exceeds the max groups bit
> field, 2 separate flags are needed - one that defaults on to indicate
> nexthop group is joined by default and a second that indicates a
> specific selection by the user (e.g, ip mon nexthop route).
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Acked-by: Stephen Hemminger <stephen@networkplumber.org>
