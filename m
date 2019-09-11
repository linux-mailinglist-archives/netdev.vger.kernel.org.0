Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABDD2B0222
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 18:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbfIKQxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 12:53:21 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:36430 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729107AbfIKQxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 12:53:20 -0400
Received: by mail-wm1-f44.google.com with SMTP id t3so318574wmj.1
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 09:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hhsVJ17s1a7ejjBmY/TQMRzA+Ai/vorgMYTO9MJ70Gk=;
        b=X9zrWMTwJqYd2yp1d7x7+OtVVZ9Zm3jhcfFSBlRPXXEV3RnAXv3OSC+QOr3M8Wji+i
         qYQqug/jHVS5evv4fKRQh3fjfcHvkLK3msAKJC4qFaYDXZH+GtYeuj1utzOu0YYQo1BP
         rgBfqhqA0wMs1RO0HzQ80z2+coYiHbgBpraH0ebACoYgs5HHJ5WN5VoJLrHG7ua1FmO0
         QGwHmTEXs6LCAV9CcDQf+qZvdcETZfzhAMBz4Jw4id9vKiLTT9aJM1CGl0pjjcIE1YLL
         2LXueY3SbzPyAQjnVcUBYT1XOYMvWGQSgbCIwA0b+M4AVf6d32m4wt8Mc/tNTTrJmFTu
         XLPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hhsVJ17s1a7ejjBmY/TQMRzA+Ai/vorgMYTO9MJ70Gk=;
        b=tslmFq87WhNmmTXzZctdulqciHeXViT9QSHHrvNCko9TzRBDR/brsuSMgxELDMvYmZ
         SVao+kaHj2KeR/MRstQ7xz/AP5SHrxkFpGpkNv0rKTKSKfg5hKigZisaRbT23dajbtX2
         zrGj+bHmbaTAEnrPRIl+lyBi1Xp3pglj7jwpT2OmOgdWVL2FUnr0W8kjC1Rrat5Qseb1
         fQk9r/alRedlZYQ27BUS3zCJlQCaF+HTwV2Mqqth9O6+TEIHV5Adpiae3JZO5q5pQ0PN
         LaZcQJ24yvh+SCnMYu6q2rdRUMUnkbILizWO8MzO2d5ZeZxGMmgFW2OvFozXAN8KfoYr
         Jahw==
X-Gm-Message-State: APjAAAVFlaabDt1O8KlokAynoT+vuT8CWn1JxPnyC5FqcX15jwaXsSJK
        9ZrHGIlYeg5DsdqWy8SukZvIz6js
X-Google-Smtp-Source: APXvYqzuz43J9zMFqG4dcaG8DVF83D6+gxhQlbpE9sgr5Y8/vyCdDZbIXyu/XbpXOtWk05q9QsDs4w==
X-Received: by 2002:a1c:23d7:: with SMTP id j206mr4776331wmj.57.1568220799053;
        Wed, 11 Sep 2019 09:53:19 -0700 (PDT)
Received: from dahern-DO-MB.local ([148.69.85.38])
        by smtp.googlemail.com with ESMTPSA id w12sm33057428wrg.47.2019.09.11.09.53.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 09:53:18 -0700 (PDT)
Subject: Re: VRF Issue Since kernel 5
To:     Alexis Bauvin <abauvin@online.net>,
        Gowen <gowen@potatocomputing.co.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <CWLP265MB1554308A1373D9ECE68CB854FDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <9E920DE7-9CC9-493C-A1D2-957FE1AED897@online.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <487f9f8f-f056-bba3-0118-2a49a058daf2@gmail.com>
Date:   Wed, 11 Sep 2019 17:53:16 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <9E920DE7-9CC9-493C-A1D2-957FE1AED897@online.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/19 10:28 AM, Alexis Bauvin wrote:
> Also, your `unreachable default metric 4278198272` route looks odd to me.
> 

New recommendation from FRR group. See
https://www.kernel.org/doc/Documentation/networking/vrf.txt and search
for 4278198272
