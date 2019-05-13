Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5E31B715
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 15:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730124AbfEMNdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 09:33:13 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46435 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728222AbfEMNdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 09:33:13 -0400
Received: by mail-wr1-f66.google.com with SMTP id r7so14667193wrr.13;
        Mon, 13 May 2019 06:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:mime-version:message-id:in-reply-to
         :references:user-agent:content-transfer-encoding;
        bh=teT375bO6TJ8glZjydOwAY1PQ/QgD84rQrsAfXP4vYM=;
        b=TbTWE556Lo3wxRG7VbC3OZetVO/UnrGPx2+xtcqDSVDPd2cD79JA0gf5S+HfVRaqxk
         NCQ7zSu8RqSrA4ZGmeGY3OGdJzcGJymPm3rXWrhXa+a5fMqAfPcQB9bjNo9SpWSvO+7G
         ygnOsun5B+yaBj4X51i6+vdawVyG3f10MyPdXEYl+FdYgXby4n2LMaijNIraPD2ySZMv
         vuqPs/3KxzlOwb0bfsq24FoEubLiBm2yMf1zcszXVrHWQL9I9vCjuM62yEVnlZDve/NU
         bqHYn/N9aua4Y6EmKkfgX0fb0UbYJwBvUb4RDgbmN8ooPNV3yaCRtW3bIVr6d3CSMsuZ
         aqqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:mime-version:message-id
         :in-reply-to:references:user-agent:content-transfer-encoding;
        bh=teT375bO6TJ8glZjydOwAY1PQ/QgD84rQrsAfXP4vYM=;
        b=AwS3N7IR3iL0A/Jw4HM+PITf+jF2RWq5zlW9EWEU87/xXnkqwIfyVs34i/aZXybUWa
         b6mEwm5cV9m5WBmIffzRq71RLd22U7Ao9ZDxUyDAbBM3NIpmEcqZ7j0G1bd93u0jgb37
         WfXBX5ukrZIwRegVD3m57YMEJTtyXN6AJfpEchF62RBnsFAuNCOrlKXBfQ5tSdiz5ENX
         w1Fdbkn+yrEsMPJXWUfIbuWj+mh1WUqcMkuW7LehnmvUhlXPgVVFW2628OEwO+5/AB3C
         kdlquVHJsHsYRHDVZnzjvGGHiXfrVJ55R/7wdd3hDehvmjudlU3rkxnlYeQOrR5xOpcJ
         oTMQ==
X-Gm-Message-State: APjAAAVIMbx+3PTRUAvGHCw4HYiWIKTmJe86VSPoaQ7PaqLaFPfGKLF2
        +YyeW9aSk6el69hPgTBKFlI=
X-Google-Smtp-Source: APXvYqwYtUSX9zu79tdi0kPPiamTeGqSrAqroxqOyT5KkeJwOle8naEnnh3aNM1yNp5qiaYgPXEKxw==
X-Received: by 2002:adf:d4d0:: with SMTP id w16mr16976954wrk.244.1557754391619;
        Mon, 13 May 2019 06:33:11 -0700 (PDT)
Received: from localhost ([92.59.185.54])
        by smtp.gmail.com with ESMTPSA id z9sm15423480wma.39.2019.05.13.06.33.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 13 May 2019 06:33:10 -0700 (PDT)
From:   Vicente Bergas <vicencb@gmail.com>
To:     Serge Semin <fancer.lancer@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, <g@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: net: phy: realtek: regression, kernel null pointer dereference
Date:   Mon, 13 May 2019 15:33:08 +0200
MIME-Version: 1.0
Message-ID: <0c90c9cd-880b-4834-86db-f3e61c91c5f4@gmail.com>
In-Reply-To: <20190513130131.jiommbisqvydmzgw@mobilestation>
References: <16f75ff4-e3e3-4d96-b084-e772e3ce1c2b@gmail.com>
 <742a2235-4571-aa7d-af90-14c708205c6f@gmail.com>
 <11446b0b-c8a4-4e5f-bfa0-0892b500f467@gmail.com>
 <61831f43-3b24-47d9-ec6f-15be6a4568c5@gmail.com>
 <0f16b2c5-ef2a-42a1-acdc-08fa9971b347@gmail.com>
 <20190513102941.4ocb3tz3wmh3pj4t@mobilestation>
 <20190513105104.af7d7n337lxqac63@mobilestation>
 <cf1e81d9-6f91-41fe-a390-b9688e5707f7@gmail.com>
 <20190513124225.odm3shcfo3tsq6xk@mobilestation>
 <20190513125103.GC28969@lunn.ch>
 <20190513130131.jiommbisqvydmzgw@mobilestation>
User-Agent: Trojita
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, May 13, 2019 3:01:33 PM CEST, Serge Semin wrote:
> On Mon, May 13, 2019 at 02:51:03PM +0200, Andrew Lunn wrote:
>>> Ahh, I see. Then using lock-less version of the access=20
>>> methods must fix the
>>> problem. You could try something like this:
>>=20
>> Kunihiko Hayash is way ahead of you.
>>=20
>> =09 Andrew
>
> I wouldn't say that five hours is "way ahead". But if something=20
> fixes a bug in
> a patch it would be good to be have the original author being Cc'ed.
>
> Vincente, here is a link to the patch, that fixes the problem.
> https://lkml.org/lkml/2019/5/13/43
>
> -Segey

Tested and working OK now.
Thanks for the link.
Rgds.
