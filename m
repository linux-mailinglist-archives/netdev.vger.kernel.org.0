Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 133E1E8F56
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 19:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731768AbfJ2Sct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 14:32:49 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44076 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730481AbfJ2Sct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 14:32:49 -0400
Received: by mail-lf1-f65.google.com with SMTP id v4so7876790lfd.11
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 11:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Z5Aj+qriV1cCjc+x7sW+VKgSvEEniUKtqAhUlYakKPc=;
        b=cIDN3AFqH5pUJ2koKfI3y1/zAxFZ6APDktFGQju7aTe23ltl2aZMF1ipsLEmF5dlid
         HJaYylSImqtXWnnINy9VuAiNCPEoUwdBNQ4kNk2QKbmphOxZ3Id7oYrA1nXx24GQ4c7h
         NOHSeB9yqejTcWBLH3gmSeVc17ZG32sabKQPSpzzYivILNFHogOB+aGmfhqwUG5/iCoW
         J02IdinscNfeFfG0uT/djOq55+1Q3svsZ3wrIePm06xanT5rCVAGH46DF7SBDLWxO00N
         3K6rRIJ0eF+k/XiJziVKG33SNSxPNuC93eV0j1BxqSDPkysI1V06kS/3myqXmvAon/7x
         Xdww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Z5Aj+qriV1cCjc+x7sW+VKgSvEEniUKtqAhUlYakKPc=;
        b=bCP+4eE3Wf0KAIdqZhvgDjf5lR2ncXo4NG57FKBhG5qJbJeYGCxVfS4ca96YO057XF
         xdJ7/IlWtyoyKq6v3mgB7cCGVN+dY0UiZjR1QXibF5QCEkipAebxJQL/b3bKn+dAJFlg
         28oZ6u/Pr4W2Amghkry2w1XeScLZGsPK+J6q3i3Dk9wKp97aGXVkc/LIPQDczWfXiuL1
         JMy5FkyFFNtwMEsaWkUMMqvwfQy6ynGpk6+cjyzyWUW1fDegnum2LXDzqaT2Rl7gEXrw
         pBUSgatE9+pmngQu1SRd2gcqpztZmL7WFVnGriKhQ853p1SIS39J+qbY+mGdPTCAIa4g
         MZ3Q==
X-Gm-Message-State: APjAAAWSmjA4ze1Sn+t9GjgneAArqXnfPfrHmiPfqPDy7lfwMtHjT6FS
        jfgUR1RLPYn+V/QorYP8k0gIfQ==
X-Google-Smtp-Source: APXvYqzmT+Ai9RFC7leZMAvVaB1hbkKMIhgGdyPXXQAyo99EuOWML3f+eJcX+6ENzlUsAAr1Inw0fA==
X-Received: by 2002:ac2:5bca:: with SMTP id u10mr3416499lfn.134.1572373967444;
        Tue, 29 Oct 2019 11:32:47 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a26sm8029120lfg.50.2019.10.29.11.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 11:32:47 -0700 (PDT)
Date:   Tue, 29 Oct 2019 11:32:37 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Yuval Avnery <yuvalav@mellanox.com>
Cc:     Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        Daniel Jurgens <danielj@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next 0/9] devlink vdev
Message-ID: <20191029113237.032c7851@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <38f489d7-0c77-6470-35ff-8f86cf655495@mellanox.com>
References: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
        <20191023120046.0f53b744@cakuba.netronome.com>
        <20191023192512.GA2414@nanopsycho>
        <20191023151409.75676835@cakuba.hsd1.ca.comcast.net>
        <9f3974a1-95e9-a482-3dcd-0b23246d9ab7@mellanox.com>
        <20191023195141.48775df1@cakuba.hsd1.ca.comcast.net>
        <20191025145808.GA20298@C02YVCJELVCG.dhcp.broadcom.net>
        <20191029100810.66b1695a@cakuba.hsd1.ca.comcast.net>
        <38f489d7-0c77-6470-35ff-8f86cf655495@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Oct 2019 18:06:28 +0000, Yuval Avnery wrote:
> On 2019-10-29 10:08 a.m., Jakub Kicinski wrote:
> > On Fri, 25 Oct 2019 10:58:08 -0400, Andy Gospodarek wrote:  
> >> # devlink vdev show pci/0000:03:00.0
> >> pci/0000:03:00.0/console/0: speed 115200 device /dev/ttySNIC0  
> > The speed in this console example makes no sense to me.
> >
> > The patches as they stand are about the peer side/other side of the
> > port. So which side of the serial device is the speed set on? One can
> > just read the speed from /dev/ttySNIC0. And link that serial device to
> > the appropriate parent via sysfs. This is pure wheel reinvention.
> >  
> The patches are not only about the other side,
> 
> They are about all the devices which are under the control of a 
> privileged user.
> 
> In the case of SmartNic, those devices (vdevs) are on the host side, and 
> the privileged user runs on the embedded CPU.
> 
> The vdev devices don't necessarily have relationship with a port. All 
> attributes are optional except flavour.

Okay, true, you can list the non-port PCIe functions. I should have
chosen my words more carefully.
