Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74D0F108684
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 03:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfKYCiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 21:38:07 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38733 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbfKYCiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 21:38:07 -0500
Received: by mail-pf1-f194.google.com with SMTP id c13so6616128pfp.5
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 18:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=kEg+SJMU+SXJVSClKxDu8d6Lp+gpZWzofzICUSfa2TI=;
        b=egb17RErMltcDdvpUzVgAS96z29LRGJ92DlBfZRSS9Bx/mLW9x4+bREVJi6CaFY24O
         kA8cQXywYQpIVtzX0sCq5sRQIJkvgh4SXTYrsMquaU1ky481cwbTfKt3CIvwqkvah0ko
         d/3xPiQXP/CTfW981tN1U7PEHnyxR6w6X4XsfE63LkK0I0wun+D4PvufCc8tJYcLJMzF
         wptaDvBhw8gRMAk+kO5z9IKKqmrNlYaEVz5aK3sOnRAEIa7yLW0ycaFXoNQs1BnA3312
         7gkenkySpZygINUU17BVHa+1pdYPKG0s1em5h4+iMzDBPYI28NdHXox6b471PwtxoGJB
         rcDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=kEg+SJMU+SXJVSClKxDu8d6Lp+gpZWzofzICUSfa2TI=;
        b=JcReDINVcphy94peN5xRAeNmuabHsDiauqAMjJNGGY3l3NPL1woPZAAafjo1VKb++V
         iDr++UwLeM9SQjCiuTkxwFlkWBV0Vyr3jKt5VI8vwnmeXEKD9NWXNckWfwpobKsjvJM2
         3gRYoRAjbEGiEhRNoqpvFOWZOokUvdY8++e6OeYgeZGQmEzOJBtS6nNVv17FEfPWnkK8
         4PHyBXVfuBxLqF4p5AThUuy7Vskl3IFqzbN2Tju8d66dHP7KyxnDK3mtjroJUvK9gcov
         ambdJnkzZRDG+d7FDycsiu2W92tJIZOk3kDGSDIVwQw858xclvGB7MD5l5uCBCQTNBLo
         hgEA==
X-Gm-Message-State: APjAAAW9SNh3DxPq9lscELpD2Vf5Jf7wEOvVdbfy6JCa3pvbySn/Otvj
        CaVum7NB6hgqWLRMx2jg4bl0zA==
X-Google-Smtp-Source: APXvYqzDMJ2DqQxVHIGF8nza3JFCwG6y8pg9m0YVg2BjzhL4l2uOtjnhcEvTRj9BqkgvTyrOaECE5A==
X-Received: by 2002:a63:ea09:: with SMTP id c9mr29716237pgi.232.1574649486900;
        Sun, 24 Nov 2019 18:38:06 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id h185sm5866687pgc.87.2019.11.24.18.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 18:38:06 -0800 (PST)
Date:   Sun, 24 Nov 2019 18:38:00 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 0/2] mlxsw: Two small updates
Message-ID: <20191124183800.3edcea2d@cakuba.netronome.com>
In-Reply-To: <20191124074803.19166-1-idosch@idosch.org>
References: <20191124074803.19166-1-idosch@idosch.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Nov 2019 09:48:01 +0200, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Patch #1 from Petr handles a corner case in GRE tunnel offload.
> 
> Patch #2 from Amit fixes a recent issue where the driver was programming
> the device to use an adjacency index (for a nexthop) that was not
> properly initialized.

Applied, thank you!
