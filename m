Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28BD42C61A
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 18:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhJMQUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 12:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhJMQT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 12:19:58 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5822EC061570
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 09:17:54 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id u18so10256181wrg.5
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 09:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fwku3EdzEWTgZ31mJcVlz+4QZC17pms4jeMoG5dZCY0=;
        b=WTicfrUeVvIlgB1sURXWiVpTAx7InaPm2IQ4zJRicBN9NdPN0k3bSfRTMY2sJFqlMZ
         xRc1KgH6K9L/x5NA2um2WTDoOXCWtUEc+KaNe57Ng36dON199b8m2Sw7FqsGZPJ3zJsm
         JvOt1qH8cfj9LuVItQ9CDvD7wm4hPYsIFrFWgAS3sL81g+ibJqIw3mQu7QdqWxHv8LYP
         kw/JOno7x/EjtRUtwMegW1HVCryV0W5Or4Xu9nMLKZvu6XL2UXeIIt2ikN4lBl1w4hOw
         VzQlFUFYONQn+HXpVpb/iLUeUqEu4hdxiSWhzZgW4BWVFT+LjjSHyqGp/gPwbm/PRgtB
         Zutw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fwku3EdzEWTgZ31mJcVlz+4QZC17pms4jeMoG5dZCY0=;
        b=zmd8KOkqVkJHLqZbUUlVgLvh6V3ng1Ltld9m5pjNgyfvl9j1H/6epgtnJw42qvaFPF
         0+4lXb1SJZP/UHt73P0BZp5WivnlA9gUhAqx9k5wyBV7tI8FGmgGhImeGGjdrlPfUouQ
         LMPobI22q+bM8xTg7KZrw1jrfNCn5xwwJxDh3m5py50mffm+Sn/H4Ga5XGfsKtY53HSX
         r/vO7MA2VuSFPJilrS66cZ4ZfwCZVcswIY++BYf8hxGLD9iJBRybf57321ZP7FALTqBZ
         Ki+/Hu2LZ4d9Bao3fwf9lQzA2JAzFPGU0eTvwlKGBGWrvyNa+KGl2pjfinTbBefMvy8D
         0JkA==
X-Gm-Message-State: AOAM533DOL+Aeh0HpyQBqmX1pDf2c37r9HVJNRvIkvcZ1ASKe4Toafm0
        aT/sV+F/qXZqPe7jS9Ao4LC5LB8SL7ZdjQ==
X-Google-Smtp-Source: ABdhPJwUdZtheTJ2ctS5pnZqWS0v3nAlSPeKzLJ4iRD59LlGTI3rBbFGELZlkqpKKJ0OFgKAwXwKJw==
X-Received: by 2002:adf:a4d5:: with SMTP id h21mr60991wrb.203.1634141873048;
        Wed, 13 Oct 2021 09:17:53 -0700 (PDT)
Received: from [80.5.213.92] (cpc108963-cmbg20-2-0-cust347.5-4.cable.virginm.net. [80.5.213.92])
        by smtp.gmail.com with ESMTPSA id q14sm5703242wmq.4.2021.10.13.09.17.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 09:17:52 -0700 (PDT)
Subject: Re: ip_list_rcv() question
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
References: <20211007121451.GA27153@EXT-6P2T573.localdomain>
From:   Edward Cree <ecree.xilinx@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>
Message-ID: <4dddfda5-1c03-6386-e204-e21df07aabd1@gmail.com>
Date:   Wed, 13 Oct 2021 17:17:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20211007121451.GA27153@EXT-6P2T573.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/10/2021 13:14, Stephen Suryaputra wrote:
> Under what condition that ip_list_rcv() would restart the sublist, i.e.
> that the skb in the list is having different skb->dev?

IIRC, something earlier in the call chain (possibly
 __netif_receive_skb_core()?) can change skb->dev to something other
 than the device that originally received the packet (orig_dev).  I
 think it's if the packet gets handled/transformed by a software
 netdevice (maybe a VLAN device?).
But really when I wrote ip_list_rcv() I just worked on the basis
 that "I don't know it can't change, so I shall assume it can".

HTH,
-ed
