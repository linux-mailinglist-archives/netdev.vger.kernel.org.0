Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3772E734A
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 20:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgL2Tvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 14:51:53 -0500
Received: from mail-ot1-f44.google.com ([209.85.210.44]:40509 "EHLO
        mail-ot1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgL2Tvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 14:51:52 -0500
Received: by mail-ot1-f44.google.com with SMTP id j12so12790865ota.7;
        Tue, 29 Dec 2020 11:51:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qco9tr50IvTpBmD0SEMx5Y9a9JGog/9aDolCVQBOnE8=;
        b=uGGg8Q5ylQTsrxrT3rGaxeEAwzQQ1YsX3nPSE39O6O+5Fw9GyWME4BExGj7gVgoc+K
         5/zjf/6jP3kABr/U1PZ3jBBFC3V+6OCoGSgaOOIlGSiRJzb3R8sk/Af4Ns5YwM6SANy8
         o2R1K297HPF1sXp9NQPVZDKndV5W268P02xiTGItj4n2PgiXpTO2yRC+Q9Ua4Zn/uXwF
         EYTO1bCCTo9fU6vuTZva20XpE3xNsk/kH868Huq/I0dbMTb2DNdLmJcW46VZvC760gnx
         HDsStI1QoFVgN1yHHMgmlXdKkieZENJKQUeQvQIMbSH420suHAFNnqphREJL+MRcyao5
         Ov4A==
X-Gm-Message-State: AOAM533o+rEf/SrpAY5gPwPXCVTJJLb13oVBjbXhgkmWBK5l+F4hRwaY
        6dtL40AzbuWDh6w86H0YDiKtp0ryp/sa5ZbH8OA=
X-Google-Smtp-Source: ABdhPJz0ZuAR5cNbJLFyCrmPPd51j+LE4YOMrpvczvL7la6sRxuN8qnay6CVKfs/X4dMTmVLUO4QKJwa072n5TmcJq8=
X-Received: by 2002:a05:6830:1bc6:: with SMTP id v6mr37406911ota.135.1609271471810;
 Tue, 29 Dec 2020 11:51:11 -0800 (PST)
MIME-Version: 1.0
References: <20201222184926.35382198@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201224032116.2453938-1-roland@kernel.org> <X+RJEI+1AR5E0z3z@kroah.com>
 <20201228133036.3a2e9fb5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAG4TOxNM8du=xadLeVwNU5Zq=MW7Kj74-1d9ThZ0q2OrXHE5qQ@mail.gmail.com> <24c6faa2a4f91c721d9a7f14bb7b641b89ae987d.camel@neukum.org>
In-Reply-To: <24c6faa2a4f91c721d9a7f14bb7b641b89ae987d.camel@neukum.org>
From:   Roland Dreier <roland@kernel.org>
Date:   Tue, 29 Dec 2020 11:50:55 -0800
Message-ID: <CAG4TOxOc2OJnzJg9mwd2h+k0mj250S6NdNQmhK7BbHhT4_KdVA@mail.gmail.com>
Subject: Re: [PATCH] CDC-NCM: remove "connected" log message
To:     Oliver Neukum <oliver@neukum.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I looked at them again and found that there is a way to get
> the same effect that will make maintenance easier in the long run.
> Could I send them to you later this week for testing?

Yes, please.  I have a good test setup now so I can easily try out patches.

Thanks,
  Roland
