Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 895A26D288
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 19:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbfGRRIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 13:08:53 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44363 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfGRRIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 13:08:53 -0400
Received: by mail-qt1-f196.google.com with SMTP id 44so395148qtg.11
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 10:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=USt0IexcQjvJYvxGzdba0dOm2UuOA1HLqlGREVbtLts=;
        b=Uvq3qpm8Js07wkm2V2Xwy5/47i/I348bvzlZpQWYY8GSWsQdtz3AzpTOYT0Q/6z8Uy
         m9rdZwU3mtoCssBJn1Ji6Y0cieVTN4ShXZqp+FJKOzdnakGRU/ZCNbC6SGEePzxIsXY4
         ZZloVwxACv4LQ6iTzWLoEranET9X7xlOqfYd9NPiLvjQLIviZxxnoKW+w+kQmcxicFku
         FEenqXgWqeI6EEfW5AI43b9J286CL/weeSMVsEI+ZfytbP16WQGCA2aYpJJlbHIKf6Fp
         kdGHdRANkQsVuEdz7DdGE8NheVeIVv4WSzpKBT1OZDe7Uxu4ruYW2zV+HcBUy4FfX1DC
         k5eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=USt0IexcQjvJYvxGzdba0dOm2UuOA1HLqlGREVbtLts=;
        b=FlO2n1b2KmrI3tf5ASZsFeAvJOwc9xl8F7lpzQ5wgym78fSCe7ze7xLPuk/1yUXGA2
         mzaa6MiKedKRTkEKN5aREOztl1+L7BGRagJhAx77J4kCo5ysURPy6v5LWswWwuSuQKul
         0RFVlxwYEUHPwdwLIHuNahcVnS/hNuwWTnfH5A9Ph9M9EKZJlJCNqGuCAjdx6+6Ppkpw
         K8BU2grpvnn5kvsRipajFMZ2FVT2T7OgIlPE2kH4N1dkDQjqBpNrRVAry8e10XXAg0fF
         0u2tKGZAwVzYCwzOr0yjyYcSZinGQwCg6T4d9krT56xZlhVYz7PvNSWVVDdLYLs62oyz
         T0Aw==
X-Gm-Message-State: APjAAAVYUpFixbcqwHwhtvOc1+fJHe5ky9QK+npvzoODqoBeyZnEJ+9B
        w4MvC8WkAL/Z/Ij3S0U3fBDUJQ==
X-Google-Smtp-Source: APXvYqycwgEwZ+jW/rNBxXJqzQViktl7Li02yI902yhAwUkM4udCUDMryMpRqGf0lyvuq8hpsI/vOg==
X-Received: by 2002:ac8:4a0d:: with SMTP id x13mr31988813qtq.356.1563469732549;
        Thu, 18 Jul 2019 10:08:52 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e18sm9914439qkm.49.2019.07.18.10.08.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 10:08:52 -0700 (PDT)
Date:   Thu, 18 Jul 2019 10:08:47 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [PATCH net-next 00/12] mlx5 TLS TX HW offload support
Message-ID: <20190718100847.52d6314b@cakuba.netronome.com>
In-Reply-To: <1b27ca27-fd33-2e2c-a4c0-ba8878a940db@mellanox.com>
References: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
        <20190705.162947.1737460613201841097.davem@davemloft.net>
        <d5d5324e-b62a-ed90-603f-b30c7eea67ea@mellanox.com>
        <20190717104141.37333cc9@cakuba.netronome.com>
        <1b27ca27-fd33-2e2c-a4c0-ba8878a940db@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Jul 2019 07:40:22 +0000, Tariq Toukan wrote:
> On 7/17/2019 8:41 PM, Jakub Kicinski wrote:
> > On Sun, 7 Jul 2019 06:44:27 +0000, Tariq Toukan wrote:  
> >> On 7/6/2019 2:29 AM, David Miller wrote:  
> >>> From: Tariq Toukan <tariqt@mellanox.com>
> >>> Date: Fri,  5 Jul 2019 18:30:10 +0300
> >>>      
> >>>> This series from Eran and me, adds TLS TX HW offload support to
> >>>> the mlx5 driver.  
> >>>
> >>> Series applied, please deal with any further feedback you get from
> >>> Jakub et al.  
> >>
> >> I will followup with patches addressing Jakub's feedback.  
> > 
> > Ping.
> >   
> 
> Hi Jakub,
> 
> I'm waiting for the window to open:
> http://vger.kernel.org/~davem/net-next.html
> 
> Do you think these can already go to net as fixes?

Yes, certainly. It's documentation and renaming a stat before it makes
it into an official release.
