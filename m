Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F6823131D
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728403AbgG1Tvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728274AbgG1Tvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 15:51:45 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316ABC061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 12:51:45 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id m8so4712056pfh.3
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 12:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nmXEvYxKEhE3HxzXZ6MSDqUYl1D9kSkFADdVhsus+ng=;
        b=E30CCYSK5o4bJEsu5ntKRmTehXscVN65vROUU4rTVzRuDzSL5MjO5++fJOQa6oI1gn
         RPDrJb5VcEy1gKs8qwbSBRNLj3xzgR75EMStrgqGRt6gYe3pYqZzpCTrA0dxUgGuNgUv
         HJXou75zogoz+Lu0T1LxvQIjc7hRffsEqXqSxi42d06VOGtJKBBqDEJ7PYA//VeognHD
         yk55ywopkJ+ZTchf/+ydgJnWmyQUK0/Ukk5CE5ND1R3idImh5dp9cxcKR1lIYQfWZ1gE
         1US67xVnyK/6bV2xx0qnkyXLUuVsUVHva/DxNv+PIsn1vr/vDKs8AyKclic+NwLy1/GQ
         jiGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nmXEvYxKEhE3HxzXZ6MSDqUYl1D9kSkFADdVhsus+ng=;
        b=cvVd72PF+veYXD2U5u9dPEPNNokWHxGMe1FA4zoXhFWhQapjizK1ocMcQnO6ObSFgf
         tADtYeqIDLwjUcPG0OT5ut0UQ5B8tQjy/nVwPJyehxlrWqOI++mhdCCOVDW3z3lERLGs
         zyeNS8TucWG9kBTawYrIYDtZXg0DGk5miYJx/PLvAS32Fb4yd0072wxhlORCKK1yfa9m
         2jX+2KRi5XJqIcPdcsSxAhQhpVJUS7sz/t99lo3hF0t11+i9SVKEVZulZwTPE+92TN9w
         4m2TMBaGsO4LI78P/+rERDE5T04ccDhTm1LgwmRZ9EHzDniNDh0/5oC/aTu2OMk23On0
         fjug==
X-Gm-Message-State: AOAM532Tf8tjNpOEjkJj/TvHK6w7kXX4ALASNEHkBpNeMHEStQgGkOPs
        sDIZfA4mgA3J8eOdFqE4aVyj2pQCwnuAzQ==
X-Google-Smtp-Source: ABdhPJxNqB3ECqXomIe6KIX/46bPP+QwPO+Z/NS8HM0JDRrbvPuZtUK98l9NSIfMtAkzXK0R46YVEQ==
X-Received: by 2002:a63:5806:: with SMTP id m6mr25992868pgb.362.1595965904452;
        Tue, 28 Jul 2020 12:51:44 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a67sm20342109pfa.81.2020.07.28.12.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 12:51:44 -0700 (PDT)
Date:   Tue, 28 Jul 2020 12:51:36 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: iproute2 DDMMYY versioning - why?
Message-ID: <20200728125136.6c5b46e8@hermes.lan>
In-Reply-To: <CAJ3xEMhk+EQ_avGSBDB5_Gnj09w3goUJKkxzt8innWvFkTeEVA@mail.gmail.com>
References: <CAJ3xEMhk+EQ_avGSBDB5_Gnj09w3goUJKkxzt8innWvFkTeEVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 16:05:50 +0300
Or Gerlitz <gerlitz.or@gmail.com> wrote:

> Stephen,
> 
> Taking into account that iproute releases are aligned with the kernel
> ones -- is there any real reason for the confusing DDMMYY double
> versioning?
> 
> I see that even the git tags go after the kernel releases..
> 
> Or.
> 

It is only an historical leftover, because 15 yrs ago that is how Alexy did it

