Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F080C2D156
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 00:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfE1WGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 18:06:17 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33846 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbfE1WGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 18:06:16 -0400
Received: by mail-pf1-f193.google.com with SMTP id n19so174346pfa.1
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 15:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pu/iQIYW7qvgkiNh0J6Znglf1J4UV3RQz2ZlYZ9mdLA=;
        b=Tul5pCN7qpmfXSFFOfClpPtAJN0N+8mA//Wp0xH6QxpSn8xrT2RKWWU/3eGNcTyF/Y
         2rhgqhKvJyPJUwck1q0h8/np5sDsw+5qKVir9DuFzvbIB7GBuNUp9ePdMFAXFwKOPH5y
         qFUm1Io5zWjqMfQRu/xCPqvvCSFVdMkR5k0AP/bNPbhP0OUs7crFT0WcnB6jpx79Wkak
         sdg3+JJlayVbD6H3pM3lkkcfFvLI9b9y7LzkMyLcXfMIyLUDQwfAl1HWslf0OPo6sZSl
         jc4p2u3p+3hp9Ag3zYZHOEVVCPVL7LG7v19qt1ZYCzMWCapqRFiELbBMEy3zXipsgPtd
         Ux7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pu/iQIYW7qvgkiNh0J6Znglf1J4UV3RQz2ZlYZ9mdLA=;
        b=taWUzXELzupUZ5kE5nuDlXbEEWzCIH8OreU0hzcTrTjr6yCXInkPlhPchiLjEDDbGc
         FHqow6eOfnDCKMep73zN5ziJzhV+praieFAY0FKVCBB4VYot2jqrSTZmCw7BnhyF2ghN
         Oh/7/FY2hsd2fG6bwZzNG1d4M+9gOj1D5FYvuv9l3+bu++zDqLdWjTYfeL1bta/NabAk
         9jIq1SQTawn/p/1F6cl4M05/mv2JQEUVeGn5uYIKS6bbM7AkvyY51o7EFYU+xfwt+aV4
         ZCralO0yS00RUThRZ9tWBM/VkUgltw29aPOsEOrk9NirFthtkGln/RLXwvjQYZto5RDD
         Atjw==
X-Gm-Message-State: APjAAAXMRScsrCVJY0njsXx672TTnMGcFBGQCCKmxpyvUhXY1iU3DhsB
        xuNiEq/Zdtkw7fj1LQ1HnPqp+VWX0DwU9gcE1adrTw==
X-Google-Smtp-Source: APXvYqwmrjmAjc2V3qQjlwV36mhNx8G4O68vfC3DzOXPBN+yecGGWiWpuCAHbPzTTZ4j+4461DtDv61IsW9VDNJycC4=
X-Received: by 2002:a65:62cc:: with SMTP id m12mr79957876pgv.237.1559081175986;
 Tue, 28 May 2019 15:06:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190528170236.29340-1-ldir@darbyshire-bryant.me.uk>
In-Reply-To: <20190528170236.29340-1-ldir@darbyshire-bryant.me.uk>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 28 May 2019 15:06:03 -0700
Message-ID: <CAM_iQpX2qDK94u8QncVLYrCSvxGHw=PijRy9VPFwPmXx8gAR=Q@mail.gmail.com>
Subject: Re: [PATCH net-next v6] net: sched: Introduce act_ctinfo action
To:     "Kevin 'ldir' Darbyshire-Bryant" <ldir@darbyshire-bryant.me.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 10:05 AM Kevin 'ldir' Darbyshire-Bryant
<ldir@darbyshire-bryant.me.uk> wrote:
>
> ctinfo is a new tc filter action module.  It is designed to restore
> information contained in firewall conntrack marks to other packet fields
> and is typically used on packet ingress paths.  At present it has two
> independent sub-functions or operating modes, DSCP restoration mode &
> skb mark restoration mode.

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks.
