Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C993B3143
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 19:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbfIORwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 13:52:46 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43396 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728560AbfIORwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 13:52:46 -0400
Received: by mail-pl1-f194.google.com with SMTP id 4so15613081pld.10
        for <netdev@vger.kernel.org>; Sun, 15 Sep 2019 10:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=udjL4aybl3lDdE7yQy2LxIsICfVrKZnV71hQEnnlH/A=;
        b=YEgUw+jwoerVaoPVtKKqeKFz574z0o/XhKQQYeRYAcdic/XUmbvjaDIvgkFN2h1aH+
         B3Y2W0Aifx059gBDGrkqykZ7NFoarzie4V5A6PHWirKUwrZkACHvzK0nvvNAPK7/Oml+
         qd9zotDqDifPLf7duTqLd+Ng0J7dvXfDuFrxobIi1tVeJc1URitZFNZ9Go7US/YopOHi
         4vE79oOi9sJntlmApucF9AjsIjaxZAw1Oe6L8OVwItG+vyb++SZpopJtNJazZaShJVoP
         ISwXBWy2ZZFf6dzckHP7Y6LBsm/XrYqSkA7bDuGmleQlEMu5Mn2JI00BsJuQHdRC4QVB
         a1nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=udjL4aybl3lDdE7yQy2LxIsICfVrKZnV71hQEnnlH/A=;
        b=Om8ARnQuL1PLuo1urS7s6u+H+2PuYKGapMY8kdFKIKCipBFFhynXwY9Z0bbVS3RyLc
         /pLOMb96R7uB1sL3VNRIsYjz7W+AYvYEW5RNAoxuyhS2CQyRqDYRCFyEV7FmjIKK+83I
         ckIdXaEPSfzVp87QiabOBIdVLlbUz+dzP93JlSRPGiWQrY7nk25S9dgwJJsJy/s8YSuT
         wUYOIsRSS5GLVmQTiDCAdBgPbenXnQ73SK1yVOYd5TOmM07uWJfgs0wkhbzPN6uRX48m
         8oRG3pmAFf/2BVJ9VesZZYBHXRg87EmOvxljxsRJvImatuCcH77ogtmN+SkXOCf2lAsT
         wmPA==
X-Gm-Message-State: APjAAAUFt21zrLHCK+rHAk35SILJ+djKr9jr0Tgv4ybrNfvriwB+z9gE
        nw/QfFNjtvLLoWTYHKheXSY=
X-Google-Smtp-Source: APXvYqzCAjc7Kuml0HBpgT/rFfWGNKL+Y2w/ig79UDSuwsjTmhZlZQ0nl2jb/+hrtKtmstVjzLircg==
X-Received: by 2002:a17:902:8bc3:: with SMTP id r3mr40643211plo.326.1568569965771;
        Sun, 15 Sep 2019 10:52:45 -0700 (PDT)
Received: from [172.27.227.180] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id r2sm55369229pfq.60.2019.09.15.10.52.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 10:52:45 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] devlink: unknown 'fw_load_policy' string
 validation
To:     Simon Horman <simon.horman@netronome.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
References: <20190911145629.28259-1-simon.horman@netronome.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c9d9b9cf-ea0b-f53f-7115-7714305ce0d9@gmail.com>
Date:   Sun, 15 Sep 2019 11:52:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190911145629.28259-1-simon.horman@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/11/19 8:56 AM, Simon Horman wrote:
> From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
> 
> The 'fw_load_policy' devlink parameter now supports an unknown value.
> 
> Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>
> ---
> 


applied to iproute2-next. Thanks

