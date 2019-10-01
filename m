Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5B33C3914
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 17:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389714AbfJAPaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 11:30:46 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40836 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbfJAPap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 11:30:45 -0400
Received: by mail-pg1-f195.google.com with SMTP id d26so4433765pgl.7
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 08:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TkD7I9ty6FO0woxzRbeHz509GxHWBF2Phc5itsOkhu8=;
        b=S0uL2A7YhSTVTYsLiai9kPDdsbDAlvI9x815Wr431Hw1kuz9kvY73JsvL30pFFzeJ/
         M8l2JfvmR++B8UQ6o8kvSdcPzShmP4na/dm5xBfMfNlmy+0xSSbcudYMaJSOwxwXDZ8m
         UXDZlncdmWkvwkkIt1H9t/ocAYGb9oHdljZVpHLspuEEdBp8SPsNWkZNL3IIX2nXc7xP
         SD6Uxnsc/iODExukPz7Eo8BgkjUJwi2XWFPDu23wIkbnOTA/ca9TM1j9rAjB9i4fPoBA
         L7w3tB9BrCSZRKQPyukihdNkMIIEDlzoY400gU02YdGGZSmPM766Z7beKtB+/iftIjaf
         m1tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TkD7I9ty6FO0woxzRbeHz509GxHWBF2Phc5itsOkhu8=;
        b=LUXZopfYQ3NGcd2OA/exr7aawQQdS2dRSG2LxmEt1s7f+Ab6gvWHwlLZAWtFeUQPRy
         qsbtxXPc3Rr9AhzCH3RsU7XB++y56NufmYyjwZzK0Yy98sSvcSYdkFv2O2ILf+hp+1MV
         tNs5sAaglS/0NN6gVPI7WPe0pZI2chSOB+AfNzWzKlo25Jc4pH3ptgy+Wm8HVGqv1O8R
         bjq0fPurIkQH9Sps9XxLrvSxkFwjFFfvP+AWG4wC3cHVY58KUIff+FP6V8bI5rd+eoVb
         ghfGQEsR1efwMzXdFrzLETqwrx0FmhDQnTXHrntY9XG5o0NHb8eXorTA6Ed4oGfOjbH0
         1MCg==
X-Gm-Message-State: APjAAAUG2q0+RsuS8aQPxN6NQKymG5qJEBLhGTTVbtcNV5d9QvS81SC1
        RPwelhSrPRidywbrRR2vJIk9qJF1Ags=
X-Google-Smtp-Source: APXvYqycwXwTqS+FONVqBTrGR561YOuZl/mmnis3anoeiv5l1C9t478Q2MOs8Z7fK271VGJuZcg3Hg==
X-Received: by 2002:a63:de53:: with SMTP id y19mr30220533pgi.243.1569943845127;
        Tue, 01 Oct 2019 08:30:45 -0700 (PDT)
Received: from [172.27.227.153] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id r21sm19839771pgm.78.2019.10.01.08.30.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 08:30:43 -0700 (PDT)
Subject: Re: [PATCH iproute2 net-next v3 0/2] support for bridge fdb and neigh
 get
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, ivecera@redhat.com,
        nikolay@cumulusnetworks.com, stephen@networkplumber.org
References: <1569905543-33478-1-git-send-email-roopa@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <02c6ab60-fbf6-49d7-7e6f-f50b8b7d86d8@gmail.com>
Date:   Tue, 1 Oct 2019 09:30:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1569905543-33478-1-git-send-email-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/19 10:52 PM, Roopa Prabhu wrote:
> From: Roopa Prabhu <roopa@cumulusnetworks.com>
> 
> This series adds iproute2 support to lookup a bridge fdb and
> neigh entry.
> example:
> $bridge fdb get 02:02:00:00:00:03 dev test-dummy0 vlan 1002
> 02:02:00:00:00:03 dev test-dummy0 vlan 1002 master bridge
> 
> $ip neigh get 10.0.2.4 dev test-dummy0
> 10.0.2.4 dev test-dummy0 lladdr de:ad:be:ef:13:37 PERMANENT
> 
> 
> v2 - remove cast around stdout in print_fdb as pointed out by stephen
> 
> v3 - add Tested by Ivan. and address feedback from david ahern
> 
> 
> Roopa Prabhu (2):
>   bridge: fdb get support
>   ipneigh: neigh get support
> 
>  bridge/fdb.c            | 113 +++++++++++++++++++++++++++++++++++++++++++++++-
>  ip/ipneigh.c            |  72 ++++++++++++++++++++++++++++--
>  man/man8/bridge.8       |  35 +++++++++++++++
>  man/man8/ip-neighbour.8 |  25 +++++++++++
>  4 files changed, 240 insertions(+), 5 deletions(-)
> 

applied to iproute2-next. Thanks
