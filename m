Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1364E6C80D
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 05:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389378AbfGRDiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 23:38:52 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:40738 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732313AbfGRDiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 23:38:51 -0400
Received: by mail-io1-f67.google.com with SMTP id h6so49201950iom.7;
        Wed, 17 Jul 2019 20:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fk4+0dkj6XW4PdBFQ9USPjNyxNqr0ymaYJUY6l7wSCI=;
        b=Iun0xdLJZkCepCGZC37X8gm3BIJxpbCCrU0X2uuED49qwnYrFyAS/lkMo2sX8msdFr
         Yp2jwwNrMah4eiSpjKWBaHFpBWWOj2GAAPV5eIPlI6RcQKwEkWfPW8IpVeJ/86SUKqcT
         YUE4y7oF5DDFWAbBMfiDA2ffPOtlefqaoX2potS/gecAdcWnlK1kHXO082mhhbsqOcGF
         HvdKxYsSLookVOy5BV+Rm1rp/nZdfqK6d6BNIqhLHflZUngI/UrNsIpuJAP0Oaq9Tvp/
         iUGRkERQ5FCKeMnb4o75sLnf5hwZEFmWuzntsay6ompugmfcD4foC04Aov2Gjtjx/GA0
         SVEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fk4+0dkj6XW4PdBFQ9USPjNyxNqr0ymaYJUY6l7wSCI=;
        b=GRIsI1nfhdYujgdLbCaIa7B4zO34OpzxTScLdyqM6fFNhEWHqek/9FercTbVFVtU6T
         8kX4CSDN7y73Wjyr8H6jR311lv4LSfXF1J+81z7h5b+AqYEhbbYoO39xB7JQ34+yjwA/
         D/ULr8Z/2dnxOsCcP0FOSiZ1eOgqn19NBQZ/XamMfwjDwSIsukFc2vyMwDwdcTzOOVBt
         J8TqO8PYk3OWu8ykwwYCh3CJeA5mLNfiYywhoplAcIC/lR1Pb48GsZDYVyDU0WpkB+4m
         9+k30koEjsvS1im0XTDYwcz0S1atUT39SoYd1lBNY92BF+aCwpgGgfd8K14LfzVHy24P
         FsTA==
X-Gm-Message-State: APjAAAVLxQxr45KFFv8VQxdY36TyRxmGCdY51Sp92oGoYYAN944N5QBO
        xfnSDz28+zpxNNZA7Ad9+3xhOMex
X-Google-Smtp-Source: APXvYqwKhnC9gxziYrH2f6czN938M8/iDu/mMZzx0PmiTAb7Z3AJ3mOaX9rVDK11ozYDDhZx4JNj3w==
X-Received: by 2002:a6b:7311:: with SMTP id e17mr43085658ioh.112.1563421130902;
        Wed, 17 Jul 2019 20:38:50 -0700 (PDT)
Received: from [10.230.24.186] ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id m10sm43708928ioj.75.2019.07.17.20.38.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jul 2019 20:38:50 -0700 (PDT)
Subject: Re: [PATCH] net: bcmgenet: use promisc for unsupported filters
To:     justinpopo6@gmail.com, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, davem@davemloft.net,
        opendmb@gmail.com
References: <1563400733-39451-1-git-send-email-justinpopo6@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <5f6422b5-e839-1600-6749-048a7e31ea96@gmail.com>
Date:   Wed, 17 Jul 2019 20:38:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1563400733-39451-1-git-send-email-justinpopo6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/17/2019 2:58 PM, justinpopo6@gmail.com wrote:
> From: Justin Chen <justinpopo6@gmail.com>
> 
> Currently we silently ignore filters if we cannot meet the filter
> requirements. This will lead to the MAC dropping packets that are
> expected to pass. A better solution would be to set the NIC to promisc
> mode when the required filters cannot be met.
> 
> Also correct the number of MDF filters supported. It should be 17,
> not 16.
> 
> Signed-off-by: Justin Chen <justinpopo6@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks Justin!
-- 
Florian
