Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5409E109531
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 22:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfKYVik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 16:38:40 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35237 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfKYVik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 16:38:40 -0500
Received: by mail-qt1-f193.google.com with SMTP id n4so18996166qte.2
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 13:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nJcAHpdSxlZlJlKtz74RXRwjIKCqX8Ch2BdxATDK5no=;
        b=qkZc96m2r/EG/m6MniOMv6uV8wvl+n888JL7/+piu3lnAcOxSTlm3ne+Ra4nUW9yHV
         30V9wtRa9sxzqJTzEtj0LpZ5GNKY0JrZrx7o/HJyDA/yXJC+37zNlLALBfIPsWp7/FYW
         /ZqYwc7rbsifiwnRnHVDUQt21gC/s1MEn7gFUQBMqzUbBdyeGvXuX/zfaH5Rp3WwiIrp
         6d6TDUKxPQVkuCfW7FsiqC/bvQijxWy/DonL/9S51ylHHGCwdmm//xwHyPAkyImaJpTO
         dZP+9amMY4RYYbkutq1vyYRiBgGcX3sYCF7m/2PbF6FUE07/Xuxv+naxJG+ZWvNqUpHN
         ouEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nJcAHpdSxlZlJlKtz74RXRwjIKCqX8Ch2BdxATDK5no=;
        b=ivPfBFg0QBLvhThYnsjUxMuv6ZPXj3gFBc2z+45MORC0S51a4RnsKNbo/D71WbyFP0
         fIr6SJATRjx1kV/RUX9o2zQKt9awPTT63XS82AC5f8+dhrLLirAFOhCorZdYXft/aqH0
         EqMPwmU6dLG48YdAbZ0SdGOsild+UCUpxaFJbHIcwh7aYe9WpWlEpNjyOmRlIexW9+CP
         I2IZFxEP4/goTx4S6M2j2brZOVN+hquM21OueY4Nsl7DvX4UHZsHV7slkioDuB36xte0
         tfshtgWOhbIptfMwSBmOLO85+LQCe9/f3g6unMSFnGN6WBmQh/IBPayW3zhWQR5ADjMS
         uO5A==
X-Gm-Message-State: APjAAAWAUMRZPWYO5x01jHUmylwh7/PiQx75v3tc2Oc93KbmlzKgsjKV
        LI9AmgZR/uKDroefmt8r/6w=
X-Google-Smtp-Source: APXvYqy+1R3rzbWt5Jm94YBhGy+GvXI6oN1cBmPLdMDa08XrGNrovqkIgFbimhCZcQgG7rMew6bHHg==
X-Received: by 2002:ac8:542:: with SMTP id c2mr16369732qth.56.1574717917851;
        Mon, 25 Nov 2019 13:38:37 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:c06f:8df5:46f1:d3e5])
        by smtp.googlemail.com with ESMTPSA id k3sm4038611qkj.119.2019.11.25.13.38.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2019 13:38:37 -0800 (PST)
Subject: Re: [PATCH iproute2-next 0/3] flower match support for masked ports
To:     Roi Dayan <roid@mellanox.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>
References: <20191120124245.3516-1-roid@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <30715aec-584a-aca7-1bed-ec01cb00fb6d@gmail.com>
Date:   Mon, 25 Nov 2019 14:38:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191120124245.3516-1-roid@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/19 5:42 AM, Roi Dayan wrote:
> Hi,
> 
> This series is for adding support for flower match on masked
> src/dst ports.
> 
> Thanks,
> Roi
> 
> Eli Britstein (3):
>   tc: flower: add u16 big endian parse option
>   tc_util: add functions for big endian masked numbers
>   tc: flower: support masked port destination and source match
> 
>  man/man8/tc-flower.8 | 13 +++++-----
>  tc/f_flower.c        | 73 ++++++++++++++++++++++++++++++++++++++++------------
>  tc/tc_util.c         | 12 +++++++++
>  tc/tc_util.h         |  2 ++
>  4 files changed, 77 insertions(+), 23 deletions(-)
> 

applied to iproute2-next. Thanks
