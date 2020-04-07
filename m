Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0AD41A0694
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 07:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgDGFar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 01:30:47 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:51856 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgDGFar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 01:30:47 -0400
Received: by mail-wm1-f50.google.com with SMTP id z7so452109wmk.1
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 22:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pplo.net; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XVV232eGa4mla1ZlD7WydWfRNKQL9Slh9qy6Anr1YR0=;
        b=IsUB5CVTlENqxxX9SnTtDESw52Nls0CX4WyflRsBDnNtLuCiIZXzRLbf1MtY5VO3YI
         aD/uLxLznptHaQGgLT7k4u8LSmUZRCoNh0p9y+KxzrAvgfMYxslotauDEqghTZkL3xR+
         cB4nJzO5fPyOfvsNnq/DOAmLMeh45VrSw/3D8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XVV232eGa4mla1ZlD7WydWfRNKQL9Slh9qy6Anr1YR0=;
        b=FQEDcBtRS5oyejNpr2ygCdCl645yOmFN7oVt5gW9oLPi0Iz7hZc7NCpP65L3tb22r/
         x+HcioPIsYqwuhqDarpFb6xQLcuO6zM/L+jEtZtyFZvZ6kziSFWAHq/6hVijq/qki4F9
         WH44i8bvBzg/samfpBzzyZJy8r9dPrA2eIysGsMlLi3FxTOiviW+sI+YmgMZMp9c8ekf
         v3V2Ym3l75BtR7kcQmEPDibkFzYJiMZjr3py1dcRrIihIsPC7Uu6UKd+3JC4cWv9IOlg
         mgatYKCiECPCgtW6/oS0XOmCAFl86SqCk1879MtCe1sbTxGBNSkOMF22g3v67OaF5hEa
         zNUg==
X-Gm-Message-State: AGi0PuYhtzG6sgddYSDPEomLB5RbxCP9L1DiU6qjCcSTlSicvLT82sXR
        6wRkmCBnEjdCtuLc35Siv+ipMw==
X-Google-Smtp-Source: APiQypLwgmnsW3oyevK2DV63rqrT9auacr4BpBWA3xg8z1zYerwlFjiXEZlTxkN+qUGfDMjRTlzZQQ==
X-Received: by 2002:a1c:6146:: with SMTP id v67mr496895wmb.78.1586237445367;
        Mon, 06 Apr 2020 22:30:45 -0700 (PDT)
Received: from supernova (85.251.42.187.dyn.user.ono.com. [85.251.42.187])
        by smtp.gmail.com with ESMTPSA id q4sm2148795wmj.1.2020.04.06.22.30.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 Apr 2020 22:30:45 -0700 (PDT)
Date:   Tue, 7 Apr 2020 07:30:42 +0200
From:   Lourdes Pedrajas <lu@pplo.net>
To:     David Miller <davem@davemloft.net>
Cc:     Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCH net-next] selftests: pmtu: implement IPIP, SIT and ip6tnl
 PMTU discovery tests
Message-ID: <20200407053042.GB3249@supernova>
References: <20200407052040.8116-1-lu@pplo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407052040.8116-1-lu@pplo.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 07, 2020 at 07:20:40AM +0200, Lourdes Pedrajas wrote:
> Add PMTU discovery tests for these encapsulations:
> 

Sorry, I forgot that net-next is closed :( Please disregard, I'll re-post.
