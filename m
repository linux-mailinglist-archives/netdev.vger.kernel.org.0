Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22B1DDCC17
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 18:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634398AbfJRQ66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 12:58:58 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44064 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390973AbfJRQ66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 12:58:58 -0400
Received: by mail-wr1-f65.google.com with SMTP id z9so6995232wrl.11
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 09:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ECd/X1I287gOaue23qpdu6/IvrCxuf6ccKrXHq1L3bM=;
        b=vdAKTvTZWHPMMfCkguKjBjhQkzM5sUrPCS77ous/hbD8nb39CNizfGenK5TCbYAE64
         8lt4rj2V48C/3m/YunoelYXzKVuPt7HU8zXaNT0VsmQ7Ww/jNTDCU5fj1z9Eo13WkOiP
         CESkYqtlkvHwIyTTBXIcZR7vuzdVCvSNxeOYtUOoco4HV5jC4HzDmKeOh8uCHROrCqbS
         RUOjk/gvirUV39tZxKyT7A9is1sHmAxgdxtHDiSp9CYq1U1MAt43+RMusf0aMDdMdAvC
         +re0Dl4Z58qUbAWQPno3unNSlKdPlaKIcLNt7jUTaKC54FlvLNK3Y79ddWWZXZrUV32y
         UIIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ECd/X1I287gOaue23qpdu6/IvrCxuf6ccKrXHq1L3bM=;
        b=NfeQ1lG3fsYPha+DD01PDdByi6WeJaH9Z4zPXS/rr3JPPa2dqpQJfVKxH4KQuLgMsN
         /7FD/FgR4u10ARq7ewuE3gs3W+ABII0CdvHjfkUQMZuCQtAIeO/wLzHJrmB+xPHl1jtQ
         f7GcQbuwemYW2caQLePRRWDe+dD09kYZ5NrsJHrLTST1Sa+olFSyEYPvsmlwUsik3oac
         gOGe4O7Ad1mhQo3tFIcxvI0dq+x6du6L+TqRckDOIa2Zq4BfcOMvG0hgQ0SW2DT2lHGn
         eGbNF4dMSXrbd5IPRs5wrnY247q5mhALEHOQOfAQaryUtR4yf8bKYMqOJg5xEodcMTX5
         0wTw==
X-Gm-Message-State: APjAAAXV+63pblWLlTqkq9yIHcYgqDd1McM+cOrjbkeg4P/B5TF4ljnS
        gAS1a9bXzguoQLWNNU9s/9/oLWLCRcE=
X-Google-Smtp-Source: APXvYqy0yrhzfbZVq0otDeD/zrnkGroTnNZiaGNJo/D7fELD4BRnvuIzRV29k17NBgj2SsmddFcfew==
X-Received: by 2002:a05:6000:1283:: with SMTP id f3mr8171337wrx.370.1571417936789;
        Fri, 18 Oct 2019 09:58:56 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id r18sm6281363wme.48.2019.10.18.09.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 09:58:56 -0700 (PDT)
Date:   Fri, 18 Oct 2019 18:58:55 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mlxsw@mellanox.com
Subject: Re: [patch net-next] devlink: add format requirement for devlink
 param names
Message-ID: <20191018165855.GH2185@nanopsycho>
References: <20191018160726.18901-1-jiri@resnulli.us>
 <20191018092550.6d599f0d@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018092550.6d599f0d@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Oct 18, 2019 at 06:25:50PM CEST, jakub.kicinski@netronome.com wrote:
>On Fri, 18 Oct 2019 18:07:26 +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Currently, the name format is not required by the code, however it is
>> required during patch review. All params added until now are in-lined
>> with the following format:
>> 1) lowercase characters, digits and underscored are allowed
>> 2) underscore is neither at the beginning nor at the end and
>>    there is no more than one in a row.
>> 
>> Add checker to the code to require this format from drivers and warn if
>> they don't follow.
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>
>Looks good, I could nit pick that length of 0 could also be disallowed
>since we're checking validity, but why would I :)

Okay.

>
>Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
