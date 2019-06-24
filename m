Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCAD51D61
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 23:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729846AbfFXVvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 17:51:09 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:46706 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbfFXVvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 17:51:09 -0400
Received: by mail-io1-f66.google.com with SMTP id i10so771372iol.13
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 14:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PpfUZhccgL5mSq46PdVN5B+h0OQ4Od9Wcwg5XIblWi0=;
        b=dcQ05BwUuYogvOyUojzft4cNo/8ADUwGCLnC9nQtYvG1Dnp85XanAjMRCYLdgoaeZE
         ubPO8Xie0NV6TBeHY1vvnGmUjrkLzUlO/2Zna2NucbjChaygy5ewVfSsf9jkjtMSMGr7
         Ikn+8Qbt0m3Pvm/OeLiDzUOAYhQnjvY4yG+MJYd5XNqTIW1JW2u33S6OwGoLhI6VaCOP
         bSPT/UkC/TCQUF/4hx2J8U0tI58MU96Zpf/zs8Y53VdZQ7RY9nk6Cdf9JzqZCu8NJuTb
         dyp8RF8FPhUcmTUG7CQzf+fxoYZahLyKof70tx69y6pnIfHWMS5w96WfzZpy/fc1/DnS
         AlbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PpfUZhccgL5mSq46PdVN5B+h0OQ4Od9Wcwg5XIblWi0=;
        b=gdyGO61sPL1AS5bfVA93+20APlAOIrFXk4H3Bo0yd50kBOMCvIdfD2+qCQiKaR1AeA
         CtMv17AmzE3NMWwGXuwGbDg0QTQwwMyWcBWwo1rhp7uw/Kj/RmIi222UpTXPB0voskxh
         qMFArQrbTRzWjw3ogzHC+vl5aRSj+XsRYEsjG7NQen0Zjx4z+CpbJuaxRbumCHdZT9x6
         npCBp+vfOEx824vkuYs2ob46PnF5Vt5naHigwGDbsGm3C5nDee0hCE818qhJVHaPsdsB
         mAII83Hw+6mOoGFvK4MTwhnDrxyul0sw8V7n8OMJmM2e1djTxGDxadJFs1uaUC9nj6AZ
         HMLw==
X-Gm-Message-State: APjAAAUeXCCfoj5CWdoC+borTDeQVM3ZyEy5GoAr60gWoBfFwDyK8JLr
        1fwRaWzn7KQhTJwrMfrVfZE=
X-Google-Smtp-Source: APXvYqwnK/qV2/2KeKJ6v8zYMFOg7hYwjCLwIYkcOAEKMSxc8LkdwqjXzWMNo4XuE8s9TbB1m5BHtQ==
X-Received: by 2002:a05:6638:38f:: with SMTP id y15mr28768429jap.143.1561413068321;
        Mon, 24 Jun 2019 14:51:08 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f558:9f3d:eff4:2876? ([2601:282:800:fd80:f558:9f3d:eff4:2876])
        by smtp.googlemail.com with ESMTPSA id t133sm23312613iof.21.2019.06.24.14.51.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 14:51:07 -0700 (PDT)
Subject: Re: [PATCH iproute2 0/3] do not set IPv6-only options on IPv4
 addresses
To:     Andrea Claudi <aclaudi@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
References: <cover.1561394228.git.aclaudi@redhat.com>
 <20190624102041.25224fae@hermes.lan>
 <CAPpH65wG9OXhEnXd2LrL0wQc9P4G7MKQjQ4bUTHN1CVqAc6bMg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c344be9c-2194-c138-4fe2-cfaeb5d44cec@gmail.com>
Date:   Mon, 24 Jun 2019 15:51:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAPpH65wG9OXhEnXd2LrL0wQc9P4G7MKQjQ4bUTHN1CVqAc6bMg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/19 3:38 PM, Andrea Claudi wrote:
> I think that if a script wrongly uses some of these flags on a IPv4
> address, it most probably operates on an unexpected address, since
> everyone is aware that these flags are IPv6 only. In other words we
> are breaking a scripted setup that is already broken.
> In this case it's probably worth exiting with error and give the
> author the chance to fix the script, otherwise the error can go
> unnoticed.
> 
> If you prefer, I can send a v2 with warnings instead of errors, just
> let me know.

Recent changes for strict mode have shown people do interesting things
with scripts and like the silent "ignores". :-(
