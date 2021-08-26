Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075563F7FE3
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 03:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237087AbhHZB1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 21:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237224AbhHZB1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 21:27:47 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06F4C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 18:27:00 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 7so1233901pfl.10
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 18:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=AYTL6jCD8+dbpoN2+sHjyq7LrAikGdmiSmUfmTbWQvA=;
        b=idYYqJ+9iCfpqTqlkcmQzqPWHow4ZE1cSDJym2hyGA2qxVIaowCN+AxG/ZXMiMiE/X
         De3galBzy9wQIixdeON/ZsD1QiZP4LmxuyX6zS/2r77lsfUVzI8xfkfCuJk5ahvbg40W
         GsJs+ioJ5koXlwiRJjCj1dNs3SpuFGqe9lWFOaBmNZqMOueg/kpZ/gHGuJ/itWCe+h57
         4RRVRjsa7aw6yz/1WVKYkemnsEhtgHJbDL4Vca2hp0ftK4x9atFaYT4IL6N0S5T/Iix+
         2oya9VUlbQdajxhfVdRfuprM7Ln2Y915JmXddBRHoZ3r/T+IgV5fVkwZ7IoQDFOrSkKw
         eWGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=AYTL6jCD8+dbpoN2+sHjyq7LrAikGdmiSmUfmTbWQvA=;
        b=RsxwOtqkjLDgO5JWvIElT/jgtezYH3lChXvMMQvjEGi3BlMbeuPK47sxyGSbTUye+K
         WsGYDXmMcyiQhOkiOb1HYJ9YsM0S6xWXiKIb335Z/LsPC0yq+HaIfNumC+V17FB6T7YD
         EKaniD4bDiamM2F+VCDaRPGNLrXHOZfdmDAJDbhnDxl4nYq9RuIAcchpOf6BifYBcAPe
         voi2H/rXd03MzP+0tuomxYf03X0H3WROItdd5ZkLh1dIr5Bwcu7JB7yXzi8yK4ViCNz+
         mfFpn+efXFOxPZ4UGwtVkiWKchL3bTvIXQqJIQ+jxifO/McWk0zskV27+kGt7sW8xSCm
         Pr0w==
X-Gm-Message-State: AOAM532kINAsBBKicZy5vi+tZXvrsBrWuSL7DTNnP0BMOPwLH+iq3DUU
        Qyls//gLa9lOW38Lo3HAmBw3cqlwFn7Aig==
X-Google-Smtp-Source: ABdhPJzfk3vC38q5THCGEu3ZxjghieZ5HB58dp2K/yBJnYHpw93pIAzDmk6edg7tdVDwPirxPSaTog==
X-Received: by 2002:a65:5a89:: with SMTP id c9mr1036240pgt.274.1629941220305;
        Wed, 25 Aug 2021 18:27:00 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id w130sm811316pfd.118.2021.08.25.18.26.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 18:26:59 -0700 (PDT)
Subject: Re: [PATCH 6/6] filter-debug
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com
References: <20210826012451.54456-1-snelson@pensando.io>
 <20210826012451.54456-7-snelson@pensando.io>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <fc163c50-29ac-7d1d-3993-755c936fd909@pensando.io>
Date:   Wed, 25 Aug 2021 18:26:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210826012451.54456-7-snelson@pensando.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/25/21 6:24 PM, Shannon Nelson wrote:
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---


Argh... disregard.
sln


