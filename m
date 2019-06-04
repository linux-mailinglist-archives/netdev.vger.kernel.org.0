Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39E1D34E4B
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbfFDRFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:05:33 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45493 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfFDRFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:05:33 -0400
Received: by mail-pf1-f195.google.com with SMTP id s11so13045099pfm.12
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 10:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hYl8/cp8i3dy1FcuvZHpVy+KADfbqOoLJVRz175pPaM=;
        b=DR7RyvtBZbbotQ7akUbkCEvJmNVG8yxZOpBEKp/gtogcUZK21m2a+vsE6Ss6aVGdhW
         cxcb2ZhXUVptwn+IwKh/jTR3mDedewxyF/YwBbbmV8dhYDlo2OC6oSJuEq257jdxL7pO
         tVAeScOGfriso9sVxSKgMeX/wGAb9GUpYAQZHn+3LJZd3F0cF5UcjWPbRY9iqac6v6rs
         WcL3q1dosPqEm7JJARRBnOSvcASniGB9PpmXzwUlKrH4D7OMjqO77TjPJPdMN7RCc0+D
         ca7qYqvWNoHEXuZVa4DFfZyXv2gvNVHfm1o4yle6Vyt4WJMZ4w9nu8C9ffbqYMmrwU0A
         V99g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hYl8/cp8i3dy1FcuvZHpVy+KADfbqOoLJVRz175pPaM=;
        b=FV1yBpu0kQJHApCfnEswUmCmNsTt1KIbsMJarvvkassPrEedze82ryeqfzah/TZBty
         tNcllx7TeQAuU0U1RBx6IKbqdwcuqKj6sOm992rWGlNlSYwV5wpD/BC95T6Es7uoWh9o
         rRG/eootae2+zZsUwX8JCkqK2FZVOGYxhaFQMYpaOHzz5OgQY6DxkkAuMo/K2kkIMdma
         WH5ECqlhBunRj318smRyeRmR2bLwLOtJY+fRc+Tg1OzsbwwOSrksJrTXHw68GoPym4vw
         R8SIisYXkS0pJcXHYAgHNIIzYc2NeVku2OZzSQ3/R+rlY+e+BZzsznJrxR/XMtVegYsn
         /kmA==
X-Gm-Message-State: APjAAAXJV2HhPrUppISC2vIAOP8FrEGpu6H08V/ts37SFwR0KkYCQJIo
        qabuX3AHD+e990kcUy/lezTbd3nG
X-Google-Smtp-Source: APXvYqysOvL3+UIF2IJjmFenlX+ZCGVPv7wr8LbSfPdaaJ+KkhfwBdkp3QttWuZkVEsaR5ZD+c/kpg==
X-Received: by 2002:a62:e041:: with SMTP id f62mr14551683pfh.128.1559667932689;
        Tue, 04 Jun 2019 10:05:32 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id w62sm6257121pfw.132.2019.06.04.10.05.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 10:05:31 -0700 (PDT)
Date:   Tue, 4 Jun 2019 10:05:29 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        shalomt@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 9/9] selftests: ptp: Add Physical Hardware Clock
 test
Message-ID: <20190604170529.5jhoexeeqdw2msqd@localhost>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-10-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603121244.3398-10-idosch@idosch.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 03:12:44PM +0300, Ido Schimmel wrote:
> From: Shalom Toledo <shalomt@mellanox.com>
> 
> Test the PTP Physical Hardware Clock functionality using the "phc_ctl" (a
> part of "linuxptp").
> 
> The test contains three sub-tests:
>   * "settime" test
>   * "adjtime" test
>   * "adjfreq" test

This looks useful!

Acked-by: Richard Cochran <richardcochran@gmail.com>
