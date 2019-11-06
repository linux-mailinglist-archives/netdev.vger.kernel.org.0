Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24442F2170
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 23:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbfKFWM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 17:12:57 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:37396 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbfKFWM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 17:12:56 -0500
Received: by mail-io1-f66.google.com with SMTP id 1so36738iou.4;
        Wed, 06 Nov 2019 14:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a6AXXiDwMuuZ4uTRzzBcyntqO8Z9VZ/tpEA/dPyvcUU=;
        b=tt47OVOkvGyMfWWQaMqHZ3NfGCe68pQKeZHi4674Pe/Rocbk53J8oWVbNKMp2E+e2P
         p1zti8xRG9Qppf93TwuCwpVnBXm6X0pUSW0P/59zHnM8Ayja7w8rDPJ0FOrWbcTNCI72
         2FKUZnGIwlZSDIh/OVT0fZptiG9LWSV2Rvpu6Jytr2G4+KqzVWUTieyRSDzz10QWNL5I
         zMFzGG6F4dMiUlXSRb8c9cL8BOSqTI8GkJCzi2MvDV5q6+XRqqEhWVEYLWLQwKQyoH46
         akQ6OXukvYC5mMnVwF1v0LzuXs96r8/FIYnQce92QQJltliBtXFPN4tjvnQT4+UvJh/s
         t9sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a6AXXiDwMuuZ4uTRzzBcyntqO8Z9VZ/tpEA/dPyvcUU=;
        b=Hk7QBdIQqFP/xsEV8oOwQWEfTUD2XJ7faGaYZR7O2JWRA+2xXcA0stF+jz3MuklIL4
         muZ/iK9PZ/v5lDNowK+AhKTQfq3LwP8i24P90nfpdtbAY9/pJ8A/SfMxuT3YiKvZwD/A
         s/0m74SjWA+W+9w0ahLVcgHrfP9NslOFpXkOtVHBe7E9f16QerM7oJxvP2a07zDE1JEI
         miSlHM9fFu9EoN1FFwFLrjcmUnBkn7fFDIMniZSwVMTQ5Q50ic5WNrmCdV+5gXKvD5ag
         botj3yszdUGAU6K9ktJ73aheIYiGD7NEiYrfhB97Yid3oZ7qQjZ5p/0gl8QJAF74cKZ3
         r09Q==
X-Gm-Message-State: APjAAAVC4C5462cUYjV1s8mgvgXa2LKTYt13eMoFKLUDaWjM/+YzPARJ
        ZilvKWMO7gRVTaPf51vxOY4=
X-Google-Smtp-Source: APXvYqz8c4qgU2suU0h6X/GB97Vk8RK+2wCICo/WkUtSgM2suKUIZLaIVJ6Ee50H6GNXGuiJy/4VHQ==
X-Received: by 2002:a05:6602:248e:: with SMTP id g14mr28235398ioe.6.1573078374482;
        Wed, 06 Nov 2019 14:12:54 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:ec38:6775:b8e6:ab09])
        by smtp.googlemail.com with ESMTPSA id h82sm5096ild.1.2019.11.06.14.12.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2019 14:12:53 -0800 (PST)
Subject: Re: [PATCH v2 0/5] Add namespace awareness to Netlink methods
To:     Jonas Bonn <jonas@norrbonn.se>, nicolas.dichtel@6wind.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net
References: <20191106053923.10414-1-jonas@norrbonn.se>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b6f0300a-7c12-bea1-6337-5a6202c63045@gmail.com>
Date:   Wed, 6 Nov 2019 15:12:52 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191106053923.10414-1-jonas@norrbonn.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/19 10:39 PM, Jonas Bonn wrote:
> Changed in v2:
> - address comment from Nicolas
> - add accumulated ACK's
> 
> Currently, Netlink has partial support for acting outside of the current
> namespace.  It appears that the intention was to extend this to all the
> methods eventually, but it hasn't been done to date.
> 
> With this series RTM_SETLINK, RTM_NEWLINK, RTM_NEWADDR, and RTM_NEWNSID
> are extended to respect the selection of the namespace to work in.
> 
> /Jonas
> 

Tests should be added to either netdevice.sh or rtnetlink.sh under
tools/testing/selftests/net for the new capabilities added here.
Negative tests as well.

