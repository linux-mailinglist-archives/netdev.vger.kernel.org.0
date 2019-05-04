Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 616B1139F0
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 15:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfEDNBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 09:01:09 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39564 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbfEDNBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 09:01:09 -0400
Received: by mail-wr1-f65.google.com with SMTP id a9so11221245wrp.6
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 06:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZZTDQ9RGQZFaqbPTFRmleRhe6hCGRaNFfzuZ/QkEqNE=;
        b=cpHWMxPaUg9aKR4JcGrClSw+M5qyDZ/tunTIAMI+wo7flpg43nqKp/fNFXXeWLEqm+
         de0nflt4ANXf3EQ238j2ZbRCmDMByxstDTcyjMhve7TnJSiAvy4aMgVIXyeSVB3Jse2y
         1subDMQfQ5TqSGUzLbrc5PX62hOpQcGbv8jPzir77oYXHW1kH5+qHvw9xcZRasPisywE
         6GotluIwk06eWZGPYlrlDeX6VpuTeqlMWKst+o368OW4TwxfdsbaeVOe7vW3Bp1WYlav
         e1d3+Bp51gtkXXWuY6qpH+Ts7WMpN8YoegznNn43joD3JrVxhIO3VgBUIjeDZ58U/Yzt
         K3yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZZTDQ9RGQZFaqbPTFRmleRhe6hCGRaNFfzuZ/QkEqNE=;
        b=YoKCoq/tS2Rtx8ejnE5vEVuf0p1cPu5652JUUiYprZ26c6/CI9KDZjj2YBU0vNi+bp
         6HVzLmjgNUz36EtgFzvZ6BsD2maoWTpVd7ltv/nUTKFK9Bvp5+JzWjNJ0+IBXoLMzzlV
         z54//+PgGJuUmnPOiXtZ8nSgQi3iXjFTCyxEDDQrCD7ENerEa3WB5k+woAQ9dsX8W9vy
         cEMtS5yJlLrFb1b2QamKnsxNwzAyctEhK3SmE25rA19aQeqoOUpWJnzE1dGh9YYabWiv
         kKa9rstCgQYav7LMsYJYNqS5hfAIp8MNDrj3XBUSvuqV/E6mnyoop8EuEGuUitV2ROgS
         Cv1w==
X-Gm-Message-State: APjAAAUTRuOiSBTBHi6aQnVbs9VRJuQVibiy7Pic+akBedvd2O+VY6Nh
        ihs6BzsWiEukUcHZ2xc5hRMgZg==
X-Google-Smtp-Source: APXvYqznfC2GeaiH+9P06sJZR/Hk883BSgyp6+GctqoWA6IuZ941Iz7EzT2M/laX9UGg4IQFwqh95Q==
X-Received: by 2002:a5d:4f87:: with SMTP id d7mr3143187wru.192.1556974867819;
        Sat, 04 May 2019 06:01:07 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id x81sm3503692wmg.8.2019.05.04.06.01.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 May 2019 06:01:07 -0700 (PDT)
Date:   Sat, 4 May 2019 15:01:05 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, xiyou.wangcong@gmail.com,
        idosch@mellanox.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, gerlitz.or@gmail.com,
        simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
Subject: Re: [PATCH net-next 05/13] net/sched: remove unused functions for
 matchall offload
Message-ID: <20190504130105.GF9049@nanopsycho.orion>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
 <20190504114628.14755-6-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190504114628.14755-6-jakub.kicinski@netronome.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, May 04, 2019 at 01:46:20PM CEST, jakub.kicinski@netronome.com wrote:
>From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
>
>Cleanup unused functions and variables after porting to the newer
>intermediate representation.
>
>Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
>Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
