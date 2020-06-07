Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521B81F0DAD
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 20:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbgFGSSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 14:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729965AbgFGSSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 14:18:13 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4F9C061A0E;
        Sun,  7 Jun 2020 11:18:13 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o8so7684674pgm.7;
        Sun, 07 Jun 2020 11:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZVbks2czq3xn3QchMjnyELV5UFJbemuq2LFS2IbPres=;
        b=rRd7NP9z6xbXv4fyy8KpovPn29MTJqqoSs6KpXXkOBQxnO33L8dlHN0EPayimjhXE4
         yGH0jDUiZjZ9Yk1dczo7Wy7kxUCc8RD0raNKEcopj/saSf1Fo2RSTkDhBRs3bDN4suGw
         CV3XFHYbQUxcNkr4wK/d8sm4fMgZtA8vi53jwZGADl86JFWDzvYEoYaDAO7HMuhJaUs/
         XZaSPC4QfstlQmactjnnb2WnXHCdI3OE7jfzwQoMOYF7xwce+gx8bfq4n5AzJ7J5irlQ
         0sINSZOQ5yb081/uyxq3s6CtGBN1VKaYXmGrrZcZ9RFb+D9RSvmPRmm0Vy46FUobnjEL
         hAhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZVbks2czq3xn3QchMjnyELV5UFJbemuq2LFS2IbPres=;
        b=LmWOf2NJlJXKqEY5nM70erftNLVKnUD+rqfhslWdMcGWSLrmtnzJc36Xg3GbLWNQxW
         UV/Sz0bdZtki41pI0y4o3Zw2JoGh4v5qtHMZPpm9c9mHO2UIt5kU2l0SFFz2FMXQZM47
         F920AMpntAeg5QpJ2mw42GtlS9tsT61DIZFMrjCitIxQpFE2ixSZVH3dNXOVIPT6xPem
         6w1817O1ahA6AdXGmieKf00m4uwWcYU4Gf5aRr/BU0TyPxci1CECGoW5hXH8bPhe/+yO
         HVPQxDZrLje490yLFJabFdH86R9U/FMPLTH4ooOJTBOKEDa4I9i7ngdZxe981Qot1fWn
         FWEA==
X-Gm-Message-State: AOAM530+P5XWEZrpQj9omx21CLCfgvvPWZqHJl3hfCc6Hxy+ljmKDp7j
        3Xw1GHAXDtmUiuhDdDeP/N5uXVtw
X-Google-Smtp-Source: ABdhPJxrNWuhXPQfrkVr6zODQvuUNrpO/ZIY5zHCxD4xc3HMipmPxvqJ406OJM0KJPuQysLsmEdvaQ==
X-Received: by 2002:a63:fe0e:: with SMTP id p14mr17043072pgh.126.1591553892226;
        Sun, 07 Jun 2020 11:18:12 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id d3sm4862677pfh.157.2020.06.07.11.18.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2020 11:18:11 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 08/10] selftests: forwarding: ethtool: Move
 different_speeds_get() to ethtool_lib
To:     Amit Cohen <amitc@mellanox.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        jiri@mellanox.com, idosch@mellanox.com, shuah@kernel.org,
        mkubecek@suse.cz, gustavo@embeddedor.com,
        cforno12@linux.vnet.ibm.com, andrew@lunn.ch,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20200607145945.30559-1-amitc@mellanox.com>
 <20200607145945.30559-9-amitc@mellanox.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <001bfa48-0c1c-752b-3cc8-8755a4a436b8@gmail.com>
Date:   Sun, 7 Jun 2020 11:18:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200607145945.30559-9-amitc@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/2020 7:59 AM, Amit Cohen wrote:
> Currently different_speeds_get() is used only by ethtool.sh tests.
> The function can be useful for another tests that check ethtool
> configurations.
> 
> Move the function to ethtool_lib in order to allow other tests to use
> it.
> 
> Signed-off-by: Amit Cohen <amitc@mellanox.com>
> Reviewed-by: Petr Machata <petrm@mellanox.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
--
Florian
