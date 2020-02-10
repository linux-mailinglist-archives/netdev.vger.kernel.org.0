Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91745156E76
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 05:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgBJEcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 23:32:04 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43117 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbgBJEcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Feb 2020 23:32:03 -0500
Received: by mail-pf1-f194.google.com with SMTP id s1so3052492pfh.10
        for <netdev@vger.kernel.org>; Sun, 09 Feb 2020 20:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OApuY9dzUu0JltbItzFu0NH+tSYPk0XMhYGouRiS530=;
        b=EvKl8WZv2B1OmJp+u/cm1mDWuDelRU+KxXpTk+wkQ9nwD04TiX1RzTq0KioK4Huev8
         q5bAw5L650WjCfgmrWsDYjFnMVzAW2FHVRfX7pG3RHUzGa2/b9pe2vGkwO6kJaaLpDnm
         gGfhXi3/7SqNOjwO3cdr0fSBlM3IWmOonwG/7U2MD3Po34c+D0MGlzd2GTP4pKShoAuf
         h66NzXoJf8QeXLbsPIwZ0yAzRu0z88V8F5hzA2dlNN20NE4hCdtkLpxYTatBrdrGOmJI
         u2VR7Bz6m2dZLR/+XF5WPOzJOfx7r+1motWieN6HsohgogczW8pnAHrlO3A6dL8ulgkZ
         1Dvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OApuY9dzUu0JltbItzFu0NH+tSYPk0XMhYGouRiS530=;
        b=p78mXcVyalmSgpOZMuzd+16/XD+rEehjg5jNZuMN+Xx7eB054SStWQf0bNBiXb8jYl
         q8sVIRV/YhwrAMECm2ULkTZ8KbebERZXOQK6cEYDKO+cpgXAEVdJqjBwbmfHSFYKmzjA
         9svJZQe9lSrBtDQnaNHmRwXB5kLU+6teOfZ+i9rLpApnLRY+UgVL0lozTnIWuPVzB01M
         SkZ716VhTC8azyTVTORlb3sLBTBDsO4tCHZ91MPAohL+xQNrtosywXxgYCq8nJncGPCX
         tiDnZDJRUGjDK87Etsd7qP+Q/0VwoRS3bQjDi1vtS9rgJvIr6K4AEsZukv1NvtegqhT7
         Ih/Q==
X-Gm-Message-State: APjAAAVm2jGWKtqNJYuxJ0OUvCeWBvQZwTBgtnXUgAj8eKVNstY5EHOI
        GUZYo5+KFTjhyc7LakfAe0g=
X-Google-Smtp-Source: APXvYqx389SujfzFyTandh0qPXuTGOjCCVGN2IWoelNW7FxnIiBSgUZbA/Csp76p6GZDCij1FKF61Q==
X-Received: by 2002:a63:1b1d:: with SMTP id b29mr12373053pgb.111.1581309123180;
        Sun, 09 Feb 2020 20:32:03 -0800 (PST)
Received: from f3 (ag119225.dynamic.ppp.asahi-net.or.jp. [157.107.119.225])
        by smtp.gmail.com with ESMTPSA id v5sm10427310pgc.11.2020.02.09.20.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 20:32:02 -0800 (PST)
Date:   Mon, 10 Feb 2020 13:31:58 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Jarrett Knauer <jrtknauer@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: Fixed extra indentation in
 qlget_get_stats()
Message-ID: <20200210043158.GA3258@f3>
References: <20200209073621.30026-1-jrtknauer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200209073621.30026-1-jrtknauer@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/02/09 00:36 -0700, Jarrett Knauer wrote:
> qlge TODO cited weird indentation all over qlge files, with
> qlget_get_stats() as an example. With this fix the TODO will need to be
> updated as well.
> 
> This is also a re-submission, as I incorrectly sent my first patch
> directly to the maintainers instead of to the correct mailing list.
> Apologies.

If you really want to fix this, I would suggest to go over all of the
driver at once. Then you can remove the TODO entry.
