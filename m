Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B52127229E
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389665AbfGWWvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:51:02 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43837 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732011AbfGWWvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 18:51:01 -0400
Received: by mail-pf1-f193.google.com with SMTP id i189so19861391pfg.10
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 15:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=dQoLYZq3OLwV3Zr4tiWhXDma1M8P1rC/By3TVMNXiLk=;
        b=ZOaoRX9hVgKDXTdCxo1cXc+VfU+42y78fVksd1sfTQCPaLLC1QPCceszBC3Qdd81VK
         Rx2FhG4zPxUgQKsORraraa8xf47UMt5sroHTYUomeTLXz+qpCGJEip0jpZLqMUQ/nfk8
         Vk7BK8TUqhgYDd2l0vpDYS1DmT9k5N1THx3i7hn736yNVVgeoKvL221+V/TLZDJVzSPV
         pJsYQ7s4phjobqvLu4JSeCu3OcgR9q4jbUtbV24AZscDktDs0QvB51WsNMz8FyXC7oy9
         H3FgkyLwJ8LuRDI8kUe/kbYcOjaH0u3kFehceaNngYugd7TmUAvfqSFxx7XSEcoP+k3t
         3mSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=dQoLYZq3OLwV3Zr4tiWhXDma1M8P1rC/By3TVMNXiLk=;
        b=B1a6GKNIqXu2/bqKferkwsQrVt3TYTKM7qazyZZM1U5qvx9rJBJYokGgyDJIe9wu6K
         F2FUSglF2cP8ftx/V/sLutPe8K6flHNHpyUeFl9MSV0TlzXWAC39mQDYE5wfGsKzQZ8m
         +pisJYfc7Rcpd2hpstoW0dKl3ju83leTxHkC6QYHvZh09Qp7UHVGsPROCamWA3HAZAAP
         qMaVsWG9oRTKGTIIuo8Y0geG/0Kk+llBu1r9QGQoMLlzsbpqcwnD18JejBhhwqNco0SH
         ak3XQ4a/m48AwEN+Q0ZTFJn/pDd1RfRZZuQ7+zihQV/ls+VvJkgnmJBlbLsAjCJZTqdo
         m26g==
X-Gm-Message-State: APjAAAXrhwpzU5ABxSlEvg2SgtI6j0Lg3No6wxY2D1gjWXNGiJpbLZFb
        36Sl+Fd/FxpDzO2U17NiQPmQFYNRdsgemg==
X-Google-Smtp-Source: APXvYqz9i1m3Mrbafemu3/u71LGyHx7TfSKRFoXaNUuMP2MzDISFhZFlUP5/NTPbth81qW+eDOqdqg==
X-Received: by 2002:a17:90a:2190:: with SMTP id q16mr81812667pjc.23.1563922260628;
        Tue, 23 Jul 2019 15:51:00 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id i9sm43613822pgg.38.2019.07.23.15.50.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 15:51:00 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 19/19] ionic: Add basic devlink interface
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20190722214023.9513-1-snelson@pensando.io>
 <20190722214023.9513-20-snelson@pensando.io>
 <20190723.144055.138556918172139772.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <da8deda0-eefb-500d-f72d-6eb720c979e2@pensando.io>
Date:   Tue, 23 Jul 2019 15:50:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190723.144055.138556918172139772.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/19 2:40 PM, David Miller wrote:
> From: Shannon Nelson <snelson@pensando.io>
> Date: Mon, 22 Jul 2019 14:40:23 -0700
>
>> +struct ionic *ionic_devlink_alloc(struct device *dev)
>> +{
>> +	struct devlink *dl;
>> +	struct ionic *ionic;
> Reverse christmas tree please.

Yep, I missed this one.

Thanks for your review time.
sln


