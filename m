Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC046DD6C7
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 07:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbfJSFkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 01:40:01 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32896 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbfJSFkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 01:40:00 -0400
Received: by mail-wr1-f68.google.com with SMTP id b9so8308735wrs.0
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 22:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Sv1NQgDBOCGlMs08EpEmF+19LOOwRRmHab1ndrX9ex8=;
        b=qwnDUm1MY69Hn+wHsGqDm9JdRVjRm4rwRyCtS492P7ERjN0gTj4DcR7tOs8Y344s9Q
         zviyBjiBLIghhoNwnRKUV+GjWQUTFSDZ5dhLeudWxxXlo38iwrVYjU0CijvhccEMZDNO
         HEVt09CuTg07+NHmBMDsfwbgniohqVXLlUuAgjyXGyRNwohAMz3bxhfgcoTRddq/jiN1
         dA5xCvzn6/CS/yMKQh20U6Yo7drssv3AK/uAxIzQ4Z1Dyd7FYD0tiyG/knws9cGltwC4
         crtsypmtPJm0fsJHKmrB0eDQELBIuHZH5hjd9NHVnhYpMsPPnDMuK9GgqsnrYmOfOysW
         i+wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Sv1NQgDBOCGlMs08EpEmF+19LOOwRRmHab1ndrX9ex8=;
        b=TgycdLMY0u+GDfhdBWkgkXosjLZhxuefpHxHCHx/zhvzPYEF/gSn8ygQijpClkxisy
         ajizUXOAeXtDX8BvBhbguUx4TcwtFPIifHiAYvE/F0YbYwe8sXapsNrUpaCr6M6HqSFe
         P7ldT0ld4U3jDpjIJoh3/CsmGAztx8ZzPr4iJ6VQAyRSHM/R+ecDE81ct8bcp6maYQsP
         DlaJXhB84IXIVxTRh9PuqbxZw5+vZb+xoxCa/TeIsV9BWoSMunC7bnWUiKUmrHNkbW/v
         68MCGKm9nJdBwXcbZkBiF840UOiFvqaliJCI/4w4iSPYfRQc1jK2IOIQ7D3GgbR9SwZI
         mnfw==
X-Gm-Message-State: APjAAAVfiZwJOzll+FpRCzJ7lj/h2dxb79o/ufHORguUhFB7wxgtTYE1
        NkYe9QrQ1ebYYCLJUc4Gus8LxA==
X-Google-Smtp-Source: APXvYqzTZ1z9N/a8bTq3zrWV5UkbFeegR0TrUF80D7uOwn8yUKyoA4xJ005sTnYn5Dp8NKOkCRa3+g==
X-Received: by 2002:a5d:6942:: with SMTP id r2mr10087647wrw.363.1571463596774;
        Fri, 18 Oct 2019 22:39:56 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id t11sm7185588wmi.25.2019.10.18.22.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 22:39:56 -0700 (PDT)
Date:   Sat, 19 Oct 2019 07:39:55 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com
Subject: Re: [patch net-next] devlink: add format requirement for devlink
 param names
Message-ID: <20191019053955.GJ2185@nanopsycho>
References: <20191018160726.18901-1-jiri@resnulli.us>
 <20191018174304.GE24810@lunn.ch>
 <20191018200822.GI2185@nanopsycho>
 <20191018202748.GL4780@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018202748.GL4780@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Oct 18, 2019 at 10:27:48PM CEST, andrew@lunn.ch wrote:
>On Fri, Oct 18, 2019 at 10:08:22PM +0200, Jiri Pirko wrote:
>> Fri, Oct 18, 2019 at 07:43:04PM CEST, andrew@lunn.ch wrote:
>> >On Fri, Oct 18, 2019 at 06:07:26PM +0200, Jiri Pirko wrote:
>> >> From: Jiri Pirko <jiri@mellanox.com>
>> >> 
>> >> Currently, the name format is not required by the code, however it is
>> >> required during patch review. All params added until now are in-lined
>> >> with the following format:
>> >> 1) lowercase characters, digits and underscored are allowed
>> >> 2) underscore is neither at the beginning nor at the end and
>> >>    there is no more than one in a row.
>> >> 
>> >> Add checker to the code to require this format from drivers and warn if
>> >> they don't follow.
>> >
>> >Hi Jiri
>> >
>> >Could you add a reference to where these requirements are derived
>> >from. What can go wrong if they are ignored? I assume it is something
>> 
>> Well, no reference. All existing params, both generic and driver
>> specific are following this format. I just wanted to make that required
>> so all params are looking similar.
>> 
>> 
>> >to do with sysfs?
>> 
>> No, why would you think so?
>
>I was not expecting it to be totally arbitrary. I thought you would
>have a real technical reason. Spaces often cause problems, as well as
>/ etc.
>
>I've had problems with hwmon device names breaking assumptions in the
>user space code, etc. I was expecting something like this.
>
>I don't really like the all lower case restriction. It makes it hard
>to be consistent. All Marvell Docs refer to the Address Translation
>Unit as ATU. I don't think there is any reference to atu. I would
>prefer to be consistent with the documentation and use ATU. But that
>is against your arbitrary rules.


There are already params with abbrs that could be upper case. So if we
do uppercase now, it would be inconsistent. I just
want the format to be as simple as possible. lowercase, digits and "_"
is very simple and can accomodate everything.


>
>       Andrew
