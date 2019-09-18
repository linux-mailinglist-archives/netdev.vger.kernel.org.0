Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C96E7B5E32
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 09:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfIRHhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 03:37:45 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37919 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727255AbfIRHhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 03:37:45 -0400
Received: by mail-wm1-f67.google.com with SMTP id o184so1247565wme.3
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 00:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MrmhxBcYMyUVjBKvbdf/BUl2INjTBV57O/XrLw/1WQg=;
        b=btAs+mijCru+k3sXXFSrS67KYeBTkWmL6TC1S1hM/j/KU+1NYhAB8Qsk3a/yfZjFeu
         srB3m2RhC8eCm2BH82FpRXffST7mGM697oGX70ZO65laDrg1+XHr9CIzBXO8Gf66TZlJ
         e9Axyj58+TM0tfTNsUTTVf45BIDrcJ1C3DFHpBezq7FbqUkDiRlz8h3oNGJGR7cPYvKo
         +YnV7DUDwD0psmVNaz5f/kqJBZoOZ0W0waTuKE2IIkThpG0i7k3yN0LFmfCHXBF1wasv
         ZE6FkmDVWh7WkMnom/Lg9ekWhBg/v5kkk5ukLIEPeKAvz53+fAjKPxKgBwACUV3f/Ubx
         nZtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MrmhxBcYMyUVjBKvbdf/BUl2INjTBV57O/XrLw/1WQg=;
        b=JAWWXJxAP0mz+AL7Ws+s7Rn2VaN3XEM3jBPpd57UY0IRqyGu242YD/1mbobE3nyd4g
         1929aG5EtrTgVhcJ+Zqj+OcAZ2EbwSwb1HuflgtVPgKWces85KPIyqy/opO5eGkpfcER
         KCcdBQ64UOp/Q8LtsdQ05o4xHKU9jDws7wciSEHZ0LcKtb51J9iAezMeshstsHfbRwUw
         2VvUdr+Zn2H2dJecFbUdEwjIUB0pwI4HSQJitSFfPljlbFbfubSsxE+p2DWidF4TWVts
         q49hnAYq/5UIXm3um7tPduwBA8Us+wZ+ppivKe6Bl/Ccn39AOo+pJj5PvIF0TI7JGGeo
         u52g==
X-Gm-Message-State: APjAAAU/jBCqLDdZnyOIAhiXJt3Kgyhcsl+b/9bUVGP9BOaYIWlVkvSZ
        VDuwmEnZtZfdz5Jy4YA70yfWTA==
X-Google-Smtp-Source: APXvYqxVqaDne/gpNHzxP9rP9+0nsUY+kuYU2D9qowfOv1vd/T60YnGqREtcHrD3zAsAYo379KDBug==
X-Received: by 2002:a1c:cf05:: with SMTP id f5mr1554685wmg.131.1568792261934;
        Wed, 18 Sep 2019 00:37:41 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id q22sm1131669wmj.5.2019.09.18.00.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 00:37:41 -0700 (PDT)
Date:   Wed, 18 Sep 2019 09:37:38 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        tariqt@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch iproute2-next v2] devlink: add reload failed indication
Message-ID: <20190918073738.GA2543@nanopsycho>
References: <20190916094448.26072-1-jiri@resnulli.us>
 <c9b57141-2caf-71c6-7590-a4783796e037@gmail.com>
 <20190917183629.GP2286@nanopsycho.orion>
 <12070e36-64e3-9a92-7dd5-0cbce87522db@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12070e36-64e3-9a92-7dd5-0cbce87522db@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Sep 18, 2019 at 01:46:13AM CEST, dsahern@gmail.com wrote:
>On 9/17/19 12:36 PM, Jiri Pirko wrote:
>> Tue, Sep 17, 2019 at 06:46:31PM CEST, dsahern@gmail.com wrote:
>>> On 9/16/19 3:44 AM, Jiri Pirko wrote:
>>>> From: Jiri Pirko <jiri@mellanox.com>
>>>>
>>>> Add indication about previous failed devlink reload.
>>>>
>>>> Example outputs:
>>>>
>>>> $ devlink dev
>>>> netdevsim/netdevsim10: reload_failed true
>>>
>>> odd output to user. Why not just "reload failed"?
>> 
>> Well it is common to have "name value". The extra space would seem
>> confusing for the reader..
>> Also it is common to have "_" instead of space for the output in cases
>> like this.
>> 
>
>I am not understanding your point.
>
>"reload failed" is still a name/value pair. It is short and to the point
>as to what it indicates. There is no need for the name in the uapi (ie.,
>the name of the netlink attribute) to be dumped here.

Ah, got it. Well it is a bool value, that means it is "true" or "false".
In json output, it is True of False. App processing json would have to
handle this case in a special way.

