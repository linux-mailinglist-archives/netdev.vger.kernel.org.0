Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50ABC21741
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 12:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbfEQKue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 06:50:34 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39567 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727727AbfEQKud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 06:50:33 -0400
Received: by mail-wr1-f66.google.com with SMTP id w8so6625089wrl.6
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 03:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=fy6ato0mdZ+343xSDfiKvFVjKi7omzZdGMuv/1R61jE=;
        b=UyHPsmHCDoLhomdBbMfbRg5J1rPMpuyjchhnP1zKjvFfywm0yvRihlRohB5oD+Dfea
         S2ixIhoIfAKakOEFgVn/bR76iznUWQ7FdLlnI8HqZuQ3amK/6pS1XhkJ29hQF2R4IStR
         zepElaDIAMiFHfAEM2QvHgd9L+ADuIiepypLXmD5bMLHnAFxsx9axQCB1cabimwTKhQT
         iB+Wat5KoDy1NLOvU+MskFh5zn2/e2LpZRW622VacW7T4Mg4vNtZQeh06ufD6+wLAJ9B
         Eem6DWGWow6S9fdQ5B2efbFRxlWPcQi6ZAwc+RjlcAztHmroeZ2ZPcbE0MPYIQdYWozs
         +okw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=fy6ato0mdZ+343xSDfiKvFVjKi7omzZdGMuv/1R61jE=;
        b=CS3+18W/Xl6ihOC4SktD247JNe81LmkhHF1jbhTMLzW//Mo5YZZUMM+I0GNEUVkxz/
         mPTeFaNg3lIFeWnxxX28IRFvXV3t9zljQrw2wgVm3rCsRbQcxwcaZPEjtYahe+PvJDN9
         7s3PMwbrqeyCBQ9ZZ4F915+EWHGM3LTV3Ph93P9udcPXXv/3Huwsnk+n5fkNp1VvKgq3
         BCxUG3IDVDW3S9YeXbZxqwQ3y3AOHGrNE40PrCw+t6j5PG+ZN4Dd0sHPZKMGGFHvIFi3
         aP4SihbLIWT64wgzkdetHBb6HOvl8MuUdvXhvdHY6LuofMmw0vShvvkki5dDxBoH6GNZ
         2Yxg==
X-Gm-Message-State: APjAAAUoqaqtiFlP8Yc9r2BnEKMpKFHaJ4qHoZWWpMK/DR1KQQrjAh6J
        bVdrDqIOFjn/+YvKZv9Gnn7qkw==
X-Google-Smtp-Source: APXvYqyqtAU6a63fClrYVQgQgQYERgFK4EvgGfWGRJC5cl2XmpSYtf5nveRsqu1iBqskymWNQq1IIA==
X-Received: by 2002:a5d:6610:: with SMTP id n16mr25864841wru.250.1558090232250;
        Fri, 17 May 2019 03:50:32 -0700 (PDT)
Received: from dell ([2.27.167.43])
        by smtp.gmail.com with ESMTPSA id y184sm9227716wmg.7.2019.05.17.03.50.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 May 2019 03:50:31 -0700 (PDT)
Date:   Fri, 17 May 2019 11:50:30 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Philippe Mazenauer <philippe.mazenauer@outlook.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib: Correct comment of prandom_seed
Message-ID: <20190517105030.GV4319@dell>
References: <AM0PR07MB44176BAB0BA6ACAAA8C6DC88FD0B0@AM0PR07MB4417.eurprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AM0PR07MB44176BAB0BA6ACAAA8C6DC88FD0B0@AM0PR07MB4417.eurprd07.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 May 2019, Philippe Mazenauer wrote:

> Variable 'entropy' was wrongly documented as 'seed', changed comment to
> reflect actual variable name.
> 
> ../lib/random32.c:179: warning: Function parameter or member 'entropy' not described in 'prandom_seed'
> ../lib/random32.c:179: warning: Excess function parameter 'seed' description in 'prandom_seed'
> 
> Signed-off-by: Philippe Mazenauer <philippe.mazenauer@outlook.de>
> ---
>  lib/random32.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Looks reasonable:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
