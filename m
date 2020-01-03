Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3CDF12F571
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 09:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgACI3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 03:29:06 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56101 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgACI3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 03:29:06 -0500
Received: by mail-wm1-f68.google.com with SMTP id q9so7675673wmj.5
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 00:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=d8QckrXtxP7FvoIRKyIsLQOJ71lgzvl6xXmzyIzStEI=;
        b=bnNSvMYeyjaAczA+PkMh93bUKFnlnYHcWW1IjcScGQwEtg1LAbkAVibbPFd7+z1lX7
         Bw1HFohTKPQeRusDPmy42U9AsVLWDkqsaizKlzi/QYTgLPtbnYW2wWjlqtupk3cpr8YQ
         PNK8AgNH2Lj8Qg8HywSbhpNDJi4FU0hBYa6k2fUJNjTgqT5plHmA35NfwBSIimU9LN9q
         4SYOJ108XdnIVW/g5bVWBB9i612UYcCqoY6dRLCmzGhUHkD/yYPgK6aAtgUTp9UUgCY+
         O5+2eyRC9SeemCkpIl7su8UNgY9ef1FEsxwcGPThq5VlFYEknJN1ofEULxJW0j0Wapov
         nEkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=d8QckrXtxP7FvoIRKyIsLQOJ71lgzvl6xXmzyIzStEI=;
        b=SW2bhr4tI/KfrRG3Arur3291gHrJ77/C+uGAig9Ym8DFb/SadE+AQv2tyPerTPblCG
         6SBzEDRRL9JOjMdD60+qL24eDkEs2NJIooXkzqGzRd21YVG7dIiByKClz1MUm7masrjN
         Uf4O/XZml/wQ4n0KJ+9TPlfoVouwyAR5/mXiZxCWQGoQV2vjQqXoIRCzdierVdpeD0qU
         J7yKlpd4VOiW5Cow8OmmvdOSAyof92fDIDcrR+RZlgv7VFnW3hYJZs3WaRG1c8U1BC8N
         eelj3RO6S3dnHj4YRxjz5sR1IjvfRjlNqR50cxWMwV2kKc48E+0gwHYI0Ubf2pAD1PWp
         zfHw==
X-Gm-Message-State: APjAAAW11/itMF8+IWpg9eAEhWyHS9t98c7gvN0Ri1eNHKCxaJ53+DvG
        Oc4RrvyFbGIrJceci1aWTdtj4A==
X-Google-Smtp-Source: APXvYqyB1m4XhEnTgly7Ix7Q3smfdLmVY2iHsEKJXfJu1fBYDYlNtlP1mVKMdp8yM2ifpjJ8NtHr0A==
X-Received: by 2002:a1c:740b:: with SMTP id p11mr19625288wmc.78.1578040144156;
        Fri, 03 Jan 2020 00:29:04 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id z6sm61226032wrw.36.2020.01.03.00.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 00:29:04 -0800 (PST)
Date:   Fri, 3 Jan 2020 09:29:03 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] selftests: loopback.sh: skip this test if the driver
 does not support
Message-ID: <20200103082903.GH12930@netronome.com>
References: <20200103074124.30369-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200103074124.30369-1-liuhangbin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 03:41:24PM +0800, Hangbin Liu wrote:
> The loopback feature is only supported on a few drivers like broadcom,
> mellanox, etc. The default veth driver has not supported it yet. To avoid
> returning failed and making the runner feel confused, let's just skip
> the test on drivers that not support loopback.
> 
> Fixes: ad11340994d5 ("selftests: Add loopback test")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

