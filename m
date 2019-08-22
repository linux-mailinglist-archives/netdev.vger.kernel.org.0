Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 005E098D70
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 10:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731236AbfHVIUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 04:20:23 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:42518 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbfHVIUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 04:20:23 -0400
Received: by mail-pl1-f171.google.com with SMTP id y1so2996806plp.9
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 01:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ctiA84ohVmTjNv2+hqGjHDIQgnDRE1bhV/IqP0i9Dzw=;
        b=fr7VI1LWXRERQsoFv4QBUBejCumCfvjFhSjVWJ50zN52NCLJPCrpeutXHrVvne+5SY
         7XGL7Na6Ju6dkV1iImP5M/Z/fCdbXLloOAxvYg+8SJpYcpltsJ2jOt19K02AZbHexGqo
         95tkmLY7MaCr6jgqp4/VREp41Y2GstW/5ReMz5WxbYy5si1U6mtuIfVf+l6swI8Mq2ZU
         x0cth2u6pKfnIdS1ff8Ol/3mw23Mty9R48e706kdrW0MKKMEPn3WA7SQCz5N2XH9lpVn
         9laft0o5533OdzrCTg2vwlglcD57rg8VV1xE3Jie/dQPi64iHUP7zyYtgOM0Mw8QUs1L
         Yu2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ctiA84ohVmTjNv2+hqGjHDIQgnDRE1bhV/IqP0i9Dzw=;
        b=LxbhARs1HzqmfsAilwC0w7336u+l0+3E8sX0INvvli7m4WxgGontJFDEx4cvp9fqtt
         O07WNDmabDcaY1IPPFnLqRkRdGKQ23Ay2RUpo4fG6z7IbeQahq0rTywZgC+9PZN3Rmb0
         NjKysGclQKGgZQCbTFFo4ns9Vg3CdYayNjWp31FuIKDrpJk48myZcHC543TvoDk0aMJ1
         QlaUfGB/vvfvWwdO3dRKt5asckZKqPu4ka1GWqp3Ri3dkTp+oHyLaAc+bPWM5EDiIXyk
         kbnjxp1oO3i7kBTYvpyd9kVl4txdI5SvZFMh2tc6mVlI34s6n7fCDGuLL57S6EBItUDQ
         msgA==
X-Gm-Message-State: APjAAAWSGoERDa5BffF1Tmnm3cBnp03ScqsIFWwrotdGxyG5NflJB0ir
        DLuOJLU7h3Xq/eb3xzg7n9M=
X-Google-Smtp-Source: APXvYqy2KpTEL6ADh9i5kRJTORl27KQxD/zlzkCzevZ03a4zWBXICc8lRo4G+LlR9KEyqBQpPd5OXQ==
X-Received: by 2002:a17:902:7288:: with SMTP id d8mr38419287pll.133.1566462022429;
        Thu, 22 Aug 2019 01:20:22 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m125sm26508056pfm.139.2019.08.22.01.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 01:20:21 -0700 (PDT)
Date:   Thu, 22 Aug 2019 16:20:12 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, Madhu Challa <challa@noironetworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jianlin Shi <jishi@redhat.com>
Subject: Re: [PATCHv2 net] ipv6/addrconf: allow adding multicast addr if
 IFA_F_MCAUTOJOIN is set
Message-ID: <20190822082012.GE18865@dhcp-12-139.nay.redhat.com>
References: <20190813135232.27146-1-liuhangbin@gmail.com>
 <20190820021947.22718-1-liuhangbin@gmail.com>
 <4306235d-db31-bf06-9d26-ce19319feae3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4306235d-db31-bf06-9d26-ce19319feae3@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 10:33:58PM -0400, David Ahern wrote:
> On 8/19/19 10:19 PM, Hangbin Liu wrote:
> > But in ipv6_add_addr() it will check the address type and reject multicast
> > address directly. So this feature is never worked for IPv6.
> 
> If true, that is really disappointing.
> 
> We need to get a functional test script started for various address cases.

Do you mean an `ip addr add` testing for all kinds of address types?

Thanks
Hangbin
