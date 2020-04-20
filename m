Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1731B1727
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 22:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgDTUbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 16:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgDTUbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 16:31:42 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6E8C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 13:31:42 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a22so353659pjk.5
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 13:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2+zi3reqJJ/j1XwoOD2Fg4wdVvgSi2y9lZyyQ3CUI+Y=;
        b=RpiYDVnUpgcnNWAIJ7nLwn5S4PBY9JhGDxS8QgVJfjQgUQsp7p6P6Xq+7CVr6x/d0d
         YAP4yxtYWfANqeIQp1yhg6okOHpFNw2rvXuNSN3s61PPpc/Bu7eagmEf2YhqbcAAsNdL
         KaKhAXQsj66Pc6Wt63TNyhPDpZIkGZffBmVNhJaMUbZj3bXm3RBD2h+1mEebTVcIdAAi
         s/skOAOZHRTuApyZnpC7ohUHQkyjOLWCitcm7RLvFcimoBFD5INQVq/GatlaHFxXsalV
         n6lRIgViFKUSPSvIP5wcNDgbFHuH87VquJvVTuihyy+R5sWuVMNbkq318UheXlIvBveo
         ebrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2+zi3reqJJ/j1XwoOD2Fg4wdVvgSi2y9lZyyQ3CUI+Y=;
        b=rsn/jBCNndUUP7hExofbbE5CoruzRraH+P5CZLEhRtXG/bTN9V8Vw/cI4Tc2bekglI
         CdMdeKQ4O5JSIxxSVSSkbFVgQQ1zQ856btfwYLMqav6emlTAAb9ulotrDWTcfznQ6tdQ
         P4Txa4TVAJjIfm6rHHJ5kVNm58LXc4EctCZ4Sl1jL5FDhfQ8mTvirN9JZnvNyLoRO2XO
         7qNGRBClTP10KQrIpLR4mscwSaYm74I7HDulsWQ0eoMO/gBhg/n8+KfCdSn4X4UcHsqW
         RLAKhXg5BHfvvlQRI5bpoCkeWCBFvSg/37tZTDrwKn/hGti+Q0FzjMXiGL0vtn6cgSZ8
         aEfA==
X-Gm-Message-State: AGi0PuZvzCkbEkvjHcN2wcOOAZLnjikmUKcnBmIM9ioWzpUntaLkasuZ
        KTqvJ1zL+a0qxjfl94GwgZ1wjA==
X-Google-Smtp-Source: APiQypIW7w2QNYFc1kT4a32mO2ARe0lzgAIuF84MErQ34vcatsq/6019WpzYDMZKT4NEuaM03tqXJg==
X-Received: by 2002:a17:90a:df88:: with SMTP id p8mr1404824pjv.119.1587414701875;
        Mon, 20 Apr 2020 13:31:41 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id l63sm199026pga.83.2020.04.20.13.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 13:31:41 -0700 (PDT)
Date:   Mon, 20 Apr 2020 09:37:04 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Odin Ugedal <odin@ugedal.com>
Cc:     toke@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] q_cake: minor fixes and cleanups
Message-ID: <20200420093704.591e8082@hermes.lan>
In-Reply-To: <20200415143936.18924-1-odin@ugedal.com>
References: <20200415143936.18924-1-odin@ugedal.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Apr 2020 16:39:33 +0200
Odin Ugedal <odin@ugedal.com> wrote:

> Some minor changes/fixes to the qdisc cake implementation.
> 
> Odin Ugedal (3):
>   q_cake: Make fwmark uint instead of int
>   q_cake: properly print memlimit
>   q_cake: detect overflow in get_size
> 
>  tc/q_cake.c  | 15 ++++++++-------
>  tc/tc_util.c |  5 +++++
>  2 files changed, 13 insertions(+), 7 deletions(-)
> 

Applied, thanks.
