Return-Path: <netdev+bounces-1487-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5199E6FDF9B
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:06:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B752C1C20D9D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:06:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4FBC14A84;
	Wed, 10 May 2023 14:06:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CD812B93
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:06:16 +0000 (UTC)
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3684E733
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:05:59 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1ac3fb15f27so8016375ad.1
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683727559; x=1686319559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2l4QawA/gJJIVcBoZQmgt6GDYVIz7HiV8g4eT0bKQoc=;
        b=dWM+ezfdAfzSxfF3uqUQM5gE2UtqZXX1r0yxLADX/9kgNteZXPALXFk6asFbL/MutV
         lvIb8rh2NG9HaY8a3LuYe7ka8k90qA22H56+kdQ5CjSn3dq//HZc0C37uyxmqjC9RB7b
         TYZ1FQanOK308ld8nAFU8Srj2eSDyRSr5DQotouHsqWw4XHrRmNBBoa2vn9EgRLNkcO8
         ZrOVtz2M8fWYWJ4pmDXIBSrnSYaGMddMkIhUvUOvGXMQ6zEBWKsMryDA+HKRq40CH8Zr
         4MSnDwshf2LOAMNA+t0h4M0CUU/heogEzBjGQuiFjsQusaN+oj7jofo+INb1U7/+FqaS
         Hngg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683727559; x=1686319559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2l4QawA/gJJIVcBoZQmgt6GDYVIz7HiV8g4eT0bKQoc=;
        b=RNfnGVYGnJKAuVAQQbCC67BPxpQNxz7JUkoTSjUQgRvNLWmXunrO2+tsFx4+/rp7Nk
         0ZaTSt9fGw0uxdB1PLBxdqveG8SKAS9Mz2uRReSqvgALRpGubnKX3iavqQ6ZPWDfOf9G
         vSZ6tncwIql6y6QG4ezvOl0RsOHOUSiYRpeKy6Cy1qoElJ0qnq3t6RxM/hTWxOH+GQwv
         mbxvZgXdkYd492wAI6KiYWvuRHzUWzhzoUKJm97iBP/s3Jr4GY1fQgwCtdU11tKZ7zja
         BWj6uDjqxMMHyrHp8SbFpjpGIGvqO8qCJK7rCQ4OeC+AZoPVsBirZW7GnYOh6Ftkw3Uc
         fGHg==
X-Gm-Message-State: AC+VfDyUKmAnfw/UWHaKp9JqBfgkUH7OY5Sfi9sXIVvtcZXC9gsMaSiw
	Sux+bTFwC2ewSs02lPQ67Iqi6YGrf2kyGFj9HVkVY721z0A=
X-Google-Smtp-Source: ACHHUZ5JVz75sHBVImT3M61UowUI4zQ5D7LaEhOW38CdiGOTyOh7vsW34DFCzKw+x/spl9wL6vpbSscRay+aJAxK+Mk=
X-Received: by 2002:a17:902:e549:b0:1a1:956d:2281 with SMTP id
 n9-20020a170902e54900b001a1956d2281mr22314712plf.3.1683727558946; Wed, 10 May
 2023 07:05:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOMZO5AMOVAZe+w3FiRO-9U98Foba5Oy4f_C0K7bGNxHA1qz_w@mail.gmail.com>
 <7b8243a3-9976-484c-a0d0-d4f3debbe979@lunn.ch> <CAOMZO5DXH1wS9YYPWXYr-TvM+9Tj8F0bY0_kd_EAjrcCpEJJ7A@mail.gmail.com>
 <CAOMZO5Dk44QSTg2rh_HPHXg=H7BJ+x1h95M+t8nr2CLW+8pABw@mail.gmail.com> <5e21a8da-b31f-4ec8-8b46-099af5a8b8af@lunn.ch>
In-Reply-To: <5e21a8da-b31f-4ec8-8b46-099af5a8b8af@lunn.ch>
From: Fabio Estevam <festevam@gmail.com>
Date: Wed, 10 May 2023 11:05:46 -0300
Message-ID: <CAOMZO5DSSQY5fa5vTmDbCxu1x2ZRdyB2kTqrkw5bRg94_-34zg@mail.gmail.com>
Subject: Re: mv88e6320: Failed to forward PTP multicast
To: Andrew Lunn <andrew@lunn.ch>, tobias@waldekranz.com, 
	Vladimir Oltean <olteanv@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>, =?UTF-8?Q?Steffen_B=C3=A4tz?= <steffen@innosonix.de>, 
	netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 5, 2023 at 10:02=E2=80=AFAM Andrew Lunn <andrew@lunn.ch> wrote:

> I'm not too familiar with all this VLAN stuff. So i could be telling
> your wrong information.... 'self' is also importing in way's i don't
> really understand. Vladimir and Tobias are the experts here.

Vladimir and Tobias,

Would you have any suggestions as to how to allow PTP multicast to be
forwarded when
vlan_filtering is active?

The whole thread is at:
https://lore.kernel.org/netdev/5cd6a70c-ea13-4547-958f-5806f86bfa10@lunn.ch=
/T/#m6453e569a98478bf5bddf09895393c3a52b91727

Thanks,

Fabio Estevam

