Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E52EAEFBE
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 18:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436888AbfIJQja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 12:39:30 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:53995 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436886AbfIJQj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 12:39:29 -0400
Received: by mail-wm1-f45.google.com with SMTP id q18so309476wmq.3
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 09:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=UXaX6LIfpIrhrIywq41AegtECEvb4ncXLxWakjs8z0Y=;
        b=I63Tjnr88NdfAq+5o210IREM9+W7CmdEb/dplGl42YOMtvy0oxCF/PPhXk+7gTLI/t
         rbwqQP2yzxHiC3jg/gLLMTN9WKqyZbMGbRHatnlp20FH8q0a1YqmG1w3PZyJ7TI02cvS
         xfIVTwyQsY9UnGEyEKXyyOBKBscm/Z6lM1UxOkuFv6mNTOhhiD+AQKEg5uV7IMNVFZRr
         YWq7g2oIQkRaLHbw7dmNkZpgpoaClc0yUFiDDLSZBCZfiPVX3qJXt/KT3WT966uK3NiR
         4/MgCz+4s6vmOU75h+4AVxD+7SWBempwm5tTQQYqkZPEJ0dwyiKAhUiDeW73FFPwbAhE
         e6+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UXaX6LIfpIrhrIywq41AegtECEvb4ncXLxWakjs8z0Y=;
        b=FgZ10wC15ufIGbaEXcC/Aev68RgJkle63bSq0tBwCxQ3s34KiWA+WJXrv0Eb1vV7Qq
         a14Gx7Er/znZ6tQOqjyfGuYck1cO3RmQy83zBoxdKePR6GBBmjCmA4g9KppeAqN1q7Ti
         hGAz1qodMWWqJGak8D/Wvh+kpmbB5VvxGoSdUFhfHB6PDlxDJjOwhnmVJdtzoHHidmhw
         AE/sCF/WCJNshZdev3R6vd4TOA3Frls5lvy2SWTGnIYCC8PaZOSMYaGS3JzhfPL5oMH5
         wPBMRxxIuAGFT3EF3IMR714Ap6yc1rMfX9wtl2EEfTDjlzlZbxaB/vJxTTj2bO6Jo5t+
         FrMQ==
X-Gm-Message-State: APjAAAVy6e/1sgKgavWOoIPhBmOmmhFMh3qilOC4HEJpp7AqdUh+3Lm3
        mQrYHZ6NKTbxzg8IyiwC5Z93u9V7
X-Google-Smtp-Source: APXvYqyBpd9g0ZTP2qdt9Q5tynGkJDYV1vff1GObqmcf1fA+WS08WSzsByvLrj5BJ5aCXrHgD/vKEQ==
X-Received: by 2002:a7b:c3c6:: with SMTP id t6mr320599wmj.5.1568133567574;
        Tue, 10 Sep 2019 09:39:27 -0700 (PDT)
Received: from dahern-DO-MB.local ([148.69.85.38])
        by smtp.googlemail.com with ESMTPSA id y3sm16996531wrl.78.2019.09.10.09.39.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 09:39:26 -0700 (PDT)
Subject: Re: VRF Issue Since kernel 5
To:     Gowen <gowen@potatocomputing.co.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <CWLP265MB1554308A1373D9ECE68CB854FDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ad6ebee6-9fe6-0bcc-e88a-71fbefa2ccb3@gmail.com>
Date:   Tue, 10 Sep 2019 17:39:25 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CWLP265MB1554308A1373D9ECE68CB854FDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/19 8:46 AM, Gowen wrote:
> 
> I can run:
> 
> 
> Admin@NETM06:~$ host www.google.co.uk
> www.google.co.uk has address 172.217.169.3
> www.google.co.uk has IPv6 address 2a00:1450:4009:80d::2003
> 
> 
> but I get a timeout for:
> 
> 
> sudo ip vrf  exec mgmt-vrf host www.google.co.uk

sudo perf record -e fib:*  ip vrf  exec mgmt-vrf host www.google.co.uk
sudo perf script

I am guessing the table is wrong for your setup, but maybe the output
(or ordering of events) sheds some light on the problem.
