Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 866F8DA475
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 06:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbfJQEAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 00:00:09 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39025 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbfJQEAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 00:00:09 -0400
Received: by mail-pg1-f194.google.com with SMTP id p12so505416pgn.6;
        Wed, 16 Oct 2019 21:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2yNtlok8yGySrOHq9u2AAN+TVi78mKC0EXtVMDO7RbE=;
        b=UjfiBqxjEEkRWPhPRvbNe7ATaeszJmXFfY3w1zwUxW9IoXcHAJr9E/LvL0tg43UbUn
         tykduJvG+eQyFEgkfubVasyQ2oM6802QtNwa2uRTIZV2BWynCrKmlgCWWfasdULf7w8c
         wn7lqz5ihCqHtU3HBTHmSnLQGvY8/7uivC1WlA+TotlJUIFlRYFM3yQCrbZQ6CF2wrtM
         C/X13h4l83CO9YTztKaGITN5iUhYO1yCm6rKgJIBafHOkcSvXiFDNgKIFOmTLPJdcAKI
         QgrCCDOTFs40sXkoL155BPSVh7+V4obY5jSeF3Aw6thSK5QcaEcqrD6AgcjgiuO8zMqW
         nnsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2yNtlok8yGySrOHq9u2AAN+TVi78mKC0EXtVMDO7RbE=;
        b=UTHCt8I9QAkpgjKxhv4Di5oLX7OF/I+Fnee75HTSvao2rw2jCjyXZsdqSm8XvcxfNL
         NlN/2qoCFpe7DNzwcTchMCJ2og+hHH3AUjzMYbZ+FFveCbe/UGACeDuiP6y39mkELuks
         1qAi8Jxw0S/L9BM/diraWw483XoRqEPEnlHxK8vl17rb1DoE4crmv7vhROrjzPNO2c/8
         EkQdtdTKoBkCScbRzhmTEqT+JVMwSsQUMSGg7KMdCswa4/nnpocweCz662IDvNmmgUCE
         t1vv3PooJYULwuWz878jGHdUxTUNxGFz5wtPyEBif5wEGz32POGhD1Yz6ywahaBuTdto
         S67A==
X-Gm-Message-State: APjAAAXH8dFq7OljdW1OjCw2lRIPBNDTnv8dhfFnxwP//cf0bZrUapEz
        ueDWaAMUu7/9S8RRJ/nQNP0=
X-Google-Smtp-Source: APXvYqzVaMKqrv1ps6lbRrvel3jjyeCl1eSNaIfxx4celkd9tFL7+xNAkROVnFHyKwkPj7+OozDt1A==
X-Received: by 2002:a62:5c85:: with SMTP id q127mr1317813pfb.39.1571284807933;
        Wed, 16 Oct 2019 21:00:07 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id p66sm657775pfg.127.2019.10.16.21.00.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 21:00:07 -0700 (PDT)
Subject: Re: [PATCH net 0/4] net: bcmgenet: restore internal EPHY support
To:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jaedon.shin@gmail.com
References: <1571267192-16720-1-git-send-email-opendmb@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <597ee52c-4dc3-2bee-87c9-5f97c382c9ba@gmail.com>
Date:   Wed, 16 Oct 2019 21:00:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <1571267192-16720-1-git-send-email-opendmb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/16/2019 4:06 PM, Doug Berger wrote:
> I managed to get my hands on an old BCM97435SVMB board to do some
> testing with the latest kernel and uncovered a number of things
> that managed to get broken over the years (some by me ;).
> 
> This commit set attempts to correct the errors I observed in my
> testing.
> 
> The first commit applies to all internal PHYs to restore proper
> reporting of link status when a link comes up.
> 
> The second commit restores the soft reset to the initialization of
> the older internal EPHYs used by 40nm Set-Top Box devices.
> 
> The third corrects a bug I introduced when removing excessive soft
> resets by altering the initialization sequence in a way that keeps
> the GENETv3 MAC interface happy.
> 
> Finally, I observed a number of issues when manually configuring
> the network interface of the older EPHYs that appear to be resolved
> by the fourth commit.

Thank you very much for addressing all of those problems!

> 
> Doug Berger (4):
>   net: bcmgenet: don't set phydev->link from MAC
>   net: phy: bcm7xxx: define soft_reset for 40nm EPHY
>   net: bcmgenet: soft reset 40nm EPHYs before MAC init
>   net: bcmgenet: reset 40nm EPHY on energy detect
> 
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c |  41 +++++----
>  drivers/net/ethernet/broadcom/genet/bcmgenet.h |   2 +-
>  drivers/net/ethernet/broadcom/genet/bcmmii.c   | 112 +++++++++++--------------
>  drivers/net/phy/bcm7xxx.c                      |   1 +
>  4 files changed, 79 insertions(+), 77 deletions(-)
> 

-- 
Florian
