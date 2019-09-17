Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 891EDB55BC
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 20:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbfIQS4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 14:56:02 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33490 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbfIQS4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 14:56:02 -0400
Received: by mail-pg1-f194.google.com with SMTP id n190so2503022pgn.0
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 11:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=viBWm5k+WLBE4ltb0Jw4Ip1TJ6rxPc0/gxth4GcDklc=;
        b=JJttJZJhO/Agd9pDlAKRI9N6eSlhkTPSgOyoFV/Rl4UQ21yYgYnIb+zk4bUCCNgMkP
         9eCc34Z3Joixh0mzekILgsAPfRaIYMoLQj81La9m9QAvagF/knE7JZ9iF1iNAbS/+kfS
         B2Pw++xMVggsOb2lWciTHpwy7iRx2vXsd9aiWwjinttZz3m/UX0gTKgv5LtRCOVjjOU9
         xHMx0GxlqCPUxLYLSpoiGxrEfRrpzLKDy4rD6ugRcjUaVsSxtJIjzvFrmKKRBnKmp+y5
         c0dbVWMJtdJQr4lt9/NK20vB+bv1j6j2OXHGFXdLIB3oAGNgVuhH2OupEVJVHtCJRvRe
         M9yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=viBWm5k+WLBE4ltb0Jw4Ip1TJ6rxPc0/gxth4GcDklc=;
        b=BIIRqZwoOE1COMCTqIeYl1U9AjU3RurJrx93xSPU14hlixIl/1D+SHXgqV/5xgmZKN
         gxKzU6+LSkEu1ilzrqkIF37ZIlK4oZ/MPd2NLZxkyjoHPCxRbHH1girVm2dUPYcQU9Wq
         ihHJon/YFMmDZzu5PKAvCbmu9QqLIlybKLPtxSZe7kA1qsW0hRRW1UnSJj0CFfpeahn8
         4JlNjGI/Rh5IrJueJBkh/TwWWzPyHsgOdTFp6zSaJkWUQDftPmdKCVkz1iRgaRo5bVOj
         wHtD9FnRn+c506fCtLUGicbDVwsMe0CXb7oEEUGh5Mb74EAol9TlVoGujnfOcKnb2aSO
         O5MQ==
X-Gm-Message-State: APjAAAWsqgRhcTliZg9jgikV8mthizXhEyfqJgVR9FWae1OwccBeUjVO
        ZW9F0jmPj66wEO2QnY0ZgLtj3NZ/jDo=
X-Google-Smtp-Source: APXvYqy7le2tGVdyB3mTKUh8Ccll0EI4gl2nHh2oeFV0rqTfj72A7oS7leI1krJTQNwXCYWW5Jo3Dw==
X-Received: by 2002:a63:3805:: with SMTP id f5mr305560pga.272.1568746561163;
        Tue, 17 Sep 2019 11:56:01 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:3d30:b2cd:f8d3:669a])
        by smtp.googlemail.com with ESMTPSA id q20sm4563591pfl.79.2019.09.17.11.55.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 11:56:00 -0700 (PDT)
Subject: Re: [PATCH net] ipv4: Revert removal of rt_uses_gateway
To:     Julian Anastasov <ja@ssi.bg>, David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <20190917173949.19982-1-dsahern@kernel.org>
 <alpine.LFD.2.21.1909172148220.2649@ja.home.ssi.bg>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9afca894-3807-632a-529b-7ceee4227bcb@gmail.com>
Date:   Tue, 17 Sep 2019 12:55:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.21.1909172148220.2649@ja.home.ssi.bg>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/19 12:50 PM, Julian Anastasov wrote:
> 
> 	Looks good to me, thanks!
> 
> Reviewed-by: Julian Anastasov <ja@ssi.bg>
> 

BTW, do you have any tests for the rt_uses_gateway paths - showing why
it is needed?

All of the pmtu, redirect, fib tests, etc worked fine without the
special flag. Sure, the 'ip ro get' had extra data; it seems like that
could be handled.
