Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA68A124A62
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfLROxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:53:54 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53081 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbfLROxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 09:53:54 -0500
Received: by mail-wm1-f66.google.com with SMTP id p9so2146504wmc.2
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 06:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZLzmB2hYKfSi+jgeXJLbQ736Y7wNA5YnJ3YQXvDrsks=;
        b=EHnzM7zcqxO5c+sTq6j5OmtUa5wWXrIFItn4OcVynMVZ8Z2axgPfK1NQ6mFPq6Fy7h
         9ceXRftoFymyZEGluqBMkzYKY0lqhinuo8SVSshVTee/Z3e8SR1mlnkG+JehzUAbVOR2
         dgRiskDvD9mmvv/EbCLfPmjunnzijDDJM12bWtQJS0Rl/TRkdppng6Eu9n6zkaJj8MSg
         wAfai750D7escJX9TtaOXToQ8GF0/GkMX1p4ER8ck+Nk8mgANwjfujXp8kY9hrV4pzv1
         Km/tvfZsPXlq25rjQyFHRsw+oX5+s5Os9SKXEUCLRq5R5XnwLm9ZgHq0DJnHL7R/8D2Y
         qQAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZLzmB2hYKfSi+jgeXJLbQ736Y7wNA5YnJ3YQXvDrsks=;
        b=ucQCi1oQ7CyCZII8WKXuYXXjDZaNWyIQsxJpzOuyJ5NQjr5DDMsHjtReA/1op5cPOo
         zkXiLMvUMGt75yT4cWSionlCPOXclvW8xvRJgEmavyTtnTDMEyiNBg9Pdwgzpg746AWP
         4hzCk86i/UBtKJgQM4m5ug25LT/Qz8XBROyth3CnZ8DRgRKzjVy+EeRJTtvs/lgYWoco
         KTpx9k++Mwp2T5TVadW3Dt5v+MO9+7GmAHgpGRceQ0nHtg+5HJ7wCdjunVXSCd3Pnvou
         2Xhc3qKUqgeAnETeDQFxesnrm4soCLzOjucDzb4mRvkfVun4UmzbMbCgx6XPl25ZuxbG
         ymJA==
X-Gm-Message-State: APjAAAVOUREgIY59JJ9z9pzUGZjBPYEYNmpyBdhptZ+fmI6FHNvdJttJ
        8JVmBkNCyGTwjeXfEY+zRVxWHwLQZpY=
X-Google-Smtp-Source: APXvYqw8muwTvRDGknnbG0oMUd/8FJbQhWmhBTa17GXDchhq7iw0MJ9GTfkB+usug97W7cYBvIAZqw==
X-Received: by 2002:a05:600c:54c:: with SMTP id k12mr3822463wmc.124.1576680832006;
        Wed, 18 Dec 2019 06:53:52 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id m3sm2828665wrs.53.2019.12.18.06.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 06:53:51 -0800 (PST)
Date:   Wed, 18 Dec 2019 15:53:48 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@mellanox.com>, netdev@vger.kernel.org,
        ayal@mellanox.com, moshe@mellanox.com, jiri@mellanox.com
Subject: Re: [PATCH iproute2 0/3] Devlink health reporter's issues
Message-ID: <20191218145348.GA2209@nanopsycho>
References: <20191211154536.5701-1-tariqt@mellanox.com>
 <20191216205351.1afb8c75@hermes.lan>
 <4a75df49-e3c9-7b67-a0da-94dda9b06465@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a75df49-e3c9-7b67-a0da-94dda9b06465@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Dec 17, 2019 at 04:08:31PM CET, dsahern@gmail.com wrote:
>On 12/16/19 9:53 PM, Stephen Hemminger wrote:
>> Applied, devlink really needs to get converted to same json
>> library as rest of iproute2.
>
>We have been saying that for too many releases. rdma has fixed its json
>support; devlink needs to the same.

It's under work now, patches are going to be sent soon, hopefully.


>
>Maybe it is time to stop taking patches.
