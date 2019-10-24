Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96D3DE2A41
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 08:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437647AbfJXGHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 02:07:01 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35904 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404173AbfJXGHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 02:07:01 -0400
Received: by mail-wm1-f68.google.com with SMTP id c22so1232878wmd.1
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 23:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KJtJhJubxopSpq8AlWmYJtHAlAa1aIERvB4QF5Ij91U=;
        b=FQ/3sqnz9WI95xNRXC0H5ECvy6A5Vv4JD5QEizhzJuRhThSO8cIWcqX1IMVDQ+/9XR
         5i61Xyfs2KoJv0C0HpFq/DL39pmPZgHyaWe4Ia6DPdxCVxffvLubSJXBOroFfuFDAQLV
         j7Hzi2281QD85H3moWBv2ZeHQr78aw/YHMsYdNvB3A/hhXA4iE8v/N1kJ6Sv3RZ/I6Oz
         /2Ua12DVhspnuYDoBtQsKjQSPQN3pKMaxgXQ9ivGP8n6JwfAxxgKEY+hk+cnRuGM0FFm
         0sg7FLCKj1CdtIXx4l8ZSC6g3WBJmaRFxRzC/s7F9OhKHRUVVD4QDlJQj68pjmx6PkbD
         zIMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KJtJhJubxopSpq8AlWmYJtHAlAa1aIERvB4QF5Ij91U=;
        b=hSZuOORTK04Y7SiC8AKtbNTWx959n2Gs0JJ47Fc7uXh1zu3yaS+tNp77dxIxKHoMWB
         aa+8HRB4ws7pBXfBeiZSh9mn3CWVxg8gy8H/v3wbEaEjSRBatZYP39UuNhOIzXFoQDDx
         4vcJbzGWCmHcUfmil7zuXn9309HOJctWVazSnECJABNbaWWgU4HlVJZR96MI4mjXhdoW
         Mq+6+0vs7NtDFPsRmSjozMZbJ0Dzw7aEP2qMP8EzGPg6GvZQgnOUXQmMW1TDJKWxEzk1
         9Hq/VFwdP+M9xmNjwXx9NK173JqHguHXVT4oCG1hUbpQUkIxoquJiGmtpfp4OXIZPZcW
         ZrpQ==
X-Gm-Message-State: APjAAAXii35FjGjO8BW5HvnDU6L6MMytFLpuCa3ZPGtiBwoRfNwnwWxF
        plKZVPB4ewuIsG4ribZIHIE0CQ==
X-Google-Smtp-Source: APXvYqzWieUdOWCdnUCU+R89scUSE6qc87UJXfp6B3gognt+EOGYCO6lzBa91VB2bf1fDajQHV/uLA==
X-Received: by 2002:a1c:dc83:: with SMTP id t125mr3337060wmg.50.1571897219016;
        Wed, 23 Oct 2019 23:06:59 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id n11sm1818597wmd.26.2019.10.23.23.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 23:06:58 -0700 (PDT)
Date:   Thu, 24 Oct 2019 08:06:57 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, andrew@lunn.ch, mlxsw@mellanox.com
Subject: Re: [patch net-next v3 3/3] devlink: add format requirement for
 devlink object names
Message-ID: <20191024060657.GA2233@nanopsycho.orion>
References: <20191021142613.26657-1-jiri@resnulli.us>
 <20191021142613.26657-4-jiri@resnulli.us>
 <60dc428e-679e-fb16-38c2-82900c9013de@gmail.com>
 <20191021155630.GY2185@nanopsycho>
 <0f165d72-bb54-f1cb-aaf7-c8a20d15ee49@gmail.com>
 <20191022055945.GZ2185@nanopsycho>
 <f1facd1c-00e4-e276-3898-b59e9d7281a2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1facd1c-00e4-e276-3898-b59e9d7281a2@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Oct 24, 2019 at 12:16:27AM CEST, dsahern@gmail.com wrote:
>On 10/21/19 11:59 PM, Jiri Pirko wrote:
>> Mon, Oct 21, 2019 at 06:11:33PM CEST, dsahern@gmail.com wrote:
>>> On 10/21/19 9:56 AM, Jiri Pirko wrote:
>>>>
>>>> I forgot to update the desc. Uppercase chars are now allowed as Andrew
>>>> requested. Regarding dash, it could be allowed of course. But why isn't
>>>> "_" enough. I mean, I think it would be good to maintain allowed chars
>>>> within a limit.
>>>
>>> That's a personal style question. Is "fib-rules" less readable than
>>> "fib_rules"? Why put such limitations in place if there is no
>>> justifiable reason?
>> 
>> You mean any limitation?
>> 
>
>I mean why are you pushing a patch to limit what characters can be used
>in names, and why are you deciding '-' is not ok but '_' is?

It is kind of randrom. I just wanted to have some limitations so all
things (params, ...) would look alike for all drivers. That's it.

>
>It just seems so random and not driven by some real limitation (e.g.,
>entries in a filesystem).o

Nothing like that.
