Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA201AEFB3
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 18:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436878AbfIJQgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 12:36:10 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:56014 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436771AbfIJQgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 12:36:09 -0400
Received: by mail-wm1-f53.google.com with SMTP id g207so291796wmg.5
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 09:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yX4mCixapFDfY7k0zH7S2+gd8N0kbeApQgH5BOYL9bs=;
        b=SKe2036DLEwJfP14QnUMGSXBrlFae7no7la5B6GdlUM0LLwyP6HTDfDS7zYC5VM+lQ
         Od47aMka9Sbx7auj1QHLN0AEMz9nMtbY8pFNxz9M5/acrxsi3PeJFoLVzVO6bkWG6G23
         G4+3WJWUjIt0S8c0OXQCEqmJz0cqL5ybZQmraHaGin57U0G+PUaPHgp8XYP7C2J+yQ6t
         vrOY2mzVpVQ2EYyyw4ti4uIEWMEbsMLShD7WgAhFZ9KJrLJ+fv6j+xEQBQQSOcuruW9w
         GkI3vWHo7D1aMAVrMw9FRCG11ypeOQod/qjohJlXM5XXsSElIRUdmTbETVYkh+zJm0iM
         COBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yX4mCixapFDfY7k0zH7S2+gd8N0kbeApQgH5BOYL9bs=;
        b=cb0JA0SvefSoaG2oE/A8TdiV6yd8I05k3RJ2dKCa8ecklWpJsMTtA+6h1qDdsjV/9I
         y21T9VkeRhGi21dwbFpofBWHD8041UozM/i1Ww722AmonYEh9bwD6bp73w1nWVblirQK
         V6ArfvybKcqTjaSmXzqkI5UrUgfPdqRkosiNR31TRQAptfKs3LYjIc8TGwUSPkKj/AYE
         iDT0/uQox799H6Q7WKlAUzgi88qWwPoVtgA1VWeXAu7j++v1NwvOJWwMNQpLl0qGUspt
         st73F+DcaKQHeHCwIZaoji3mBjaD2zALASGSOLiY++RwUeEEANqHQ5sAowouxYXWunDl
         HU/w==
X-Gm-Message-State: APjAAAWOWcmDQQVjLs3jt6od0D+mTXJP5UDy/1jGtovfZegW03EbzhY4
        wd9IReWpIcxVcEmTFgBugYTKtPp4
X-Google-Smtp-Source: APXvYqzOVLUV+dK9a//vU3NG6qwz6+oIcTwbbQ/zm2E4SMSm+al5g54Yt/hioslebx2woYkOCmPwjA==
X-Received: by 2002:a1c:c90e:: with SMTP id f14mr295870wmb.54.1568133366155;
        Tue, 10 Sep 2019 09:36:06 -0700 (PDT)
Received: from dahern-DO-MB.local ([148.69.85.38])
        by smtp.googlemail.com with ESMTPSA id v11sm27718389wrv.54.2019.09.10.09.36.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 09:36:05 -0700 (PDT)
Subject: Re: VRF Issue Since kernel 5
To:     Alexis Bauvin <abauvin@online.net>,
        Gowen <gowen@potatocomputing.co.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <CWLP265MB1554308A1373D9ECE68CB854FDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <9E920DE7-9CC9-493C-A1D2-957FE1AED897@online.net>
 <CWLP265MB1554B902B7F3B43E6E75FD0DFDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <7CAF2F23-5D88-4BE7-B703-06B71D1EDD11@online.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <db3f6cd0-aa28-0883-715c-3e1eaeb7fd1e@gmail.com>
Date:   Tue, 10 Sep 2019 17:36:04 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <7CAF2F23-5D88-4BE7-B703-06B71D1EDD11@online.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/19 1:01 PM, Alexis Bauvin wrote:
> Could you try swapping the local and l3mdev rules?
> 
> `ip rule del pref 0; ip rule add from all lookup local pref 1001`

yes, the rules should be re-ordered so that local rule is after l3mdev
rule (VRF is implemented as policy routing). In general, I would reverse
the order of those commands to ensure no breakage.

Also, 5.0 I think it was (too many kernel versions) added a new l3mdev
sysctl (raw_l3mdev_accept). Check all 3 of them and nmake sure they are
set properly for your use case.

These slides do not cover 5.0 changes but are still the best collection
of notes on VRF:
http://schd.ws/hosted_files/ossna2017/fe/vrf-tutorial-oss.pdf
