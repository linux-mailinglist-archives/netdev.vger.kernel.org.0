Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B49FDDAAD
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 21:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfJSTUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 15:20:41 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36942 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfJSTUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 15:20:41 -0400
Received: by mail-qt1-f194.google.com with SMTP id g50so124953qtb.4
        for <netdev@vger.kernel.org>; Sat, 19 Oct 2019 12:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=f0g+3R31LRkR+0ekxv0emPPzou/yadzP62nF+AuV1FI=;
        b=R4fX6Tq7HyftvO789VVTyEvMjzaWEnQWUhQqI5+we9l61CsezZ/ONjMUR+s/HEiM5g
         VujIF65y5EhHq8mTrHAv7SwIrR/OdsrLk1Qp/uBxCUQpYBZ0UJ6zPvcVkqAII3vM+vnZ
         4Is3AmB25wUmcVJQW9EKXNXqIV/YY+WfFOiFT+7WFMuy2Dp43wfdqzpHFVXrkUVa9ryE
         fpUzh4AV8ABpwuefK7c+Gyp5/J7zUAzyp8EkA1jSlsFCkwMSjvnIw2qkj6Ot43rHQ2nJ
         uI1aVi8EoifTyVEoEFKyM2XSJ08kp7k8fYEXzfLx2Pws90sTai5Bmw69PUv4KsdqsN2c
         3u+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=f0g+3R31LRkR+0ekxv0emPPzou/yadzP62nF+AuV1FI=;
        b=m4B2ZX/hZjSD0qxodpoj2Rqiqeuvi3RawzD8V9N7HkYj8ektwLzKs7GYQB8ODRIfgK
         0khF6fEzkmUwT9n44SvRfDBMqUBiQjlVq4udoBBDv99wNxAdIPIDqCnBmYLZlFurX8kD
         PFXDN6C8MbkNvYEE0Yj0CKBiFMFZDKtxcK7w2p7FDdWIUX8UqgAOojMFI+jBKQjLHWEU
         jnZZOC9IC9/9xE+/SzysMQTszRXnBXvcG+zkc/Kr/vkefpnoxmbGndAYEAdKyJ62q1VY
         tyb6btQ/pcIzgzuTEbVk6vIYzcwoAWnaD3kGjcCfOw5UdmKqNYY3BvWu4LNdTuyXzXs0
         WFZg==
X-Gm-Message-State: APjAAAVoRKkMS076mvxM6QC80szlyD/yauChw4qK26pOLxWVnV6Yw8gi
        FoPCehXX9kudiArx3UOap7bE7ugZ
X-Google-Smtp-Source: APXvYqwUxPjAP5wSvbFmBi2cJt64PC+6Zri7vh1705/hsB5sGjc0ccTFK7JK8W9kXdrtIHiEwY1jlw==
X-Received: by 2002:ac8:1207:: with SMTP id x7mr16484064qti.255.1571512840504;
        Sat, 19 Oct 2019 12:20:40 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id j4sm4898639qkf.116.2019.10.19.12.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 12:20:39 -0700 (PDT)
Date:   Sat, 19 Oct 2019 15:20:38 -0400
Message-ID: <20191019152038.GD3419791@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v4 2/2] net: dsa: mv88e6xxx: Add devlink param
 for ATU hash algorithm.
In-Reply-To: <20191019185201.24980-3-andrew@lunn.ch>
References: <20191019185201.24980-1-andrew@lunn.ch>
 <20191019185201.24980-3-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Oct 2019 20:52:01 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> Some of the marvell switches have bits controlling the hash algorithm
> the ATU uses for MAC addresses. In some industrial settings, where all
> the devices are from the same manufacture, and hence use the same OUI,
> the default hashing algorithm is not optimal. Allow the other
> algorithms to be selected via devlink.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
