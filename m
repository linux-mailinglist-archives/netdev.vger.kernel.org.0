Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1219B7B4B8
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 23:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbfG3VDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 17:03:05 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36111 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfG3VDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 17:03:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so67318795wrs.3
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 14:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FPr+LzpDg5/UlcmRNbQ05kmToPxklejST3vORmEqpjo=;
        b=xVGfrxCBpXYDwatAAz0wvQ/FwhwYjBV7bQybvpJcsiBqdJ1EP7mV7MUbdbDjptUnfX
         QCOt5cyWpVIKh9wa6yuJk2FCEw3zp/Sf0cpujCsAKrjUTQ2H3PKfNsd9Xe5M4+w3Ty0G
         q9Wh1pWQgEXjGNFmiPizzwyzqewaLks8ljTESd8TBGJIcSunNwf0f4yDe0N8JV01lvRX
         E0h7pumZ/RcCROmiftCRvrIIYymdobSdOXGfiY35qblP0K6EeWCBX/2Ub1G7EHAULuQd
         rjim4YE+zKMcg6vS6RUexB5vpzslhcIEPbZhxMqSep3ZmAaSAn8dhyfKfP3fdph2k8Qc
         jKJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FPr+LzpDg5/UlcmRNbQ05kmToPxklejST3vORmEqpjo=;
        b=cKgspAEJyYvNPpgp/MmmFD48dNW9Wz5iBNeLm3ZwuIh4BjrlNZbPn1+Q/Ke5fndk26
         n/DlDPSTlpnV9kh5n93wXZnQL7ErlaTMak1e6Kx2nObnXo8TXl+G5RF+uOZUw5TAbS6s
         b+EVaH+MMtNa2lAEZ/tg+wYuOQKvoRHcHt/bzZGA3fAah1S0ABAMX97ukhv9xG4jSEDL
         uVM/Wu2bIbgFSc3Ia75e9so98mz01gr47X8AUUoMdM47z57EbkRdD5HmZOOE4dZbMTd/
         q86y2cwPIbOxvLcmyx3EsI4L7BhG+Nco2/iWttWoJeuUi+ZLJFELzVhsjkMqYgUugU1J
         p28w==
X-Gm-Message-State: APjAAAVGWdvX+aSS6v/9/uA+9D3ivstMUHuTDVQojM5QgOgwKSP3PbUy
        epSxXySxK9c0ol1ftU/q8Sw=
X-Google-Smtp-Source: APXvYqzAeUPE0I6WTi+2CaqccHTK7KQfiU+wMIlMGRvf3vNzJ4hJlq0e9k+jGoqVZ36U36in1RVyNw==
X-Received: by 2002:adf:ed41:: with SMTP id u1mr123312712wro.162.1564520582852;
        Tue, 30 Jul 2019 14:03:02 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 5sm53767607wmg.42.2019.07.30.14.03.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 14:03:02 -0700 (PDT)
Date:   Tue, 30 Jul 2019 23:03:01 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch net-next 3/3] netdevsim: create devlink and netdev
 instances in namespace
Message-ID: <20190730210301.GB2288@nanopsycho.orion>
References: <20190727094459.26345-1-jiri@resnulli.us>
 <20190727094459.26345-4-jiri@resnulli.us>
 <20190729115906.6bc2176d@cakuba.netronome.com>
 <20190730060655.GB2312@nanopsycho.orion>
 <20190730101411.7dc1e83d@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730101411.7dc1e83d@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 30, 2019 at 07:14:11PM CEST, jakub.kicinski@netronome.com wrote:
>On Tue, 30 Jul 2019 08:06:55 +0200, Jiri Pirko wrote:
>> >> diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
>> >> index 79c05af2a7c0..cdf53d0e0c49 100644
>> >> --- a/drivers/net/netdevsim/netdevsim.h
>> >> +++ b/drivers/net/netdevsim/netdevsim.h
>> >> @@ -19,6 +19,7 @@
>> >>  #include <linux/netdevice.h>
>> >>  #include <linux/u64_stats_sync.h>
>> >>  #include <net/devlink.h>
>> >> +#include <net/net_namespace.h>  
>> >
>> >You can just do a forward declaration, no need to pull in the header.  
>> 
>> Sure, but why?
>
>Less time to compile the kernel after net_namespace.h was touched.
>Don't we all spend more time that we would like to recompiling the
>kernel? :(  Not a huge deal if you have a strong preference.

I removed it in v2. I don't care that much either :)
