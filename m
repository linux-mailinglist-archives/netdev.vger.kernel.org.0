Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F329218B33
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 17:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbgGHP2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 11:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729022AbgGHP2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 11:28:22 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A59C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 08:28:22 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id md7so1344370pjb.1
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 08:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RPtngnu4f3DvHnA6YFMs4k4HjElHJ0DdQk9AoUuCLXM=;
        b=jgvivYlDYmwTdINWlnQtLjDimFCsGeDMHUKGH0UnR+/j1TDr1VPT0SWtnzGTxbcs5j
         anHlq7w75cDvbbmM5kRooMUY8t9LiU853c3/y5z+2RmyT3U6Q/H2DE4D0g2h8Sqy/1Ru
         e79DkenIdp/WwRPj8svI50WmGHfYN3elIc9AF+xjRHcJjHUK+crDR/qFdVzcDl5pc6SC
         vA2QPNQdRIf8G3b9jYK3O8R0whKGOGCZuiaBb7QhE00CCApN/8EhEO6sf9T0thIZql1u
         hP9r+ILeImudR1GydVYcvjv3AZzQd07gpoyaot9V9IzWUWmpOQ5bKx1FSr2wN9BTNVtN
         qkNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RPtngnu4f3DvHnA6YFMs4k4HjElHJ0DdQk9AoUuCLXM=;
        b=FjpT95QipQStt5W7gEeEwTk2HTAes1XJSA57bLAX3RSZgz6HQj2ljO67Pc+iAX68kk
         bTD8pgN5uleAIvT9dZtBEk6fWSCwPqJSGVl+IPZ7vl/2D0/JM6vQUsggt0IB2WBnHePm
         wdp2HjvuC7A4sNpwByVBYqUvdKFll3Xjt6QVH02HD1vWf8dVpJkfY1e9IPTkYzoLJIm3
         II6cU+WN3CXivD85jCNlkc+O31dW+g6wohTLcKpQrLLI9ZHGl+/ub5MKxaAxJFyNjL/Y
         cEeqBYSkZ7240UlxjspygasiYFxRgZHea64Qy6lDmhgp5zntDf6OH857Qh6NpLsbAfCY
         c1tw==
X-Gm-Message-State: AOAM5333i6BTxUpU8a9WcQTOjR65QNRncO1Su5kx7WcyhtMvvoE9Y8Vf
        MVuYSZZSbmRQN0aK/KqugqMQng==
X-Google-Smtp-Source: ABdhPJyFBO84CwPymakIw4y9pvyyZ+xGF5WY3LjRBNtUr9xIM7Qto/WCDUU5lYbehp05w0EeiQBFkw==
X-Received: by 2002:a17:90a:2465:: with SMTP id h92mr9560900pje.26.1594222102428;
        Wed, 08 Jul 2020 08:28:22 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id e191sm222385pfh.42.2020.07.08.08.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 08:28:22 -0700 (PDT)
Date:   Wed, 8 Jul 2020 08:28:19 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Anton Danilov <littlesmilingcloud@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] nstat: case-insensitive pattern matching
Message-ID: <20200708082819.155f7bb7@hermes.lan>
In-Reply-To: <20200708123801.878-1-littlesmilingcloud@gmail.com>
References: <20200708123801.878-1-littlesmilingcloud@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Jul 2020 15:38:02 +0300
Anton Danilov <littlesmilingcloud@gmail.com> wrote:

> The option 'nocase' allows ignore case in the pattern matching.
> 
> Examples:
>     nstat --nocase *drop*
>     nstat -azi icmp*
> 
> Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>

Why not just make it the default?
I can't imagine a scenario where user would want to match on icmp different than ICMP

