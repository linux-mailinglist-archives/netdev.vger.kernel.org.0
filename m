Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F07271A2553
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 17:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgDHPgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 11:36:45 -0400
Received: from mail-qk1-f173.google.com ([209.85.222.173]:44943 "EHLO
        mail-qk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728942AbgDHPgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 11:36:43 -0400
Received: by mail-qk1-f173.google.com with SMTP id j4so497583qkc.11
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 08:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=sxeWyCQdNpdEpYRo+Y4PyUMAycLOhv+ajInP2C0qDng=;
        b=FdyQUhHwVVN+YVFog1G/K82F75PnHQSrKVgdNBsxxljFrzZnjjgggGelu7PKhOb0Mo
         zAetRXRUv0YPP/aPvtHpTvoCAbBuC9ebAds81EJ2cu8g7ccJD1cHKu0UaXsZ3CHLRyKf
         ocafB04iiOLhAFzFUy9CP0au7kzUSfp8txaPWY8gTAS4LUX700OcGB2YL21MTFX+nrcE
         UR6umRU6LVEKvc//mMML9IIDYbJPTKFqz2dGMHDWl0r4rJNYqFAYnhG0ivqk8Xn82WyR
         dsuHVng4LL30THPA4TPKr1YiVwIh1kWNRnJkF1EwIlsOAxCHgr8D6UOIYTbEoHccSpiR
         8kNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sxeWyCQdNpdEpYRo+Y4PyUMAycLOhv+ajInP2C0qDng=;
        b=Kt+jwBJswx4nmLdNLEIdbjnY6Xnt1QInOBc0b1U+UUe8jUgQM+u+l7QAhoOtaAF5HT
         pB7+a8edxzJkz18mkL/sJrnKxkkPd/Rwkn+b7HXihrbF0eI/VWNAa82bPw6qpOCOiJ2x
         R8/CWwMHq5WOrxd8RTJc3DwibdGcA5/WjPDjCbC6TGA8sWbOLAbQWzzZPVeUfXveaq8C
         7ZGtpIohzhsF7kbdHJFNnkWEAX1Xc4rgm0+I8sVCResjdJuthH0ommilUueKhTirsBkI
         47XYktj9SjD3IFIHYi0Nn3bO+xhnpud7OXfhkEdnnZaeopPZ5MkUlMsQWE8w9lEazyO8
         1yVA==
X-Gm-Message-State: AGi0PuYPnlqOXPj0ytGxtESVcvwCSGaqMsavSozPHNhGJBhRGISMOEdP
        bjBsmLK1yoqn24lxg4zmqk04C6z9
X-Google-Smtp-Source: APiQypKxPH+ei3IoV1I4l9d4UoUcVuanfephySr3CEpUkvmTJVC9xvr0MxKywXAZb92/m6DjDZ+BoQ==
X-Received: by 2002:a37:8781:: with SMTP id j123mr5904928qkd.308.1586360201856;
        Wed, 08 Apr 2020 08:36:41 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:440d:6925:c240:4cc1? ([2601:282:803:7700:440d:6925:c240:4cc1])
        by smtp.googlemail.com with ESMTPSA id b82sm7767199qkc.13.2020.04.08.08.36.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 08:36:41 -0700 (PDT)
Subject: Re: VRF Issue Since kernel 5
To:     mmanning@vyatta.att-mail.com,
        Maximilian Bosch <maximilian@mbosch.me>, netdev@vger.kernel.org
References: <CWLP265MB1554C88316ACF2BDD4692ECAFDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB15544E2F2303FA2D0F76B7F5FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <CWLP265MB1554604C9DB9B28D245E47A2FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <ef7ca3ad-d85c-01aa-42b6-b08db69399e4@vyatta.att-mail.com>
 <20200310204721.7jo23zgb7pjf5j33@topsnens>
 <2583bdb7-f9ea-3b7b-1c09-a273d3229b45@gmail.com>
 <20200401181650.flnxssoyih7c5s5y@topsnens>
 <b6ead5e9-cc0e-5017-e9a1-98b09b110650@gmail.com>
 <20200401203523.vafhsqb3uxfvvvxq@topsnens>
 <00917d3a-17f8-b772-5b93-3abdf1540b94@gmail.com>
 <20200402230233.mumqo22khf7q7o7c@topsnens>
 <5e64064d-eb03-53d3-f80a-7646e71405d8@gmail.com>
 <d81f97fe-be4b-041d-1233-7e69758d96ef@vyatta.att-mail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fb75df70-ef65-320c-7be5-ed51193f354b@gmail.com>
Date:   Wed, 8 Apr 2020 09:36:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <d81f97fe-be4b-041d-1233-7e69758d96ef@vyatta.att-mail.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/8/20 4:07 AM, Mike Manning wrote:
> Hi Maximilian,
> Can you please clarify what the issue is with using 'ip vrf exec <vrf>
> ssh' for running the ssh client in the vrf? This is the recommended
> method for running an application in a VRF. As part of our VRF

Running a client in default vrf and using route leaking to get the
packet to go out is a broken setup. If it ever worked at all it was
sheer luck and not the intention of the design. Route leaking between
VRFs is for forwarding, not local processes. If a local process is to
work over a VRF it MUST set the VRF on the socket; anything else is just
broken.
