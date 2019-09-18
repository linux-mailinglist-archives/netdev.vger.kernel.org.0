Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4D9EB6D78
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 22:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbfIRUXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 16:23:54 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:40914 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbfIRUXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 16:23:53 -0400
Received: by mail-wr1-f51.google.com with SMTP id l3so731566wru.7
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 13:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YTGvZkHzZWGI/pIVxyD+NCqPLCZ/CgJL1rpK1m7Z0/0=;
        b=ALV4lOHTCDrkA+cl81qeqUBbhv/NECcFbJ0tXpCqHCfHVpnD7SHujtxoy1ZqAzhr+Q
         5DApI47mixfw6a4vjzH9p9DOqciNVHVUWgQDXLRo2ndKwl4UGYgjhppcRy9GgP/eHw+L
         HiHzxbP1VMNvIpTJFp13C75vbTkYGd0Rw0UpRrQ3uqjaaExaVTkfuUp317xRw93o50D+
         erWm3twX8kV0DAGUyw+auqqIZxJi/cD895NDVQiwZt/TRrc7fCaG64XOP47r7z3XCqJt
         WIuT/1t77XqouQTPpv5afvRpCg33HnddolY7OsRzbWpJ1wWhWqLhlt1F7tpyfQoh/PNH
         1jQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YTGvZkHzZWGI/pIVxyD+NCqPLCZ/CgJL1rpK1m7Z0/0=;
        b=ILrWHVNdIJAWJxVD0DaDEMjQqnWpIVqkrYtqlVCt/OOd2nBTGGHs9q+15p993vAxwq
         i2u8bICoSnZRy5FcrcOdGdivoKJwkfDHkKnL1UKDJjh3EOOVtN//GQ9W1Q5cvho1f7gs
         7Bbqtv7DuW9AWscPmaLKnM5jF8YlSx+wpnqP+Qt2SXkvCC008R2TFToIT6fm74NDQMRW
         60jXpiIucrZ2gozD2HMP9YlVsg0inr9igaOgqmT7EoEEzVtG/7kmNG3EmyCmN4LI/frJ
         y1mi5rK3q2DeclSMqb/EmKP1U8kwIel2uLlkH6C+Qt8g/KyWlU5ds8jZDpSo+n6b7Kms
         y9IA==
X-Gm-Message-State: APjAAAUYAKtEul6OvvfuFQHO+t8JJ81m2CxCqub7NLSQy9b7JVm7OJxy
        uxfjoSlyzL9wqN8CSPMIX22pzVMxeW4=
X-Google-Smtp-Source: APXvYqwvWeNGpqPW0lTerR5GLgPrwcew8AqO/ENC/fWqwR48Uhl4C6i921PeOo37TBbvUNDMviPYMA==
X-Received: by 2002:a5d:4a8a:: with SMTP id o10mr4566620wrq.201.1568838231658;
        Wed, 18 Sep 2019 13:23:51 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id m16sm2504046wml.11.2019.09.18.13.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 13:23:51 -0700 (PDT)
Date:   Wed, 18 Sep 2019 22:23:50 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        tariqt@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch iproute2-next v2] devlink: add reload failed indication
Message-ID: <20190918202350.GA2187@nanopsycho>
References: <20190916094448.26072-1-jiri@resnulli.us>
 <c9b57141-2caf-71c6-7590-a4783796e037@gmail.com>
 <20190917183629.GP2286@nanopsycho.orion>
 <12070e36-64e3-9a92-7dd5-0cbce87522db@gmail.com>
 <20190918073738.GA2543@nanopsycho>
 <13688c37-3f27-bdb4-973b-dd73031fa230@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13688c37-3f27-bdb4-973b-dd73031fa230@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Sep 18, 2019 at 10:01:31PM CEST, dsahern@gmail.com wrote:
>On 9/18/19 1:37 AM, Jiri Pirko wrote:
>> Wed, Sep 18, 2019 at 01:46:13AM CEST, dsahern@gmail.com wrote:
>>> On 9/17/19 12:36 PM, Jiri Pirko wrote:
>>>> Tue, Sep 17, 2019 at 06:46:31PM CEST, dsahern@gmail.com wrote:
>>>>> On 9/16/19 3:44 AM, Jiri Pirko wrote:
>>>>>> From: Jiri Pirko <jiri@mellanox.com>
>>>>>>
>>>>>> Add indication about previous failed devlink reload.
>>>>>>
>>>>>> Example outputs:
>>>>>>
>>>>>> $ devlink dev
>>>>>> netdevsim/netdevsim10: reload_failed true
>>>>>
>>>>> odd output to user. Why not just "reload failed"?
>>>>
>>>> Well it is common to have "name value". The extra space would seem
>>>> confusing for the reader..
>>>> Also it is common to have "_" instead of space for the output in cases
>>>> like this.
>>>>
>>>
>>> I am not understanding your point.
>>>
>>> "reload failed" is still a name/value pair. It is short and to the point
>>> as to what it indicates. There is no need for the name in the uapi (ie.,
>>> the name of the netlink attribute) to be dumped here.
>> 
>> Ah, got it. Well it is a bool value, that means it is "true" or "false".
>> In json output, it is True of False. App processing json would have to
>> handle this case in a special way.
>> 
>
>Technically it is a u8. But really I do not understand why it is
>RELOAD_FAILED and not RELOAD_STATUS which is more generic and re-usable.
>e.g,. 'none', 'failed', 'success'.

I was thinking about that. But I was not able to figure out any other
possible values. So it is bool. For indication of some other status,
there would have to be independent bool/othertype anyway.
