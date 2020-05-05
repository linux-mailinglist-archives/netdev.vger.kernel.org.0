Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51E31C4C9E
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 05:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgEEDTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 23:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgEEDTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 23:19:33 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D002C061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 20:19:33 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id fu13so391795pjb.5
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 20:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ql485aFHW8quVlerGG9ms+J5Hywqsnvoywo7XH/T9Jc=;
        b=cny0QiF9NxGp5pUZGFJw5uxKGXLOPd9MFOZtQ2oKgPgguJkFDaN6xDjyZJuinEr/Ko
         r8seea+agJAecf8t1vxQOTRQ1ZSEfjHXxybXdbFNDOgt3TYeNixqL0NGDLe5v8HRB6UH
         lW+EVfMtiH+UpCPhEqy7498+lw7yc/oD49HRWj8oj8NWTY33INEy9wqFS8zg024kfwO4
         8xYXkgQXTiZzpEkhy68i1Y7W1Z/g9qd9Da5uJKUkaQ7f44nIcHwcM5MqFFtcVmIE5QzM
         sXoweunvAoVdoOyDKkEhsM86pRiyD/EfXjtKySo4omjnFfubHoLE6wmQwz+Qq+ytgGS8
         A2ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ql485aFHW8quVlerGG9ms+J5Hywqsnvoywo7XH/T9Jc=;
        b=eJBKhISkEYGjJbmmjMJgSI7BHnYbUrFuFmc8+fwIQQjn7ftKEVz8BCVu9RfqZuxYz/
         pOc4WXO/ABSZKvJ9BVDV/Vw3yE/2Fmzr4xeBAeonsEbeZrHl8BNAZ/lFV5nJtN4RcpTd
         miexN7IeCHfPh1NTAWojdSYd1GBr+/34qAIXecj10O1cxwSrL2eywC55h7kzCyqa3Vq+
         AQQe2GiVVHMpNq+VwV5OG0omxVbmAQ/fvf/u4lc5/YNL6dKyL6zYP79IDglwBcF0Pxbl
         uqEC/b9nXwLU4yw5ax7/fNGfgVyiWuakOKGY3/8pHg+PxuaSmG/3JxZZOSloSAT28dhQ
         HGEA==
X-Gm-Message-State: AGi0PubNGQ2XaQ1xM0sWoKyWvl6TWbNSkAIFH6esVYMeM2kedt9JiEoh
        V6vV/uP1T/mSBAU/ieWnih0=
X-Google-Smtp-Source: APiQypKAgQ22febD8Jrn6ZQnxzeUHFTSDThQP9+l8E9CBKOwS0g5kBNOurkGGAXY4IH36SKRC2zHPA==
X-Received: by 2002:a17:90a:d24a:: with SMTP id o10mr344098pjw.18.1588648772526;
        Mon, 04 May 2020 20:19:32 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 128sm513464pfy.5.2020.05.04.20.19.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 20:19:31 -0700 (PDT)
Subject: Re: [PATCH net-next v2 04/10] net: ethtool: Add attributes for cable
 test reports
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, michael@walle.cc
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-5-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a31a1a36-5f9b-5283-b86c-94974d8dbf5d@gmail.com>
Date:   Mon, 4 May 2020 20:19:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200505001821.208534-5-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/2020 5:18 PM, Andrew Lunn wrote:
> Add the attributes needed to report cable test results to userspace.
> The reports are expected to be per twisted pair. A nested property per
> pair can report the result of the cable test. A nested property can
> also report the length of the cable to any fault.
> 
> v2:
> Grammar fixes
> Change length from u16 to u32
> s/DEV/HEADER/g
> Add status attributes
> Rename pairs from numbers to letters.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
